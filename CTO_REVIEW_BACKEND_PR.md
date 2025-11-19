# Backend PR - Critical Production Fixes

## 🚨 CRITICAL ISSUES - Production Blockers

### Issue #2: Completed Events Shown in All Discovery Modes ❌ CRITICAL
**Priority:** P0 - URGENT - PRODUCTION BLOCKER
**Impact:** Severe UX degradation - users see stale, irrelevant past events across the app
**Location:** `internal/repository/postgres/event_repo.go:117-220`

**Root Cause:**
The `List()` repository method has `WHERE 1=1` with NO default status filter. This returns ALL events including completed ones, making the app appear stale and providing no value to users.

**Current Code (Lines 124-134):**
```go
query := `
  SELECT e.id, e.host_id, e.title, ...
  FROM events e
  INNER JOIN users u ON e.host_id = u.id
  WHERE 1=1  // ❌ NO STATUS FILTER!
`
```

**Impact Areas:**
1. ✅ Discover page - trending/for_you/chill modes show completed events
2. ✅ Event listing page - all event lists include past events
3. ✅ Event search - completed events pollute results
4. ✅ Calendar view - shows events that already happened

**Fix Required:**
Add default status filter to `List()` method in `event_repo.go`:

```go
query := `
  SELECT e.id, e.host_id, e.title, e.description, e.category, e.start_time, e.end_time,
    e.location_name, e.location_address, e.location_lat, e.location_lng,
    e.max_attendees, e.price, e.is_free, e.status, e.privacy, e.requirements,
    e.ticketing_enabled, e.tickets_sold, e.created_at, e.updated_at,
    u.name as host_name, u.avatar_url as host_avatar_url,
    (SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'confirmed') as attendees_count
  FROM events e
  INNER JOIN users u ON e.host_id = u.id
  WHERE e.status IN ('upcoming', 'ongoing')  // ✅ ADD THIS LINE
`
```

**Testing:**
1. Verify `/events` endpoint only returns upcoming/ongoing events
2. Verify `/events?mode=trending` filters completed events
3. Verify `/events?mode=for_you` filters completed events
4. Verify `/events?mode=chill` filters completed events
5. Ensure explicit status filter still works: `/events?status=completed`

---

### Issue #3A: "For You" Algorithm Has Broken Math ❌ CRITICAL
**Priority:** P0 - URGENT - LOGIC BUG
**Impact:** Recommendation algorithm works backwards - newer events get lower scores
**Location:** `internal/repository/postgres/event_repo.go:184-187`

**Root Cause:**
Math error in recency calculation. The formula multiplies days since creation by -0.3, making OLD events get LOWER scores (more negative). While we sort DESC (so newer events rank higher by being less negative), the logic is backwards.

**Current Code (Lines 184-187):**
```go
case "for_you":
  query += ` ORDER BY
    ((SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'confirmed') * 0.5 +
     EXTRACT(EPOCH FROM (NOW() - e.created_at)) / 86400.0 * -0.3) +  // ❌ BACKWARDS!
    random() * 10 DESC`
```

**Problem Breakdown:**
- `EXTRACT(EPOCH FROM (NOW() - e.created_at)) / 86400.0` = days since creation (positive number)
- Multiplying by `-0.3` makes it negative
- Event created 30 days ago: `30 * -0.3 = -9` (penalty)
- Event created today: `0 * -0.3 = 0` (no bonus)
- We want recent events to get a **bonus**, not old events to get a **penalty**

**Fix Required:**
```go
case "for_you":
  // For You: Personalized mix - balance popularity with discovery
  // Recency bonus: newer events get higher scores (max +9 for brand new)
  query += ` ORDER BY
    ((SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'confirmed') * 0.5 +
     GREATEST(30 - EXTRACT(DAY FROM (NOW() - e.created_at)), 0) * 0.3) +  // ✅ RECENCY BONUS
    random() * 10 DESC`
```

**Logic Explanation:**
- Event created today: `GREATEST(30 - 0, 0) * 0.3 = 9.0` (max bonus)
- Event created 15 days ago: `GREATEST(30 - 15, 0) * 0.3 = 4.5` (medium bonus)
- Event created 30+ days ago: `GREATEST(30 - 30, 0) * 0.3 = 0` (no bonus)

---

### Issue #3B: "Chill" Mode Missing Core Filters ⚠️ HIGH
**Priority:** P1 - HIGH
**Impact:** "Chill" mode doesn't actually filter for intimate/small events
**Location:** `internal/repository/postgres/event_repo.go:189-197`

**Root Cause:**
The mode only SORTS by capacity, but doesn't FILTER. Large 1000-person events still appear if they have few attendees. Missing price filter for budget-friendly events.

**Current Code (Lines 189-197):**
```go
case "chill":
  query += ` ORDER BY
    COALESCE(e.max_attendees, 999999) ASC,  // Just sorts, doesn't filter
    (SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'confirmed') ASC,
    random()`
```

**Fix Required:**
Add WHERE clause filters BEFORE the ORDER BY:

```go
case "chill":
  // Chill: Small, intimate, budget-friendly events
  // Filter for small capacity (<50) AND (free OR low price <200000)
  query += ` AND (e.max_attendees < 50)
             AND (e.is_free = true OR e.price < 200000)
             ORDER BY
             e.max_attendees ASC,
             (SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'confirmed') ASC,
             random()`
```

**Reasoning:**
- "Chill" implies intimate, small gatherings
- Max 50 attendees = small venue, cozy atmosphere
- Free or <200k IDR = budget-friendly, casual
- Still sorts by smallest capacity and fewest attendees

---

## 📋 PR CHECKLIST

### Critical Changes Required:
- [ ] **P0:** Add `WHERE e.status IN ('upcoming', 'ongoing')` to `List()` method (Issue #2)
- [ ] **P0:** Fix "for_you" recency calculation math (Issue #3A)
- [ ] **P1:** Add filters to "chill" mode (Issue #3B)

### Testing Requirements:
- [ ] Verify `/events` only returns upcoming/ongoing events
- [ ] Verify `/events?mode=trending` works correctly with status filter
- [ ] Verify `/events?mode=for_you` ranks recent events higher
- [ ] Verify `/events?mode=chill` only shows small, budget-friendly events
- [ ] Verify explicit status override: `/events?status=completed` still works
- [ ] Load test: Verify COUNT query performance with large datasets

### Database Considerations:
- [ ] Ensure index exists on `events(status)` column
- [ ] Ensure index exists on `events(created_at)` column
- [ ] Ensure index exists on `events(max_attendees)` column
- [ ] Monitor query performance after changes

---

## 🔍 CODE REVIEW NOTES

**Great Work On:**
1. ✅ Pagination properly implemented (BLOCKER 6 fixed)
2. ✅ All critical endpoints exist and working
3. ✅ Good use of PostGIS for location queries
4. ✅ Proper SQL injection prevention with parameterized queries
5. ✅ Developer left helpful CTO review comments in code (lines 118-198)

**Concerns:**
1. ❌ No default status filter = stale data everywhere
2. ❌ Math error in recommendation algorithm
3. ❌ "Chill" mode is sorting, not filtering
4. ⚠️ No automated tests for discovery algorithms
5. ⚠️ No A/B testing framework for algorithm tuning

---

## 🎯 ACCEPTANCE CRITERIA

**Issue #2 - Status Filtering:**
- [ ] GET `/events` returns only upcoming/ongoing events
- [ ] GET `/events?mode=trending` returns only upcoming/ongoing events
- [ ] GET `/events?mode=for_you` returns only upcoming/ongoing events
- [ ] GET `/events?mode=chill` returns only upcoming/ongoing events
- [ ] GET `/events?status=completed` still works (explicit override)
- [ ] No completed events in default responses

**Issue #3A - For You Algorithm:**
- [ ] Newly created events rank higher than old events (all else equal)
- [ ] Popular old events still rank well (attendee count matters)
- [ ] Random factor provides variety
- [ ] Algorithm query executes in <100ms

**Issue #3B - Chill Mode:**
- [ ] Only events with max_attendees < 50 appear
- [ ] Only free OR price < 200000 events appear
- [ ] Events sorted by smallest capacity first
- [ ] At least 5-10 events returned in typical scenarios

---

## 📊 PERFORMANCE CONSIDERATIONS

### Query Performance:
```sql
-- Current query plan analysis needed
EXPLAIN ANALYZE
SELECT e.id, e.host_id, e.title, ...
FROM events e
INNER JOIN users u ON e.host_id = u.id
WHERE e.status IN ('upcoming', 'ongoing')
ORDER BY e.created_at DESC
LIMIT 20;
```

### Recommended Indexes:
```sql
-- If not exists, create these indexes
CREATE INDEX IF NOT EXISTS idx_events_status ON events(status);
CREATE INDEX IF NOT EXISTS idx_events_created_at ON events(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_events_max_attendees ON events(max_attendees);
CREATE INDEX IF NOT EXISTS idx_events_status_created ON events(status, created_at DESC);

-- For "chill" mode optimization
CREATE INDEX IF NOT EXISTS idx_events_chill
  ON events(status, max_attendees, is_free, price)
  WHERE max_attendees < 50;
```

---

## 🚀 DEPLOYMENT NOTES

### Pre-Deployment:
1. Run database migrations if adding indexes
2. Test on staging environment with production data clone
3. Verify API response times <100ms for event listing

### Post-Deployment:
1. Monitor `/events` endpoint latency
2. Track user engagement with discover modes
3. Measure click-through rates for "for_you" recommendations
4. Gather feedback on "chill" mode relevance

### Rollback Plan:
If performance degrades:
1. Remove indexes causing lock contention
2. Revert WHERE clause changes
3. Scale read replicas if needed

---

## 📝 FUTURE IMPROVEMENTS

**Algorithm Enhancements:**
1. Add user preference tracking for "for_you" personalization
2. Implement collaborative filtering (users who joined X also joined Y)
3. Add category affinity scoring
4. Time-of-day and day-of-week preferences
5. Distance-based relevance

**Infrastructure:**
1. Add Redis caching for popular event lists
2. Implement CDN for event images
3. Add full-text search with Elasticsearch
4. Create analytics pipeline for algorithm A/B testing

---

**Generated:** 2025-01-19
**Reviewer:** CTO Review
**Status:** READY FOR IMPLEMENTATION
**Estimated Effort:** 2-3 hours

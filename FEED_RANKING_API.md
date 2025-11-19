# Feed Ranking API Documentation

## Overview

The Feed Ranking Agent is an intelligent content ranking system that processes user profiles and content lists to generate 7 different personalized and filtered feeds. It uses implicit signals like engagement metrics, user preferences, tags, mood, and temporal factors to rank content.

## API Endpoint

**POST** `/api/v1/feed/rank`

- **Content-Type:** `application/json`
- **Authentication:** Not required (public endpoint)

## Request Schema

```json
{
  "user_profile": {
    "id": "user-uuid",
    "preferred_tags": {
      "tech": 1.5,
      "music": 1.2,
      "sports": 0.8
    },
    "liked_contents": ["content-id-1", "content-id-2"],
    "followed_authors": ["author-id-1", "author-id-2"],
    "avg_view_time_ms": 45000,
    "skip_rate": 0.25,
    "location": {
      "city": "Jakarta",
      "latitude": -6.2088,
      "longitude": 106.8456
    },
    "timezone": "Asia/Jakarta"
  },
  "contents": {
    "events": [
      {
        "id": "e1",
        "title": "Tech Meetup",
        "description": "Weekly tech discussion",
        "created_at": "2025-11-19T10:00:00Z",
        "start_time": "2025-11-19T18:00:00Z",
        "city": "Jakarta",
        "price_cents": 0,
        "capacity": 50,
        "mood": "casual",
        "tags": ["tech", "networking"],
        "metrics": {
          "views_24h": 1200,
          "likes_24h": 85,
          "shares_24h": 12,
          "saves": 35,
          "avg_view_ms": 120000
        },
        "visibility": "public",
        "status": "published",
        "author_id": "host-id-1"
      }
    ],
    "posts": [
      {
        "id": "p1",
        "caption": "Check out this amazing tech event!",
        "created_at": "2025-11-19T09:00:00Z",
        "tags": ["tech", "event"],
        "metrics": {
          "views_24h": 5000,
          "likes_24h": 250,
          "shares_24h": 45,
          "saves": 80,
          "avg_view_ms": 30000,
          "comments": 42
        },
        "visibility": "public",
        "status": "published",
        "author_id": "author-id-1"
      }
    ]
  },
  "today_window": {
    "start_utc": "2025-11-19T00:00:00Z",
    "end_utc": "2025-11-20T00:00:00Z"
  }
}
```

## Response Schema

```json
{
  "trending_event": ["e12", "e3", "e7"],
  "for_you_posts": ["p4", "p9", "p2"],
  "for_you_events": ["e2", "e17", "e5"],
  "chill_events": ["e5", "e33", "e21"],
  "hari_ini_events": ["e8", "e11", "e3"],
  "gratis_events": ["e20", "e21", "e1"],
  "bayar_events": ["e7", "e14", "e9"]
}
```

All fields return ordered arrays of content IDs, sorted by relevance/priority (highest first).

## Feed Types Explained

### 1. `trending_event` (String array)
**Single most viral event globally**

**Ranking Factors:**
- High velocity engagement (views_24h, likes_24h, shares_24h)
- Recency boost (newer events rank higher)
- Save count (indicates strong interest)
- Exponential decay over 48 hours

**Use Case:** Highlight the hottest event happening right now.

---

### 2. `for_you_posts` (String array)
**Personalized post feed based on user preferences**

**Ranking Factors:**
- Tag affinity (matches user's `preferred_tags`)
- Followed authors (100-point boost)
- Content quality (saves, long view time)
- Social proof (likes, shares)

**Use Case:** Main feed for posts tailored to user interests.

---

### 3. `for_you_events` (String array)
**Personalized event feed based on user preferences**

**Ranking Factors:**
- Same as `for_you_posts`
- Additional mood matching boost (if event mood matches user preferences)

**Use Case:** Discover events aligned with user interests.

---

### 4. `chill_events` (String array)
**Intimate, relaxed events for small gatherings**

**Ranking Factors:**
- Mood = "chill" OR tags contain chill keywords (coffee, relax, hangout, etc.)
- Ideal capacity: 6-12 people (small intimate groups)
- High save count (quality indicator)
- Long view time (deep interest)
- **Penalty** for hype (events with >500 views/shares get downranked)

**Use Case:** Users looking for low-key, small gatherings.

---

### 5. `hari_ini_events` (String array)
**Events happening TODAY (within user's local timezone)**

**Ranking Factors:**
- `start_time` must fall within `today_window`
- Urgency boost (events starting sooner rank higher)
- Engagement (likes, saves)

**Use Case:** "What's happening today?" discovery.

---

### 6. `gratis_events` (String array)
**Free events (price_cents == 0)**

**Ranking Factors:**
- `price_cents` must be 0
- Engagement metrics (views, likes, shares, saves)

**Use Case:** Budget-conscious users or free event browsers.

---

### 7. `bayar_events` (String array)
**Paid events (price_cents > 0)**

**Ranking Factors:**
- `price_cents` must be > 0
- Higher save weight (users willing to pay = strong intent)
- Slight quality boost for higher-priced events

**Use Case:** Premium event discovery.

---

## Filtering Rules

The ranking agent automatically filters content:

✅ **Included:**
- `visibility` = "public"
- `status` = "published"
- Case-insensitive matching

❌ **Excluded:**
- Private/followers-only content
- Draft/cancelled content

---

## Ranking Algorithm Overview

### Trending Score Formula
```
score = (views_24h * 0.3 + likes_24h * 5.0 + shares_24h * 10.0 + saves * 3.0)
        * exp(-hours_since_creation / 48)
```

### Personalization Score Formula
```
score = tag_affinity * 10.0
      + (followed_author ? 100.0 : 0)
      + saves * 5.0
      + (avg_view_ms > user_avg ? view_time_ratio * 3.0 : 0)
      + likes_24h * 2.0
      + shares_24h * 4.0
```

### Chill Score Formula
```
score = capacity_match_bonus (50 if 6-12, 30 if 4-15, 10 otherwise)
      + (mood == "chill" ? 40.0 : 0)
      + saves * 8.0
      + avg_view_ms / 1000
      - (hype_penalty if views+shares > 500)
```

---

## Example Use Cases

### 1. Onboarding New User
```json
{
  "user_profile": {
    "id": "new-user-123",
    "preferred_tags": {},
    "liked_contents": [],
    "followed_authors": [],
    "avg_view_time_ms": 30000,
    "skip_rate": 0.5
  },
  "contents": { ... }
}
```
**Result:** Agent falls back to engagement-based ranking (trending, high saves).

---

### 2. Power User with Rich History
```json
{
  "user_profile": {
    "id": "power-user-456",
    "preferred_tags": {
      "tech": 2.0,
      "startup": 1.8,
      "AI": 1.5
    },
    "liked_contents": ["post-1", "event-2", ...],
    "followed_authors": ["author-a", "author-b", ...],
    "avg_view_time_ms": 120000,
    "skip_rate": 0.1
  },
  "contents": { ... }
}
```
**Result:** Highly personalized feeds with strong preference for tech/AI content from followed authors.

---

### 3. Location-Based Discovery
```json
{
  "user_profile": {
    "id": "user-789",
    "location": {
      "city": "Bandung",
      "latitude": -6.9175,
      "longitude": 107.6191
    }
  },
  "contents": {
    "events": [
      {
        "city": "Bandung",
        "location": { "latitude": -6.9147, "longitude": 107.6098 }
      }
    ]
  }
}
```
**Note:** Location is provided but not yet used in ranking (future enhancement).

---

## Performance Considerations

- **Computational Complexity:** O(n log n) per feed type (sorting)
- **Deduplication:** Content IDs can appear in multiple feeds (intentional)
- **Recommended Content Limits:**
  - Events: 50-200 per request
  - Posts: 100-500 per request

---

## Integration Examples

### cURL
```bash
curl -X POST http://localhost:8081/api/v1/feed/rank \
  -H "Content-Type: application/json" \
  -d @ranking_request.json
```

### Go (Using net/http)
```go
import (
    "bytes"
    "encoding/json"
    "net/http"
)

req := feed_ranking.RankingRequest{ /* ... */ }
body, _ := json.Marshal(req)

resp, err := http.Post(
    "http://localhost:8081/api/v1/feed/rank",
    "application/json",
    bytes.NewBuffer(body),
)
```

### JavaScript (Fetch API)
```javascript
const response = await fetch('http://localhost:8081/api/v1/feed/rank', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(rankingRequest)
});

const rankedFeeds = await response.json();
console.log(rankedFeeds.for_you_posts);
```

---

## Future Enhancements

Potential improvements not yet implemented:
- Geo-distance ranking (use `location.latitude/longitude`)
- Collaborative filtering (similar users' preferences)
- Time-of-day preferences
- Diversity injection (avoid filter bubbles)
- A/B testing framework
- Real-time feedback loop (user interactions update preferences)

---

## Testing

Run unit tests:
```bash
go test ./internal/usecase/feed_ranking/... -v
```

Test coverage:
```bash
go test ./internal/usecase/feed_ranking/... -cover
```

---

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "message": "Invalid request body",
  "error": {
    "code": "BAD_REQUEST",
    "details": "json: cannot unmarshal..."
  }
}
```

### 400 Validation Failed
```json
{
  "success": false,
  "message": "Validation failed",
  "error": {
    "code": "BAD_REQUEST",
    "details": "user_profile.id is required"
  }
}
```

---

## Notes

- **No Authentication:** Endpoint is public for flexibility (can be protected if needed)
- **Stateless:** Each request is independent
- **Idempotent:** Same input always produces same output
- **No External Dependencies:** Pure algorithmic ranking (no ML models)
- **Timezone Aware:** Uses `today_window` for accurate "today" filtering

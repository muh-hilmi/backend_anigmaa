# Database Seeding Guide
**Date:** 2025-11-12
**Project:** Anigmaa Backend

---

## 🎯 Problem: Empty API Responses

**Frontend reported:**
```json
Response: {
  "success": true,
  "message": "Comments retrieved successfully",
  "data": []  // ❌ Empty!
}
```

**Root Cause:** ✅ API works, ❌ Database has no seed data yet

---

## ✅ Good News: Seed Data Already Exists!

The comprehensive seed file includes:
- ✅ 25 users with profiles
- ✅ 30 events (various categories)
- ✅ 50 posts (with images and event tags)
- ✅ **42 comments** (including nested replies) ← **Available!**
- ✅ **18 Q&A entries** (questions + answers) ← **Available!**
- ✅ Likes, follows, bookmarks
- ✅ Event attendees

**File Location:** `/db/seeds/01_comprehensive_seed.sql`

---

## 🚀 How to Apply Seed Data

### **Option 1: Using psql (Recommended)**

```bash
# Make sure PostgreSQL is running
docker-compose up -d postgres

# Apply seed data
psql postgresql://postgres:postgres@localhost:5432/anigmaa -f db/seeds/01_comprehensive_seed.sql

# Verify data was inserted
psql postgresql://postgres:postgres@localhost:5432/anigmaa -c "SELECT COUNT(*) FROM comments;"
psql postgresql://postgres:postgres@localhost:5432/anigmaa -c "SELECT COUNT(*) FROM event_qna;"
```

### **Option 2: Using Docker**

```bash
# If using Docker Compose
docker-compose exec postgres psql -U postgres -d anigmaa -f /docker-entrypoint-initdb.d/01_comprehensive_seed.sql

# Or copy file and execute
docker cp db/seeds/01_comprehensive_seed.sql anigmaa_postgres:/tmp/
docker-compose exec postgres psql -U postgres -d anigmaa -f /tmp/01_comprehensive_seed.sql
```

### **Option 3: Using DBeaver/pgAdmin**

1. Open DBeaver or pgAdmin
2. Connect to database: `localhost:5432/anigmaa`
3. Open SQL Editor
4. Load file: `/db/seeds/01_comprehensive_seed.sql`
5. Execute script (F5 or Run button)

### **Option 4: Automatic on Fresh Install**

```bash
# Stop and remove all containers
docker-compose down -v

# This will remove ALL data!
# Copy seed file to init directory (auto-runs on first start)
cp db/seeds/01_comprehensive_seed.sql docker/init/

# Start fresh
docker-compose up -d

# Migrations + seed data will run automatically
```

---

## 📊 What Data Gets Seeded

### **1. Users (25 total)**

Sample users with credentials:
```
Email: rudi@anigmaa.com
Password: (hashed)
Username: rudihartono
Bio: "Coffee enthusiast | Event organizer"

Email: siti@anigmaa.com
Password: (hashed)
Username: sitinur
Bio: "Foodie & travel lover 🌏"

... 23 more users
```

### **2. Comments (42 total)**

#### Sample Comments:
```sql
-- Post #1 Comments (Coffee Event)
"This sounds amazing! Already registered 🎉"
  └─ Reply: "Awesome! See you there 😊"
"What time does it start exactly?"
  └─ Reply: "10 AM sharp! Don't be late"

-- Post #2 Comments (Food Tour)
"Count me in! Love street food 🍜"
"Which spots are we visiting?"
  └─ Reply: "It's a surprise! But trust me, all legendary spots"

-- Post #3 Comments (Gaming Tournament)
"My team is ready! Let's win this 🏆"
"Good luck everyone! May the best team win"
  └─ Reply: "We're coming for that prize! 😎"

... 36 more comments
```

**Features:**
- ✅ Nested comments (replies to comments)
- ✅ Timestamps (from 5 hours ago to 3 days ago)
- ✅ Various authors
- ✅ Includes emojis
- ✅ Mix of Indonesian and English

### **3. Event Q&A (18 total)**

#### Sample Q&A:
```sql
-- Event: Coffee Cupping Session
Q: "Apakah ada demo brewing juga?"
A: "Yes! We will have brewing demonstrations using V60, Aeropress, and French Press."
Status: Answered

Q: "Boleh bawa teman yang belum daftar?"
A: "Maaf, karena tempat terbatas, semua peserta harus registrasi terlebih dahulu."
Status: Answered

Q: "Apakah ada sertifikat setelah acara?"
A: NULL (Unanswered)
Status: Not answered

-- Event: Latte Art Workshop
Q: "Do I need to bring my own cup?"
A: "No, all equipment and materials will be provided!"
Status: Answered

... 14 more Q&A entries
```

**Features:**
- ✅ Questions with answers
- ✅ Some unanswered questions (realistic)
- ✅ Host/organizer answers
- ✅ Mix of languages
- ✅ Timestamps

### **4. Events (30 total)**

Categories:
- ☕ Coffee (2 events)
- 🍜 Food (3 events)
- 🎮 Gaming (2 events)
- 🎨 Workshop (5 events)
- 🎵 Music (2 events)
- 🏃 Sports (3 events)
- 💼 Meetup (5 events)
- And more...

### **5. Posts (50 total)**

Types:
- Text posts
- Posts with images
- Posts with event tags
- Mix of topics (tech, food, art, sports)

---

## 🔍 Verify Seed Data Was Applied

Run these queries to confirm:

```sql
-- Check comments
SELECT COUNT(*) as comment_count FROM comments;
-- Expected: 42

-- Check Q&A
SELECT COUNT(*) as qna_count FROM event_qna;
-- Expected: 18

-- Check users
SELECT COUNT(*) as user_count FROM users;
-- Expected: 25

-- Check events
SELECT COUNT(*) as event_count FROM events;
-- Expected: 30

-- Check posts
SELECT COUNT(*) as post_count FROM posts;
-- Expected: 50

-- Sample comment with author
SELECT
  c.content,
  u.name as author,
  c.created_at
FROM comments c
JOIN users u ON c.author_id = u.id
LIMIT 5;

-- Sample Q&A with event
SELECT
  e.title as event_title,
  eq.question,
  eq.answer,
  eq.is_answered
FROM event_qna eq
JOIN events e ON eq.event_id = e.id
LIMIT 5;
```

---

## 🧪 Test APIs After Seeding

### **Test Comments API:**

```bash
# Get comments for a post
curl http://localhost:8081/api/v1/posts/a0000001-0000-0000-0000-000000000001/comments \
  -H "Authorization: Bearer $TOKEN"

# Expected response:
{
  "data": [
    {
      "id": "c0000001-0000-0000-0000-000000000001",
      "post_id": "a0000001-0000-0000-0000-000000000001",
      "author": {
        "id": "22222222-2222-2222-2222-222222222222",
        "name": "Siti Nurhaliza",
        "username": "sitinur",
        "avatar": "https://i.pravatar.cc/150?img=2"
      },
      "content": "This sounds amazing! Already registered 🎉",
      "created_at": "2025-11-11T...",
      "likes_count": 3,
      "is_liked_by_current_user": false
    },
    // ... more comments
  ]
}
```

### **Test Q&A API:**

```bash
# Get Q&A for an event
curl http://localhost:8081/api/v1/events/e0000001-0000-0000-0000-000000000001/qna \
  -H "Authorization: Bearer $TOKEN"

# Expected response:
{
  "data": [
    {
      "id": "...",
      "event_id": "e0000001-0000-0000-0000-000000000001",
      "author": {
        "id": "22222222-2222-2222-2222-222222222222",
        "name": "Siti Nurhaliza"
      },
      "question": "Apakah ada demo brewing juga?",
      "answer": "Yes! We will have brewing demonstrations...",
      "answered_by": {
        "id": "11111111-1111-1111-1111-111111111111",
        "name": "Rudi Hartono"
      },
      "answered_at": "2025-11-12T...",
      "is_answered": true,
      "upvotes_count": 0,
      "is_upvoted_by_current_user": false
    },
    // ... more Q&A
  ]
}
```

---

## 🔧 Troubleshooting

### **Issue: "relation does not exist"**

**Cause:** Migrations not run yet

**Fix:**
```bash
# Run migrations first
docker-compose exec backend go run cmd/migrate/main.go up

# Or restart backend (auto-runs migrations)
docker-compose restart backend
```

### **Issue: "duplicate key value violates unique constraint"**

**Cause:** Seed data already inserted

**Fix:**
```bash
# Check if data exists
psql -U postgres -d anigmaa -c "SELECT COUNT(*) FROM comments;"

# If count > 0, data already seeded
# No action needed!
```

### **Issue: "permission denied"**

**Cause:** Wrong database user

**Fix:**
```bash
# Use postgres superuser
psql postgresql://postgres:postgres@localhost:5432/anigmaa -f db/seeds/01_comprehensive_seed.sql
```

### **Issue: Empty responses persist after seeding**

**Possible causes:**
1. ✅ Seed ran but on different database
2. ✅ Backend connected to different database
3. ✅ Cache issue

**Fixes:**
```bash
# 1. Verify database connection
docker-compose logs backend | grep "Connected to PostgreSQL"

# 2. Check environment variables
docker-compose exec backend env | grep DB_

# 3. Restart backend
docker-compose restart backend

# 4. Clear Redis cache (if using)
docker-compose exec redis redis-cli FLUSHALL
```

---

## 📝 Creating Additional Test Data

### **Add Comments via API:**

```bash
curl -X POST http://localhost:8081/api/v1/posts/comments \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "post_id": "a0000001-0000-0000-0000-000000000001",
    "content": "This is a test comment from API!"
  }'
```

### **Add Q&A via API:**

```bash
# Ask question
curl -X POST http://localhost:8081/api/v1/events/e0000001-0000-0000-0000-000000000001/qna \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "question": "What should I bring to the event?"
  }'

# Answer question (as event host)
curl -X POST http://localhost:8081/api/v1/qna/{question_id}/answer \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "answer": "Just bring yourself and enthusiasm!"
  }'
```

---

## 🎯 Quick Start (Fresh Install)

```bash
# 1. Stop everything
docker-compose down -v

# 2. Start database
docker-compose up -d postgres

# Wait 5 seconds for DB to be ready
sleep 5

# 3. Run migrations
docker-compose up -d backend
sleep 3

# 4. Apply seed data
docker cp db/seeds/01_comprehensive_seed.sql $(docker-compose ps -q postgres):/tmp/seed.sql
docker-compose exec postgres psql -U postgres -d anigmaa -f /tmp/seed.sql

# 5. Verify
docker-compose exec postgres psql -U postgres -d anigmaa -c "
  SELECT
    'Comments' as table_name, COUNT(*) as count FROM comments
  UNION ALL
  SELECT 'Q&A', COUNT(*) FROM event_qna
  UNION ALL
  SELECT 'Posts', COUNT(*) FROM posts
  UNION ALL
  SELECT 'Events', COUNT(*) FROM events;
"

# Expected output:
# table_name | count
# -----------+-------
# Comments   |    42
# Q&A        |    18
# Posts      |    50
# Events     |    30

# 6. Test API
curl http://localhost:8081/health
```

---

## 📚 Additional Resources

### **Seed Files Available:**

1. `db/seeds/01_comprehensive_seed.sql` - Full seed data (recommended)
2. `db/seeds/02_mailhilmi_user_seed.sql` - Specific user for testing

### **Migration Files:**

Located in: `migrations/consolidated/`
- Auto-run on backend startup
- Can be run manually if needed

### **Database Schema:**

See `API_IMPLEMENTATION_REVIEW.md` for full schema documentation

---

## ✅ Summary

**Problem:** Empty API responses (comments, Q&A)
**Root Cause:** Database not seeded yet
**Solution:** Apply seed file

**Quick Fix:**
```bash
docker cp db/seeds/01_comprehensive_seed.sql $(docker-compose ps -q postgres):/tmp/seed.sql
docker-compose exec postgres psql -U postgres -d anigmaa -f /tmp/seed.sql
```

**Verification:**
```bash
docker-compose exec postgres psql -U postgres -d anigmaa -c "SELECT COUNT(*) FROM comments;"
# Should return: 42
```

---

**Document Version:** 1.0
**Last Updated:** 2025-11-12
**Seed Data Version:** Comprehensive v1.0

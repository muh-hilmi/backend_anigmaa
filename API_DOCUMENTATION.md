# Anigmaa Backend API Documentation

**Base URL**: `http://localhost:8081`
**API Version**: v1
**Base Path**: `/api/v1`

## Authentication

Gunakan JWT Bearer Token untuk endpoint yang memerlukan autentikasi:

```
Authorization: Bearer <your_jwt_token>
```

---

## 📋 Table of Contents

1. [Health Check](#health-check)
2. [Authentication](#authentication-endpoints)
3. [Users](#user-endpoints)
4. [Events](#event-endpoints)
5. [Posts & Comments](#post-endpoints)
6. [Tickets](#ticket-endpoints)
7. [Communities](#community-endpoints)
8. [Analytics](#analytics-endpoints)
9. [Q&A](#qa-endpoints)
10. [Profile](#profile-endpoints)
11. [Upload](#upload-endpoints)
12. [Payments](#payment-endpoints)

---

## Health Check

### Check Service Status
```
GET /health
```
**Auth**: No
**Response**: `{ "status": "ok" }`

### Check Database
```
GET /health/db
```
**Auth**: No
**Response**: `{ "status": "ok", "database": "connected" }`

### Check Redis
```
GET /health/redis
```
**Auth**: No
**Response**: `{ "status": "ok", "redis": "connected" }`

---

## Authentication Endpoints

### Register
```
POST /api/v1/auth/register
```
**Auth**: No
**Body**:
```json
{
  "email": "user@example.com",
  "password": "password123",
  "full_name": "John Doe",
  "username": "johndoe"
}
```
**Response**:
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "username": "johndoe",
    "full_name": "John Doe",
    "is_verified": false
  },
  "access_token": "jwt_token",
  "refresh_token": "refresh_token"
}
```

### Login
```
POST /api/v1/auth/login
```
**Auth**: No
**Body**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
**Response**: Same as Register

### Google OAuth
```
POST /api/v1/auth/google
```
**Auth**: No
**Body**:
```json
{
  "id_token": "google_id_token"
}
```
**Response**: Same as Register

### Logout
```
POST /api/v1/auth/logout
```
**Auth**: Yes
**Response**: `{ "message": "Logout successful" }`

### Refresh Token
```
POST /api/v1/auth/refresh
```
**Auth**: Yes
**Body**:
```json
{
  "refresh_token": "refresh_token"
}
```
**Response**:
```json
{
  "access_token": "new_jwt_token"
}
```

### Change Password
```
POST /api/v1/auth/change-password
```
**Auth**: Yes
**Body**:
```json
{
  "current_password": "oldpass123",
  "new_password": "newpass123"
}
```

### Forgot Password
```
POST /api/v1/auth/forgot-password
```
**Auth**: No
**Body**:
```json
{
  "email": "user@example.com"
}
```

### Reset Password
```
POST /api/v1/auth/reset-password
```
**Auth**: No
**Body**:
```json
{
  "token": "reset_token",
  "new_password": "newpass123"
}
```

### Verify Email
```
POST /api/v1/auth/verify-email
```
**Auth**: No
**Body**:
```json
{
  "token": "verification_token"
}
```

### Resend Verification
```
POST /api/v1/auth/resend-verification
```
**Auth**: Yes

---

## User Endpoints

### Get Current User
```
GET /api/v1/users/me
```
**Auth**: Yes
**Response**:
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "username": "johndoe",
  "full_name": "John Doe",
  "bio": "My bio",
  "avatar_url": "https://...",
  "is_verified": true,
  "followers_count": 100,
  "following_count": 50
}
```

### Update Current User
```
PUT /api/v1/users/me
```
**Auth**: Yes
**Body**:
```json
{
  "full_name": "John Updated",
  "bio": "New bio",
  "avatar_url": "https://...",
  "birth_date": "1990-01-01"
}
```

### Update User Settings
```
PUT /api/v1/users/me/settings
```
**Auth**: Yes
**Body**:
```json
{
  "privacy_setting": "public",
  "notification_enabled": true,
  "language": "id"
}
```

### Search Users
```
GET /api/v1/users/search?q=john&limit=20
```
**Auth**: Yes
**Query Params**:
- `q`: search term (required)
- `limit`: results limit (default: 20)

**Response**:
```json
{
  "users": [
    {
      "id": "uuid",
      "username": "johndoe",
      "full_name": "John Doe",
      "avatar_url": "https://...",
      "is_following": false
    }
  ]
}
```

### Get User by ID
```
GET /api/v1/users/:id
```
**Auth**: Yes

### Get User Followers
```
GET /api/v1/users/:id/followers?limit=20&offset=0
```
**Auth**: Yes

### Get User Following
```
GET /api/v1/users/:id/following?limit=20&offset=0
```
**Auth**: Yes

### Follow User
```
POST /api/v1/users/:id/follow
```
**Auth**: Yes

### Unfollow User
```
DELETE /api/v1/users/:id/follow
```
**Auth**: Yes

### Get User Stats
```
GET /api/v1/users/:id/stats
```
**Auth**: Yes
**Response**:
```json
{
  "followers_count": 100,
  "following_count": 50,
  "posts_count": 25,
  "events_hosted": 5,
  "events_joined": 15
}
```

---

## Event Endpoints

### Get Events List
```
GET /api/v1/events?category=music&is_free=true&limit=20&offset=0
```
**Auth**: No
**Query Params**:
- `category`: music, sports, tech, arts, food, education, business, other
- `is_free`: true/false
- `status`: upcoming, ongoing, past
- `limit`: default 20
- `offset`: default 0

**Response**:
```json
{
  "events": [
    {
      "id": "uuid",
      "title": "Music Festival 2025",
      "description": "Annual music event",
      "start_time": "2025-12-01T18:00:00Z",
      "end_time": "2025-12-01T23:00:00Z",
      "location": "Jakarta Convention Center",
      "latitude": -6.2088,
      "longitude": 106.8456,
      "category": "music",
      "max_attendees": 500,
      "current_attendees": 250,
      "price": 150000,
      "image_url": "https://...",
      "status": "upcoming",
      "host": {
        "id": "uuid",
        "username": "organizer",
        "full_name": "Event Organizer"
      }
    }
  ],
  "total": 100
}
```

### Get Nearby Events
```
GET /api/v1/events/nearby?lat=-6.2088&lng=106.8456&radius=5000&limit=20
```
**Auth**: No
**Query Params**:
- `lat`: latitude (required)
- `lng`: longitude (required)
- `radius`: in meters (default: 5000)
- `limit`: default 20

### Get Event Details
```
GET /api/v1/events/:id
```
**Auth**: No
**Response**: Same as events list item + additional details

### Create Event
```
POST /api/v1/events
```
**Auth**: Yes
**Body**:
```json
{
  "title": "Music Festival 2025",
  "description": "Annual music event",
  "start_time": "2025-12-01T18:00:00Z",
  "end_time": "2025-12-01T23:00:00Z",
  "location": "Jakarta Convention Center",
  "latitude": -6.2088,
  "longitude": 106.8456,
  "category": "music",
  "max_attendees": 500,
  "price": 150000,
  "image_url": "https://..."
}
```

### Update Event
```
PUT /api/v1/events/:id
```
**Auth**: Yes (Host only)
**Body**: Same as Create Event

### Delete Event
```
DELETE /api/v1/events/:id
```
**Auth**: Yes (Host only)

### Join Event
```
POST /api/v1/events/:id/join
```
**Auth**: Yes

### Leave Event
```
DELETE /api/v1/events/:id/join
```
**Auth**: Yes

### Get My Events
```
GET /api/v1/events/my-events?limit=20&offset=0
```
**Auth**: Yes

### Get Hosted Events
```
GET /api/v1/events/hosted?limit=20&offset=0
```
**Auth**: Yes

### Get Joined Events
```
GET /api/v1/events/joined?limit=20&offset=0
```
**Auth**: Yes

### Get Event Attendees
```
GET /api/v1/events/:id/attendees?limit=20&offset=0
```
**Auth**: No

### Get Event Tickets (Host Only)
```
GET /api/v1/events/:id/tickets
```
**Auth**: Yes (Host only)

---

## Post Endpoints

### Get Feed
```
GET /api/v1/posts/feed?limit=20&offset=0
```
**Auth**: Yes
**Response**:
```json
{
  "posts": [
    {
      "id": "uuid",
      "content": "Check out this event!",
      "type": "text_with_event",
      "image_url": "https://...",
      "author": {
        "id": "uuid",
        "username": "johndoe",
        "full_name": "John Doe",
        "avatar_url": "https://..."
      },
      "attached_event": {
        "id": "uuid",
        "title": "Event Name"
      },
      "likes_count": 50,
      "comments_count": 10,
      "reposts_count": 5,
      "is_liked": true,
      "is_reposted": false,
      "is_bookmarked": false,
      "created_at": "2025-11-18T10:00:00Z"
    }
  ]
}
```

### Create Post
```
POST /api/v1/posts
```
**Auth**: Yes
**Body**:
```json
{
  "content": "Check out this event!",
  "type": "text_with_event",
  "image_url": "https://...",
  "attached_event_id": "event_uuid"
}
```
**Types**: `text`, `image`, `text_with_event`

### Get Post by ID
```
GET /api/v1/posts/:id
```
**Auth**: Yes

### Update Post
```
PUT /api/v1/posts/:id
```
**Auth**: Yes (Author only)
**Body**:
```json
{
  "content": "Updated content",
  "image_url": "https://..."
}
```

### Delete Post
```
DELETE /api/v1/posts/:id
```
**Auth**: Yes (Author only)

### Like Post
```
POST /api/v1/posts/:id/like
```
**Auth**: Yes

### Unlike Post
```
POST /api/v1/posts/:id/unlike
```
**Auth**: Yes

### Repost
```
POST /api/v1/posts/repost
```
**Auth**: Yes
**Body**:
```json
{
  "post_id": "uuid",
  "quote_text": "Optional quote text"
}
```

### Undo Repost
```
POST /api/v1/posts/:id/undo-repost
```
**Auth**: Yes

### Bookmark Post
```
POST /api/v1/posts/:id/bookmark
```
**Auth**: Yes

### Remove Bookmark
```
DELETE /api/v1/posts/:id/bookmark
```
**Auth**: Yes

### Get Bookmarks
```
GET /api/v1/posts/bookmarks?limit=20&offset=0
```
**Auth**: Yes

### Get Post Comments
```
GET /api/v1/posts/:id/comments?limit=20&offset=0
```
**Auth**: Yes

### Add Comment
```
POST /api/v1/posts/comments
```
**Auth**: Yes
**Body**:
```json
{
  "post_id": "uuid",
  "content": "Nice post!"
}
```

### Update Comment
```
PUT /api/v1/posts/comments/:commentId
```
**Auth**: Yes (Author only)
**Body**:
```json
{
  "content": "Updated comment"
}
```

### Delete Comment
```
DELETE /api/v1/posts/comments/:commentId
```
**Auth**: Yes (Author only)

### Like Comment
```
POST /api/v1/posts/:id/comments/:commentId/like
```
**Auth**: Yes

### Unlike Comment
```
POST /api/v1/posts/:id/comments/:commentId/unlike
```
**Auth**: Yes

---

## Ticket Endpoints

### Purchase Ticket
```
POST /api/v1/tickets/purchase
```
**Auth**: Yes
**Body**:
```json
{
  "event_id": "uuid",
  "quantity": 2
}
```
**Response**:
```json
{
  "transaction_id": "uuid",
  "order_id": "ORDER-123",
  "payment_url": "https://midtrans.com/...",
  "total_amount": 300000,
  "status": "pending"
}
```

### Get My Tickets
```
GET /api/v1/tickets/my-tickets?status=active&limit=20
```
**Auth**: Yes
**Query Params**:
- `status`: active, used, cancelled
- `limit`: default 20

**Response**:
```json
{
  "tickets": [
    {
      "id": "uuid",
      "event": {
        "id": "uuid",
        "title": "Music Festival",
        "start_time": "2025-12-01T18:00:00Z"
      },
      "ticket_code": "TICK-12345",
      "status": "active",
      "purchased_at": "2025-11-18T10:00:00Z"
    }
  ]
}
```

### Get Ticket Details
```
GET /api/v1/tickets/:id
```
**Auth**: Yes

### Check In
```
POST /api/v1/tickets/check-in
```
**Auth**: Yes
**Body**:
```json
{
  "attendance_code": "EVENT-CODE-123"
}
```

### Cancel Ticket
```
POST /api/v1/tickets/:id/cancel
```
**Auth**: Yes

### Get Transaction
```
GET /api/v1/tickets/transactions/:id
```
**Auth**: Yes

---

## Community Endpoints

### Get Communities
```
GET /api/v1/communities?search=tech&limit=20&offset=0
```
**Auth**: Yes
**Response**:
```json
{
  "communities": [
    {
      "id": "uuid",
      "name": "Tech Enthusiasts",
      "description": "Community for tech lovers",
      "privacy": "public",
      "image_url": "https://...",
      "members_count": 500,
      "is_member": true,
      "owner": {
        "id": "uuid",
        "username": "owner"
      }
    }
  ]
}
```

### Get My Communities
```
GET /api/v1/communities/my-communities
```
**Auth**: Yes

### Create Community
```
POST /api/v1/communities
```
**Auth**: Yes
**Body**:
```json
{
  "name": "Tech Enthusiasts",
  "description": "Community for tech lovers",
  "privacy": "public",
  "image_url": "https://..."
}
```
**Privacy**: `public`, `private`

### Get Community Details
```
GET /api/v1/communities/:id
```
**Auth**: Yes

### Update Community
```
PUT /api/v1/communities/:id
```
**Auth**: Yes (Owner only)
**Body**: Same as Create Community

### Delete Community
```
DELETE /api/v1/communities/:id
```
**Auth**: Yes (Owner only)

### Join Community
```
POST /api/v1/communities/:id/join
```
**Auth**: Yes

### Leave Community
```
DELETE /api/v1/communities/:id/leave
```
**Auth**: Yes

### Get Community Members
```
GET /api/v1/communities/:id/members?limit=20&offset=0
```
**Auth**: Yes

---

## Analytics Endpoints

### Get Event Analytics
```
GET /api/v1/analytics/events/:id
```
**Auth**: Yes (Host only)
**Response**:
```json
{
  "event_id": "uuid",
  "total_tickets_sold": 250,
  "total_revenue": 37500000,
  "attendance_rate": 95.5,
  "daily_sales": [
    {
      "date": "2025-11-18",
      "tickets_sold": 50,
      "revenue": 7500000
    }
  ]
}
```

### Get Event Transactions
```
GET /api/v1/analytics/events/:id/transactions?limit=20&offset=0
```
**Auth**: Yes (Host only)

### Get Host Revenue
```
GET /api/v1/analytics/host/revenue?start_date=2025-01-01&end_date=2025-12-31
```
**Auth**: Yes (Host only)
**Response**:
```json
{
  "total_revenue": 150000000,
  "total_tickets_sold": 1500,
  "total_events": 10,
  "commission_paid": 15000000
}
```

### Get Host Events with Revenue
```
GET /api/v1/analytics/host/events?limit=20&offset=0
```
**Auth**: Yes (Host only)

---

## Q&A Endpoints

### Get Event Q&A
```
GET /api/v1/events/:id/qna?limit=20&offset=0&sort=upvotes
```
**Auth**: Yes
**Query Params**:
- `sort`: upvotes, recent
- `filter`: unanswered, answered

**Response**:
```json
{
  "questions": [
    {
      "id": "uuid",
      "question": "What time does the event start?",
      "answer": "Event starts at 6 PM",
      "upvotes_count": 10,
      "is_upvoted": false,
      "is_answered": true,
      "author": {
        "id": "uuid",
        "username": "user"
      },
      "created_at": "2025-11-18T10:00:00Z"
    }
  ]
}
```

### Ask Question
```
POST /api/v1/events/:id/qna
```
**Auth**: Yes
**Body**:
```json
{
  "question": "What time does the event start?"
}
```

### Upvote Question
```
POST /api/v1/qna/:id/upvote
```
**Auth**: Yes

### Remove Upvote
```
DELETE /api/v1/qna/:id/upvote
```
**Auth**: Yes

### Answer Question
```
POST /api/v1/qna/:id/answer
```
**Auth**: Yes (Host only)
**Body**:
```json
{
  "answer": "Event starts at 6 PM"
}
```

### Delete Question
```
DELETE /api/v1/qna/:id
```
**Auth**: Yes (Author only)

---

## Profile Endpoints

### Get Profile by Username
```
GET /api/v1/profile/:username
```
**Auth**: No
**Response**:
```json
{
  "id": "uuid",
  "username": "johndoe",
  "full_name": "John Doe",
  "bio": "Tech enthusiast",
  "avatar_url": "https://...",
  "followers_count": 100,
  "following_count": 50,
  "posts_count": 25,
  "is_following": false
}
```

### Get User Posts
```
GET /api/v1/profile/:username/posts?limit=20&offset=0
```
**Auth**: No

### Get User Events
```
GET /api/v1/profile/:username/events?type=hosted&limit=20
```
**Auth**: No
**Query Params**:
- `type`: hosted, joined

---

## Upload Endpoints

### Upload Image
```
POST /api/v1/upload/image
```
**Auth**: Yes
**Content-Type**: `multipart/form-data`
**Body**:
- `image`: File (max 5MB, formats: jpg, jpeg, png, gif, webp)

**Response**:
```json
{
  "url": "https://storage.example.com/images/uuid.jpg"
}
```

---

## Payment Endpoints

### Midtrans Webhook
```
POST /api/v1/webhooks/midtrans
```
**Auth**: No (Signature verified)
**Note**: Digunakan oleh Midtrans untuk notifikasi payment

### Get Transaction Status
```
GET /api/v1/payments/transactions/:order_id/status
```
**Auth**: Yes
**Response**:
```json
{
  "order_id": "ORDER-123",
  "status": "settlement",
  "payment_type": "gopay",
  "gross_amount": 300000,
  "transaction_time": "2025-11-18T10:00:00Z"
}
```

---

## Error Responses

Semua error mengikuti format:

```json
{
  "error": "Error message here",
  "details": "Optional detailed explanation"
}
```

### HTTP Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request (validation error)
- `401` - Unauthorized (missing/invalid token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found
- `409` - Conflict (duplicate data)
- `500` - Internal Server Error

---

## Pagination

Endpoints dengan pagination menggunakan query params:
- `limit`: jumlah data per halaman (default: 20)
- `offset`: skip data (default: 0)

Response:
```json
{
  "data": [...],
  "total": 100,
  "limit": 20,
  "offset": 0
}
```

---

## Date Format

Semua timestamp menggunakan **RFC3339** format:
```
2025-11-18T10:00:00Z
```

---

## Environment Variables

Untuk menjalankan backend:

```env
DATABASE_URL=postgresql://user:pass@localhost:5432/anigmaa
REDIS_URL=redis://localhost:6379
JWT_SECRET=your_jwt_secret
GOOGLE_CLIENT_ID=your_google_client_id
MIDTRANS_SERVER_KEY=your_midtrans_key
MIDTRANS_IS_PRODUCTION=false
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email
SMTP_PASS=your_password
```

---

## Swagger Documentation

Akses dokumentasi interaktif di:
```
http://localhost:8081/swagger/index.html
```

---

## Support

Untuk pertanyaan atau issue, hubungi tim backend atau buat issue di repository.

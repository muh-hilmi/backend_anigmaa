# Frontend API Integration Guide

## Table of Contents
- [Getting Started](#getting-started)
- [API Base URL](#api-base-url)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
- [Error Handling](#error-handling)
- [Example Code](#example-code)

## Getting Started

### 1. Swagger Documentation
Interactive API documentation is available at:
```
http://localhost:8081/swagger/index.html
```

### 2. Health Check
```bash
curl http://localhost:8081/health
```

## API Base URL

**Development:**
```
http://localhost:8081/api/v1
```

**Production:**
```
https://api.anigmaa.com/api/v1
```

## Authentication

### Authentication Flow

1. **Register/Login** → Get JWT token
2. **Store token** in localStorage/sessionStorage
3. **Include token** in Authorization header for protected endpoints

### Token Format
```
Authorization: Bearer <your-jwt-token>
```

### Token Expiration
- Access Token: 24 hours
- Refresh Token: 168 hours (7 days)

## API Endpoints

### 🔓 Public Endpoints (No Auth Required)

#### Authentication
```
POST   /auth/register          - Register new user
POST   /auth/login             - Login with email/password
POST   /auth/google            - Login with Google OAuth
POST   /auth/forgot-password   - Request password reset
POST   /auth/reset-password    - Reset password with token
POST   /auth/verify-email      - Verify email address
```

#### Events (Public Access)
```
GET    /events                 - List all events
GET    /events/nearby          - Get nearby events (with lat/lng)
GET    /events/:id             - Get event details
GET    /events/:id/attendees   - Get event attendees
```

#### Profiles (Public Access)
```
GET    /profile/:username          - Get user profile by username
GET    /profile/:username/posts    - Get user's posts
GET    /profile/:username/events   - Get user's events
```

### 🔐 Protected Endpoints (Auth Required)

#### Authentication
```
POST   /auth/logout            - Logout user
POST   /auth/refresh           - Refresh access token
```

#### Users
```
GET    /users/me               - Get current user profile
PUT    /users/me               - Update current user profile
PUT    /users/me/settings      - Update user settings
GET    /users/:id              - Get user by ID
GET    /users/:id/followers    - Get user's followers
GET    /users/:id/following    - Get users being followed
POST   /users/:id/follow       - Follow user
DELETE /users/:id/follow       - Unfollow user
GET    /users/:id/stats        - Get user statistics
```

#### Events
```
POST   /events                 - Create new event
PUT    /events/:id             - Update event
DELETE /events/:id             - Delete event
POST   /events/:id/join        - Join event
DELETE /events/:id/join        - Leave event
GET    /events/my-events       - Get my hosted events
GET    /events/joined          - Get events I've joined
```

#### Posts
```
GET    /posts/feed             - Get personalized feed
POST   /posts                  - Create new post
GET    /posts/:id              - Get post by ID
PUT    /posts/:id              - Update post
DELETE /posts/:id              - Delete post
POST   /posts/:id/like         - Like post
POST   /posts/:id/unlike       - Unlike post
POST   /posts/repost           - Repost a post
POST   /posts/:id/undo-repost  - Undo repost
GET    /posts/:id/comments     - Get post comments
POST   /posts/comments         - Add comment to post
PUT    /posts/comments/:commentId    - Update comment
DELETE /posts/comments/:commentId    - Delete comment
```

#### Tickets
```
POST   /tickets/purchase       - Purchase event ticket
GET    /tickets/my-tickets     - Get my tickets
GET    /tickets/:id            - Get ticket details
POST   /tickets/check-in       - Check-in to event
POST   /tickets/:id/cancel     - Cancel ticket
```

#### Analytics (Host Only)
```
GET    /analytics/events/:id                - Get event analytics
GET    /analytics/events/:id/transactions   - Get event transactions
GET    /analytics/host/revenue              - Get revenue summary
GET    /analytics/host/events               - Get hosted events list
```

## Error Handling

### HTTP Status Codes
```
200 - OK
201 - Created
400 - Bad Request (validation error)
401 - Unauthorized (invalid/missing token)
403 - Forbidden (insufficient permissions)
404 - Not Found
500 - Internal Server Error
```

### Error Response Format
```json
{
  "error": "Error message here",
  "details": "Additional details (optional)"
}
```

### Success Response Format
```json
{
  "data": { ... },
  "message": "Success message (optional)"
}
```

## Example Code

See the following files for implementation examples:
- `docs/examples/api-client.js` - Vanilla JavaScript with Axios
- `docs/examples/api-client.ts` - TypeScript with Axios
- `docs/examples/types.ts` - TypeScript type definitions
- `docs/examples/usage-examples.js` - Common use cases

## CORS Configuration

The backend allows requests from:
```
http://localhost:3000    (React default)
http://localhost:5173    (Vite default)
http://localhost:8081    (Backend port)
```

## Request Examples

### Register User
```bash
curl -X POST http://localhost:8081/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securePassword123",
    "name": "John Doe",
    "username": "johndoe"
  }'
```

### Login
```bash
curl -X POST http://localhost:8081/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securePassword123"
  }'
```

### Get Current User (Protected)
```bash
curl http://localhost:8081/api/v1/users/me \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Create Event (Protected)
```bash
curl -X POST http://localhost:8081/api/v1/events \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Coffee Meetup",
    "description": "Let's grab coffee together!",
    "category": "coffee",
    "start_time": "2025-12-01T14:00:00Z",
    "end_time": "2025-12-01T16:00:00Z",
    "location_name": "Starbucks Central Park",
    "location_address": "Central Park Mall, Jakarta",
    "location_lat": -6.1751,
    "location_lng": 106.8650,
    "max_attendees": 10,
    "is_free": true
  }'
```

### Get Nearby Events
```bash
curl "http://localhost:8081/api/v1/events/nearby?lat=-6.1751&lng=106.8650&radius=5000"
```

## WebSocket Support
Currently not implemented. All communication is via REST API.

## Rate Limiting
Currently not implemented. May be added in future versions.

## Pagination
List endpoints support pagination via query parameters:
```
?page=1&limit=20
```

## Filtering & Sorting
Many list endpoints support filtering and sorting:
```
/events?category=coffee&status=upcoming&sort=start_time
```

## Need Help?
- Check Swagger docs: `http://localhost:8081/swagger/index.html`
- View example code in `docs/examples/`
- Check backend logs for detailed error messages

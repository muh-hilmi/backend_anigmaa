# Microservices Database Architecture

This directory contains consolidated database schemas for a microservices architecture. Each service has its own dedicated database schema file.

## Service Overview

### 1. User Service (`user_service_db.sql`)
**Purpose:** Manages all user-related data, authentication, and social features.

**Tables:**
- `users` - Core user data (email, password, profile)
- `user_settings` - User preferences and settings
- `user_stats` - User statistics and counters
- `user_privacy` - Privacy preferences
- `follows` - Social following relationships
- `invitations` - Event invitation tracking

**Key Features:**
- Username validation and uniqueness
- Social features (follow system)
- Invitation tracking with success counters
- Automatic stat updates via triggers

---

### 2. Event Service (`event_service_db.sql`)
**Purpose:** Manages events, attendees, and event-related features.

**Tables:**
- `events` - Core event data with geolocation
- `event_attendees` - Event attendance tracking
- `event_images` - Event image gallery
- `event_qna` - Event Q&A functionality
- `reviews` - Event reviews and ratings

**Key Features:**
- PostGIS geolocation support
- Event categories (coffee, gaming, sports, etc.)
- Attendee status tracking
- Q&A system for events
- Review and rating system (1-5 stars)

**Extensions Required:**
- `uuid-ossp`
- `postgis`

---

### 3. Post Service (`post_service_db.sql`)
**Purpose:** Manages posts, comments, and social interactions.

**Tables:**
- `posts` - User posts with multiple types
- `post_images` - Post image attachments
- `comments` - Nested comments on posts
- `likes` - Likes for posts and comments
- `reposts` - Repost functionality
- `bookmarks` - Saved posts
- `shares` - Share tracking

**Key Features:**
- Multiple post types (text, images, events, polls)
- Visibility control (public, followers, private)
- Nested comment replies
- Like system for posts and comments
- Bookmark and share tracking

---

### 4. Ticket Service (`ticket_service_db.sql`)
**Purpose:** Manages event tickets and payment transactions.

**Tables:**
- `tickets` - Event tickets with attendance codes
- `ticket_transactions` - Payment transaction tracking

**Key Features:**
- Unique attendance codes
- Check-in tracking
- Payment transaction management
- Multiple payment methods support
- Refund tracking

---

## Cross-Service References

Some tables reference entities from other services via foreign keys. In a true microservices architecture, these would be handled differently (e.g., via API calls or event-driven communication).

### Current Foreign Key References:

**User Service:**
- No external dependencies

**Event Service:**
- `events.host_id` → User Service
- `event_attendees.user_id` → User Service
- `event_qna.user_id` → User Service
- `event_qna.answered_by` → User Service
- `reviews.reviewer_id` → User Service

**Post Service:**
- `posts.author_id` → User Service
- `posts.event_id` → Event Service
- `posts.attached_event_id` → Event Service
- `comments.author_id` → User Service
- `likes.user_id` → User Service
- `reposts.user_id` → User Service
- `bookmarks.user_id` → User Service
- `shares.user_id` → User Service

**Ticket Service:**
- `tickets.user_id` → User Service
- `tickets.event_id` → Event Service

---

## Deployment Options

### Option 1: Separate Databases (Full Microservices)
Each service gets its own PostgreSQL database:

```bash
# Create databases
createdb anigmaa_user_service
createdb anigmaa_event_service
createdb anigmaa_post_service
createdb anigmaa_ticket_service

# Initialize each database
psql anigmaa_user_service < db/services/user_service_db.sql
psql anigmaa_event_service < db/services/event_service_db.sql
psql anigmaa_post_service < db/services/post_service_db.sql
psql anigmaa_ticket_service < db/services/ticket_service_db.sql
```

**Considerations:**
- Foreign key constraints must be removed or handled at application level
- Implement API communication between services
- Consider using event-driven architecture (Kafka, RabbitMQ)

### Option 2: Single Database with Schemas (Monolith-to-Microservices Transition)
Keep all services in one database but use separate schemas:

```sql
-- Create schemas
CREATE SCHEMA IF NOT EXISTS user_service;
CREATE SCHEMA IF NOT EXISTS event_service;
CREATE SCHEMA IF NOT EXISTS post_service;
CREATE SCHEMA IF NOT EXISTS ticket_service;

-- Then run SQL files with schema prefix
-- Or modify search_path before running each file
```

### Option 3: Current Monolith (Development/Testing)
Use the existing migration system in `/migrations` directory for a monolithic deployment.

---

## Migration Strategy

### From Monolith to Microservices:

1. **Phase 1: Logical Separation**
   - Use these consolidated files for documentation
   - Keep existing monolith structure
   - Refactor application code to use service boundaries

2. **Phase 2: Schema Separation**
   - Move to separate schemas in same database
   - Update connection strings in application
   - Test cross-service queries

3. **Phase 3: Database Separation**
   - Split into separate databases
   - Implement inter-service communication
   - Remove foreign key constraints
   - Add application-level referential integrity checks

---

## Maintenance

### Adding New Tables

When adding new tables, determine which service they belong to:
- User-related → `user_service_db.sql`
- Event-related → `event_service_db.sql`
- Post/Social-related → `post_service_db.sql`
- Ticketing/Payment-related → `ticket_service_db.sql`

### Updating Existing Tables

Update the appropriate service file and maintain consistency with migration files in `/migrations`.

---

## Testing

Each service database can be tested independently:

```bash
# Test user service
psql -d test_user_service -f db/services/user_service_db.sql
# Run user service tests

# Test event service
psql -d test_event_service -f db/services/event_service_db.sql
# Run event service tests

# ... etc
```

---

## Notes

- All services use UUID as primary keys
- Timestamps use `TIMESTAMP WITH TIME ZONE`
- All services include `update_updated_at_column()` trigger function
- Extensions (`uuid-ossp`, `postgis`) must be installed before running scripts

---

## Questions?

For questions about the database architecture, please refer to:
- Original migrations: `/migrations`
- Application code: `/internal/repository/postgres`
- API documentation: `/docs`

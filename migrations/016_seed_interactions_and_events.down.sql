-- ============================================================================
-- ROLLBACK: SEED DATA FOR INTERACTIONS AND EVENTS
-- ============================================================================
-- This migration removes all seeded interaction data
-- WARNING: This will delete likes, comments, shares, and event attendees
-- Only use this if you want to reset to a clean state
-- ============================================================================

-- Delete all likes
DELETE FROM likes;

-- Delete all comments
DELETE FROM comments;

-- Delete all shares
DELETE FROM shares;

-- Delete all reposts
DELETE FROM reposts;

-- Delete all event attendees
DELETE FROM event_attendees;

-- Reset event counters
UPDATE events SET
    attendees_count = 0,
    tickets_sold = 0;

-- Reset post counters
UPDATE posts SET
    likes_count = 0,
    comments_count = 0,
    shares_count = 0,
    reposts_count = 0;

-- Reset user stats
UPDATE user_stats SET
    events_attended = 0;

-- Reset all events to free (optional - remove if you want to keep pricing)
UPDATE events SET
    is_free = TRUE,
    price = NULL,
    ticketing_enabled = FALSE;

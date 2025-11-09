-- ============================================================================
-- ROLLBACK: REMOVE COUNTERS AND Q&A TABLE
-- ============================================================================

-- Drop event_qna table
DROP TRIGGER IF EXISTS update_event_qna_updated_at ON event_qna;
DROP TABLE IF EXISTS event_qna CASCADE;

-- Remove attendees_count column from events table
ALTER TABLE events DROP COLUMN IF EXISTS attendees_count;

-- Reset counters to 0 (optional, but clean)
UPDATE posts SET likes_count = 0, comments_count = 0, reposts_count = 0, shares_count = 0;
UPDATE comments SET likes_count = 0;

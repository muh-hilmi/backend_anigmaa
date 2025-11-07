-- Rollback for 011: Remove enhanced seed data

-- Remove likes added in this migration
DELETE FROM likes WHERE created_at >= NOW() - INTERVAL '3 days';

-- Remove comments added in this migration
DELETE FROM comments WHERE id LIKE 'c50e8400-e29b-41d4-a716-446655440%';

-- Remove event attendees added in this migration
DELETE FROM event_attendees WHERE joined_at >= NOW() - INTERVAL '14 days';

-- Reset counts
UPDATE posts SET likes_count = 0, comments_count = 0;
UPDATE events SET attendees_count = 0;

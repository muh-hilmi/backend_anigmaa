-- Rollback for 012: Remove bulk posts and events

-- Remove all generated posts (ID pattern: 750e8400-e29b-41d4-a716-4466554*)
DELETE FROM posts WHERE id LIKE '750e8400-e29b-41d4-a716-4466554%';

-- Remove all generated events (ID pattern: 850e8400-e29b-41d4-a716-4466554*)
DELETE FROM events WHERE id LIKE '850e8400-e29b-41d4-a716-4466554%';

-- Cleanup orphaned data
DELETE FROM likes WHERE likeable_id NOT IN (SELECT id FROM posts);
DELETE FROM comments WHERE post_id NOT IN (SELECT id FROM posts);
DELETE FROM event_attendees WHERE event_id NOT IN (SELECT id FROM events);

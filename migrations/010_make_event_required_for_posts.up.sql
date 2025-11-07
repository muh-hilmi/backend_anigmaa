-- Make attached_event_id required for all posts
-- This ensures that every post must have an associated event

-- Add NOT NULL constraint to attached_event_id
ALTER TABLE posts
ALTER COLUMN attached_event_id SET NOT NULL;

-- Add a check constraint to ensure the event exists
ALTER TABLE posts
DROP CONSTRAINT IF EXISTS posts_attached_event_id_fkey,
ADD CONSTRAINT posts_attached_event_id_fkey
FOREIGN KEY (attached_event_id)
REFERENCES events(id)
ON DELETE RESTRICT;

-- Revert making attached_event_id required for posts

-- Remove NOT NULL constraint from attached_event_id
ALTER TABLE posts
ALTER COLUMN attached_event_id DROP NOT NULL;

-- Restore the original foreign key constraint with SET NULL on delete
ALTER TABLE posts
DROP CONSTRAINT IF EXISTS posts_attached_event_id_fkey,
ADD CONSTRAINT posts_attached_event_id_fkey
FOREIGN KEY (attached_event_id)
REFERENCES events(id)
ON DELETE SET NULL;

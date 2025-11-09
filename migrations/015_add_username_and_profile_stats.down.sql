-- ============================================================================
-- ROLLBACK: USERNAME AND ENHANCED PROFILE STATS
-- ============================================================================

-- Drop triggers
DROP TRIGGER IF EXISTS update_invites_count_trigger ON invitations;
DROP TRIGGER IF EXISTS update_posts_count_trigger ON posts;

-- Drop functions
DROP FUNCTION IF EXISTS update_invites_count();
DROP FUNCTION IF EXISTS update_posts_count();

-- Drop invitations table
DROP TABLE IF EXISTS invitations;

-- Drop columns from user_stats
ALTER TABLE user_stats DROP COLUMN IF EXISTS posts_count;
ALTER TABLE user_stats DROP COLUMN IF EXISTS invites_successful_count;

-- Drop username constraints and index
DROP INDEX IF EXISTS idx_users_username;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_username_unique;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_username_format;

-- Drop username column
ALTER TABLE users DROP COLUMN IF EXISTS username;

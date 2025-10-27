-- Drop triggers
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
DROP FUNCTION IF EXISTS update_updated_at_column();

-- Drop indexes
DROP INDEX IF EXISTS idx_follows_following;
DROP INDEX IF EXISTS idx_follows_follower;
DROP INDEX IF EXISTS idx_users_email;

-- Drop tables
DROP TABLE IF EXISTS follows;
DROP TABLE IF EXISTS user_privacy;
DROP TABLE IF EXISTS user_stats;
DROP TABLE IF EXISTS user_settings;
DROP TABLE IF EXISTS users;

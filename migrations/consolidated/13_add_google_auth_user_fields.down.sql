-- ============================================================================
-- ROLLBACK: Remove Google Auth User Fields
-- ============================================================================
-- This migration rolls back the changes made in 13_add_google_auth_user_fields.up.sql
-- ============================================================================

-- Drop new indexes
DROP INDEX IF EXISTS idx_users_interests;
DROP INDEX IF EXISTS idx_users_gender;
DROP INDEX IF EXISTS idx_users_date_of_birth;
DROP INDEX IF EXISTS idx_users_location;

-- Drop new constraints
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_gender_values;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_phone_format;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_username_format;

-- Drop unique index for username
DROP INDEX IF EXISTS users_username_unique_idx;

-- Remove new columns
ALTER TABLE users DROP COLUMN IF EXISTS interests;
ALTER TABLE users DROP COLUMN IF EXISTS location;
ALTER TABLE users DROP COLUMN IF EXISTS gender;
ALTER TABLE users DROP COLUMN IF EXISTS date_of_birth;
ALTER TABLE users DROP COLUMN IF EXISTS phone;

-- Restore username and password_hash as NOT NULL
-- NOTE: This will fail if there are existing users with NULL values
-- In production, you would need to handle data migration before this
ALTER TABLE users ALTER COLUMN password_hash SET NOT NULL;
ALTER TABLE users ALTER COLUMN username SET NOT NULL;

-- Restore original username constraints
ALTER TABLE users ADD CONSTRAINT users_username_unique UNIQUE (username);
ALTER TABLE users ADD CONSTRAINT users_username_format CHECK (username ~ '^[a-zA-Z0-9_-]{3,50}$');

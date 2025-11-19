-- ============================================================================
-- MIGRATION: Add Google Auth User Fields
-- ============================================================================
-- This migration adds support for Google authentication and enhanced user profiles:
-- 1. Makes username and password_hash nullable (Google auth doesn't need them)
-- 2. Adds essential user profile fields: phone, date_of_birth, gender, location, interests
-- 3. Updates constraints and indexes
-- ============================================================================

-- ============================================================================
-- MODIFY USERS TABLE
-- ============================================================================

-- Make username nullable and remove NOT NULL constraint
ALTER TABLE users ALTER COLUMN username DROP NOT NULL;

-- Make password_hash nullable (Google OAuth users don't have password)
ALTER TABLE users ALTER COLUMN password_hash DROP NOT NULL;

-- Remove username unique constraint (we'll add it back as a conditional unique)
-- First, drop the existing constraint
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_username_unique;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_username_format;

-- Add new columns
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(20);
ALTER TABLE users ADD COLUMN IF NOT EXISTS date_of_birth DATE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS gender VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS location VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS interests TEXT[];

-- Re-add username format check, but only when username is not null
ALTER TABLE users ADD CONSTRAINT users_username_format
    CHECK (username IS NULL OR username ~ '^[a-zA-Z0-9_-]{3,50}$');

-- Add unique constraint for username when it's not null
-- (PostgreSQL allows multiple NULLs in a unique column)
CREATE UNIQUE INDEX IF NOT EXISTS users_username_unique_idx ON users(username) WHERE username IS NOT NULL;

-- Add check constraints for new fields
ALTER TABLE users ADD CONSTRAINT users_phone_format
    CHECK (phone IS NULL OR phone ~ '^[0-9]{10,15}$');

ALTER TABLE users ADD CONSTRAINT users_gender_values
    CHECK (gender IS NULL OR gender IN ('Laki-laki', 'Perempuan', 'Lainnya', 'Prefer not to say'));

-- ============================================================================
-- CREATE INDEXES FOR NEW FIELDS
-- ============================================================================

-- Index for location-based queries
CREATE INDEX IF NOT EXISTS idx_users_location ON users(location) WHERE location IS NOT NULL;

-- Index for date of birth (for age-based filtering)
CREATE INDEX IF NOT EXISTS idx_users_date_of_birth ON users(date_of_birth) WHERE date_of_birth IS NOT NULL;

-- Index for gender-based filtering
CREATE INDEX IF NOT EXISTS idx_users_gender ON users(gender) WHERE gender IS NOT NULL;

-- GIN index for interests array (for array search)
CREATE INDEX IF NOT EXISTS idx_users_interests ON users USING GIN(interests) WHERE interests IS NOT NULL;

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Changes made:
-- 1. Made username and password_hash nullable (supports Google OAuth)
-- 2. Added phone, date_of_birth, gender, location, interests fields
-- 3. Added validation constraints for phone and gender
-- 4. Created indexes for efficient querying on new fields
-- 5. Updated username unique constraint to allow multiple NULLs
-- ============================================================================

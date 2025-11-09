-- ============================================================================
-- ADD USERNAME AND ENHANCED PROFILE STATS
-- ============================================================================
-- This migration adds:
-- 1. username field to users table (unique, required for profile sharing)
-- 2. posts_count to user_stats (track total posts created)
-- 3. invites_successful_count to user_stats (track successful invitations)
-- 4. Updates all counters to reflect existing data
-- ============================================================================

-- ============================================================================
-- ADD USERNAME TO USERS TABLE
-- ============================================================================

-- Add username column (nullable initially)
ALTER TABLE users ADD COLUMN IF NOT EXISTS username VARCHAR(50);

-- Generate usernames for existing users (using name + random numbers)
DO $$
DECLARE
    user_record RECORD;
    base_username TEXT;
    final_username TEXT;
    counter INTEGER;
BEGIN
    FOR user_record IN SELECT id, name FROM users WHERE username IS NULL
    LOOP
        -- Create base username from name (lowercase, remove spaces, take first 20 chars)
        base_username := lower(regexp_replace(substring(user_record.name, 1, 20), '[^a-zA-Z0-9]', '', 'g'));

        -- If base_username is empty, use 'user'
        IF base_username = '' THEN
            base_username := 'user';
        END IF;

        -- Try to find unique username
        counter := 0;
        final_username := base_username;

        WHILE EXISTS (SELECT 1 FROM users WHERE username = final_username) LOOP
            counter := counter + 1;
            final_username := base_username || floor(random() * 10000)::text;
        END LOOP;

        -- Update user with unique username
        UPDATE users SET username = final_username WHERE id = user_record.id;
    END LOOP;
END $$;

-- Make username NOT NULL and UNIQUE after populating
ALTER TABLE users ALTER COLUMN username SET NOT NULL;
ALTER TABLE users ADD CONSTRAINT users_username_unique UNIQUE (username);

-- Add index for username lookups
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Add check constraint for username format (alphanumeric, underscore, hyphen, 3-50 chars)
ALTER TABLE users ADD CONSTRAINT users_username_format
    CHECK (username ~ '^[a-zA-Z0-9_-]{3,50}$');

-- ============================================================================
-- ADD POSTS_COUNT AND INVITES_SUCCESSFUL_COUNT TO USER_STATS
-- ============================================================================

-- Add posts_count column
ALTER TABLE user_stats ADD COLUMN IF NOT EXISTS posts_count INTEGER DEFAULT 0;

-- Add invites_successful_count column (tracks how many people user successfully invited)
ALTER TABLE user_stats ADD COLUMN IF NOT EXISTS invites_successful_count INTEGER DEFAULT 0;

-- ============================================================================
-- UPDATE COUNTERS WITH EXISTING DATA
-- ============================================================================

-- Update posts_count for all users
UPDATE user_stats SET posts_count = (
    SELECT COUNT(*) FROM posts
    WHERE author_id = user_stats.user_id
);

-- Insert user_stats for users who don't have one yet
INSERT INTO user_stats (user_id, events_attended, events_created, followers_count, following_count, reviews_given, average_rating, posts_count, invites_successful_count)
SELECT u.id, 0, 0, 0, 0, 0, 0.0, 0, 0
FROM users u
WHERE NOT EXISTS (SELECT 1 FROM user_stats WHERE user_id = u.id);

-- Update posts_count again for new entries
UPDATE user_stats SET posts_count = (
    SELECT COUNT(*) FROM posts
    WHERE author_id = user_stats.user_id
)
WHERE posts_count = 0;

-- Update events_created count (ensure it's accurate)
UPDATE user_stats SET events_created = (
    SELECT COUNT(*) FROM events
    WHERE host_id = user_stats.user_id
);

-- ============================================================================
-- CREATE INVITATIONS TABLE (for tracking who invited whom)
-- ============================================================================

-- Create invitations table if not exists
CREATE TABLE IF NOT EXISTS invitations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    inviter_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    invitee_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    event_id UUID REFERENCES events(id) ON DELETE SET NULL,
    status VARCHAR(20) DEFAULT 'pending', -- pending, accepted, declined
    invited_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    responded_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(inviter_id, invitee_id, event_id)
);

-- Create indexes for invitations
CREATE INDEX IF NOT EXISTS idx_invitations_inviter ON invitations(inviter_id);
CREATE INDEX IF NOT EXISTS idx_invitations_invitee ON invitations(invitee_id);
CREATE INDEX IF NOT EXISTS idx_invitations_event ON invitations(event_id);
CREATE INDEX IF NOT EXISTS idx_invitations_status ON invitations(status);

-- ============================================================================
-- CREATE FUNCTION TO UPDATE INVITES_SUCCESSFUL_COUNT
-- ============================================================================

-- Function to update invites count when invitation is accepted
CREATE OR REPLACE FUNCTION update_invites_count()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'accepted' AND (OLD.status IS NULL OR OLD.status != 'accepted') THEN
        -- Increment inviter's successful invites count
        UPDATE user_stats
        SET invites_successful_count = invites_successful_count + 1
        WHERE user_id = NEW.inviter_id;
    ELSIF OLD.status = 'accepted' AND NEW.status != 'accepted' THEN
        -- Decrement if status changed from accepted to something else
        UPDATE user_stats
        SET invites_successful_count = GREATEST(invites_successful_count - 1, 0)
        WHERE user_id = NEW.inviter_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- Create trigger for invitations
DROP TRIGGER IF EXISTS update_invites_count_trigger ON invitations;
CREATE TRIGGER update_invites_count_trigger
    AFTER INSERT OR UPDATE ON invitations
    FOR EACH ROW EXECUTE FUNCTION update_invites_count();

-- ============================================================================
-- CREATE FUNCTION TO AUTO-UPDATE POSTS_COUNT
-- ============================================================================

-- Function to update posts count when post is created/deleted
CREATE OR REPLACE FUNCTION update_posts_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE user_stats
        SET posts_count = posts_count + 1
        WHERE user_id = NEW.author_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE user_stats
        SET posts_count = GREATEST(posts_count - 1, 0)
        WHERE user_id = OLD.author_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

-- Create trigger for posts
DROP TRIGGER IF EXISTS update_posts_count_trigger ON posts;
CREATE TRIGGER update_posts_count_trigger
    AFTER INSERT OR DELETE ON posts
    FOR EACH ROW EXECUTE FUNCTION update_posts_count();

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Added:
-- - username field to users table (unique, indexed, with validation)
-- - posts_count to user_stats (auto-updated via trigger)
-- - invites_successful_count to user_stats (auto-updated via trigger)
-- - invitations table for tracking invitations
-- - Triggers to auto-update counts
-- - Generated unique usernames for all existing users
--
-- Profile sharing is now possible via username!
-- Example: /profile/username or share link: https://app.anigmaa.com/@username
-- ============================================================================

-- ============================================================================
-- USER SERVICE DATABASE SCHEMA
-- ============================================================================
-- This file contains all user-related database schema including:
-- - Users table with authentication and profile data
-- - User settings, stats, and privacy preferences
-- - Social features (follows, invitations)
-- - All related indexes, triggers, and functions
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- CORE USER TABLES
-- ============================================================================

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    bio TEXT,
    avatar_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP WITH TIME ZONE,
    is_verified BOOLEAN DEFAULT FALSE,
    is_email_verified BOOLEAN DEFAULT FALSE,
    CONSTRAINT users_username_format CHECK (username ~ '^[a-zA-Z0-9_-]{3,50}$')
);

-- Create user_settings table
CREATE TABLE IF NOT EXISTS user_settings (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    push_notifications BOOLEAN DEFAULT TRUE,
    email_notifications BOOLEAN DEFAULT TRUE,
    dark_mode BOOLEAN DEFAULT FALSE,
    language VARCHAR(10) DEFAULT 'en',
    location_enabled BOOLEAN DEFAULT TRUE,
    show_online_status BOOLEAN DEFAULT TRUE
);

-- Create user_stats table
CREATE TABLE IF NOT EXISTS user_stats (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    events_attended INTEGER DEFAULT 0,
    events_created INTEGER DEFAULT 0,
    followers_count INTEGER DEFAULT 0,
    following_count INTEGER DEFAULT 0,
    reviews_given INTEGER DEFAULT 0,
    average_rating DECIMAL(3, 2) DEFAULT 0.0,
    posts_count INTEGER DEFAULT 0,
    invites_successful_count INTEGER DEFAULT 0
);

-- Create user_privacy table
CREATE TABLE IF NOT EXISTS user_privacy (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    profile_visible BOOLEAN DEFAULT TRUE,
    events_visible BOOLEAN DEFAULT TRUE,
    allow_followers BOOLEAN DEFAULT TRUE,
    show_email BOOLEAN DEFAULT FALSE,
    show_location BOOLEAN DEFAULT TRUE
);

-- ============================================================================
-- SOCIAL FEATURES
-- ============================================================================

-- Create follows table
CREATE TABLE IF NOT EXISTS follows (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    following_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(follower_id, following_id),
    CHECK (follower_id != following_id)
);

-- Create invitations table
CREATE TABLE IF NOT EXISTS invitations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    inviter_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    invitee_id UUID,
    event_id UUID,
    status VARCHAR(20) DEFAULT 'pending', -- pending, accepted, declined
    invited_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    responded_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(inviter_id, invitee_id, event_id)
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Users indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Follows indexes
CREATE INDEX IF NOT EXISTS idx_follows_follower ON follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_follows_following ON follows(following_id);

-- Invitations indexes
CREATE INDEX IF NOT EXISTS idx_invitations_inviter ON invitations(inviter_id);
CREATE INDEX IF NOT EXISTS idx_invitations_invitee ON invitations(invitee_id);
CREATE INDEX IF NOT EXISTS idx_invitations_event ON invitations(event_id);
CREATE INDEX IF NOT EXISTS idx_invitations_status ON invitations(status);

-- ============================================================================
-- TRIGGERS AND FUNCTIONS
-- ============================================================================

-- Function to update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- Trigger to update users updated_at
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

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

-- Trigger for invitations
DROP TRIGGER IF EXISTS update_invites_count_trigger ON invitations;
CREATE TRIGGER update_invites_count_trigger
    AFTER INSERT OR UPDATE ON invitations
    FOR EACH ROW EXECUTE FUNCTION update_invites_count();

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- User Service includes:
-- - Users table with username support
-- - User settings, stats, and privacy
-- - Social features (follows, invitations)
-- - Automatic counter updates via triggers
-- - Username validation and indexing
-- ============================================================================

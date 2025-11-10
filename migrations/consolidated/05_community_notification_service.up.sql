-- ============================================================================
-- COMMUNITY & NOTIFICATION SERVICE DATABASE SCHEMA
-- ============================================================================
-- This schema contains:
-- - communities: User communities/groups
-- - community_members: Community membership tracking
-- - notifications: User notifications
-- ============================================================================

-- ============================================================================
-- ENUMS
-- ============================================================================

-- Community privacy
CREATE TYPE community_privacy AS ENUM ('public', 'private', 'secret');

-- Community role
CREATE TYPE community_role AS ENUM ('owner', 'admin', 'moderator', 'member');

-- Notification type
CREATE TYPE notification_type AS ENUM (
    'like_post',
    'comment_post',
    'mention',
    'follow',
    'event_invitation',
    'event_reminder',
    'event_update',
    'community_invitation',
    'community_post',
    'system'
);

-- ============================================================================
-- COMMUNITIES TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS communities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    avatar_url VARCHAR(500),
    cover_url VARCHAR(500),
    creator_id UUID NOT NULL,  -- References users(id)
    privacy community_privacy DEFAULT 'public',
    members_count INTEGER DEFAULT 0,
    posts_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT communities_slug_format CHECK (slug ~ '^[a-z0-9-]+$')
);

-- ============================================================================
-- COMMUNITY MEMBERS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS community_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    community_id UUID NOT NULL REFERENCES communities(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,  -- References users(id)
    role community_role DEFAULT 'member',
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(community_id, user_id)
);

-- ============================================================================
-- NOTIFICATIONS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,  -- References users(id) - recipient
    actor_id UUID,  -- References users(id) - who triggered the notification
    type notification_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    link VARCHAR(500),  -- Deep link to the content
    metadata JSONB,  -- Additional data (post_id, event_id, etc.)
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Communities indexes
CREATE INDEX IF NOT EXISTS idx_communities_creator ON communities(creator_id);
CREATE INDEX IF NOT EXISTS idx_communities_slug ON communities(slug);
CREATE INDEX IF NOT EXISTS idx_communities_privacy ON communities(privacy);

-- Community members indexes
CREATE INDEX IF NOT EXISTS idx_community_members_community ON community_members(community_id);
CREATE INDEX IF NOT EXISTS idx_community_members_user ON community_members(user_id);
CREATE INDEX IF NOT EXISTS idx_community_members_role ON community_members(role);

-- Notifications indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread ON notifications(user_id, is_read) WHERE is_read = false;

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Trigger to update communities updated_at
DROP TRIGGER IF EXISTS update_communities_updated_at ON communities;
CREATE TRIGGER update_communities_updated_at BEFORE UPDATE ON communities
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- TRIGGER FUNCTIONS FOR AUTO-UPDATING COUNTERS
-- ============================================================================

-- Function to update community members count
CREATE OR REPLACE FUNCTION update_community_members_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE communities
        SET members_count = members_count + 1
        WHERE id = NEW.community_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE communities
        SET members_count = GREATEST(members_count - 1, 0)
        WHERE id = OLD.community_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

-- Create trigger for community members count
DROP TRIGGER IF EXISTS update_community_members_count_trigger ON community_members;
CREATE TRIGGER update_community_members_count_trigger
    AFTER INSERT OR DELETE ON community_members
    FOR EACH ROW EXECUTE FUNCTION update_community_members_count();

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Created tables:
-- 1. communities - User communities/groups
-- 2. community_members - Membership tracking with roles
-- 3. notifications - User notification system
--
-- Features:
-- - Community privacy levels (public, private, secret)
-- - Role-based access (owner, admin, moderator, member)
-- - Comprehensive notification system
-- - Auto-updating member counts
-- - Optimized indexes for queries
-- ============================================================================

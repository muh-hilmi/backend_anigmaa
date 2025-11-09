-- ============================================================================
-- EVENT SERVICE DATABASE SCHEMA
-- ============================================================================
-- This file contains all event-related database schema including:
-- - Events table with geolocation support
-- - Event attendees and images
-- - Event Q&A functionality
-- - Event reviews and ratings
-- - All related indexes, triggers, and functions
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;

-- ============================================================================
-- ENUMS
-- ============================================================================

-- Create event status enum
CREATE TYPE event_status AS ENUM ('upcoming', 'ongoing', 'completed', 'cancelled');

-- Create event privacy enum
CREATE TYPE event_privacy AS ENUM ('public', 'private', 'friends_only');

-- Create event category enum
CREATE TYPE event_category AS ENUM (
    'coffee', 'food', 'gaming', 'sports', 'music', 'movies',
    'study', 'art', 'other', 'workshop', 'networking'
);

-- Create attendee status enum
CREATE TYPE attendee_status AS ENUM ('pending', 'confirmed', 'cancelled');

-- ============================================================================
-- CORE EVENT TABLES
-- ============================================================================

-- Create events table
CREATE TABLE IF NOT EXISTS events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category event_category NOT NULL,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    location_name VARCHAR(255) NOT NULL,
    location_address TEXT NOT NULL,
    location_lat DECIMAL(10, 8) NOT NULL,
    location_lng DECIMAL(11, 8) NOT NULL,
    location_geom GEOGRAPHY(POINT, 4326),
    max_attendees INTEGER NOT NULL CHECK (max_attendees > 0),
    attendees_count INTEGER DEFAULT 0,
    price DECIMAL(10, 2) CHECK (price >= 0),
    is_free BOOLEAN DEFAULT TRUE,
    status event_status DEFAULT 'upcoming',
    privacy event_privacy DEFAULT 'public',
    requirements TEXT,
    ticketing_enabled BOOLEAN DEFAULT FALSE,
    tickets_sold INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CHECK (end_time > start_time)
);

-- Create event_images table
CREATE TABLE IF NOT EXISTS event_images (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    image_url VARCHAR(500) NOT NULL,
    order_index INTEGER NOT NULL DEFAULT 0
);

-- Create event_attendees table
CREATE TABLE IF NOT EXISTS event_attendees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status attendee_status DEFAULT 'confirmed',
    UNIQUE(event_id, user_id)
);

-- ============================================================================
-- EVENT Q&A
-- ============================================================================

-- Create event_qna table for Q&A functionality
CREATE TABLE IF NOT EXISTS event_qna (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    question TEXT NOT NULL,
    answer TEXT,
    answered_by UUID,
    answered_at TIMESTAMP WITH TIME ZONE,
    is_answered BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- EVENT REVIEWS
-- ============================================================================

-- Create reviews table
CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    reviewer_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(event_id, reviewer_id)
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Events indexes
CREATE INDEX IF NOT EXISTS idx_events_host ON events(host_id);
CREATE INDEX IF NOT EXISTS idx_events_category ON events(category);
CREATE INDEX IF NOT EXISTS idx_events_status ON events(status);
CREATE INDEX IF NOT EXISTS idx_events_start_time ON events(start_time);
CREATE INDEX IF NOT EXISTS idx_events_location_geom ON events USING GIST(location_geom);

-- Event images indexes
CREATE INDEX IF NOT EXISTS idx_event_images_event ON event_images(event_id);

-- Event attendees indexes
CREATE INDEX IF NOT EXISTS idx_event_attendees_event ON event_attendees(event_id);
CREATE INDEX IF NOT EXISTS idx_event_attendees_user ON event_attendees(user_id);

-- Event Q&A indexes
CREATE INDEX IF NOT EXISTS idx_event_qna_event ON event_qna(event_id);
CREATE INDEX IF NOT EXISTS idx_event_qna_user ON event_qna(user_id);
CREATE INDEX IF NOT EXISTS idx_event_qna_is_answered ON event_qna(is_answered);

-- Reviews indexes
CREATE INDEX IF NOT EXISTS idx_reviews_event ON reviews(event_id);
CREATE INDEX IF NOT EXISTS idx_reviews_reviewer ON reviews(reviewer_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);

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

-- Function to update location_geom from lat/lng
CREATE OR REPLACE FUNCTION update_location_geom()
RETURNS TRIGGER AS $$
BEGIN
    NEW.location_geom := ST_SetSRID(ST_MakePoint(NEW.location_lng, NEW.location_lat), 4326)::geography;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- Trigger to update location_geom
DROP TRIGGER IF EXISTS update_events_location_geom ON events;
CREATE TRIGGER update_events_location_geom BEFORE INSERT OR UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_location_geom();

-- Trigger to update events updated_at
DROP TRIGGER IF EXISTS update_events_updated_at ON events;
CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger to update event_qna updated_at
DROP TRIGGER IF EXISTS update_event_qna_updated_at ON event_qna;
CREATE TRIGGER update_event_qna_updated_at BEFORE UPDATE ON event_qna
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger to update reviews updated_at
DROP TRIGGER IF EXISTS update_reviews_updated_at ON reviews;
CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Event Service includes:
-- - Events table with geolocation support (PostGIS)
-- - Event categories: coffee, food, gaming, sports, music, etc.
-- - Event attendees with status tracking
-- - Event images with ordering support
-- - Event Q&A functionality for user questions
-- - Event reviews and ratings (1-5 stars)
-- - Automatic geolocation updates via triggers
-- - Foreign key references to user_id (external service)
-- ============================================================================

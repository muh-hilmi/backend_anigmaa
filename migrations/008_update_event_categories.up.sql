-- Update event_category enum to match Flutter app expectations
-- This migration updates the enum values to align with the mobile app

-- Step 1: Add new enum values
ALTER TYPE event_category ADD VALUE IF NOT EXISTS 'meetup';
ALTER TYPE event_category ADD VALUE IF NOT EXISTS 'workshop';
ALTER TYPE event_category ADD VALUE IF NOT EXISTS 'networking';
ALTER TYPE event_category ADD VALUE IF NOT EXISTS 'creative';
ALTER TYPE event_category ADD VALUE IF NOT EXISTS 'outdoor';
ALTER TYPE event_category ADD VALUE IF NOT EXISTS 'fitness';
ALTER TYPE event_category ADD VALUE IF NOT EXISTS 'learning';
ALTER TYPE event_category ADD VALUE IF NOT EXISTS 'social';

-- Note: PostgreSQL doesn't allow removing enum values easily
-- Old values (coffee, gaming, music, movies, study, art, other) will remain but deprecated
-- They are mapped to new values in application code if needed

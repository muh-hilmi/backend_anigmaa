-- Drop triggers
DROP TRIGGER IF EXISTS update_events_updated_at ON events;
DROP TRIGGER IF EXISTS update_events_location_geom ON events;
DROP FUNCTION IF EXISTS update_location_geom();

-- Drop indexes
DROP INDEX IF EXISTS idx_event_images_event;
DROP INDEX IF EXISTS idx_event_attendees_user;
DROP INDEX IF EXISTS idx_event_attendees_event;
DROP INDEX IF EXISTS idx_events_location_geom;
DROP INDEX IF EXISTS idx_events_start_time;
DROP INDEX IF EXISTS idx_events_status;
DROP INDEX IF EXISTS idx_events_category;
DROP INDEX IF EXISTS idx_events_host;

-- Drop tables
DROP TABLE IF EXISTS event_attendees;
DROP TABLE IF EXISTS event_images;
DROP TABLE IF EXISTS events;

-- Drop enums
DROP TYPE IF EXISTS attendee_status;
DROP TYPE IF EXISTS event_category;
DROP TYPE IF EXISTS event_privacy;
DROP TYPE IF EXISTS event_status;

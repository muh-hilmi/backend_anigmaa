-- Drop trigger
DROP TRIGGER IF EXISTS update_reviews_updated_at ON reviews;

-- Drop indexes
DROP INDEX IF EXISTS idx_reviews_rating;
DROP INDEX IF EXISTS idx_reviews_reviewer;
DROP INDEX IF EXISTS idx_reviews_event;

-- Drop table
DROP TABLE IF EXISTS reviews;

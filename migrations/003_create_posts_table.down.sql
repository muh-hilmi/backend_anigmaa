-- Drop triggers
DROP TRIGGER IF EXISTS update_comments_updated_at ON comments;
DROP TRIGGER IF EXISTS update_posts_updated_at ON posts;

-- Drop indexes
DROP INDEX IF EXISTS idx_shares_post;
DROP INDEX IF EXISTS idx_bookmarks_user;
DROP INDEX IF EXISTS idx_reposts_post;
DROP INDEX IF EXISTS idx_reposts_user;
DROP INDEX IF EXISTS idx_likes_likeable;
DROP INDEX IF EXISTS idx_likes_user;
DROP INDEX IF EXISTS idx_comments_parent;
DROP INDEX IF EXISTS idx_comments_author;
DROP INDEX IF EXISTS idx_comments_post;
DROP INDEX IF EXISTS idx_post_images_post;
DROP INDEX IF EXISTS idx_posts_visibility;
DROP INDEX IF EXISTS idx_posts_type;
DROP INDEX IF EXISTS idx_posts_created_at;
DROP INDEX IF EXISTS idx_posts_author;

-- Drop tables
DROP TABLE IF EXISTS shares;
DROP TABLE IF EXISTS bookmarks;
DROP TABLE IF EXISTS reposts;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS post_images;
DROP TABLE IF EXISTS posts;

-- Drop enums
DROP TYPE IF EXISTS likeable_type;
DROP TYPE IF EXISTS post_visibility;
DROP TYPE IF EXISTS post_type;

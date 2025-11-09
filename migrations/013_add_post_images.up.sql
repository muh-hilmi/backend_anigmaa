-- ============================================================================
-- ADD IMAGES TO EXISTING POSTS
-- ============================================================================
-- This migration adds sample images to make the feed more visually appealing
-- Uses Unsplash image URLs for various post types
-- ============================================================================

-- Update posts to type 'text_with_images' for posts that will have images
UPDATE posts SET type = 'text_with_images' WHERE id IN (
    '750e8400-e29b-41d4-a716-446655440000', -- Coffee meetup
    '750e8400-e29b-41d4-a716-446655440001', -- Gaming night
    '750e8400-e29b-41d4-a716-446655440002', -- Morning run
    '750e8400-e29b-41d4-a716-446655440003', -- Acoustic night
    '750e8400-e29b-41d4-a716-446655440004', -- Movie marathon
    '750e8400-e29b-41d4-a716-446655440006', -- Coffee shop discovery
    '750e8400-e29b-41d4-a716-446655440008', -- Personal best run
    '750e8400-e29b-41d4-a716-446655440009', -- Watercolor painting
    '750e8400-e29b-41d4-a716-446655440010', -- Blade Runner
    '750e8400-e29b-41d4-a716-446655440020', -- Coffee morning
    '750e8400-e29b-41d4-a716-446655440021', -- Gaming night weekend
    '750e8400-e29b-41d4-a716-446655440022', -- Brunch spot
    '750e8400-e29b-41d4-a716-446655440023', -- Morning run tomorrow
    '750e8400-e29b-41d4-a716-446655440024'  -- Acoustic night next week
);

-- ============================================================================
-- INSERT POST IMAGES
-- ============================================================================

-- Post 1: Coffee meetup (2 images)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440000', 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800', 0),
('750e8400-e29b-41d4-a716-446655440000', 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800', 1);

-- Post 2: Gaming night (3 images)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440001', 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=800', 0),
('750e8400-e29b-41d4-a716-446655440001', 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800', 1),
('750e8400-e29b-41d4-a716-446655440001', 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=800', 2);

-- Post 3: Morning run (1 image)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440002', 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800', 0);

-- Post 4: Acoustic night (2 images)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440003', 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=800', 0),
('750e8400-e29b-41d4-a716-446655440003', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800', 1);

-- Post 5: Movie marathon (2 images)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440004', 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800', 0),
('750e8400-e29b-41d4-a716-446655440004', 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800', 1);

-- Post 7: Coffee shop discovery (4 images - max)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440006', 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800', 0),
('750e8400-e29b-41d4-a716-446655440006', 'https://images.unsplash.com/photo-1453614512568-c4024d13c247?w=800', 1),
('750e8400-e29b-41d4-a716-446655440006', 'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800', 2),
('750e8400-e29b-41d4-a716-446655440006', 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800', 3);

-- Post 9: Personal best run (2 images)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440008', 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=800', 0),
('750e8400-e29b-41d4-a716-446655440008', 'https://images.unsplash.com/photo-1571008887538-b36bb32f4571?w=800', 1);

-- Post 10: Watercolor painting (3 images)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440009', 'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=800', 0),
('750e8400-e29b-41d4-a716-446655440009', 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800', 1),
('750e8400-e29b-41d4-a716-446655440009', 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800', 2);

-- Post 11: Blade Runner (2 images)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440010', 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800', 0),
('750e8400-e29b-41d4-a716-446655440010', 'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=800', 1);

-- Post 20: Coffee morning (2 images)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440020', 'https://images.unsplash.com/photo-1497515114629-f71d768fd07c?w=800', 0),
('750e8400-e29b-41d4-a716-446655440020', 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800', 1);

-- Post 21: Gaming night weekend (2 images)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440021', 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800', 0),
('750e8400-e29b-41d4-a716-446655440021', 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=800', 1);

-- Post 22: Brunch spot (4 images - food porn!)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440022', 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=800', 0),
('750e8400-e29b-41d4-a716-446655440022', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800', 1),
('750e8400-e29b-41d4-a716-446655440022', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800', 2),
('750e8400-e29b-41d4-a716-446655440022', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800', 3);

-- Post 23: Morning run tomorrow (1 image)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440023', 'https://images.unsplash.com/photo-1483721310020-03333e577078?w=800', 0);

-- Post 24: Acoustic night next week (3 images)
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('750e8400-e29b-41d4-a716-446655440024', 'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=800', 0),
('750e8400-e29b-41d4-a716-446655440024', 'https://images.unsplash.com/photo-1598387993441-a364f854c3e1?w=800', 1),
('750e8400-e29b-41d4-a716-446655440024', 'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=800', 2);

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Total posts with images: 14
-- Total images added: 35
-- Image distribution:
--   - 1 image: 2 posts
--   - 2 images: 8 posts
--   - 3 images: 2 posts
--   - 4 images: 2 posts
-- ============================================================================

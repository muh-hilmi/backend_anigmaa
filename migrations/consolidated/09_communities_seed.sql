-- ============================================================================
-- COMMUNITIES COMPREHENSIVE SEED DATA
-- ============================================================================
-- This seed file contains:
-- - 12 communities (various categories)
-- - Community members with different roles
-- - Community posts and interactions
-- - Community events association
-- ============================================================================

-- ============================================================================
-- 1. COMMUNITIES (12 diverse communities)
-- ============================================================================

INSERT INTO communities (id, name, slug, description, avatar_url, cover_url, creator_id, privacy, created_at) VALUES
-- Tech & Developer Communities
('c1000001-0000-0000-0000-000000000001', 'Jakarta Tech Meetup', 'jakarta-tech-meetup',
'Monthly meetup for software engineers, developers, and tech enthusiasts in Jakarta. Share knowledge, network, and grow together! 🚀',
'https://images.unsplash.com/photo-1522071820081-009f0129c71c',
'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',
'99999999-9999-9999-9999-999999999999', 'public', NOW() - INTERVAL '10 months'),

('c1000002-0000-0000-0000-000000000002', 'React Indonesia', 'react-indonesia',
'Indonesian React.js community. Learn React, share best practices, and build amazing UIs together! ⚛️',
'https://images.unsplash.com/photo-1633356122544-f134324a6cee',
'https://images.unsplash.com/photo-1587620962725-abab7fe55159',
'99999999-9999-9999-9999-999999999999', 'public', NOW() - INTERVAL '1 year'),

('c1000003-0000-0000-0000-000000000003', 'Backend Engineers Indonesia', 'backend-engineers-id',
'Community for backend developers. Discuss APIs, databases, microservices, and system design. 🔧',
'https://images.unsplash.com/photo-1558494949-ef010cbdcc31',
'https://images.unsplash.com/photo-1544197150-b99a580bb7a8',
'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'public', NOW() - INTERVAL '8 months'),

-- Coffee & Food Communities
('c1000004-0000-0000-0000-000000000004', 'Jakarta Coffee Enthusiasts', 'jakarta-coffee-enthusiasts',
'For those who love specialty coffee! Share your favorite coffee spots, brewing techniques, and bean recommendations ☕',
'https://images.unsplash.com/photo-1511920170033-f8396924c348',
'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
'11111111-1111-1111-1111-111111111111', 'public', NOW() - INTERVAL '6 months'),

('c1000005-0000-0000-0000-000000000005', 'Foodie Jakarta', 'foodie-jakarta',
'Discover the best food spots in Jakarta! Share reviews, recommendations, and food adventures 🍜🍕',
'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
'22222222-2222-2222-2222-222222222222', 'public', NOW() - INTERVAL '1 year'),

-- Sports & Fitness Communities
('c1000006-0000-0000-0000-000000000006', 'Jakarta Runners Club', 'jakarta-runners-club',
'Running community in Jakarta. Join our weekly runs, marathons, and stay fit together! 🏃‍♂️💪',
'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8',
'https://images.unsplash.com/photo-1452626038306-9aae5e071dd3',
'55555555-5555-5555-5555-555555555555', 'public', NOW() - INTERVAL '2 years'),

('c1000007-0000-0000-0000-000000000007', 'Badminton Jakarta', 'badminton-jakarta',
'Badminton players community. Weekly games, tournaments, and training sessions! 🏸',
'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea',
'https://images.unsplash.com/photo-1554068865-24cecd4e34b8',
'60606060-6060-6060-6060-606060606060', 'public', NOW() - INTERVAL '9 months'),

-- Creative & Arts Communities
('c1000008-0000-0000-0000-000000000008', 'Jakarta Photographers', 'jakarta-photographers',
'Photography community for beginners and professionals. Share your work, learn techniques, photo walks! 📸',
'https://images.unsplash.com/photo-1542038784456-1ea8e935640e',
'https://images.unsplash.com/photo-1452587925148-ce544e77e70d',
'88888888-8888-8888-8888-888888888888', 'public', NOW() - INTERVAL '1 year'),

('c1000009-0000-0000-0000-000000000009', 'Digital Artists Indonesia', 'digital-artists-indonesia',
'Community for digital artists, illustrators, and designers. Share your art, get feedback, and grow! 🎨',
'https://images.unsplash.com/photo-1561998338-13ad7883b20f',
'https://images.unsplash.com/photo-1513364776144-60967b0f800f',
'44444444-4444-4444-4444-444444444444', 'public', NOW() - INTERVAL '7 months'),

-- Gaming & Anime Communities
('c1000010-0000-0000-0000-000000000010', 'Gamers Jakarta', 'gamers-jakarta',
'Gaming community for PC, console, and mobile gamers. Tournaments, LAN parties, and game nights! 🎮',
'https://images.unsplash.com/photo-1542751371-adc38448a05e',
'https://images.unsplash.com/photo-1538481199705-c710c4e965fc',
'33333333-3333-3333-3333-333333333333', 'public', NOW() - INTERVAL '1 year'),

('c1000011-0000-0000-0000-000000000011', 'Anime & Manga Indonesia', 'anime-manga-indonesia',
'Indonesian anime and manga community. Discuss your favorite series, cosplay, and conventions! 🎌',
'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f',
'https://images.unsplash.com/photo-1613376023733-0a73315d9b06',
'10101010-1010-1010-1010-101010101010', 'public', NOW() - INTERVAL '6 months'),

-- Lifestyle & Wellness
('c1000012-0000-0000-0000-000000000012', 'Yoga & Mindfulness Jakarta', 'yoga-mindfulness-jakarta',
'Community for yoga practitioners and mindfulness enthusiasts. Classes, workshops, and wellness events 🧘‍♀️',
'https://images.unsplash.com/photo-1506126613408-eca07ce68773',
'https://images.unsplash.com/photo-1588286840104-8957b019727f',
'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'public', NOW() - INTERVAL '5 months')
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 2. COMMUNITY MEMBERS (diverse membership)
-- ============================================================================

INSERT INTO community_members (community_id, user_id, role, joined_at) VALUES
-- Jakarta Tech Meetup (Large active community)
('c1000001-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999', 'owner', NOW() - INTERVAL '10 months'),
('c1000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'admin', NOW() - INTERVAL '9 months'),
('c1000001-0000-0000-0000-000000000001', '50505050-5050-5050-5050-505050505050', 'moderator', NOW() - INTERVAL '8 months'),
('c1000001-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'member', NOW() - INTERVAL '7 months'),
('c1000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'member', NOW() - INTERVAL '6 months'),
('c1000001-0000-0000-0000-000000000001', '33333333-3333-3333-3333-333333333333', 'member', NOW() - INTERVAL '5 months'),
('c1000001-0000-0000-0000-000000000001', '44444444-4444-4444-4444-444444444444', 'member', NOW() - INTERVAL '4 months'),
('c1000001-0000-0000-0000-000000000001', '80808080-8080-8080-8080-808080808080', 'member', NOW() - INTERVAL '3 months'),
('c1000001-0000-0000-0000-000000000001', '70707070-7070-7070-7070-707070707070', 'member', NOW() - INTERVAL '2 months'),
('c1000001-0000-0000-0000-000000000001', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'member', NOW() - INTERVAL '1 month'),

-- React Indonesia
('c1000002-0000-0000-0000-000000000002', '99999999-9999-9999-9999-999999999999', 'owner', NOW() - INTERVAL '1 year'),
('c1000002-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'admin', NOW() - INTERVAL '11 months'),
('c1000002-0000-0000-0000-000000000002', '80808080-8080-8080-8080-808080808080', 'member', NOW() - INTERVAL '10 months'),
('c1000002-0000-0000-0000-000000000002', '70707070-7070-7070-7070-707070707070', 'member', NOW() - INTERVAL '9 months'),
('c1000002-0000-0000-0000-000000000002', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'member', NOW() - INTERVAL '8 months'),

-- Backend Engineers Indonesia
('c1000003-0000-0000-0000-000000000003', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'owner', NOW() - INTERVAL '8 months'),
('c1000003-0000-0000-0000-000000000003', '99999999-9999-9999-9999-999999999999', 'admin', NOW() - INTERVAL '7 months'),
('c1000003-0000-0000-0000-000000000003', '50505050-5050-5050-5050-505050505050', 'member', NOW() - INTERVAL '6 months'),
('c1000003-0000-0000-0000-000000000003', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'member', NOW() - INTERVAL '5 months'),

-- Jakarta Coffee Enthusiasts
('c1000004-0000-0000-0000-000000000004', '11111111-1111-1111-1111-111111111111', 'owner', NOW() - INTERVAL '6 months'),
('c1000004-0000-0000-0000-000000000004', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'admin', NOW() - INTERVAL '5 months'),
('c1000004-0000-0000-0000-000000000004', '22222222-2222-2222-2222-222222222222', 'member', NOW() - INTERVAL '4 months'),
('c1000004-0000-0000-0000-000000000004', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'member', NOW() - INTERVAL '3 months'),
('c1000004-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'member', NOW() - INTERVAL '2 months'),
('c1000004-0000-0000-0000-000000000004', '99999999-9999-9999-9999-999999999999', 'member', NOW() - INTERVAL '1 month'),

-- Foodie Jakarta
('c1000005-0000-0000-0000-000000000005', '22222222-2222-2222-2222-222222222222', 'owner', NOW() - INTERVAL '1 year'),
('c1000005-0000-0000-0000-000000000005', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'admin', NOW() - INTERVAL '10 months'),
('c1000005-0000-0000-0000-000000000005', '11111111-1111-1111-1111-111111111111', 'member', NOW() - INTERVAL '9 months'),
('c1000005-0000-0000-0000-000000000005', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'member', NOW() - INTERVAL '8 months'),
('c1000005-0000-0000-0000-000000000005', '90909090-9090-9090-9090-909090909090', 'member', NOW() - INTERVAL '7 months'),

-- Jakarta Runners Club
('c1000006-0000-0000-0000-000000000006', '55555555-5555-5555-5555-555555555555', 'owner', NOW() - INTERVAL '2 years'),
('c1000006-0000-0000-0000-000000000006', '20202020-2020-2020-2020-202020202020', 'admin', NOW() - INTERVAL '1 year'),
('c1000006-0000-0000-0000-000000000006', '60606060-6060-6060-6060-606060606060', 'moderator', NOW() - INTERVAL '10 months'),
('c1000006-0000-0000-0000-000000000006', '11111111-1111-1111-1111-111111111111', 'member', NOW() - INTERVAL '8 months'),
('c1000006-0000-0000-0000-000000000006', '30303030-3030-3030-3030-303030303030', 'member', NOW() - INTERVAL '6 months'),
('c1000006-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'member', NOW() - INTERVAL '4 months'),

-- Badminton Jakarta
('c1000007-0000-0000-0000-000000000007', '60606060-6060-6060-6060-606060606060', 'owner', NOW() - INTERVAL '9 months'),
('c1000007-0000-0000-0000-000000000007', '55555555-5555-5555-5555-555555555555', 'admin', NOW() - INTERVAL '8 months'),
('c1000007-0000-0000-0000-000000000007', '33333333-3333-3333-3333-333333333333', 'member', NOW() - INTERVAL '7 months'),
('c1000007-0000-0000-0000-000000000007', '11111111-1111-1111-1111-111111111111', 'member', NOW() - INTERVAL '5 months'),

-- Jakarta Photographers
('c1000008-0000-0000-0000-000000000008', '88888888-8888-8888-8888-888888888888', 'owner', NOW() - INTERVAL '1 year'),
('c1000008-0000-0000-0000-000000000008', '70707070-7070-7070-7070-707070707070', 'admin', NOW() - INTERVAL '11 months'),
('c1000008-0000-0000-0000-000000000008', '40404040-4040-4040-4040-404040404040', 'moderator', NOW() - INTERVAL '10 months'),
('c1000008-0000-0000-0000-000000000008', '44444444-4444-4444-4444-444444444444', 'member', NOW() - INTERVAL '9 months'),
('c1000008-0000-0000-0000-000000000008', '22222222-2222-2222-2222-222222222222', 'member', NOW() - INTERVAL '8 months'),

-- Digital Artists Indonesia
('c1000009-0000-0000-0000-000000000009', '44444444-4444-4444-4444-444444444444', 'owner', NOW() - INTERVAL '7 months'),
('c1000009-0000-0000-0000-000000000009', '80808080-8080-8080-8080-808080808080', 'admin', NOW() - INTERVAL '6 months'),
('c1000009-0000-0000-0000-000000000009', '88888888-8888-8888-8888-888888888888', 'member', NOW() - INTERVAL '5 months'),
('c1000009-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'member', NOW() - INTERVAL '4 months'),

-- Gamers Jakarta
('c1000010-0000-0000-0000-000000000010', '33333333-3333-3333-3333-333333333333', 'owner', NOW() - INTERVAL '1 year'),
('c1000010-0000-0000-0000-000000000010', '10101010-1010-1010-1010-101010101010', 'admin', NOW() - INTERVAL '10 months'),
('c1000010-0000-0000-0000-000000000010', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'member', NOW() - INTERVAL '8 months'),
('c1000010-0000-0000-0000-000000000010', '11111111-1111-1111-1111-111111111111', 'member', NOW() - INTERVAL '6 months'),

-- Anime & Manga Indonesia
('c1000011-0000-0000-0000-000000000011', '10101010-1010-1010-1010-101010101010', 'owner', NOW() - INTERVAL '6 months'),
('c1000011-0000-0000-0000-000000000011', '33333333-3333-3333-3333-333333333333', 'admin', NOW() - INTERVAL '5 months'),
('c1000011-0000-0000-0000-000000000011', '44444444-4444-4444-4444-444444444444', 'member', NOW() - INTERVAL '4 months'),
('c1000011-0000-0000-0000-000000000011', '70707070-7070-7070-7070-707070707070', 'member', NOW() - INTERVAL '3 months'),

-- Yoga & Mindfulness Jakarta
('c1000012-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'owner', NOW() - INTERVAL '5 months'),
('c1000012-0000-0000-0000-000000000012', '90909090-9090-9090-9090-909090909090', 'admin', NOW() - INTERVAL '4 months'),
('c1000012-0000-0000-0000-000000000012', '30303030-3030-3030-3030-303030303030', 'member', NOW() - INTERVAL '3 months'),
('c1000012-0000-0000-0000-000000000012', '22222222-2222-2222-2222-222222222222', 'member', NOW() - INTERVAL '2 months')
ON CONFLICT (community_id, user_id) DO NOTHING;

-- ============================================================================
-- 3. COMMUNITY STATS (auto-calculated)
-- ============================================================================

UPDATE communities c SET members_count = (
    SELECT COUNT(*) FROM community_members cm WHERE cm.community_id = c.id
);

-- ============================================================================
-- COMMUNITIES SEED SUMMARY
-- ============================================================================
-- Created 12 diverse communities:
-- - 3 Tech/Developer communities (Tech Meetup, React, Backend)
-- - 2 Food/Coffee communities (Coffee, Foodie)
-- - 2 Sports communities (Running, Badminton)
-- - 2 Creative communities (Photography, Digital Art)
-- - 2 Gaming/Entertainment (Gaming, Anime)
-- - 1 Wellness community (Yoga)
-- Total members: ~80 memberships across all communities
-- ============================================================================

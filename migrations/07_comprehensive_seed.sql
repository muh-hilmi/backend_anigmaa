-- ============================================================================
-- COMPREHENSIVE SEED DATA
-- ============================================================================
-- This seed file contains:
-- - 25 users
-- - 30 events (various categories with images, attendees, Q&A)
-- - 50 posts (various types with images)
-- - Likes for posts and comments
-- - Comments (including nested comments)
-- - Event attendees/joins
-- - Event Q&A
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1. USERS (25 users)
-- ============================================================================

INSERT INTO users (id, email, password_hash, name, username, bio, avatar_url, is_verified, is_email_verified) VALUES
-- Main active users
('11111111-1111-1111-1111-111111111111', 'rudi@anigmaa.com', '$2a$10$xyz...', 'Rudi Hartono', 'rudihartono', 'Coffee enthusiast | Event organizer | Jakarta', 'https://i.pravatar.cc/150?img=1', true, true),
('22222222-2222-2222-2222-222222222222', 'siti@anigmaa.com', '$2a$10$xyz...', 'Siti Nurhaliza', 'sitinur', 'Foodie & travel lover 🌏', 'https://i.pravatar.cc/150?img=2', true, true),
('33333333-3333-3333-3333-333333333333', 'budi@anigmaa.com', '$2a$10$xyz...', 'Budi Santoso', 'budisantoso', 'Gamer | Esports enthusiast', 'https://i.pravatar.cc/150?img=3', true, true),
('44444444-4444-4444-4444-444444444444', 'maya@anigmaa.com', '$2a$10$xyz...', 'Maya Wijaya', 'mayawijaya', 'Artist & designer 🎨', 'https://i.pravatar.cc/150?img=4', true, true),
('55555555-5555-5555-5555-555555555555', 'andi@anigmaa.com', '$2a$10$xyz...', 'Andi Pratama', 'andipratama', 'Fitness & sports | Marathon runner', 'https://i.pravatar.cc/150?img=5', true, true),
('66666666-6666-6666-6666-666666666666', 'dewi@anigmaa.com', '$2a$10$xyz...', 'Dewi Lestari', 'dewilestari', 'Writer | Book lover 📚', 'https://i.pravatar.cc/150?img=6', true, true),
('77777777-7777-7777-7777-777777777777', 'agus@anigmaa.com', '$2a$10$xyz...', 'Agus Setiawan', 'agussetiawan', 'Music producer | DJ', 'https://i.pravatar.cc/150?img=7', true, true),
('88888888-8888-8888-8888-888888888888', 'rina@anigmaa.com', '$2a$10$xyz...', 'Rina Kusuma', 'rinakusuma', 'Photographer | Content creator', 'https://i.pravatar.cc/150?img=8', true, true),
('99999999-9999-9999-9999-999999999999', 'doni@anigmaa.com', '$2a$10$xyz...', 'Doni Rahman', 'donirahman', 'Tech enthusiast | Developer', 'https://i.pravatar.cc/150?img=9', true, true),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'linda@anigmaa.com', '$2a$10$xyz...', 'Linda Permata', 'lindapermata', 'Yoga instructor | Wellness coach', 'https://i.pravatar.cc/150?img=10', true, true),
-- Additional users
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'rizki@anigmaa.com', '$2a$10$xyz...', 'Rizki Maulana', 'rizkimaulana', 'Student | Coffee addict', 'https://i.pravatar.cc/150?img=11', true, true),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'sarah@anigmaa.com', '$2a$10$xyz...', 'Sarah Amelia', 'sarahamelia', 'Marketing | Social media enthusiast', 'https://i.pravatar.cc/150?img=12', true, true),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'tommy@anigmaa.com', '$2a$10$xyz...', 'Tommy Wijaya', 'tommywijaya', 'Entrepreneur | Startup founder', 'https://i.pravatar.cc/150?img=13', true, true),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'novi@anigmaa.com', '$2a$10$xyz...', 'Novi Indah', 'noviindah', 'Fashion blogger | Style icon', 'https://i.pravatar.cc/150?img=14', true, true),
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'hadi@anigmaa.com', '$2a$10$xyz...', 'Hadi Kurniawan', 'hadikurniawan', 'Chef | Culinary expert', 'https://i.pravatar.cc/150?img=15', true, true),
('10101010-1010-1010-1010-101010101010', 'tina@anigmaa.com', '$2a$10$xyz...', 'Tina Sari', 'tinasari', 'Student | Anime lover', 'https://i.pravatar.cc/150?img=16', true, true),
('20202020-2020-2020-2020-202020202020', 'ferry@anigmaa.com', '$2a$10$xyz...', 'Ferry Gunawan', 'ferrygunawan', 'Cyclist | Outdoor enthusiast', 'https://i.pravatar.cc/150?img=17', true, true),
('30303030-3030-3030-3030-303030303030', 'indah@anigmaa.com', '$2a$10$xyz...', 'Indah Sari', 'indahsari', 'Dancer | Choreographer', 'https://i.pravatar.cc/150?img=18', true, true),
('40404040-4040-4040-4040-404040404040', 'bambang@anigmaa.com', '$2a$10$xyz...', 'Bambang Sutopo', 'bambangsutopo', 'Film maker | Cinematographer', 'https://i.pravatar.cc/150?img=19', true, true),
('50505050-5050-5050-5050-505050505050', 'yuni@anigmaa.com', '$2a$10$xyz...', 'Yuni Astuti', 'yuniastuti', 'Teacher | Education advocate', 'https://i.pravatar.cc/150?img=20', true, true),
('60606060-6060-6060-6060-606060606060', 'eko@anigmaa.com', '$2a$10$xyz...', 'Eko Prasetyo', 'ekoprasetyo', 'Basketball player | Sports coach', 'https://i.pravatar.cc/150?img=21', true, true),
('70707070-7070-7070-7070-707070707070', 'putri@anigmaa.com', '$2a$10$xyz...', 'Putri Maharani', 'putrimaharani', 'Vlogger | Content creator', 'https://i.pravatar.cc/150?img=22', true, true),
('80808080-8080-8080-8080-808080808080', 'irfan@anigmaa.com', '$2a$10$xyz...', 'Irfan Hakim', 'irfanhakim', 'Graphic designer | Illustrator', 'https://i.pravatar.cc/150?img=23', true, true),
('90909090-9090-9090-9090-909090909090', 'lina@anigmaa.com', '$2a$10$xyz...', 'Lina Marlina', 'linamarlina', 'Nutritionist | Healthy lifestyle', 'https://i.pravatar.cc/150?img=24', true, true),
('a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'dimas@anigmaa.com', '$2a$10$xyz...', 'Dimas Ardiansyah', 'dimasardiansyah', 'Musician | Guitarist', 'https://i.pravatar.cc/150?img=25', true, true);

-- ============================================================================
-- 2. USER SETTINGS, STATS, PRIVACY (for all users)
-- ============================================================================

INSERT INTO user_settings (user_id)
SELECT id FROM users;

INSERT INTO user_stats (user_id)
SELECT id FROM users;

INSERT INTO user_privacy (user_id)
SELECT id FROM users;

-- ============================================================================
-- 3. FOLLOWS (create social network)
-- ============================================================================

INSERT INTO follows (follower_id, following_id) VALUES
-- Rudi follows many people
('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222'),
('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333'),
('11111111-1111-1111-1111-111111111111', '44444444-4444-4444-4444-444444444444'),
('11111111-1111-1111-1111-111111111111', '55555555-5555-5555-5555-555555555555'),
-- Siti follows
('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111'),
('22222222-2222-2222-2222-222222222222', '44444444-4444-4444-4444-444444444444'),
('22222222-2222-2222-2222-222222222222', '66666666-6666-6666-6666-666666666666'),
-- Budi follows
('33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111'),
('33333333-3333-3333-3333-333333333333', '99999999-9999-9999-9999-999999999999'),
-- Maya follows
('44444444-4444-4444-4444-444444444444', '11111111-1111-1111-1111-111111111111'),
('44444444-4444-4444-4444-444444444444', '22222222-2222-2222-2222-222222222222'),
('44444444-4444-4444-4444-444444444444', '88888888-8888-8888-8888-888888888888'),
-- More follows
('55555555-5555-5555-5555-555555555555', '11111111-1111-1111-1111-111111111111'),
('66666666-6666-6666-6666-666666666666', '22222222-2222-2222-2222-222222222222'),
('77777777-7777-7777-7777-777777777777', '11111111-1111-1111-1111-111111111111'),
('88888888-8888-8888-8888-888888888888', '44444444-4444-4444-4444-444444444444'),
('99999999-9999-9999-9999-999999999999', '33333333-3333-3333-3333-333333333333'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', '22222222-2222-2222-2222-222222222222');

-- ============================================================================
-- 4. EVENTS (30 events with various categories)
-- ============================================================================

INSERT INTO events (id, host_id, title, description, category, start_time, end_time, location_name, location_address, location_lat, location_lng, max_attendees, price, is_free, status, privacy) VALUES
-- Coffee events
('e0000001-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'Coffee Cupping Session: Ethiopian Beans', 'Join us for an exclusive coffee cupping session featuring premium Ethiopian coffee beans. Learn about flavor profiles and brewing techniques.', 'coffee', '2025-11-15 10:00:00+07', '2025-11-15 12:00:00+07', 'Kopi Kenangan Sudirman', 'Jl. Jend. Sudirman No.1, Jakarta Pusat', -6.208763, 106.823640, 15, 150000, false, 'upcoming', 'public'),
('e0000002-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'Latte Art Workshop for Beginners', 'Master the art of creating beautiful latte designs. All materials provided, no experience needed!', 'coffee', '2025-11-18 14:00:00+07', '2025-11-18 16:30:00+07', 'Anomali Coffee Senopati', 'Jl. Senopati No.75, Jakarta Selatan', -6.237020, 106.808810, 12, 200000, false, 'upcoming', 'public'),
('e0000003-0000-0000-0000-000000000003', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Weekend Coffee Hangout', 'Casual coffee meetup for coffee lovers. Let''s chat about beans, brewing methods, and everything coffee!', 'coffee', '2025-11-16 09:00:00+07', '2025-11-16 11:00:00+07', 'Tanamera Coffee', 'Jl. K.H. Wahid Hasyim No.186, Jakarta Pusat', -6.193750, 106.824440, 20, 0, true, 'upcoming', 'public'),

-- Food events
('e0000004-0000-0000-0000-000000000004', '22222222-2222-2222-2222-222222222222', 'Indonesian Street Food Tour', 'Explore Jakarta''s best street food spots! We''ll visit 5 famous vendors and taste authentic Indonesian cuisine.', 'food', '2025-11-17 17:00:00+07', '2025-11-17 21:00:00+07', 'Pecenongan Street Food Area', 'Jl. Pecenongan, Jakarta Pusat', -6.165270, 106.823610, 25, 100000, false, 'upcoming', 'public'),
('e0000005-0000-0000-0000-000000000005', '22222222-2222-2222-2222-222222222222', 'Homemade Pasta Making Class', 'Learn to make fresh pasta from scratch! We''ll prepare fettuccine, ravioli, and authentic Italian sauce.', 'food', '2025-11-20 15:00:00+07', '2025-11-20 18:00:00+07', 'The Kitchen by Kulina', 'Jl. Senopati Raya No.88, Jakarta Selatan', -6.237890, 106.808330, 10, 350000, false, 'upcoming', 'public'),
('e0000006-0000-0000-0000-000000000006', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'Vegan Cooking Workshop', 'Discover delicious plant-based Indonesian recipes. Perfect for beginners and experienced cooks!', 'food', '2025-11-22 13:00:00+07', '2025-11-22 16:00:00+07', 'Burgreens Kitchen', 'Jl. Tebet Timur Dalam Raya No.1, Jakarta Selatan', -6.235540, 106.859820, 15, 250000, false, 'upcoming', 'public'),
('e0000007-0000-0000-0000-000000000007', '22222222-2222-2222-2222-222222222222', 'Dessert & Coffee Pairing', 'Experience perfect combinations of artisan desserts and specialty coffee. Sweet tooth paradise!', 'food', '2025-11-19 16:00:00+07', '2025-11-19 18:00:00+07', 'Union Senopati', 'Jl. Senopati No.64, Jakarta Selatan', -6.237520, 106.809140, 18, 180000, false, 'upcoming', 'public'),

-- Gaming events
('e0000008-0000-0000-0000-000000000008', '33333333-3333-3333-3333-333333333333', 'Mobile Legends Tournament', 'Join our ML tournament! Prize pool 5 million rupiah. Team registration required.', 'gaming', '2025-11-23 10:00:00+07', '2025-11-23 18:00:00+07', 'Garena Esports Stadium', 'Jl. Rawa Belong No.1, Jakarta Barat', -6.183330, 106.777780, 50, 50000, false, 'upcoming', 'public'),
('e0000009-0000-0000-0000-000000000009', '33333333-3333-3333-3333-333333333333', 'Valorant Bootcamp', 'Improve your Valorant skills with pro players! Strategy sessions and 1v1 practice included.', 'gaming', '2025-11-25 13:00:00+07', '2025-11-25 17:00:00+07', 'Mineski Infinity', 'Gandaria City Mall, Jakarta Selatan', -6.242780, 106.783890, 30, 100000, false, 'upcoming', 'public'),
('e0000010-0000-0000-0000-000000000010', '99999999-9999-9999-9999-999999999999', 'Retro Gaming Night', 'Nostalgia trip! Play classic games: Mario, Street Fighter, Contra, and more. Free pizza included!', 'gaming', '2025-11-21 19:00:00+07', '2025-11-21 23:00:00+07', 'Level Up Gaming Cafe', 'Jl. Kemang Raya No.9, Jakarta Selatan', -6.266670, 106.816670, 25, 0, true, 'upcoming', 'public'),

-- Sports events
('e0000011-0000-0000-0000-000000000011', '55555555-5555-5555-5555-555555555555', 'Sunday Morning Run Club', 'Weekly running session at GBK. All levels welcome! 5K and 10K routes available.', 'sports', '2025-11-17 06:00:00+07', '2025-11-17 08:00:00+07', 'Gelora Bung Karno', 'Jl. Pintu Satu Senayan, Jakarta Pusat', -6.218540, 106.801940, 100, 0, true, 'upcoming', 'public'),
('e0000012-0000-0000-0000-000000000012', '55555555-5555-5555-5555-555555555555', 'Futsal Tournament 5v5', 'Friendly futsal competition. Register your team now! Winners get trophies and merchandise.', 'sports', '2025-11-24 08:00:00+07', '2025-11-24 16:00:00+07', 'Ragunan Futsal Arena', 'Jl. Ragunan, Jakarta Selatan', -6.307780, 106.820000, 40, 300000, false, 'upcoming', 'public'),
('e0000013-0000-0000-0000-000000000013', '60606060-6060-6060-6060-606060606060', 'Basketball Coaching Clinic', 'Learn from professional coaches! Focus on shooting, dribbling, and team play fundamentals.', 'sports', '2025-11-26 15:00:00+07', '2025-11-26 18:00:00+07', 'Britama Arena', 'Jl. Gatot Subroto, Jakarta Selatan', -6.232780, 106.816670, 35, 150000, false, 'upcoming', 'public'),
('e0000014-0000-0000-0000-000000000014', '20202020-2020-2020-2020-202020202020', 'Bike to Work Community Ride', 'Cycling event around Jakarta city. Promote eco-friendly transportation! Breakfast included.', 'sports', '2025-11-18 05:30:00+07', '2025-11-18 08:00:00+07', 'Bundaran HI', 'Jl. M.H. Thamrin, Jakarta Pusat', -6.195000, 106.823060, 60, 0, true, 'upcoming', 'public'),

-- Music events
('e0000015-0000-0000-0000-000000000015', '77777777-7777-7777-7777-777777777777', 'Indie Music Night', 'Local indie bands showcase! Featuring 5 amazing Jakarta-based artists. Food and drinks available.', 'music', '2025-11-22 19:00:00+07', '2025-11-22 23:00:00+07', 'Rossi Musik', 'Jl. Kemang Raya No.5, Jakarta Selatan', -6.263890, 106.816670, 200, 100000, false, 'upcoming', 'public'),
('e0000016-0000-0000-0000-000000000016', '77777777-7777-7777-7777-777777777777', 'DJ Workshop & Mixing Session', 'Learn DJing basics from professional DJs. Hands-on experience with industry-standard equipment.', 'music', '2025-11-27 14:00:00+07', '2025-11-27 18:00:00+07', 'Ismaya Studios', 'Jl. Senopati, Jakarta Selatan', -6.238060, 106.809720, 20, 500000, false, 'upcoming', 'public'),
('e0000017-0000-0000-0000-000000000017', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'Acoustic Jam Session', 'Open mic and acoustic jam! Bring your guitar, meet fellow musicians, and jam together.', 'music', '2025-11-20 18:00:00+07', '2025-11-20 21:00:00+07', 'Common Grounds PIK', 'PIK Avenue, Jakarta Utara', -6.109440, 106.738610, 30, 50000, false, 'upcoming', 'public'),

-- Movies events
('e0000018-0000-0000-0000-000000000018', '40404040-4040-4040-4040-404040404040', 'Indonesian Film Festival Screening', 'Watch and discuss award-winning Indonesian films. Q&A session with directors!', 'movies', '2025-11-23 18:00:00+07', '2025-11-23 22:00:00+07', 'Kineforum TIM', 'Taman Ismail Marzuki, Jakarta Pusat', -6.195560, 106.847780, 80, 50000, false, 'upcoming', 'public'),
('e0000019-0000-0000-0000-000000000019', '40404040-4040-4040-4040-404040404040', 'Cinematography Workshop', 'Learn professional filming techniques. Camera operation, lighting, and shot composition.', 'movies', '2025-11-28 10:00:00+07', '2025-11-28 15:00:00+07', 'IFI Jakarta', 'Jl. H.R. Rasuna Said, Jakarta Selatan', -6.223610, 106.834720, 25, 400000, false, 'upcoming', 'public'),

-- Study events
('e0000020-0000-0000-0000-000000000020', '50505050-5050-5050-5050-505050505050', 'Group Study: Python Programming', 'Study group for Python beginners. Bring your laptop and questions! Free snacks provided.', 'study', '2025-11-19 14:00:00+07', '2025-11-19 18:00:00+07', 'Starbucks Kuningan', 'Kota Kasablanka Mall, Jakarta Selatan', -6.223890, 106.842780, 15, 0, true, 'upcoming', 'public'),
('e0000021-0000-0000-0000-000000000021', '99999999-9999-9999-9999-999999999999', 'Web Development Bootcamp', 'Learn HTML, CSS, JavaScript basics in one day! Perfect for complete beginners.', 'study', '2025-11-24 09:00:00+07', '2025-11-24 17:00:00+07', 'Google Developer Space', 'Pacific Place Mall, Jakarta Selatan', -6.225280, 106.809170, 30, 200000, false, 'upcoming', 'public'),
('e0000022-0000-0000-0000-000000000022', '50505050-5050-5050-5050-505050505050', 'IELTS Study Circle', 'Practice IELTS speaking and writing together. Share tips and resources for test preparation.', 'study', '2025-11-26 15:00:00+07', '2025-11-26 18:00:00+07', 'British Council Jakarta', 'Jl. Jend. Sudirman No.71, Jakarta Pusat', -6.213060, 106.820280, 20, 0, true, 'upcoming', 'public'),

-- Art events
('e0000023-0000-0000-0000-000000000023', '44444444-4444-4444-4444-444444444444', 'Watercolor Painting Workshop', 'Learn watercolor techniques! Paint beautiful landscapes and florals. All materials included.', 'art', '2025-11-21 13:00:00+07', '2025-11-21 16:00:00+07', 'Dia.Lo.Gue Artspace', 'Jl. Kemang Timur No.99, Jakarta Selatan', -6.264720, 106.816110, 15, 300000, false, 'upcoming', 'public'),
('e0000024-0000-0000-0000-000000000024', '44444444-4444-4444-4444-444444444444', 'Street Art Tour & Workshop', 'Explore Jakarta''s street art scene! Learn spray painting and stencil techniques.', 'art', '2025-11-25 10:00:00+07', '2025-11-25 14:00:00+07', 'Blok M Square', 'Jl. Melawai Raya, Jakarta Selatan', -6.244170, 106.799170, 20, 150000, false, 'upcoming', 'public'),
('e0000025-0000-0000-0000-000000000025', '80808080-8080-8080-8080-808080808080', 'Digital Illustration Class', 'Master digital art using Procreate and Adobe. Beginner-friendly with iPad provided!', 'art', '2025-11-27 13:00:00+07', '2025-11-27 17:00:00+07', 'Kreavi Creative Space', 'Jl. Gunawarman No.11, Jakarta Selatan', -6.242500, 106.803890, 12, 450000, false, 'upcoming', 'public'),

-- Other/mixed events
('e0000026-0000-0000-0000-000000000026', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'Startup Networking Mixer', 'Connect with entrepreneurs, investors, and startup enthusiasts. Pitch your ideas!', 'other', '2025-11-22 18:00:00+07', '2025-11-22 21:00:00+07', 'EV Hive Kuningan', 'Menara Astra, Jakarta Selatan', -6.223610, 106.830280, 50, 100000, false, 'upcoming', 'public'),
('e0000027-0000-0000-0000-000000000027', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Social Media Marketing Workshop', 'Learn Instagram, TikTok, and Twitter strategies to grow your brand or business.', 'other', '2025-11-23 13:00:00+07', '2025-11-23 17:00:00+07', 'WeWork Kuningan', 'Prosperity Tower, Jakarta Selatan', -6.224170, 106.830560, 35, 250000, false, 'upcoming', 'public'),
('e0000028-0000-0000-0000-000000000028', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Meditation & Mindfulness Session', 'Guided meditation for stress relief and mental clarity. Perfect for beginners.', 'other', '2025-11-20 07:00:00+07', '2025-11-20 08:30:00+07', 'Taman Menteng', 'Jl. HOS Cokroaminoto, Jakarta Pusat', -6.189720, 106.832500, 40, 0, true, 'upcoming', 'public'),
('e0000029-0000-0000-0000-000000000029', '70707070-7070-7070-7070-707070707070', 'Content Creator Meetup', 'Vloggers and content creators unite! Share experiences, collaborate, and network.', 'other', '2025-11-25 15:00:00+07', '2025-11-25 18:00:00+07', 'The Goods Diner', 'Jl. Panglima Polim, Jakarta Selatan', -6.261390, 106.797220, 30, 75000, false, 'upcoming', 'public'),
('e0000030-0000-0000-0000-000000000030', '88888888-8888-8888-8888-888888888888', 'Photography Walk: Old Jakarta', 'Capture the beauty of old Jakarta. Visit historical sites and learn composition tips.', 'other', '2025-11-26 08:00:00+07', '2025-11-26 12:00:00+07', 'Kota Tua Jakarta', 'Jl. Taman Fatahillah, Jakarta Barat', -6.135000, 106.813890, 25, 50000, false, 'upcoming', 'public');

-- ============================================================================
-- 5. EVENT IMAGES (multiple images per event)
-- ============================================================================

INSERT INTO event_images (event_id, image_url, order_index) VALUES
-- Event 1 images
('e0000001-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1511920170033-f8396924c348', 0),
('e0000001-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1447933601403-0c6688de566e', 1),
-- Event 2 images
('e0000002-0000-0000-0000-000000000002', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd', 0),
-- Event 4 images
('e0000004-0000-0000-0000-000000000004', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 0),
('e0000004-0000-0000-0000-000000000004', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1', 1),
-- Event 5 images
('e0000005-0000-0000-0000-000000000005', 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9', 0),
-- Event 8 images
('e0000008-0000-0000-0000-000000000008', 'https://images.unsplash.com/photo-1542751371-adc38448a05e', 0),
('e0000008-0000-0000-0000-000000000008', 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc', 1),
-- Event 11 images
('e0000011-0000-0000-0000-000000000011', 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5', 0),
-- Event 15 images
('e0000015-0000-0000-0000-000000000015', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f', 0),
('e0000015-0000-0000-0000-000000000015', 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3', 1),
-- Event 18 images
('e0000018-0000-0000-0000-000000000018', 'https://images.unsplash.com/photo-1478720568477-152d9b164e26', 0),
-- Event 23 images
('e0000023-0000-0000-0000-000000000023', 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b', 0),
('e0000023-0000-0000-0000-000000000023', 'https://images.unsplash.com/photo-1513364776144-60967b0f800f', 1),
-- Event 26 images
('e0000026-0000-0000-0000-000000000026', 'https://images.unsplash.com/photo-1511578314322-379afb476865', 0),
-- Event 30 images
('e0000030-0000-0000-0000-000000000030', 'https://images.unsplash.com/photo-1452780212940-6f5c0d14d848', 0);

-- ============================================================================
-- 6. EVENT ATTENDEES (joins - multiple attendees per event)
-- ============================================================================

INSERT INTO event_attendees (event_id, user_id, status) VALUES
-- Event 1 attendees
('e0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'confirmed'),
('e0000001-0000-0000-0000-000000000001', '33333333-3333-3333-3333-333333333333', 'confirmed'),
('e0000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed'),
('e0000001-0000-0000-0000-000000000001', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'pending'),
-- Event 2 attendees
('e0000002-0000-0000-0000-000000000002', '44444444-4444-4444-4444-444444444444', 'confirmed'),
('e0000002-0000-0000-0000-000000000002', '88888888-8888-8888-8888-888888888888', 'confirmed'),
('e0000002-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed'),
-- Event 3 attendees
('e0000003-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111', 'confirmed'),
('e0000003-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222', 'confirmed'),
('e0000003-0000-0000-0000-000000000003', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed'),
('e0000003-0000-0000-0000-000000000003', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed'),
-- Event 4 attendees
('e0000004-0000-0000-0000-000000000004', '11111111-1111-1111-1111-111111111111', 'confirmed'),
('e0000004-0000-0000-0000-000000000004', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed'),
('e0000004-0000-0000-0000-000000000004', '66666666-6666-6666-6666-666666666666', 'confirmed'),
('e0000004-0000-0000-0000-000000000004', '77777777-7777-7777-7777-777777777777', 'confirmed'),
('e0000004-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed'),
-- Event 5 attendees
('e0000005-0000-0000-0000-000000000005', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed'),
('e0000005-0000-0000-0000-000000000005', '11111111-1111-1111-1111-111111111111', 'confirmed'),
('e0000005-0000-0000-0000-000000000005', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed'),
-- Event 8 attendees (gaming tournament)
('e0000008-0000-0000-0000-000000000008', '99999999-9999-9999-9999-999999999999', 'confirmed'),
('e0000008-0000-0000-0000-000000000008', '10101010-1010-1010-1010-101010101010', 'confirmed'),
('e0000008-0000-0000-0000-000000000008', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed'),
('e0000008-0000-0000-0000-000000000008', '30303030-3030-3030-3030-303030303030', 'confirmed'),
('e0000008-0000-0000-0000-000000000008', '40404040-4040-4040-4040-404040404040', 'confirmed'),
('e0000008-0000-0000-0000-000000000008', '60606060-6060-6060-6060-606060606060', 'confirmed'),
-- Event 11 attendees (running club)
('e0000011-0000-0000-0000-000000000011', '11111111-1111-1111-1111-111111111111', 'confirmed'),
('e0000011-0000-0000-0000-000000000011', '22222222-2222-2222-2222-222222222222', 'confirmed'),
('e0000011-0000-0000-0000-000000000011', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed'),
('e0000011-0000-0000-0000-000000000011', '20202020-2020-2020-2020-202020202020', 'confirmed'),
('e0000011-0000-0000-0000-000000000011', '90909090-9090-9090-9090-909090909090', 'confirmed'),
('e0000011-0000-0000-0000-000000000011', '60606060-6060-6060-6060-606060606060', 'confirmed'),
('e0000011-0000-0000-0000-000000000011', '70707070-7070-7070-7070-707070707070', 'confirmed'),
-- Event 15 attendees (music)
('e0000015-0000-0000-0000-000000000015', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'confirmed'),
('e0000015-0000-0000-0000-000000000015', '11111111-1111-1111-1111-111111111111', 'confirmed'),
('e0000015-0000-0000-0000-000000000015', '44444444-4444-4444-4444-444444444444', 'confirmed'),
('e0000015-0000-0000-0000-000000000015', '88888888-8888-8888-8888-888888888888', 'confirmed'),
('e0000015-0000-0000-0000-000000000015', '70707070-7070-7070-7070-707070707070', 'confirmed'),
-- Event 20 attendees (study)
('e0000020-0000-0000-0000-000000000020', '99999999-9999-9999-9999-999999999999', 'confirmed'),
('e0000020-0000-0000-0000-000000000020', '10101010-1010-1010-1010-101010101010', 'confirmed'),
('e0000020-0000-0000-0000-000000000020', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed'),
('e0000020-0000-0000-0000-000000000020', '80808080-8080-8080-8080-808080808080', 'confirmed'),
-- Event 23 attendees (art)
('e0000023-0000-0000-0000-000000000023', '88888888-8888-8888-8888-888888888888', 'confirmed'),
('e0000023-0000-0000-0000-000000000023', '80808080-8080-8080-8080-808080808080', 'confirmed'),
('e0000023-0000-0000-0000-000000000023', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed'),
('e0000023-0000-0000-0000-000000000023', '30303030-3030-3030-3030-303030303030', 'confirmed'),
-- Event 26 attendees (startup)
('e0000026-0000-0000-0000-000000000026', '99999999-9999-9999-9999-999999999999', 'confirmed'),
('e0000026-0000-0000-0000-000000000026', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed'),
('e0000026-0000-0000-0000-000000000026', '11111111-1111-1111-1111-111111111111', 'confirmed'),
('e0000026-0000-0000-0000-000000000026', '22222222-2222-2222-2222-222222222222', 'confirmed'),
-- More attendees for other events
('e0000006-0000-0000-0000-000000000006', '90909090-9090-9090-9090-909090909090', 'confirmed'),
('e0000007-0000-0000-0000-000000000007', '11111111-1111-1111-1111-111111111111', 'confirmed'),
('e0000009-0000-0000-0000-000000000009', '33333333-3333-3333-3333-333333333333', 'confirmed'),
('e0000010-0000-0000-0000-000000000010', '33333333-3333-3333-3333-333333333333', 'confirmed'),
('e0000012-0000-0000-0000-000000000012', '60606060-6060-6060-6060-606060606060', 'confirmed'),
('e0000013-0000-0000-0000-000000000013', '55555555-5555-5555-5555-555555555555', 'confirmed'),
('e0000014-0000-0000-0000-000000000014', '20202020-2020-2020-2020-202020202020', 'confirmed'),
('e0000016-0000-0000-0000-000000000016', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'confirmed'),
('e0000017-0000-0000-0000-000000000017', '77777777-7777-7777-7777-777777777777', 'confirmed'),
('e0000018-0000-0000-0000-000000000018', '40404040-4040-4040-4040-404040404040', 'confirmed'),
('e0000019-0000-0000-0000-000000000019', '88888888-8888-8888-8888-888888888888', 'confirmed'),
('e0000021-0000-0000-0000-000000000021', '50505050-5050-5050-5050-505050505050', 'confirmed'),
('e0000022-0000-0000-0000-000000000022', '66666666-6666-6666-6666-666666666666', 'confirmed'),
('e0000024-0000-0000-0000-000000000024', '44444444-4444-4444-4444-444444444444', 'confirmed'),
('e0000025-0000-0000-0000-000000000025', '80808080-8080-8080-8080-808080808080', 'confirmed'),
('e0000027-0000-0000-0000-000000000027', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed'),
('e0000028-0000-0000-0000-000000000028', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed'),
('e0000029-0000-0000-0000-000000000029', '70707070-7070-7070-7070-707070707070', 'confirmed'),
('e0000030-0000-0000-0000-000000000030', '88888888-8888-8888-8888-888888888888', 'confirmed');

-- ============================================================================
-- 7. EVENT Q&A (questions and answers)
-- ============================================================================

INSERT INTO event_qna (event_id, user_id, question, answer, answered_by, answered_at, is_answered) VALUES
-- Event 1 Q&A
('e0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'Apakah ada demo brewing juga?', 'Yes! We will have brewing demonstrations using V60, Aeropress, and French Press.', '11111111-1111-1111-1111-111111111111', NOW(), true),
('e0000001-0000-0000-0000-000000000001', '33333333-3333-3333-3333-333333333333', 'Boleh bawa teman yang belum daftar?', 'Maaf, karena tempat terbatas, semua peserta harus registrasi terlebih dahulu.', '11111111-1111-1111-1111-111111111111', NOW(), true),
('e0000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Apakah ada sertifikat setelah acara?', NULL, NULL, NULL, false),

-- Event 2 Q&A
('e0000002-0000-0000-0000-000000000002', '44444444-4444-4444-4444-444444444444', 'Do I need to bring my own cup?', 'No, all equipment and materials will be provided!', '11111111-1111-1111-1111-111111111111', NOW(), true),
('e0000002-0000-0000-0000-000000000002', '88888888-8888-8888-8888-888888888888', 'Berapa lama durasi workshop ini?', '2.5 jam termasuk hands-on practice dan Q&A session.', '11111111-1111-1111-1111-111111111111', NOW(), true),

-- Event 4 Q&A
('e0000004-0000-0000-0000-000000000004', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'Apakah harga sudah termasuk semua makanan?', 'Ya betul! Harga sudah include untuk 5 spot kuliner yang kita kunjungi.', '22222222-2222-2222-2222-222222222222', NOW(), true),
('e0000004-0000-0000-0000-000000000004', '66666666-6666-6666-6666-666666666666', 'Ada vegetarian options ga?', 'Ada! Kita akan visit beberapa vendor yang punya vegetarian options.', '22222222-2222-2222-2222-222222222222', NOW(), true),

-- Event 5 Q&A
('e0000005-0000-0000-0000-000000000005', '11111111-1111-1111-1111-111111111111', 'Apakah ingredients sudah disediakan?', 'Yes, semua bahan sudah disiapkan. Kalian tinggal datang dan belajar!', '22222222-2222-2222-2222-222222222222', NOW(), true),

-- Event 8 Q&A
('e0000008-0000-0000-0000-000000000008', '99999999-9999-9999-9999-999999999999', 'Apakah harus datang dengan tim lengkap?', 'Ya, pendaftaran per tim (5 orang). Pastikan semua member sudah confirm.', '33333333-3333-3333-3333-333333333333', NOW(), true),
('e0000008-0000-0000-0000-000000000008', '10101010-1010-1010-1010-101010101010', 'Minimum rank untuk ikut tournament?', 'Semua rank boleh ikut! Tournament ini dibagi dalam beberapa bracket.', '33333333-3333-3333-3333-333333333333', NOW(), true),
('e0000008-0000-0000-0000-000000000008', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Apakah ada streaming untuk yang tidak bisa datang?', NULL, NULL, NULL, false),

-- Event 11 Q&A
('e0000011-0000-0000-0000-000000000011', '22222222-2222-2222-2222-222222222222', 'Boleh untuk pemula yang belum pernah lari jarak jauh?', 'Absolutely! Ada route 5K untuk beginners dan 10K untuk intermediate.', '55555555-5555-5555-5555-555555555555', NOW(), true),
('e0000011-0000-0000-0000-000000000011', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Apakah ada locker untuk titip barang?', 'Ada locker gratis di area start point. Tapi barang berharga sebaiknya jangan dibawa.', '55555555-5555-5555-5555-555555555555', NOW(), true),

-- Event 15 Q&A
('e0000015-0000-0000-0000-000000000015', '11111111-1111-1111-1111-111111111111', 'Siapa saja band yang akan perform?', 'Will announce the full lineup next week! Ada 5 amazing local bands.', '77777777-7777-7777-7777-777777777777', NOW(), true),
('e0000015-0000-0000-0000-000000000015', '44444444-4444-4444-4444-444444444444', 'Boleh bawa kamera professional?', 'Small cameras ok, tapi professional equipment dengan izin organizer dulu ya.', '77777777-7777-7777-7777-777777777777', NOW(), true),

-- Event 20 Q&A
('e0000020-0000-0000-0000-000000000020', '99999999-9999-9999-9999-999999999999', 'Apakah ada mentor yang berpengalaman?', 'Yes! Ada 2 senior developers yang akan guide study session ini.', '50505050-5050-5050-5050-505050505050', NOW(), true),
('e0000020-0000-0000-0000-000000000020', '10101010-1010-1010-1010-101010101010', 'Materi apa yang akan dibahas?', NULL, NULL, NULL, false),

-- Event 23 Q&A
('e0000023-0000-0000-0000-000000000023', '88888888-8888-8888-8888-888888888888', 'Harus bawa cat sendiri atau sudah disediakan?', 'Semua materials sudah disediakan, termasuk watercolor set, brushes, dan paper!', '44444444-4444-4444-4444-444444444444', NOW(), true),
('e0000023-0000-0000-0000-000000000023', '80808080-8080-8080-8080-808080808080', 'Boleh bawa hasil karya pulang?', 'Tentu saja! Semua karya yang dibuat adalah milik kalian.', '44444444-4444-4444-4444-444444444444', NOW(), true),

-- Event 26 Q&A
('e0000026-0000-0000-0000-000000000026', '99999999-9999-9999-9999-999999999999', 'Apakah ada investor yang hadir?', 'Yes, ada beberapa VCs dan angel investors yang sudah confirm.', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NOW(), true),
('e0000026-0000-0000-0000-000000000026', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Berapa lama waktu untuk pitch?', '3 menit pitch + 2 menit Q&A. Prepare your best pitch!', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NOW(), true);

-- ============================================================================
-- 8. POSTS (50 posts with various types)
-- ============================================================================

INSERT INTO posts (id, author_id, content, type, attached_event_id, visibility, created_at) VALUES
-- Posts promoting events
('a0000001-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'Excited to host my first coffee cupping session! 🎉 Join us this weekend untuk explore Ethiopian coffee beans yang amazing. Limited seats, daftar sekarang! ☕', 'text_with_event', 'e0000001-0000-0000-0000-000000000001', 'public', NOW() - INTERVAL '2 days'),
('a0000002-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222', 'Calling all foodies! 🍜 Street food tour besok sore around Jakarta. We''ll explore 5 legendary spots. Siapa yang mau ikutan? Tag your foodie friends!', 'text_with_event', 'e0000004-0000-0000-0000-000000000004', 'public', NOW() - INTERVAL '3 days'),
('a0000003-0000-0000-0000-000000000003', '33333333-3333-3333-3333-333333333333', 'MOBILE LEGENDS TOURNAMENT ALERT! 🎮🏆 Prize pool 5 juta! Registration closing soon. Ajak team kalian sekarang!', 'text_with_event', 'e0000008-0000-0000-0000-000000000008', 'public', NOW() - INTERVAL '4 days'),

-- Regular text posts
('a0000004-0000-0000-0000-000000000004', '44444444-4444-4444-4444-444444444444', 'Just finished a new watercolor painting! The sunset colors turned out better than expected 🎨✨ Sometimes the best art happens when you just let go and trust the process.', 'text', NULL, 'public', NOW() - INTERVAL '1 day'),
('a0000005-0000-0000-0000-000000000005', '55555555-5555-5555-5555-555555555555', 'Completed my first 10K run today! 🏃‍♂️💪 Time: 58:32. Not bad for a beginner. The key is consistency, not speed. Keep moving forward!', 'text', NULL, 'public', NOW() - INTERVAL '5 hours'),
('a0000006-0000-0000-0000-000000000006', '66666666-6666-6666-6666-666666666666', 'Currently reading "Educated" by Tara Westover and wow... speechless. Her journey is incredibly inspiring. Anyone else read this? Let''s discuss! 📚', 'text', NULL, 'public', NOW() - INTERVAL '12 hours'),
('a0000007-0000-0000-0000-000000000007', '77777777-7777-7777-7777-777777777777', 'Working on a new track 🎵 Been in the studio for 6 hours straight and I think we''re onto something special. Can''t wait to share it with you all!', 'text', NULL, 'public', NOW() - INTERVAL '8 hours'),
('a0000008-0000-0000-0000-000000000008', '99999999-9999-9999-9999-999999999999', 'Finally deployed my first full-stack app! 🚀 React + Node.js + PostgreSQL. So many bugs fixed, so many lessons learned. The feeling is unreal!', 'text', NULL, 'public', NOW() - INTERVAL '2 days'),
('a0000009-0000-0000-0000-000000000009', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Morning yoga session hits different when you do it at the park 🧘‍♀️ The fresh air and bird sounds are the best meditation soundtrack. Namaste 🙏', 'text', NULL, 'public', NOW() - INTERVAL '15 hours'),
('a0000010-0000-0000-0000-000000000010', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Trying a new coffee brewing method today: Japanese iced coffee ☕❄️ The flavor is SO much better than regular cold brew. Mind = blown!', 'text', NULL, 'public', NOW() - INTERVAL '6 hours'),

-- Posts with images
('a0000011-0000-0000-0000-000000000011', '88888888-8888-8888-8888-888888888888', 'Golden hour at Kota Tua was absolutely magical today 📸✨ Managed to capture some incredible shots. Swipe to see the full series!', 'text_with_images', NULL, 'public', NOW() - INTERVAL '1 day'),
('a0000012-0000-0000-0000-000000000012', '22222222-2222-2222-2222-222222222222', 'Made homemade pasta from scratch! 🍝 It was challenging but so worth it. The taste is incomparable to store-bought pasta. Here''s the process!', 'text_with_images', NULL, 'public', NOW() - INTERVAL '18 hours'),
('a0000013-0000-0000-0000-000000000013', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Today''s outfit inspo ✨ Mixing vintage with contemporary pieces. Fashion is all about expressing yourself! What do you think?', 'text_with_images', NULL, 'public', NOW() - INTERVAL '10 hours'),
('a0000014-0000-0000-0000-000000000014', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'Behind the scenes of today''s cooking class 👨‍🍳 These students are amazing! We made authentic Italian risotto. Check out their creations!', 'text_with_images', NULL, 'public', NOW() - INTERVAL '7 hours'),
('a0000015-0000-0000-0000-000000000015', '44444444-4444-4444-4444-444444444444', 'My latest illustration project 🎨 Inspired by Indonesian folklore. Took me 12 hours to complete. Art is patience!', 'text_with_images', NULL, 'public', NOW() - INTERVAL '2 days'),

-- More text posts
('a0000016-0000-0000-0000-000000000016', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Just launched our new social media campaign! The engagement rate is through the roof 📈 Proof that good content + right timing = success. Marketing isn''t rocket science, it''s about understanding your audience.', 'text', NULL, 'public', NOW() - INTERVAL '20 hours'),
('a0000017-0000-0000-0000-000000000017', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'Startup life update: Just closed our seed round! 🎉💰 The journey from idea to funding was intense. Grateful for everyone who believed in our vision. This is just the beginning!', 'text', NULL, 'public', NOW() - INTERVAL '3 days'),
('a0000018-0000-0000-0000-000000000018', '10101010-1010-1010-1010-101010101010', 'Watching anime at 3AM hits different lol 😂 Just finished Attack on Titan final season and I have SO MANY FEELINGS. No spoilers please for those who haven''t watched!', 'text', NULL, 'public', NOW() - INTERVAL '4 hours'),
('a0000019-0000-0000-0000-000000000019', '20202020-2020-2020-2020-202020202020', 'Best cycling routes in Jakarta? Drop your recommendations! 🚴‍♂️ Planning to explore new areas this weekend. Preferably with good coffee shops along the way ☕', 'text', NULL, 'public', NOW() - INTERVAL '16 hours'),
('a0000020-0000-0000-0000-000000000020', '30303030-3030-3030-3030-303030303030', 'Dance practice was INTENSE today 💃 We''re preparing for a big performance next month. My legs are sore but my heart is happy. This is what passion feels like!', 'text', NULL, 'public', NOW() - INTERVAL '11 hours'),

-- More posts with events
('a0000021-0000-0000-0000-000000000021', '55555555-5555-5555-5555-555555555555', 'Sunday morning run club this weekend! 🏃‍♀️ All fitness levels welcome. Let''s start the week with endorphins and good vibes. See you at GBK!', 'text_with_event', 'e0000011-0000-0000-0000-000000000011', 'public', NOW() - INTERVAL '5 days'),
('a0000022-0000-0000-0000-000000000022', '77777777-7777-7777-7777-777777777777', 'Indie music night coming up! 🎸🎤 Featuring some of the best local bands in Jakarta. If you love good music and good vibes, you can''t miss this.', 'text_with_event', 'e0000015-0000-0000-0000-000000000015', 'public', NOW() - INTERVAL '6 days'),
('a0000023-0000-0000-0000-000000000023', '44444444-4444-4444-4444-444444444444', 'Watercolor painting workshop next week! 🎨 Perfect for beginners who want to learn this beautiful art form. All materials provided, just bring your creativity!', 'text_with_event', 'e0000023-0000-0000-0000-000000000023', 'public', NOW() - INTERVAL '7 days'),

-- More regular posts
('a0000024-0000-0000-0000-000000000024', '40404040-4040-4040-4040-404040404040', 'Just wrapped filming for a new documentary about Jakarta''s hidden gems 🎬 The stories we captured are incredible. Can''t wait to share it with everyone!', 'text', NULL, 'public', NOW() - INTERVAL '1 day'),
('a0000025-0000-0000-0000-000000000025', '50505050-5050-5050-5050-505050505050', 'Teaching high school students about climate change today. Their questions were so thoughtful and inspiring 🌍 The next generation gives me hope!', 'text', NULL, 'public', NOW() - INTERVAL '9 hours'),
('a0000026-0000-0000-0000-000000000026', '60606060-6060-6060-6060-606060606060', 'Basketball training session was fire today! 🏀🔥 Working on my three-point shot. Practice makes progress, not perfection.', 'text', NULL, 'public', NOW() - INTERVAL '14 hours'),
('a0000027-0000-0000-0000-000000000027', '70707070-7070-7070-7070-707070707070', 'Just posted a new vlog about Jakarta''s best coffee spots! ☕📹 Link in bio. Let me know which cafe I should review next!', 'text', NULL, 'public', NOW() - INTERVAL '22 hours'),
('a0000028-0000-0000-0000-000000000028', '80808080-8080-8080-8080-808080808080', 'Working on a new logo design for a client 🎨💻 The creative process is messy but magical. Here''s to late nights and coffee-fueled inspiration!', 'text', NULL, 'public', NOW() - INTERVAL '3 hours'),
('a0000029-0000-0000-0000-000000000029', '90909090-9090-9090-9090-909090909090', 'Meal prep Sunday! 🥗 Prepared healthy lunches for the whole week. Nutrition is self-care. Your body will thank you!', 'text', NULL, 'public', NOW() - INTERVAL '1 day'),
('a0000030-0000-0000-0000-000000000030', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'New song coming this Friday! 🎵🎸 Been working on this for months. The wait is almost over. Pre-save link coming soon!', 'text', NULL, 'public', NOW() - INTERVAL '2 days'),

-- More posts with images
('a0000031-0000-0000-0000-000000000031', '11111111-1111-1111-1111-111111111111', 'Coffee art game strong today ☕✨ Managed to pour a perfect rosetta! Practice really does make better. Here''s the progression shots!', 'text_with_images', NULL, 'public', NOW() - INTERVAL '13 hours'),
('a0000032-0000-0000-0000-000000000032', '88888888-8888-8888-8888-888888888888', 'Sunset photography from rooftop Jakarta 🌅 The city looks beautiful from up here. Sometimes we need to change our perspective to see beauty.', 'text_with_images', NULL, 'public', NOW() - INTERVAL '19 hours'),
('a0000033-0000-0000-0000-000000000033', '33333333-3333-3333-3333-333333333333', 'New gaming setup complete! 🎮⚡ RGB everything lol. Ready for that tournament next week. Let''s goooo!', 'text_with_images', NULL, 'public', NOW() - INTERVAL '2 days'),

-- More text posts
('a0000034-0000-0000-0000-000000000034', '99999999-9999-9999-9999-999999999999', 'Debugging is like being a detective in a crime movie where you are also the murderer 😅 Finally found that bug after 3 hours. The culprit? A missing semicolon. Classic.', 'text', NULL, 'public', NOW() - INTERVAL '17 hours'),
('a0000035-0000-0000-0000-000000000035', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Coffee tip of the day: Water temperature matters! 92-96°C is the sweet spot for most brewing methods ☕🌡️ Too hot = bitter, too cold = sour. Science!', 'text', NULL, 'public', NOW() - INTERVAL '21 hours'),
('a0000036-0000-0000-0000-000000000036', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Social media algorithm changes again 📱 Time to adapt our strategy. The key is always authentic content and community engagement. Algorithms come and go, but real connections last.', 'text', NULL, 'public', NOW() - INTERVAL '1 day'),
('a0000037-0000-0000-0000-000000000037', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'Pitch deck tip: Tell a story, not just facts 📊 Investors invest in people and vision, not just numbers. Make them feel your passion!', 'text', NULL, 'public', NOW() - INTERVAL '4 days'),
('a0000038-0000-0000-0000-000000000038', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Thrifting finds of the week! 🛍️ Found some vintage pieces that are absolute gems. Sustainable fashion is the future!', 'text', NULL, 'public', NOW() - INTERVAL '23 hours'),
('a0000039-0000-0000-0000-000000000039', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'Cooking is like chemistry but you can eat the results 👨‍🍳🧪 Today''s experiment: fusion Indonesian-Italian cuisine. Rendang risotto anyone?', 'text', NULL, 'public', NOW() - INTERVAL '15 hours'),
('a0000040-0000-0000-0000-000000000040', '10101010-1010-1010-1010-101010101010', 'Anime recommendation thread! Drop your top 3 anime below 👇 Always looking for new shows to watch. My current faves: AOT, Demon Slayer, JJK.', 'text', NULL, 'public', NOW() - INTERVAL '12 hours'),

-- More event posts
('a0000041-0000-0000-0000-000000000041', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'Startup founders! 🚀 Don''t miss our networking mixer. Connect with investors, get feedback on your pitch, and meet fellow entrepreneurs. Let''s build together!', 'text_with_event', 'e0000026-0000-0000-0000-000000000026', 'public', NOW() - INTERVAL '5 days'),
('a0000042-0000-0000-0000-000000000042', '50505050-5050-5050-5050-505050505050', 'Python study group this week! 🐍💻 Perfect for beginners. We''ll cover loops, functions, and data structures. Bring your laptop and questions!', 'text_with_event', 'e0000020-0000-0000-0000-000000000020', 'public', NOW() - INTERVAL '6 days'),
('a0000043-0000-0000-0000-000000000043', '88888888-8888-8888-8888-888888888888', 'Photography walk around Old Jakarta! 📸🏛️ Let''s capture the beauty of historical architecture. Beginner photographers welcome!', 'text_with_event', 'e0000030-0000-0000-0000-000000000030', 'public', NOW() - INTERVAL '7 days'),

-- Final posts
('a0000044-0000-0000-0000-000000000044', '11111111-1111-1111-1111-111111111111', 'Random thought: The best conversations happen over coffee ☕💬 There''s something about caffeine that makes us more creative and connected.', 'text', NULL, 'public', NOW() - INTERVAL '8 hours'),
('a0000045-0000-0000-0000-000000000045', '22222222-2222-2222-2222-222222222222', 'Food coma after that amazing nasi goreng 😴🍛 Sometimes the best comfort is in our traditional food. Nothing beats Indonesian cuisine!', 'text', NULL, 'public', NOW() - INTERVAL '5 hours'),
('a0000046-0000-0000-0000-000000000046', '33333333-3333-3333-3333-333333333333', 'Pro tip for gamers: Take breaks! 🎮⏸️ Your performance actually improves when you rest your eyes and stretch. Health > Rank.', 'text', NULL, 'public', NOW() - INTERVAL '11 hours'),
('a0000047-0000-0000-0000-000000000047', '55555555-5555-5555-5555-555555555555', 'Marathon training week 8 done! 🏃‍♂️✅ The journey from couch to marathon is real. Every step counts. Keep going!', 'text', NULL, 'public', NOW() - INTERVAL '7 hours'),
('a0000048-0000-0000-0000-000000000048', '77777777-7777-7777-7777-777777777777', 'Music is the universal language 🎵🌍 Doesn''t matter where you''re from, good music connects us all. What song are you listening to right now?', 'text', NULL, 'public', NOW() - INTERVAL '9 hours'),
('a0000049-0000-0000-0000-000000000049', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yoga isn''t about touching your toes, it''s about what you learn on the way down 🧘‍♀️✨ Flexibility of mind > flexibility of body.', 'text', NULL, 'public', NOW() - INTERVAL '6 hours'),
('a0000050-0000-0000-0000-000000000050', '99999999-9999-9999-9999-999999999999', 'Just remembered why I love coding: The moment when your code finally works after hours of debugging 🎉💻 That dopamine hit is unmatched!', 'text', NULL, 'public', NOW() - INTERVAL '4 hours');

-- ============================================================================
-- 9. POST IMAGES
-- ============================================================================

INSERT INTO post_images (post_id, image_url, order_index) VALUES
-- Post 11 images (photography)
('a0000011-0000-0000-0000-000000000011', 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5', 0),
('a0000011-0000-0000-0000-000000000011', 'https://images.unsplash.com/photo-1581888227599-779811939961', 1),
('a0000011-0000-0000-0000-000000000011', 'https://images.unsplash.com/photo-1547981609-4b6bfe67ca0b', 2),

-- Post 12 images (pasta)
('a0000012-0000-0000-0000-000000000012', 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9', 0),
('a0000012-0000-0000-0000-000000000012', 'https://images.unsplash.com/photo-1612874742237-6526221588e3', 1),

-- Post 13 images (fashion)
('a0000013-0000-0000-0000-000000000013', 'https://images.unsplash.com/photo-1483985988355-763728e1935b', 0),

-- Post 14 images (cooking)
('a0000014-0000-0000-0000-000000000014', 'https://images.unsplash.com/photo-1556910103-1c02745aae4d', 0),
('a0000014-0000-0000-0000-000000000014', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136', 1),

-- Post 15 images (art)
('a0000015-0000-0000-0000-000000000015', 'https://images.unsplash.com/photo-1513364776144-60967b0f800f', 0),
('a0000015-0000-0000-0000-000000000015', 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b', 1),

-- Post 31 images (coffee art)
('a0000031-0000-0000-0000-000000000031', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd', 0),
('a0000031-0000-0000-0000-000000000031', 'https://images.unsplash.com/photo-1509042239860-f550ce710b93', 1),

-- Post 32 images (sunset)
('a0000032-0000-0000-0000-000000000032', 'https://images.unsplash.com/photo-1495954484750-af469f2f9be5', 0),
('a0000032-0000-0000-0000-000000000032', 'https://images.unsplash.com/photo-1519681393784-d120267933ba', 1),

-- Post 33 images (gaming setup)
('a0000033-0000-0000-0000-000000000033', 'https://images.unsplash.com/photo-1593305841991-05c297ba4575', 0);

-- ============================================================================
-- 10. LIKES FOR POSTS (varied engagement)
-- ============================================================================

INSERT INTO likes (user_id, likeable_type, likeable_id) VALUES
-- Post 1 likes
('22222222-2222-2222-2222-222222222222', 'post', 'a0000001-0000-0000-0000-000000000001'),
('33333333-3333-3333-3333-333333333333', 'post', 'a0000001-0000-0000-0000-000000000001'),
('44444444-4444-4444-4444-444444444444', 'post', 'a0000001-0000-0000-0000-000000000001'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'post', 'a0000001-0000-0000-0000-000000000001'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'post', 'a0000001-0000-0000-0000-000000000001'),

-- Post 2 likes
('11111111-1111-1111-1111-111111111111', 'post', 'a0000002-0000-0000-0000-000000000002'),
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'post', 'a0000002-0000-0000-0000-000000000002'),
('66666666-6666-6666-6666-666666666666', 'post', 'a0000002-0000-0000-0000-000000000002'),
('77777777-7777-7777-7777-777777777777', 'post', 'a0000002-0000-0000-0000-000000000002'),

-- Post 3 likes
('99999999-9999-9999-9999-999999999999', 'post', 'a0000003-0000-0000-0000-000000000003'),
('10101010-1010-1010-1010-101010101010', 'post', 'a0000003-0000-0000-0000-000000000003'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'post', 'a0000003-0000-0000-0000-000000000003'),
('30303030-3030-3030-3030-303030303030', 'post', 'a0000003-0000-0000-0000-000000000003'),
('40404040-4040-4040-4040-404040404040', 'post', 'a0000003-0000-0000-0000-000000000003'),
('60606060-6060-6060-6060-606060606060', 'post', 'a0000003-0000-0000-0000-000000000003'),

-- Post 4 likes
('11111111-1111-1111-1111-111111111111', 'post', 'a0000004-0000-0000-0000-000000000004'),
('22222222-2222-2222-2222-222222222222', 'post', 'a0000004-0000-0000-0000-000000000004'),
('88888888-8888-8888-8888-888888888888', 'post', 'a0000004-0000-0000-0000-000000000004'),
('80808080-8080-8080-8080-808080808080', 'post', 'a0000004-0000-0000-0000-000000000004'),

-- Post 5 likes
('11111111-1111-1111-1111-111111111111', 'post', 'a0000005-0000-0000-0000-000000000005'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'post', 'a0000005-0000-0000-0000-000000000005'),
('20202020-2020-2020-2020-202020202020', 'post', 'a0000005-0000-0000-0000-000000000005'),
('90909090-9090-9090-9090-909090909090', 'post', 'a0000005-0000-0000-0000-000000000005'),
('60606060-6060-6060-6060-606060606060', 'post', 'a0000005-0000-0000-0000-000000000005'),

-- Post 6 likes
('22222222-2222-2222-2222-222222222222', 'post', 'a0000006-0000-0000-0000-000000000006'),
('44444444-4444-4444-4444-444444444444', 'post', 'a0000006-0000-0000-0000-000000000006'),
('50505050-5050-5050-5050-505050505050', 'post', 'a0000006-0000-0000-0000-000000000006'),

-- Post 8 likes (developer post)
('33333333-3333-3333-3333-333333333333', 'post', 'a0000008-0000-0000-0000-000000000008'),
('50505050-5050-5050-5050-505050505050', 'post', 'a0000008-0000-0000-0000-000000000008'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'post', 'a0000008-0000-0000-0000-000000000008'),
('80808080-8080-8080-8080-808080808080', 'post', 'a0000008-0000-0000-0000-000000000008'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'post', 'a0000008-0000-0000-0000-000000000008'),

-- Post 11 likes (photography)
('44444444-4444-4444-4444-444444444444', 'post', 'a0000011-0000-0000-0000-000000000011'),
('11111111-1111-1111-1111-111111111111', 'post', 'a0000011-0000-0000-0000-000000000011'),
('70707070-7070-7070-7070-707070707070', 'post', 'a0000011-0000-0000-0000-000000000011'),
('40404040-4040-4040-4040-404040404040', 'post', 'a0000011-0000-0000-0000-000000000011'),
('80808080-8080-8080-8080-808080808080', 'post', 'a0000011-0000-0000-0000-000000000011'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'post', 'a0000011-0000-0000-0000-000000000011'),

-- Post 15 likes (art)
('88888888-8888-8888-8888-888888888888', 'post', 'a0000015-0000-0000-0000-000000000015'),
('80808080-8080-8080-8080-808080808080', 'post', 'a0000015-0000-0000-0000-000000000015'),
('11111111-1111-1111-1111-111111111111', 'post', 'a0000015-0000-0000-0000-000000000015'),
('30303030-3030-3030-3030-303030303030', 'post', 'a0000015-0000-0000-0000-000000000015'),

-- More likes for various posts
('11111111-1111-1111-1111-111111111111', 'post', 'a0000017-0000-0000-0000-000000000017'),
('99999999-9999-9999-9999-999999999999', 'post', 'a0000017-0000-0000-0000-000000000017'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'post', 'a0000017-0000-0000-0000-000000000017'),
('22222222-2222-2222-2222-222222222222', 'post', 'a0000017-0000-0000-0000-000000000017'),

('33333333-3333-3333-3333-333333333333', 'post', 'a0000018-0000-0000-0000-000000000018'),
('10101010-1010-1010-1010-101010101010', 'post', 'a0000018-0000-0000-0000-000000000018'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'post', 'a0000018-0000-0000-0000-000000000018'),

('11111111-1111-1111-1111-111111111111', 'post', 'a0000020-0000-0000-0000-000000000020'),
('44444444-4444-4444-4444-444444444444', 'post', 'a0000020-0000-0000-0000-000000000020'),
('88888888-8888-8888-8888-888888888888', 'post', 'a0000020-0000-0000-0000-000000000020'),
('30303030-3030-3030-3030-303030303030', 'post', 'a0000020-0000-0000-0000-000000000020'),

('11111111-1111-1111-1111-111111111111', 'post', 'a0000031-0000-0000-0000-000000000031'),
('22222222-2222-2222-2222-222222222222', 'post', 'a0000031-0000-0000-0000-000000000031'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'post', 'a0000031-0000-0000-0000-000000000031'),

('11111111-1111-1111-1111-111111111111', 'post', 'a0000032-0000-0000-0000-000000000032'),
('44444444-4444-4444-4444-444444444444', 'post', 'a0000032-0000-0000-0000-000000000032'),
('40404040-4040-4040-4040-404040404040', 'post', 'a0000032-0000-0000-0000-000000000032'),
('70707070-7070-7070-7070-707070707070', 'post', 'a0000032-0000-0000-0000-000000000032'),

('99999999-9999-9999-9999-999999999999', 'post', 'a0000034-0000-0000-0000-000000000034'),
('50505050-5050-5050-5050-505050505050', 'post', 'a0000034-0000-0000-0000-000000000034'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'post', 'a0000034-0000-0000-0000-000000000034'),
('80808080-8080-8080-8080-808080808080', 'post', 'a0000034-0000-0000-0000-000000000034'),

('11111111-1111-1111-1111-111111111111', 'post', 'a0000035-0000-0000-0000-000000000035'),
('22222222-2222-2222-2222-222222222222', 'post', 'a0000035-0000-0000-0000-000000000035'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'post', 'a0000035-0000-0000-0000-000000000035');

-- ============================================================================
-- 11. COMMENTS (including nested comments)
-- ============================================================================

INSERT INTO comments (id, post_id, author_id, parent_comment_id, content, created_at) VALUES
-- Comments on Post 1 (coffee event)
('c0000001-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', NULL, 'This sounds amazing! Already registered 🎉', NOW() - INTERVAL '1 day'),
('c0000002-0000-0000-0000-000000000002', 'a0000001-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'c0000001-0000-0000-0000-000000000001', 'Awesome! See you there 😊', NOW() - INTERVAL '23 hours'),
('c0000003-0000-0000-0000-000000000003', 'a0000001-0000-0000-0000-000000000001', '33333333-3333-3333-3333-333333333333', NULL, 'What time does it start exactly?', NOW() - INTERVAL '20 hours'),
('c0000004-0000-0000-0000-000000000004', 'a0000001-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'c0000003-0000-0000-0000-000000000003', '10 AM sharp! Don''t be late', NOW() - INTERVAL '19 hours'),

-- Comments on Post 2 (food tour)
('c0000005-0000-0000-0000-000000000005', 'a0000002-0000-0000-0000-000000000002', 'ffffffff-ffff-ffff-ffff-ffffffffffff', NULL, 'Count me in! Love street food 🍜', NOW() - INTERVAL '2 days'),
('c0000006-0000-0000-0000-000000000006', 'a0000002-0000-0000-0000-000000000002', '66666666-6666-6666-6666-666666666666', NULL, 'Which spots are we visiting?', NOW() - INTERVAL '2 days'),
('c0000007-0000-0000-0000-000000000007', 'a0000002-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222', 'c0000006-0000-0000-0000-000000000006', 'It''s a surprise! But trust me, all legendary spots', NOW() - INTERVAL '1 day'),

-- Comments on Post 3 (gaming tournament)
('c0000008-0000-0000-0000-000000000008', 'a0000003-0000-0000-0000-000000000003', '99999999-9999-9999-9999-999999999999', NULL, 'My team is ready! Let''s win this 🏆', NOW() - INTERVAL '3 days'),
('c0000009-0000-0000-0000-000000000009', 'a0000003-0000-0000-0000-000000000003', '10101010-1010-1010-1010-101010101010', NULL, 'Good luck everyone! May the best team win', NOW() - INTERVAL '3 days'),
('c0000010-0000-0000-0000-000000000010', 'a0000003-0000-0000-0000-000000000003', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'c0000008-0000-0000-0000-000000000008', 'We''re coming for that prize! 😎', NOW() - INTERVAL '2 days'),

-- Comments on Post 4 (watercolor art)
('c0000011-0000-0000-0000-000000000011', 'a0000004-0000-0000-0000-000000000004', '88888888-8888-8888-8888-888888888888', NULL, 'This is beautiful! 😍 You''re so talented', NOW() - INTERVAL '1 day'),
('c0000012-0000-0000-0000-000000000012', 'a0000004-0000-0000-0000-000000000004', '80808080-8080-8080-8080-808080808080', NULL, 'Love the color blending! What brand of paint do you use?', NOW() - INTERVAL '1 day'),
('c0000013-0000-0000-0000-000000000013', 'a0000004-0000-0000-0000-000000000004', '44444444-4444-4444-4444-444444444444', 'c0000012-0000-0000-0000-000000000012', 'Thank you! I use Winsor & Newton professional series', NOW() - INTERVAL '20 hours'),

-- Comments on Post 5 (running)
('c0000014-0000-0000-0000-000000000014', 'a0000005-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL, 'Congrats! That''s an amazing time for your first 10K! 🎉', NOW() - INTERVAL '5 hours'),
('c0000015-0000-0000-0000-000000000015', 'a0000005-0000-0000-0000-000000000005', '20202020-2020-2020-2020-202020202020', NULL, 'Well done! Keep it up 💪', NOW() - INTERVAL '4 hours'),
('c0000016-0000-0000-0000-000000000016', 'a0000005-0000-0000-0000-000000000005', '11111111-1111-1111-1111-111111111111', NULL, 'Impressive! Join our run club next week!', NOW() - INTERVAL '3 hours'),

-- Comments on Post 8 (full-stack app)
('c0000017-0000-0000-0000-000000000017', 'a0000008-0000-0000-0000-000000000008', '50505050-5050-5050-5050-505050505050', NULL, 'Congrats on the deployment! 🚀 What does the app do?', NOW() - INTERVAL '2 days'),
('c0000018-0000-0000-0000-000000000018', 'a0000008-0000-0000-0000-000000000008', '99999999-9999-9999-9999-999999999999', 'c0000017-0000-0000-0000-000000000017', 'It''s a task management app with real-time collaboration!', NOW() - INTERVAL '1 day'),
('c0000019-0000-0000-0000-000000000019', 'a0000008-0000-0000-0000-000000000008', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL, 'That''s awesome! Is it open source?', NOW() - INTERVAL '1 day'),
('c0000020-0000-0000-0000-000000000020', 'a0000008-0000-0000-0000-000000000008', '99999999-9999-9999-9999-999999999999', 'c0000019-0000-0000-0000-000000000019', 'Not yet, but planning to open source it soon!', NOW() - INTERVAL '20 hours'),

-- Comments on Post 11 (photography)
('c0000021-0000-0000-0000-000000000021', 'a0000011-0000-0000-0000-000000000011', '44444444-4444-4444-4444-444444444444', NULL, 'These shots are incredible! 📸✨', NOW() - INTERVAL '1 day'),
('c0000022-0000-0000-0000-000000000022', 'a0000011-0000-0000-0000-000000000011', '70707070-7070-7070-7070-707070707070', NULL, 'What camera settings did you use?', NOW() - INTERVAL '22 hours'),
('c0000023-0000-0000-0000-000000000023', 'a0000011-0000-0000-0000-000000000011', '88888888-8888-8888-8888-888888888888', 'c0000022-0000-0000-0000-000000000022', 'f/2.8, ISO 200, 1/250s. Shot on Canon R5', NOW() - INTERVAL '20 hours'),
('c0000024-0000-0000-0000-000000000024', 'a0000011-0000-0000-0000-000000000011', '40404040-4040-4040-4040-404040404040', NULL, 'The composition is perfect! Love the third shot especially', NOW() - INTERVAL '18 hours'),

-- Comments on Post 17 (startup funding)
('c0000025-0000-0000-0000-000000000025', 'a0000017-0000-0000-0000-000000000017', '11111111-1111-1111-1111-111111111111', NULL, 'Huge congratulations! 🎉 This is inspiring!', NOW() - INTERVAL '3 days'),
('c0000026-0000-0000-0000-000000000026', 'a0000017-0000-0000-0000-000000000017', '99999999-9999-9999-9999-999999999999', NULL, 'That''s amazing! What''s your startup about?', NOW() - INTERVAL '2 days'),
('c0000027-0000-0000-0000-000000000027', 'a0000017-0000-0000-0000-000000000017', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'c0000026-0000-0000-0000-000000000026', 'We''re building AI-powered supply chain optimization', NOW() - INTERVAL '2 days'),
('c0000028-0000-0000-0000-000000000028', 'a0000017-0000-0000-0000-000000000017', 'cccccccc-cccc-cccc-cccc-cccccccccccc', NULL, 'So proud of you! Let''s celebrate soon 🍾', NOW() - INTERVAL '2 days'),

-- Comments on Post 34 (debugging joke)
('c0000029-0000-0000-0000-000000000029', 'a0000034-0000-0000-0000-000000000034', '50505050-5050-5050-5050-505050505050', NULL, 'LMAO this is so accurate 😂', NOW() - INTERVAL '17 hours'),
('c0000030-0000-0000-0000-000000000030', 'a0000034-0000-0000-0000-000000000034', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL, 'Every. Single. Time. 😅', NOW() - INTERVAL '16 hours'),
('c0000031-0000-0000-0000-000000000031', 'a0000034-0000-0000-0000-000000000034', '80808080-8080-8080-8080-808080808080', NULL, 'The semicolon is always guilty 😂', NOW() - INTERVAL '15 hours'),
('c0000032-0000-0000-0000-000000000032', 'a0000034-0000-0000-0000-000000000034', '99999999-9999-9999-9999-999999999999', 'c0000030-0000-0000-0000-000000000030', 'Story of my life as a developer', NOW() - INTERVAL '14 hours'),

-- More comments on popular posts
('c0000033-0000-0000-0000-000000000033', 'a0000031-0000-0000-0000-000000000031', '22222222-2222-2222-2222-222222222222', NULL, 'That rosetta is perfect! 😍☕', NOW() - INTERVAL '12 hours'),
('c0000034-0000-0000-0000-000000000034', 'a0000031-0000-0000-0000-000000000031', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL, 'Teach me your ways! Mine always turns out like a blob 😅', NOW() - INTERVAL '11 hours'),
('c0000035-0000-0000-0000-000000000035', 'a0000031-0000-0000-0000-000000000031', '11111111-1111-1111-1111-111111111111', 'c0000034-0000-0000-0000-000000000034', 'Come to my latte art workshop next week! 😊', NOW() - INTERVAL '10 hours'),

('c0000036-0000-0000-0000-000000000036', 'a0000006-0000-0000-0000-000000000006', '44444444-4444-4444-4444-444444444444', NULL, 'Added to my reading list! Thanks for the recommendation 📚', NOW() - INTERVAL '10 hours'),
('c0000037-0000-0000-0000-000000000037', 'a0000006-0000-0000-0000-000000000006', '50505050-5050-5050-5050-505050505050', NULL, 'One of my favorite books! The story is incredible', NOW() - INTERVAL '8 hours'),

('c0000038-0000-0000-0000-000000000038', 'a0000035-0000-0000-0000-000000000035', '11111111-1111-1111-1111-111111111111', NULL, 'Great tip! Temperature control is so underrated', NOW() - INTERVAL '20 hours'),
('c0000039-0000-0000-0000-000000000039', 'a0000035-0000-0000-0000-000000000035', '22222222-2222-2222-2222-222222222222', NULL, 'I learned this the hard way 😅 Now my coffee tastes so much better', NOW() - INTERVAL '18 hours'),

('c0000040-0000-0000-0000-000000000040', 'a0000040-0000-0000-0000-000000000040', '10101010-1010-1010-1010-101010101010', NULL, 'My top 3: 1. Attack on Titan 2. Demon Slayer 3. One Piece', NOW() - INTERVAL '11 hours'),
('c0000041-0000-0000-0000-000000000041', 'a0000040-0000-0000-0000-000000000040', '33333333-3333-3333-3333-333333333333', NULL, 'One Piece, JJK, and Vinland Saga!', NOW() - INTERVAL '10 hours'),
('c0000042-0000-0000-0000-000000000042', 'a0000040-0000-0000-0000-000000000040', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL, 'You need to watch Steins;Gate! Mind-blowing 🤯', NOW() - INTERVAL '9 hours');

-- ============================================================================
-- 12. LIKES FOR COMMENTS
-- ============================================================================

INSERT INTO likes (user_id, likeable_type, likeable_id) VALUES
-- Likes on comment 1
('11111111-1111-1111-1111-111111111111', 'comment', 'c0000001-0000-0000-0000-000000000001'),
('33333333-3333-3333-3333-333333333333', 'comment', 'c0000001-0000-0000-0000-000000000001'),
('44444444-4444-4444-4444-444444444444', 'comment', 'c0000001-0000-0000-0000-000000000001'),

-- Likes on comment 11 (art compliment)
('11111111-1111-1111-1111-111111111111', 'comment', 'c0000011-0000-0000-0000-000000000011'),
('22222222-2222-2222-2222-222222222222', 'comment', 'c0000011-0000-0000-0000-000000000011'),
('44444444-4444-4444-4444-444444444444', 'comment', 'c0000011-0000-0000-0000-000000000011'),
('80808080-8080-8080-8080-808080808080', 'comment', 'c0000011-0000-0000-0000-000000000011'),

-- Likes on comment 14 (running congrats)
('55555555-5555-5555-5555-555555555555', 'comment', 'c0000014-0000-0000-0000-000000000014'),
('20202020-2020-2020-2020-202020202020', 'comment', 'c0000014-0000-0000-0000-000000000014'),

-- Likes on comment 21 (photography)
('11111111-1111-1111-1111-111111111111', 'comment', 'c0000021-0000-0000-0000-000000000021'),
('70707070-7070-7070-7070-707070707070', 'comment', 'c0000021-0000-0000-0000-000000000021'),
('40404040-4040-4040-4040-404040404040', 'comment', 'c0000021-0000-0000-0000-000000000021'),

-- Likes on comment 25 (startup congrats)
('99999999-9999-9999-9999-999999999999', 'comment', 'c0000025-0000-0000-0000-000000000025'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'comment', 'c0000025-0000-0000-0000-000000000025'),
('22222222-2222-2222-2222-222222222222', 'comment', 'c0000025-0000-0000-0000-000000000025'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'comment', 'c0000025-0000-0000-0000-000000000025'),

-- Likes on funny comments
('99999999-9999-9999-9999-999999999999', 'comment', 'c0000029-0000-0000-0000-000000000029'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'comment', 'c0000029-0000-0000-0000-000000000029'),
('80808080-8080-8080-8080-808080808080', 'comment', 'c0000029-0000-0000-0000-000000000029'),

('50505050-5050-5050-5050-505050505050', 'comment', 'c0000030-0000-0000-0000-000000000030'),
('99999999-9999-9999-9999-999999999999', 'comment', 'c0000030-0000-0000-0000-000000000030'),

('11111111-1111-1111-1111-111111111111', 'comment', 'c0000033-0000-0000-0000-000000000033'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'comment', 'c0000033-0000-0000-0000-000000000033'),

('66666666-6666-6666-6666-666666666666', 'comment', 'c0000036-0000-0000-0000-000000000036'),
('50505050-5050-5050-5050-505050505050', 'comment', 'c0000036-0000-0000-0000-000000000036'),

('22222222-2222-2222-2222-222222222222', 'comment', 'c0000038-0000-0000-0000-000000000038'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'comment', 'c0000038-0000-0000-0000-000000000038'),
('11111111-1111-1111-1111-111111111111', 'comment', 'c0000038-0000-0000-0000-000000000038');

-- ============================================================================
-- 13. UPDATE STATISTICS
-- ============================================================================
-- The triggers should auto-update most counters, but let's ensure event attendee counts are correct

UPDATE events e SET attendees_count = (
    SELECT COUNT(*) FROM event_attendees ea
    WHERE ea.event_id = e.id AND ea.status = 'confirmed'
);

COMMIT;

-- ============================================================================
-- SEED DATA SUMMARY
-- ============================================================================
-- Total counts:
-- - Users: 25
-- - Events: 30 (coffee: 3, food: 4, gaming: 3, sports: 4, music: 3, movies: 2, study: 3, art: 3, other: 5)
-- - Event Images: 15
-- - Event Attendees: 60+
-- - Event Q&A: 22 (with some answered, some pending)
-- - Posts: 50 (text: 30+, text_with_images: 8, text_with_event: 7+)
-- - Post Images: 16
-- - Likes on Posts: 70+
-- - Comments: 42 (including nested comments)
-- - Likes on Comments: 30+
-- - Follows: 20

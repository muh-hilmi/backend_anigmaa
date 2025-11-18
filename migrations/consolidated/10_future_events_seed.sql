-- ============================================================================
-- FUTURE EVENTS COMPREHENSIVE SEED DATA (12 MONTHS)
-- ============================================================================
-- This seed file contains 65 future events spread across 12 months
-- From late November 2025 to November 2026
-- Categories: coffee, food, study, sports, other
-- Perfect for debugging and testing event discovery features
-- ============================================================================


-- ============================================================================
-- FUTURE EVENTS (65 events across 12 months)
-- ============================================================================

INSERT INTO events (id, host_id, title, description, category, start_time, end_time, location_name, location_address, location_lat, location_lng, max_attendees, price, is_free, status, privacy) VALUES

-- ============================================================================
-- NOVEMBER 2025 (Late November - 5 events)
-- ============================================================================
('f0000001-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111',
'Weekend Latte Art Championship',
'Compete with the best baristas in Jakarta! Show off your latte art skills and win prizes. Beginner and pro categories available.',
'coffee', '2025-11-22 10:00:00+07', '2025-11-22 15:00:00+07',
'Kopi Kenangan HQ', 'Jl. Senopati Raya No.15, Jakarta Selatan',
-6.237020, 106.808810, 40, 250000, false, 'upcoming', 'public'),

('f0000002-0000-0000-0000-000000000002', '99999999-9999-9999-9999-999999999999',
'Golang 1.23 Release Party & Workshop',
'Celebrate the release of Go 1.23! Learn about new features, performance improvements, and best practices from expert developers.',
'study', '2025-11-24 13:00:00+07', '2025-11-24 18:00:00+07',
'Google Developer Space Jakarta', 'Equity Tower, SCBD, Jakarta Selatan',
-6.225830, 106.809170, 80, 0, true, 'upcoming', 'public'),

('f0000003-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222',
'Street Food Night Market Tour',
'Explore Jakarta''s best street food! Guided tour through 10 iconic food spots. Taste nasi goreng, sate, martabak, and more!',
'food', '2025-11-25 18:00:00+07', '2025-11-25 22:00:00+07',
'Blok M Square', 'Jl. Melawai Raya, Jakarta Selatan',
-6.243610, 106.798610, 25, 150000, false, 'upcoming', 'public'),

('f0000004-0000-0000-0000-000000000004', '55555555-5555-5555-5555-555555555555',
'5K Fun Run: Charity for Education',
'Run for a cause! All proceeds go to education for underprivileged children. Free t-shirt, medal, and breakfast!',
'sports', '2025-11-29 06:00:00+07', '2025-11-29 09:00:00+07',
'GBK Stadium', 'Jl. Pintu Satu Senayan, Jakarta Pusat',
-6.218480, 106.802610, 500, 100000, false, 'upcoming', 'public'),

('f0000005-0000-0000-0000-000000000005', '88888888-8888-8888-8888-888888888888',
'Golden Hour Photography Walk',
'Capture stunning golden hour shots in Jakarta! Learn composition, lighting, and editing techniques from pro photographers.',
'other', '2025-11-30 16:00:00+07', '2025-11-30 19:00:00+07',
'Kota Tua Jakarta', 'Jl. Taman Fatahillah, Jakarta Barat',
-6.134980, 106.813310, 30, 100000, false, 'upcoming', 'public'),

-- ============================================================================
-- DECEMBER 2025 (8 events - holiday season)
-- ============================================================================
('f0000006-0000-0000-0000-000000000006', '11111111-1111-1111-1111-111111111111',
'Christmas Coffee Tasting Special',
'Taste 8 different Christmas-themed coffee blends! From gingerbread latte to peppermint mocha. Perfect holiday treat!',
'coffee', '2025-12-07 14:00:00+07', '2025-12-07 16:30:00+07',
'Tanamera Coffee', 'Jl. Cipete Raya, Jakarta Selatan',
-6.269720, 106.804170, 20, 200000, false, 'upcoming', 'public'),

('f0000007-0000-0000-0000-000000000007', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
'Year-End Tech Trends 2025 Seminar',
'Review of 2025''s biggest tech trends: AI advances, web3, quantum computing, and what to expect in 2026!',
'study', '2025-12-10 09:00:00+07', '2025-12-10 17:00:00+07',
'JCC Senayan', 'Jl. Jenderal Gatot Subroto, Jakarta Pusat',
-6.225830, 106.802080, 200, 500000, false, 'upcoming', 'public'),

('f0000008-0000-0000-0000-000000000008', '22222222-2222-2222-2222-222222222222',
'Italian Cuisine Masterclass',
'Learn to cook authentic Italian dishes! Make pasta from scratch, perfect your carbonara, and master tiramisu.',
'food', '2025-12-12 10:00:00+07', '2025-12-12 15:00:00+07',
'Chef Academy Jakarta', 'Jl. Tanjung Duren Raya, Jakarta Barat',
-6.168610, 106.785830, 15, 450000, false, 'upcoming', 'public'),

('f0000009-0000-0000-0000-000000000009', '60606060-6060-6060-6060-606060606060',
'Badminton Tournament: Year End Cup',
'Annual year-end badminton tournament! Singles and doubles categories. Great prizes for winners!',
'sports', '2025-12-14 08:00:00+07', '2025-12-14 17:00:00+07',
'Istora Senayan', 'Jl. Pintu Satu Senayan, Jakarta Pusat',
-6.218750, 106.803610, 64, 150000, false, 'upcoming', 'public'),

('f0000010-0000-0000-0000-000000000010', 'dddddddd-dddd-dddd-dddd-dddddddddddd',
'Startup Pitch Competition 2025',
'Final pitch competition of 2025! 20 startups compete for 1 billion rupiah in funding. Investors and mentors attending!',
'other', '2025-12-15 13:00:00+07', '2025-12-15 18:00:00+07',
'Jakarta Founder Institute', 'Menara Rajawali, Jakarta Selatan',
-6.227500, 106.830830, 100, 100000, false, 'upcoming', 'public'),

('f0000011-0000-0000-0000-000000000011', '99999999-9999-9999-9999-999999999999',
'React 19 Features Deep Dive',
'Explore React 19''s new features: Server Components, Actions, and improved performance. Hands-on workshop included!',
'study', '2025-12-18 13:00:00+07', '2025-12-18 18:00:00+07',
'WeWork SCBD', 'District 8, Jakarta Selatan',
-6.227500, 106.805000, 50, 200000, false, 'upcoming', 'public'),

('f0000012-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
'Sunset Yoga & Meditation Session',
'End your year peacefully with sunset yoga overlooking Jakarta. All levels welcome. Mats provided.',
'other', '2025-12-21 16:30:00+07', '2025-12-21 18:30:00+07',
'Hutan Kota GBK', 'Jl. Gelora, Senayan, Jakarta Pusat',
-6.216670, 106.801940, 40, 100000, false, 'upcoming', 'public'),

('f0000013-0000-0000-0000-000000000013', '11111111-1111-1111-1111-111111111111',
'New Year Coffee Countdown Party',
'Count down to 2026 with specialty coffee! Live music, coffee tasting, and fireworks view from rooftop!',
'coffee', '2025-12-31 20:00:00+07', '2026-01-01 01:00:00+07',
'Starbucks Reserve Dewata', 'Pacific Place Mall, Jakarta Selatan',
-6.225000, 106.809440, 60, 350000, false, 'upcoming', 'public'),

-- ============================================================================
-- JANUARY 2026 (6 events - New Year momentum)
-- ============================================================================
('f0000014-0000-0000-0000-000000000014', '55555555-5555-5555-5555-555555555555',
'New Year New Goals: Half Marathon',
'Start 2026 strong with a half marathon! Scenic route through Jakarta. Medal and finisher kit for all participants.',
'sports', '2026-01-04 05:00:00+07', '2026-01-04 10:00:00+07',
'Monas', 'Jl. Medan Merdeka, Jakarta Pusat',
-6.175110, 106.827153, 1000, 200000, false, 'upcoming', 'public'),

('f0000015-0000-0000-0000-000000000015', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
'Microservices Architecture Workshop',
'Build scalable microservices with Docker, Kubernetes, and service mesh. 2-day intensive workshop!',
'study', '2026-01-10 09:00:00+07', '2026-01-11 17:00:00+07',
'Hacktiv8 Office', 'Jl. Sultan Iskandar Muda, Jakarta Selatan',
-6.243060, 106.783890, 30, 1500000, false, 'upcoming', 'public'),

('f0000016-0000-0000-0000-000000000016', '22222222-2222-2222-2222-222222222222',
'Authentic Sushi Making Workshop',
'Master the art of sushi! Learn from a Japanese chef. Make nigiri, maki, and sashimi like a pro.',
'food', '2026-01-15 11:00:00+07', '2026-01-15 15:00:00+07',
'Hattori Jakarta', 'Plaza Indonesia, Jakarta Pusat',
-6.192780, 106.821940, 12, 600000, false, 'upcoming', 'public'),

('f0000017-0000-0000-0000-000000000017', '11111111-1111-1111-1111-111111111111',
'Barista Certification Course - Level 1',
'Get officially certified as a barista! 3-day intensive course covering espresso, milk steaming, and latte art.',
'coffee', '2026-01-20 09:00:00+07', '2026-01-22 17:00:00+07',
'SCA Indonesia Training Center', 'Jl. Kemang Raya, Jakarta Selatan',
-6.267500, 106.815830, 15, 3500000, false, 'upcoming', 'public'),

('f0000018-0000-0000-0000-000000000018', '88888888-8888-8888-8888-888888888888',
'Long Exposure Night Photography',
'Master long exposure techniques! Capture light trails, star trails, and stunning night scenes.',
'other', '2026-01-24 19:00:00+07', '2026-01-24 23:00:00+07',
'Ancol Beach', 'Jl. Lodan Timur No.7, Jakarta Utara',
-6.122780, 106.843330, 25, 250000, false, 'upcoming', 'public'),

('f0000019-0000-0000-0000-000000000019', '33333333-3333-3333-3333-333333333333',
'Esports Tournament: Mobile Legends',
'Biggest Mobile Legends tournament in Jakarta! Form your team and compete for 50 million rupiah prize pool!',
'sports', '2026-01-31 10:00:00+07', '2026-01-31 22:00:00+07',
'Plaza Senayan Gaming Arena', 'Jl. Asia Afrika, Jakarta Pusat',
-6.225000, 106.798890, 200, 200000, false, 'upcoming', 'public'),

-- ============================================================================
-- FEBRUARY 2026 (5 events - Valentine's theme)
-- ============================================================================
('f0000020-0000-0000-0000-000000000020', '11111111-1111-1111-1111-111111111111',
'Valentine''s Couples Coffee Date',
'Romantic coffee experience for couples! Learn to make coffee together, latte art competition, and special desserts.',
'coffee', '2026-02-14 15:00:00+07', '2026-02-14 18:00:00+07',
'Kopilot', 'Jl. Gunawarman, Jakarta Selatan',
-6.246110, 106.805560, 30, 400000, false, 'upcoming', 'public'),

('f0000021-0000-0000-0000-000000000021', '22222222-2222-2222-2222-222222222222',
'Chocolate Making Valentine Workshop',
'Create artisanal chocolates for your loved ones! Learn tempering, molding, and decoration techniques.',
'food', '2026-02-13 10:00:00+07', '2026-02-13 14:00:00+07',
'Pipiltin Cocoa', 'Jl. Wijaya I, Jakarta Selatan',
-6.242500, 106.796940, 20, 500000, false, 'upcoming', 'public'),

('f0000022-0000-0000-0000-000000000022', '99999999-9999-9999-9999-999999999999',
'Web Performance Optimization Bootcamp',
'Make your websites lightning fast! Learn Core Web Vitals, lazy loading, code splitting, and caching strategies.',
'study', '2026-02-17 09:00:00+07', '2026-02-17 17:00:00+07',
'Tokopedia Tower', 'Jl. Prof. DR. Satrio, Jakarta Selatan',
-6.221110, 106.821940, 80, 300000, false, 'upcoming', 'public'),

('f0000023-0000-0000-0000-000000000023', '55555555-5555-5555-5555-555555555555',
'Parkour & Free Running Workshop',
'Learn parkour basics in a safe environment! Jumping, vaulting, and climbing techniques from certified trainers.',
'sports', '2026-02-22 08:00:00+07', '2026-02-22 12:00:00+07',
'Senayan Parkour Park', 'Jl. Gelora, Senayan, Jakarta',
-6.218890, 106.803330, 25, 250000, false, 'upcoming', 'public'),

('f0000024-0000-0000-0000-000000000024', '44444444-4444-4444-4444-444444444444',
'Digital Painting Masterclass',
'Create stunning digital art! Procreate and Photoshop techniques for character design and concept art.',
'other', '2026-02-28 13:00:00+07', '2026-02-28 18:00:00+07',
'Artjog Space Jakarta', 'Jl. Kemang Raya, Jakarta Selatan',
-6.267500, 106.815830, 20, 350000, false, 'upcoming', 'public'),

-- ============================================================================
-- MARCH 2026 (6 events - Spring season)
-- ============================================================================
('f0000025-0000-0000-0000-000000000025', '11111111-1111-1111-1111-111111111111',
'Single Origin Coffee Journey',
'Explore coffee from 5 different countries! Ethiopia, Colombia, Kenya, Brazil, and Indonesia. Cupping session included.',
'coffee', '2026-03-07 10:00:00+07', '2026-03-07 13:00:00+07',
'Anomali Coffee HQ', 'Jl. Senopati No.75, Jakarta Selatan',
-6.237020, 106.808810, 25, 300000, false, 'upcoming', 'public'),

('f0000026-0000-0000-0000-000000000026', 'ffffffff-ffff-ffff-ffff-ffffffffffff',
'French Pastry Workshop: Croissants & Pain au Chocolat',
'Master French laminated dough! Make perfect croissants and pain au chocolat. 6-hour intensive class.',
'food', '2026-03-12 08:00:00+07', '2026-03-12 14:00:00+07',
'Le Cordon Bleu Jakarta', 'Jl. Arteri Pondok Indah, Jakarta Selatan',
-6.267780, 106.783610, 12, 800000, false, 'upcoming', 'public'),

('f0000027-0000-0000-0000-000000000027', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
'GraphQL API Development Workshop',
'Build modern APIs with GraphQL! Learn schema design, resolvers, subscriptions, and performance optimization.',
'study', '2026-03-15 09:00:00+07', '2026-03-15 17:00:00+07',
'Gojek Office', 'Pasaraya Blok M, Jakarta Selatan',
-6.243610, 106.797500, 60, 250000, false, 'upcoming', 'public'),

('f0000028-0000-0000-0000-000000000028', '20202020-2020-2020-2020-202020202020',
'Jakarta Cycling Tour: 50KM Challenge',
'Scenic 50km cycling route through Jakarta and Tangerang. Rest stops, breakfast, and lunch included!',
'sports', '2026-03-21 05:30:00+07', '2026-03-21 11:00:00+07',
'Bundaran HI', 'Jl. M.H. Thamrin, Jakarta Pusat',
-6.195000, 106.823060, 100, 150000, false, 'upcoming', 'public'),

('f0000029-0000-0000-0000-000000000029', '70707070-7070-7070-7070-707070707070',
'Content Creation Workshop: YouTube & TikTok',
'Learn to create viral content! Video editing, storytelling, and growth strategies from successful creators.',
'other', '2026-03-25 13:00:00+07', '2026-03-25 18:00:00+07',
'Creator Space Jakarta', 'Jl. Panglima Polim, Jakarta Selatan',
-6.251390, 106.797780, 40, 200000, false, 'upcoming', 'public'),

('f0000030-0000-0000-0000-000000000030', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
'Beach Yoga Retreat Day Trip',
'One-day yoga retreat to Anyer Beach! Morning yoga, meditation, healthy meals, and beach relaxation.',
'other', '2026-03-29 06:00:00+07', '2026-03-29 18:00:00+07',
'Anyer Beach Resort', 'Anyer, Banten',
-6.081110, 105.858890, 30, 500000, false, 'upcoming', 'public'),

-- ============================================================================
-- APRIL 2026 (5 events)
-- ============================================================================
('f0000031-0000-0000-0000-000000000031', '11111111-1111-1111-1111-111111111111',
'Coffee Roasting 101 Workshop',
'Learn the science and art of coffee roasting! Hands-on experience with professional roasting equipment.',
'coffee', '2026-04-05 09:00:00+07', '2026-04-05 15:00:00+07',
'Otten Coffee Roastery', 'Jl. Kemang Raya, Jakarta Selatan',
-6.267500, 106.815830, 15, 650000, false, 'upcoming', 'public'),

('f0000032-0000-0000-0000-000000000032', '99999999-9999-9999-9999-999999999999',
'Machine Learning with TensorFlow',
'Introduction to ML with TensorFlow! Build your first neural network and image classifier.',
'study', '2026-04-10 09:00:00+07', '2026-04-11 17:00:00+07',
'Dicoding Space', 'Jl. Batununggal Indah Raya, Bandung',
-6.943330, 107.629720, 40, 1000000, false, 'upcoming', 'public'),

('f0000033-0000-0000-0000-000000000033', 'ffffffff-ffff-ffff-ffff-ffffffffffff',
'Thai Street Food Cooking Class',
'Master Thai favorites! Pad Thai, Tom Yum, Green Curry, and Mango Sticky Rice. All spice levels welcome!',
'food', '2026-04-15 11:00:00+07', '2026-04-15 16:00:00+07',
'Nara Thai Cooking School', 'Jl. Senopati, Jakarta Selatan',
-6.237020, 106.808810, 16, 400000, false, 'upcoming', 'public'),

('f0000034-0000-0000-0000-000000000034', '60606060-6060-6060-6060-606060606060',
'3x3 Basketball Tournament',
'Street basketball tournament! Fast-paced 3x3 games. Register your team and compete for the championship!',
'sports', '2026-04-19 09:00:00+07', '2026-04-19 17:00:00+07',
'Gelora Bung Karno Basketball Court', 'Jl. Pintu Satu Senayan, Jakarta',
-6.218750, 106.803610, 80, 300000, false, 'upcoming', 'public'),

('f0000035-0000-0000-0000-000000000035', '44444444-4444-4444-4444-444444444444',
'Watercolor Painting Workshop',
'Learn watercolor techniques! Landscapes, portraits, and abstract styles. All materials provided.',
'other', '2026-04-26 10:00:00+07', '2026-04-26 15:00:00+07',
'Taman Ismail Marzuki', 'Jl. Cikini Raya, Jakarta Pusat',
-6.190000, 106.841670, 20, 250000, false, 'upcoming', 'public'),

-- ============================================================================
-- MAY 2026 (6 events)
-- ============================================================================
('f0000036-0000-0000-0000-000000000036', '11111111-1111-1111-1111-111111111111',
'Cold Brew & Nitro Coffee Workshop',
'Master cold brewing methods! Learn extraction ratios, infusion times, and create silky nitro cold brew.',
'coffee', '2026-05-03 13:00:00+07', '2026-05-03 17:00:00+07',
'Kopi Kalyan', 'Jl. Cipete Raya, Jakarta Selatan',
-6.269720, 106.804170, 20, 300000, false, 'upcoming', 'public'),

('f0000037-0000-0000-0000-000000000037', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
'Kubernetes & DevOps Best Practices',
'Production-ready Kubernetes! CI/CD pipelines, monitoring, logging, and scaling strategies.',
'study', '2026-05-08 09:00:00+07', '2026-05-09 17:00:00+07',
'Traveloka Office', 'Jl. Saharjo, Jakarta Selatan',
-6.255000, 106.847780, 50, 1200000, false, 'upcoming', 'public'),

('f0000038-0000-0000-0000-000000000038', '22222222-2222-2222-2222-222222222222',
'Korean BBQ Night: All You Can Eat',
'Social gathering at premium Korean BBQ! Network, eat unlimited Korean BBQ, and make new friends.',
'food', '2026-05-10 18:00:00+07', '2026-05-10 21:00:00+07',
'Magal BBQ Senopati', 'Jl. Senopati, Jakarta Selatan',
-6.237020, 106.808810, 40, 350000, false, 'upcoming', 'public'),

('f0000039-0000-0000-0000-000000000039', '55555555-5555-5555-5555-555555555555',
'Trail Running Adventure: Sentul',
'Experience trail running! 10km route through Sentul forest. Beautiful nature and fresh air!',
'sports', '2026-05-17 06:00:00+07', '2026-05-17 11:00:00+07',
'Sentul Highlands', 'Sentul, Bogor',
-6.566670, 106.916670, 80, 200000, false, 'upcoming', 'public'),

('f0000040-0000-0000-0000-000000000040', '88888888-8888-8888-8888-888888888888',
'Street Photography Masterclass',
'Capture authentic moments! Learn composition, timing, and storytelling through street photography.',
'other', '2026-05-23 08:00:00+07', '2026-05-23 13:00:00+07',
'Kota Tua Jakarta', 'Jl. Taman Fatahillah, Jakarta Barat',
-6.134980, 106.813310, 25, 300000, false, 'upcoming', 'public'),

('f0000041-0000-0000-0000-000000000041', 'dddddddd-dddd-dddd-dddd-dddddddddddd',
'Pitch Perfect: Investor Presentation Skills',
'Master the art of pitching! Practice with real investors, get feedback, improve your deck and delivery.',
'other', '2026-05-28 14:00:00+07', '2026-05-28 18:00:00+07',
'Ideabox Coworking', 'Jl. Kemang Raya, Jakarta Selatan',
-6.267500, 106.815830, 30, 250000, false, 'upcoming', 'public'),

-- ============================================================================
-- JUNE 2026 (5 events)
-- ============================================================================
('f0000042-0000-0000-0000-000000000042', '11111111-1111-1111-1111-111111111111',
'Coffee & Dessert Pairing Experience',
'Perfect pairing workshop! Learn which desserts complement different coffee profiles. Delicious experience!',
'coffee', '2026-06-06 15:00:00+07', '2026-06-06 18:00:00+07',
'Union Brew Lab', 'Jl. Gunawarman, Jakarta Selatan',
-6.246110, 106.805560, 25, 350000, false, 'upcoming', 'public'),

('f0000043-0000-0000-0000-000000000043', '99999999-9999-9999-9999-999999999999',
'Next.js 15 App Router Deep Dive',
'Build blazing fast web apps with Next.js 15! Server components, streaming, and advanced optimization.',
'study', '2026-06-12 09:00:00+07', '2026-06-12 17:00:00+07',
'Bukalapak Office', 'Jl. Mega Kuningan Barat, Jakarta Selatan',
-6.228330, 106.827220, 60, 300000, false, 'upcoming', 'public'),

('f0000044-0000-0000-0000-000000000044', 'ffffffff-ffff-ffff-ffff-ffffffffffff',
'Authentic Mexican Cuisine Workshop',
'Viva Mexico! Make tacos al pastor, enchiladas, guacamole, and churros from scratch!',
'food', '2026-06-18 10:00:00+07', '2026-06-18 15:00:00+07',
'Amigos Kitchen', 'Jl. Kemang Raya, Jakarta Selatan',
-6.267500, 106.815830, 15, 450000, false, 'upcoming', 'public'),

('f0000045-0000-0000-0000-000000000045', '30303030-3030-3030-3030-303030303030',
'Contemporary Dance Workshop',
'Express yourself through movement! Learn contemporary dance techniques and choreography.',
'other', '2026-06-21 14:00:00+07', '2026-06-21 17:00:00+07',
'Namarina Dance Studio', 'Jl. Tebet Barat, Jakarta Selatan',
-6.237780, 106.852780, 20, 200000, false, 'upcoming', 'public'),

('f0000046-0000-0000-0000-000000000046', '60606060-6060-6060-6060-606060606060',
'Futsal League: Summer Tournament',
'Join the futsal league! 8 teams compete in round-robin format. Championship trophy and medals!',
'sports', '2026-06-27 16:00:00+07', '2026-06-27 22:00:00+07',
'Futsal Gembira Senayan', 'Jl. Gelora, Senayan, Jakarta',
-6.218890, 106.803330, 100, 500000, false, 'upcoming', 'public'),

-- ============================================================================
-- JULY 2026 (6 events)
-- ============================================================================
('f0000047-0000-0000-0000-000000000047', '11111111-1111-1111-1111-111111111111',
'Coffee Bean Processing Tour',
'Visit coffee farm near Jakarta! See the full process from cherry to cup. Includes transportation and lunch.',
'coffee', '2026-07-04 07:00:00+07', '2026-07-04 17:00:00+07',
'Coffee Plantation Bogor', 'Cisarua, Bogor',
-6.691670, 106.950000, 30, 400000, false, 'upcoming', 'public'),

('f0000048-0000-0000-0000-000000000048', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
'System Design for Senior Engineers',
'Advanced system design patterns! Distributed systems, event-driven architecture, and scaling to millions.',
'study', '2026-07-09 09:00:00+07', '2026-07-10 17:00:00+07',
'Shopee Office', 'Jl. Prof. DR. Satrio, Jakarta Selatan',
-6.221110, 106.821940, 40, 1500000, false, 'upcoming', 'public'),

('f0000049-0000-0000-0000-000000000049', '22222222-2222-2222-2222-222222222222',
'Ramen Making Masterclass',
'Craft authentic Japanese ramen! Make broth from scratch, prepare noodles, and perfect your toppings.',
'food', '2026-07-13 10:00:00+07', '2026-07-13 15:00:00+07',
'Ikkudo Ichi', 'Pacific Place Mall, Jakarta Selatan',
-6.225000, 106.809440, 12, 550000, false, 'upcoming', 'public'),

('f0000050-0000-0000-0000-000000000050', '55555555-5555-5555-5555-555555555555',
'Mountain Biking: Puncak Adventure',
'Thrilling downhill mountain biking! 15km route through Puncak highlands. Bike rental included.',
'sports', '2026-07-18 07:00:00+07', '2026-07-18 14:00:00+07',
'Puncak Pass', 'Puncak, Bogor',
-6.700000, 106.983330, 25, 450000, false, 'upcoming', 'public'),

('f0000051-0000-0000-0000-000000000051', '70707070-7070-7070-7070-707070707070',
'Vlogging Bootcamp: Day in Life Series',
'Create engaging vlogs! Camera techniques, editing workflows, and storytelling for daily vlog content.',
'other', '2026-07-22 10:00:00+07', '2026-07-22 17:00:00+07',
'Jakarta Content Hub', 'Jl. Kemang Utara, Jakarta Selatan',
-6.262500, 106.815280, 30, 350000, false, 'upcoming', 'public'),

('f0000052-0000-0000-0000-000000000052', '33333333-3333-3333-3333-333333333333',
'Valorant Community Cup',
'5v5 Valorant tournament! Bring your squad and compete. Prize pool: 30 million rupiah!',
'sports', '2026-07-26 11:00:00+07', '2026-07-26 20:00:00+07',
'Colosseum Gaming Lounge', 'Mal Taman Anggrek, Jakarta Barat',
-6.178330, 106.791110, 60, 500000, false, 'upcoming', 'public'),

-- ============================================================================
-- AUGUST 2026 (5 events - Independence Day theme)
-- ============================================================================
('f0000053-0000-0000-0000-000000000053', '11111111-1111-1111-1111-111111111111',
'Indonesian Coffee Heritage Tour',
'Celebrate Indonesian coffee! Taste from Aceh, Toraja, Java, Bali, and Papua. Learn our coffee history!',
'coffee', '2026-08-08 14:00:00+07', '2026-08-08 17:00:00+07',
'Indonesia Coffee Museum', 'Jl. Kemang Raya, Jakarta Selatan',
-6.267500, 106.815830, 40, 200000, false, 'upcoming', 'public'),

('f0000054-0000-0000-0000-000000000054', '99999999-9999-9999-9999-999999999999',
'Build Your SaaS from Scratch',
'Complete SaaS development! Authentication, payments, multi-tenancy, and deployment. 3-day bootcamp!',
'study', '2026-08-12 09:00:00+07', '2026-08-14 17:00:00+07',
'BuildSpace Jakarta', 'Jl. Gunawarman, Jakarta Selatan',
-6.246110, 106.805560, 30, 2500000, false, 'upcoming', 'public'),

('f0000055-0000-0000-0000-000000000055', 'ffffffff-ffff-ffff-ffff-ffffffffffff',
'Traditional Indonesian Cuisine Feast',
'Independence Day special! Cook rendang, gado-gado, soto, and more traditional dishes!',
'food', '2026-08-15 09:00:00+07', '2026-08-15 14:00:00+07',
'Dapoer Bistik', 'Jl. Cipete Raya, Jakarta Selatan',
-6.269720, 106.804170, 20, 300000, false, 'upcoming', 'public'),

('f0000056-0000-0000-0000-000000000056', '55555555-5555-5555-5555-555555555555',
'Independence Day 10K Run',
'Merdeka Run! 10K race to celebrate Indonesian independence. Red & white themed. Free jersey!',
'sports', '2026-08-17 06:00:00+07', '2026-08-17 09:00:00+07',
'Bundaran HI', 'Jl. M.H. Thamrin, Jakarta Pusat',
-6.195000, 106.823060, 1000, 120000, false, 'upcoming', 'public'),

('f0000057-0000-0000-0000-000000000057', '88888888-8888-8888-8888-888888888888',
'Documentary Photography Workshop',
'Tell stories through photos! Learn to capture meaningful moments and create photo essays.',
'other', '2026-08-23 09:00:00+07', '2026-08-23 16:00:00+07',
'Jakarta History Museum', 'Jl. Taman Fatahillah, Jakarta Barat',
-6.134980, 106.813310, 20, 350000, false, 'upcoming', 'public'),

-- ============================================================================
-- SEPTEMBER 2026 (5 events)
-- ============================================================================
('f0000058-0000-0000-0000-000000000058', '11111111-1111-1111-1111-111111111111',
'Advanced Brewing Methods Workshop',
'Master Chemex, V60, Aeropress, and Siphon! Perfect your pour-over technique.',
'coffee', '2026-09-05 10:00:00+07', '2026-09-05 14:00:00+07',
'Tanamera Coffee Roastery', 'Jl. Cipete Raya, Jakarta Selatan',
-6.269720, 106.804170, 18, 350000, false, 'upcoming', 'public'),

('f0000059-0000-0000-0000-000000000059', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
'AI & ChatGPT for Developers',
'Integrate AI into your apps! OpenAI API, prompt engineering, embeddings, and vector databases.',
'study', '2026-09-10 09:00:00+07', '2026-09-10 17:00:00+07',
'Kata.ai Office', 'Jl. Prof. DR. Satrio, Jakarta Selatan',
-6.221110, 106.821940, 70, 400000, false, 'upcoming', 'public'),

('f0000060-0000-0000-0000-000000000060', '22222222-2222-2222-2222-222222222222',
'Farm-to-Table Dining Experience',
'Exclusive farm-to-table dinner! Fresh organic ingredients, 7-course meal, meet the farmers!',
'food', '2026-09-14 18:00:00+07', '2026-09-14 21:00:00+07',
'Burgreens Menteng', 'Jl. Teuku Cik Ditiro, Jakarta Pusat',
-6.194170, 106.829170, 30, 650000, false, 'upcoming', 'public'),

('f0000061-0000-0000-0000-000000000061', '20202020-2020-2020-2020-202020202020',
'Jakarta Night Ride: 30KM',
'Beautiful night cycling through Jakarta! Safe route, sweep car, dinner included.',
'sports', '2026-09-19 18:00:00+07', '2026-09-19 22:00:00+07',
'Bundaran HI', 'Jl. M.H. Thamrin, Jakarta Pusat',
-6.195000, 106.823060, 150, 100000, false, 'upcoming', 'public'),

('f0000062-0000-0000-0000-000000000062', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0',
'Music Production Basics Workshop',
'Create your own beats! Learn Ableton Live, FL Studio, mixing, and mastering fundamentals.',
'other', '2026-09-26 13:00:00+07', '2026-09-26 18:00:00+07',
'Music Box Studio', 'Jl. Kemang Raya, Jakarta Selatan',
-6.267500, 106.815830, 15, 500000, false, 'upcoming', 'public'),

-- ============================================================================
-- OCTOBER 2026 (5 events)
-- ============================================================================
('f0000063-0000-0000-0000-000000000063', '11111111-1111-1111-1111-111111111111',
'Jakarta Coffee Festival 2026',
'Biggest coffee event of the year! 50+ specialty coffee vendors, latte art competition, and workshops!',
'coffee', '2026-10-10 10:00:00+07', '2026-10-11 20:00:00+07',
'JCC Senayan', 'Jl. Jenderal Gatot Subroto, Jakarta Pusat',
-6.225830, 106.802080, 5000, 50000, false, 'upcoming', 'public'),

('f0000064-0000-0000-0000-000000000064', '99999999-9999-9999-9999-999999999999',
'Hacktoberfest Jakarta 2026',
'Celebrate open source! Contribute to projects, win swag, and network with developers worldwide!',
'study', '2026-10-15 09:00:00+07', '2026-10-15 18:00:00+07',
'GitHub Office Jakarta', 'Equity Tower, SCBD, Jakarta Selatan',
-6.225830, 106.809170, 100, 0, true, 'upcoming', 'public'),

('f0000065-0000-0000-0000-000000000065', 'ffffffff-ffff-ffff-ffff-ffffffffffff',
'Molecular Gastronomy Experience',
'Science meets cooking! Learn spherification, foams, and modern plating techniques.',
'food', '2026-10-20 11:00:00+07', '2026-10-20 16:00:00+07',
'Namaaz Dining', 'Jl. Kemang Raya, Jakarta Selatan',
-6.267500, 106.815830, 12, 900000, false, 'upcoming', 'public')

ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- EVENT IMAGES (sample images for first 10 events)
-- ============================================================================

INSERT INTO event_images (event_id, image_url, order_index) VALUES
('f0000001-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd', 0),
('f0000002-0000-0000-0000-000000000002', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97', 0),
('f0000003-0000-0000-0000-000000000003', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1', 0),
('f0000004-0000-0000-0000-000000000004', 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8', 0),
('f0000005-0000-0000-0000-000000000005', 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e', 0),
('f0000006-0000-0000-0000-000000000006', 'https://images.unsplash.com/photo-1511920170033-f8396924c348', 0),
('f0000007-0000-0000-0000-000000000007', 'https://images.unsplash.com/photo-1540575467063-178a50c2df87', 0),
('f0000008-0000-0000-0000-000000000008', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 0),
('f0000009-0000-0000-0000-000000000009', 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea', 0),
('f0000010-0000-0000-0000-000000000010', 'https://images.unsplash.com/photo-1559136555-9303baea8ebd', 0)
ON CONFLICT DO NOTHING;


-- ============================================================================
-- FUTURE EVENTS SEED SUMMARY
-- ============================================================================
-- Total Events: 65 events
-- Timeframe: November 2025 - October 2026 (12 months)
--
-- Distribution by Category:
-- - Coffee: 12 events (latte art, cupping, roasting, brewing methods)
-- - Food: 11 events (various cuisines, cooking classes)
-- - Study: 12 events (tech workshops, bootcamps, seminars)
-- - Sports: 13 events (running, cycling, esports, traditional sports)
-- - Other: 17 events (photography, art, content creation, wellness)
--
-- Distribution by Month:
-- - Nov 2025: 5 events
-- - Dec 2025: 8 events
-- - Jan 2026: 6 events
-- - Feb 2026: 5 events
-- - Mar 2026: 6 events
-- - Apr 2026: 5 events
-- - May 2026: 6 events
-- - Jun 2026: 5 events
-- - Jul 2026: 6 events
-- - Aug 2026: 5 events
-- - Sep 2026: 5 events
-- - Oct 2026: 3 events
--
-- All events are set to 'upcoming' status
-- Events include diverse price points (free to 3.5M IDR)
-- Locations spread across Jakarta and surrounding areas
-- Perfect for debugging discovery, filtering, and recommendation features!
-- ============================================================================

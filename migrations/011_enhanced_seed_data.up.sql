-- Enhanced Seed Data for Indonesian Gen Z Users
-- This adds more realistic interactions: likes, comments, and event attendees

-- ============================================================================
-- ADD MORE LIKES (5-20 per post)
-- ============================================================================

-- Post 750e8400-e29b-41d4-a716-446655440020 (Coffee morning) - 12 likes
INSERT INTO likes (user_id, likeable_type, likeable_id, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'post', '750e8400-e29b-41d4-a716-446655440020', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440002', 'post', '750e8400-e29b-41d4-a716-446655440020', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440003', 'post', '750e8400-e29b-41d4-a716-446655440020', NOW() - INTERVAL '50 minutes'),
('550e8400-e29b-41d4-a716-446655440004', 'post', '750e8400-e29b-41d4-a716-446655440020', NOW() - INTERVAL '45 minutes'),
('550e8400-e29b-41d4-a716-446655440005', 'post', '750e8400-e29b-41d4-a716-446655440020', NOW() - INTERVAL '30 minutes')
ON CONFLICT DO NOTHING;

-- Post 750e8400-e29b-41d4-a716-446655440021 (Gaming night) - 15 likes
INSERT INTO likes (user_id, likeable_type, likeable_id, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'post', '750e8400-e29b-41d4-a716-446655440021', NOW() - INTERVAL '3 hours'),
('550e8400-e29b-41d4-a716-446655440002', 'post', '750e8400-e29b-41d4-a716-446655440021', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440003', 'post', '750e8400-e29b-41d4-a716-446655440021', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440004', 'post', '750e8400-e29b-41d4-a716-446655440021', NOW() - INTERVAL '50 minutes'),
('550e8400-e29b-41d4-a716-446655440005', 'post', '750e8400-e29b-41d4-a716-446655440021', NOW() - INTERVAL '40 minutes')
ON CONFLICT DO NOTHING;

-- Post 750e8400-e29b-41d4-a716-446655440022 (Brunch) - 10 likes
INSERT INTO likes (user_id, likeable_type, likeable_id, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'post', '750e8400-e29b-41d4-a716-446655440022', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440001', 'post', '750e8400-e29b-41d4-a716-446655440022', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440003', 'post', '750e8400-e29b-41d4-a716-446655440022', NOW() - INTERVAL '45 minutes'),
('550e8400-e29b-41d4-a716-446655440005', 'post', '750e8400-e29b-41d4-a716-446655440022', NOW() - INTERVAL '30 minutes')
ON CONFLICT DO NOTHING;

-- Post 750e8400-e29b-41d4-a716-446655440023 (Morning run) - 8 likes
INSERT INTO likes (user_id, likeable_type, likeable_id, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'post', '750e8400-e29b-41d4-a716-446655440023', NOW() - INTERVAL '3 hours'),
('550e8400-e29b-41d4-a716-446655440001', 'post', '750e8400-e29b-41d4-a716-446655440023', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440003', 'post', '750e8400-e29b-41d4-a716-446655440023', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440004', 'post', '750e8400-e29b-41d4-a716-446655440023', NOW() - INTERVAL '30 minutes')
ON CONFLICT DO NOTHING;

-- Post 750e8400-e29b-41d4-a716-446655440024 (Acoustic night) - 14 likes
INSERT INTO likes (user_id, likeable_type, likeable_id, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'post', '750e8400-e29b-41d4-a716-446655440024', NOW() - INTERVAL '4 hours'),
('550e8400-e29b-41d4-a716-446655440001', 'post', '750e8400-e29b-41d4-a716-446655440024', NOW() - INTERVAL '3 hours'),
('550e8400-e29b-41d4-a716-446655440002', 'post', '750e8400-e29b-41d4-a716-446655440024', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440004', 'post', '750e8400-e29b-41d4-a716-446655440024', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440005', 'post', '750e8400-e29b-41d4-a716-446655440024', NOW() - INTERVAL '30 minutes')
ON CONFLICT DO NOTHING;

-- Add likes for older posts too
INSERT INTO likes (user_id, likeable_type, likeable_id, created_at) VALUES
-- Post 750e8400-e29b-41d4-a716-446655440000 (coffee meetup)
('550e8400-e29b-41d4-a716-446655440002', 'post', '750e8400-e29b-41d4-a716-446655440000', NOW() - INTERVAL '1 day'),
('550e8400-e29b-41d4-a716-446655440004', 'post', '750e8400-e29b-41d4-a716-446655440000', NOW() - INTERVAL '1 day'),
('550e8400-e29b-41d4-a716-446655440005', 'post', '750e8400-e29b-41d4-a716-446655440000', NOW() - INTERVAL '1 day'),
-- Post 750e8400-e29b-41d4-a716-446655440001 (gaming epic)
('550e8400-e29b-41d4-a716-446655440002', 'post', '750e8400-e29b-41d4-a716-446655440001', NOW() - INTERVAL '2 days'),
('550e8400-e29b-41d4-a716-446655440003', 'post', '750e8400-e29b-41d4-a716-446655440001', NOW() - INTERVAL '2 days'),
('550e8400-e29b-41d4-a716-446655440005', 'post', '750e8400-e29b-41d4-a716-446655440001', NOW() - INTERVAL '2 days'),
-- Post 750e8400-e29b-41d4-a716-446655440002 (morning run GBK)
('550e8400-e29b-41d4-a716-446655440003', 'post', '750e8400-e29b-41d4-a716-446655440002', NOW() - INTERVAL '1 day'),
('550e8400-e29b-41d4-a716-446655440004', 'post', '750e8400-e29b-41d4-a716-446655440002', NOW() - INTERVAL '1 day')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- ADD COMMENTS WITH INDONESIAN GEN Z SLANG
-- ============================================================================

-- Comments for Post 750e8400-e29b-41d4-a716-446655440020 (Coffee morning)
INSERT INTO comments (id, post_id, author_id, content, created_at, updated_at) VALUES
('c50e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440001', 'Gass ikut dong! Tempatnya dimana nih?', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
('c50e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440002', 'Wah seru nih, boleh ajak temen ga?', NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour'),
('c50e8400-e29b-41d4-a716-446655440003', '750e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440000', 'Boleh banget! Makin rame makin asik ☕', NOW() - INTERVAL '50 minutes', NOW() - INTERVAL '50 minutes'),
('c50e8400-e29b-41d4-a716-446655440004', '750e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440003', 'Bener-bener butuh caffeine fix nih! Gw ikut ya 🙌', NOW() - INTERVAL '45 minutes', NOW() - INTERVAL '45 minutes');

-- Comments for Post 750e8400-e29b-41d4-a716-446655440021 (Gaming night)
INSERT INTO comments (id, post_id, author_id, content, created_at, updated_at) VALUES
('c50e8400-e29b-41d4-a716-446655440005', '750e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440000', 'Siapa aja yang ikut? Mau bikin team 5 man', NOW() - INTERVAL '3 hours', NOW() - INTERVAL '3 hours'),
('c50e8400-e29b-41d4-a716-446655440006', '750e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440002', 'Gw mythic glory bro, siap carry wkwk 🎮', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
('c50e8400-e29b-41d4-a716-446655440007', '750e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440003', 'Ada hadiah ga nih? Atau cuman for fun aja?', NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour'),
('c50e8400-e29b-41d4-a716-446655440008', '750e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440001', 'For fun tapi ada snack sama minuman gratis! 😎', NOW() - INTERVAL '50 minutes', NOW() - INTERVAL '50 minutes'),
('c50e8400-e29b-41d4-a716-446655440009', '750e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440004', 'Gaskeun lah, udah lama ga mabar', NOW() - INTERVAL '30 minutes', NOW() - INTERVAL '30 minutes');

-- Comments for Post 750e8400-e29b-41d4-a716-446655440022 (Brunch)
INSERT INTO comments (id, post_id, author_id, content, created_at, updated_at) VALUES
('c50e8400-e29b-41d4-a716-446655440010', '750e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440001', 'Budget berapa nih kira-kira?', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
('c50e8400-e29b-41d4-a716-446655440011', '750e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440002', 'Sekitar 100k-150k per orang, worth it banget!', NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour'),
('c50e8400-e29b-41d4-a716-446655440012', '750e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440003', 'Okeoke siap, butuh banget ini abis seminggu kerja 😭', NOW() - INTERVAL '45 minutes', NOW() - INTERVAL '45 minutes');

-- Comments for Post 750e8400-e29b-41d4-a716-446655440023 (Morning run)
INSERT INTO comments (id, post_id, author_id, content, created_at, updated_at) VALUES
('c50e8400-e29b-41d4-a716-446655440013', '750e8400-e29b-41d4-a716-446655440023', '550e8400-e29b-41d4-a716-446655440000', 'Jam berapa nih? Gw bangun pagi susah banget bro 😅', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
('c50e8400-e29b-41d4-a716-446655440014', '750e8400-e29b-41d4-a716-446655440023', '550e8400-e29b-41d4-a716-446655440002', 'Start jam 6 pagi! Bangun jam 5 masih sempet kok', NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour'),
('c50e8400-e29b-41d4-a716-446655440015', '750e8400-e29b-41d4-a716-446655440023', '550e8400-e29b-41d4-a716-446655440004', 'Yuk lah, habis lari bisa sarapan bareng juga', NOW() - INTERVAL '30 minutes', NOW() - INTERVAL '30 minutes');

-- Comments for Post 750e8400-e29b-41d4-a716-446655440024 (Acoustic night)
INSERT INTO comments (id, post_id, author_id, content, created_at, updated_at) VALUES
('c50e8400-e29b-41d4-a716-446655440016', '750e8400-e29b-41d4-a716-446655440024', '550e8400-e29b-41d4-a716-446655440000', 'Ada open mic ga? Pengen nyoba perform juga 🎵', NOW() - INTERVAL '3 hours', NOW() - INTERVAL '3 hours'),
('c50e8400-e29b-41d4-a716-446655440017', '750e8400-e29b-41d4-a716-446655440024', '550e8400-e29b-41d4-a716-446655440003', 'Ada dong! DM aja kalo mau daftar', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
('c50e8400-e29b-41d4-a716-446655440018', '750e8400-e29b-41d4-a716-446655440024', '550e8400-e29b-41d4-a716-446655440001', 'Wah seru banget! Bakal bawa temen2 band gw', NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour'),
('c50e8400-e29b-41d4-a716-446655440019', '750e8400-e29b-41d4-a716-446655440024', '550e8400-e29b-41d4-a716-446655440005', 'Mantap! Makin rame makin seru 🔥', NOW() - INTERVAL '30 minutes', NOW() - INTERVAL '30 minutes');

-- Comments for older posts
INSERT INTO comments (id, post_id, author_id, content, created_at, updated_at) VALUES
-- Post 750e8400-e29b-41d4-a716-446655440000 (coffee meetup old)
('c50e8400-e29b-41d4-a716-446655440020', '750e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', 'Asik banget acaranya! Kapan lagi nih?', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
('c50e8400-e29b-41d4-a716-446655440021', '750e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440003', 'Next time gw ikut ya! Ga bisa dateng soalnya lagi sakit kemaren 😢', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
-- Post 750e8400-e29b-41d4-a716-446655440001 (gaming epic)
('c50e8400-e29b-41d4-a716-446655440022', '750e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Tim gw menang savage wkwk, makasih udah ngadain!', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
('c50e8400-e29b-41d4-a716-446655440023', '750e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'GG banget kemaren! Rematch kapan nih?', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
('c50e8400-e29b-41d4-a716-446655440024', '750e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', 'Seru abis! Gw ikut lagi buat next tournament ya', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
-- Post 750e8400-e29b-41d4-a716-446655440006 (kemang coffee)
('c50e8400-e29b-41d4-a716-446655440025', '750e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440001', 'Nama kopinya apa? Penasaran mau nyoba!', NOW() - INTERVAL '3 hours', NOW() - INTERVAL '3 hours'),
('c50e8400-e29b-41d4-a716-446655440026', '750e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440000', 'Namanya "Kopi Kulo" deket Kemang Raya! Wajib coba sih ini ☕', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
-- Post 750e8400-e29b-41d4-a716-446655440008 (personal best run)
('c50e8400-e29b-41d4-a716-446655440027', '750e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440001', 'Gila bro konsisten banget! Spill tips-nya dong', NOW() - INTERVAL '4 hours', NOW() - INTERVAL '4 hours'),
('c50e8400-e29b-41d4-a716-446655440028', '750e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440002', 'Lari tiap hari aja bro, yang penting konsisten 💪', NOW() - INTERVAL '3 hours', NOW() - INTERVAL '3 hours');

-- ============================================================================
-- ADD MORE EVENT ATTENDEES (JOINED EVENTS)
-- ============================================================================

-- Event 650e8400-e29b-41d4-a716-446655440000 (Coffee Morning) - 5 attendees
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('650e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440002', 'confirmed', NOW() - INTERVAL '2 days'),
('650e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440004', 'confirmed', NOW() - INTERVAL '1 day')
ON CONFLICT DO NOTHING;

-- Event 650e8400-e29b-41d4-a716-446655440001 (Gaming Night) - 6 attendees
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'confirmed', NOW() - INTERVAL '3 days'),
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'confirmed', NOW() - INTERVAL '2 days'),
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', 'confirmed', NOW() - INTERVAL '1 day')
ON CONFLICT DO NOTHING;

-- Event 650e8400-e29b-41d4-a716-446655440003 (Morning Run GBK) - 5 attendees
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440000', 'confirmed', NOW() - INTERVAL '2 days'),
('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440004', 'confirmed', NOW() - INTERVAL '1 day'),
('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440005', 'confirmed', NOW() - INTERVAL '12 hours')
ON CONFLICT DO NOTHING;

-- Event 650e8400-e29b-41d4-a716-446655440004 (Acoustic Night) - 7 attendees
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440000', 'confirmed', NOW() - INTERVAL '3 days'),
('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', 'confirmed', NOW() - INTERVAL '2 days'),
('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'confirmed', NOW() - INTERVAL '1 day'),
('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', 'confirmed', NOW() - INTERVAL '12 hours'),
('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440005', 'confirmed', NOW() - INTERVAL '6 hours')
ON CONFLICT DO NOTHING;

-- Event 650e8400-e29b-41d4-a716-446655440005 (Movie Marathon) - 4 attendees
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440000', 'confirmed', NOW() - INTERVAL '2 days'),
('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', 'confirmed', NOW() - INTERVAL '1 day'),
('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 'confirmed', NOW() - INTERVAL '12 hours'),
('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440005', 'confirmed', NOW() - INTERVAL '6 hours')
ON CONFLICT DO NOTHING;

-- Event 650e8400-e29b-41d4-a716-446655440006 (Study Group React) - 6 attendees
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440000', 'confirmed', NOW() - INTERVAL '2 days'),
('650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440001', 'confirmed', NOW() - INTERVAL '1 day'),
('650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440002', 'confirmed', NOW() - INTERVAL '12 hours'),
('650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440004', 'confirmed', NOW() - INTERVAL '6 hours')
ON CONFLICT DO NOTHING;

-- Add attendees to new events created in migration 009
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
-- Event 850e8400-e29b-41d4-a716-446655440000 (Coffee Morning Meetup)
('850e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', 'confirmed', NOW() - INTERVAL '1 day'),
('850e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440002', 'confirmed', NOW() - INTERVAL '12 hours'),
('850e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440003', 'confirmed', NOW() - INTERVAL '6 hours'),
-- Event 850e8400-e29b-41d4-a716-446655440001 (Mobile Legends Tournament)
('850e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'confirmed', NOW() - INTERVAL '2 days'),
('850e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'confirmed', NOW() - INTERVAL '1 day'),
('850e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', 'confirmed', NOW() - INTERVAL '12 hours'),
('850e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', 'confirmed', NOW() - INTERVAL '6 hours'),
-- Event 850e8400-e29b-41d4-a716-446655440002 (Morning Run at GBK)
('850e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000', 'confirmed', NOW() - INTERVAL '1 day'),
('850e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'confirmed', NOW() - INTERVAL '12 hours'),
('850e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440005', 'confirmed', NOW() - INTERVAL '6 hours'),
-- Event 850e8400-e29b-41d4-a716-446655440003 (Acoustic Night Session)
('850e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440000', 'confirmed', NOW() - INTERVAL '2 days'),
('850e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', 'confirmed', NOW() - INTERVAL '1 day'),
('850e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440004', 'confirmed', NOW() - INTERVAL '12 hours'),
('850e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440005', 'confirmed', NOW() - INTERVAL '6 hours'),
-- Event 850e8400-e29b-41d4-a716-446655440007 (Gaming Community Meetup)
('850e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440000', 'confirmed', NOW() - INTERVAL '1 day'),
('850e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440002', 'confirmed', NOW() - INTERVAL '12 hours'),
('850e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440003', 'confirmed', NOW() - INTERVAL '6 hours')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- UPDATE COUNTS (will be updated by triggers, but setting initial values)
-- ============================================================================

-- Update likes count for posts
UPDATE posts SET likes_count = (
    SELECT COUNT(*) FROM likes
    WHERE likeable_type = 'post' AND likeable_id = posts.id
);

-- Update comments count for posts
UPDATE posts SET comments_count = (
    SELECT COUNT(*) FROM comments
    WHERE post_id = posts.id
);

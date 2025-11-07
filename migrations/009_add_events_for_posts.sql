-- Create events for posts that don't have attached events
-- This migration ensures all posts have an associated event

-- 1. Movie marathon event for post 750e8400-e29b-41d4-a716-446655440004
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440004',
    '550e8400-e29b-41d4-a716-446655440004',
    'Marathon Film Sci-Fi Klasik',
    'Marathon film akhir minggu ini! 🎬 Film-film sci-fi klasik nih. Popcorn udah siap cuy. Siapa yang mau ikutan?',
    'creative',
    '2025-10-27 14:00:00+00',
    '2025-10-27 22:00:00+00',
    'Home Cinema',
    'Jakarta',
    -6.2088,
    106.8456,
    15,
    true,
    'upcoming',
    'public',
    '2025-10-26 16:08:46.18918+00',
    '2025-10-26 16:08:46.18918+00'
);

-- 2. Acoustic night event for post 750e8400-e29b-41d4-a716-446655440003
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440003',
    '550e8400-e29b-41d4-a716-446655440003',
    'Sesi Akustik Malem',
    'Acara akustik minggu lalu magis banget cuy 🎵✨ Banyak bakat di komunitas kita! Gabisa nunggu yang next deh!',
    'creative',
    '2025-11-05 19:00:00+00',
    '2025-11-05 22:00:00+00',
    'Community Hall',
    'Jakarta',
    -6.2088,
    106.8456,
    50,
    true,
    'upcoming',
    'public',
    '2025-10-27 16:08:46.18918+00',
    '2025-10-27 16:08:46.18918+00'
);

-- 3. Coffee morning meetup for post 750e8400-e29b-41d4-a716-446655440000
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440000',
    '550e8400-e29b-41d4-a716-446655440000',
    'Ngopi Pagi Bareng',
    'Baru aja organize acara ngopi pagi yang asik banget! ☕ Excited banget ketemu sesama pecinta kopi akhir minggu ini.',
    'food',
    '2025-11-02 09:00:00+00',
    '2025-11-02 11:00:00+00',
    'Kopi Kenangan',
    'Jakarta Selatan',
    -6.2615,
    106.7810,
    20,
    true,
    'upcoming',
    'public',
    '2025-10-28 16:08:46.18918+00',
    '2025-10-28 16:08:46.18918+00'
);

-- 4. Gaming night event for post 750e8400-e29b-41d4-a716-446655440001
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440001',
    '550e8400-e29b-41d4-a716-446655440001',
    'Turnamen Mobile Legends Malem Ini',
    'Malem gaming kemaren epic abis! 🎮 Makasih semua yang dateng. Udah planning yang next nih. Ada yang mau turnamen Mobile Legends?',
    'creative',
    '2025-11-07 18:00:00+00',
    '2025-11-07 23:00:00+00',
    'Gaming Cafe',
    'Jakarta',
    -6.2088,
    106.8456,
    30,
    false,
    'upcoming',
    'public',
    '2025-10-29 16:08:46.18918+00',
    '2025-10-29 16:08:46.18918+00'
);

-- 5. Study group session for post 750e8400-e29b-41d4-a716-446655440005
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440005',
    '550e8400-e29b-41d4-a716-446655440005',
    'Study Group React Hooks',
    'Sesi study group hari ini produktif banget cuy! 📚 Belajar banyak tentang React hooks. Makasih semuanya!',
    'learning',
    '2025-11-08 14:00:00+00',
    '2025-11-08 17:00:00+00',
    'Library',
    'Jakarta',
    -6.2088,
    106.8456,
    15,
    true,
    'upcoming',
    'public',
    '2025-10-30 16:08:46.18918+00',
    '2025-10-30 16:08:46.18918+00'
);

-- 6. Morning run at GBK for post 750e8400-e29b-41d4-a716-446655440002
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440002',
    '550e8400-e29b-41d4-a716-446655440002',
    'Lari Pagi di GBK',
    'Lari pagi di GBK besok! 🏃‍♂️ Cuacanya perfect sih. Yuk gaskeun! Ketemu jam 6 pagi ya.',
    'fitness',
    '2025-10-31 23:00:00+00',
    '2025-11-01 00:30:00+00',
    'Gelora Bung Karno Stadium',
    'Jakarta Pusat',
    -6.2185,
    106.8018,
    25,
    true,
    'upcoming',
    'public',
    '2025-10-30 16:08:46.18918+00',
    '2025-10-30 16:08:46.18918+00'
);

-- 7. Gaming community for post 750e8400-e29b-41d4-a716-446655440007
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440007',
    '550e8400-e29b-41d4-a716-446655440001',
    'Kumpul Komunitas Gaming',
    'Cari orang lagi nih buat join komunitas gaming kita! Main macem-macem game, semua level skill welcome banget 🎮',
    'creative',
    '2025-11-10 16:00:00+00',
    '2025-11-10 20:00:00+00',
    'Gaming Hub',
    'Jakarta',
    -6.2088,
    106.8456,
    40,
    true,
    'upcoming',
    'public',
    '2025-10-31 04:08:46.18918+00',
    '2025-10-31 04:08:46.18918+00'
);

-- 8. Personal best 5km run for post 750e8400-e29b-41d4-a716-446655440008
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440008',
    '550e8400-e29b-41d4-a716-446655440002',
    'Challenge Lari Pagi 5K',
    'Personal best hari ini! 5km dalam 25 menit cuy 🏃‍♂️💨 Training gw worth it banget!',
    'fitness',
    '2025-11-15 22:00:00+00',
    '2025-11-15 23:00:00+00',
    'GBK Track',
    'Jakarta',
    -6.2185,
    106.8018,
    20,
    true,
    'upcoming',
    'public',
    '2025-10-31 08:08:46.18918+00',
    '2025-10-31 08:08:46.18918+00'
);

-- 9. Coffee shop discovery for post 750e8400-e29b-41d4-a716-446655440006
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440006',
    '550e8400-e29b-41d4-a716-446655440000',
    'Tour Kafe Kemang',
    'Nemu kafe baru di Kemang yang kece abis! Latte art-nya gila sih ☕🎨 Highly recommended cuy!',
    'food',
    '2025-11-12 10:00:00+00',
    '2025-11-12 12:00:00+00',
    'New Coffee Shop',
    'Kemang, Jakarta Selatan',
    -6.2615,
    106.8156,
    12,
    true,
    'upcoming',
    'public',
    '2025-10-31 10:08:46.18918+00',
    '2025-10-31 10:08:46.18918+00'
);

-- 10. Blade Runner movie for post 750e8400-e29b-41d4-a716-446655440010
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440010',
    '550e8400-e29b-41d4-a716-446655440004',
    'Nonton Blade Runner 2049',
    'Baru nonton Blade Runner 2049 lagi. Masih bikin merinding cuy. Masterpiece banget! 🎬',
    'creative',
    '2025-11-14 19:00:00+00',
    '2025-11-14 22:00:00+00',
    'Home Theater',
    'Jakarta',
    -6.2088,
    106.8456,
    10,
    true,
    'upcoming',
    'public',
    '2025-10-31 12:08:46.18918+00',
    '2025-10-31 12:08:46.18918+00'
);

-- 11. Study buddy for post 750e8400-e29b-41d4-a716-446655440011
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440011',
    '550e8400-e29b-41d4-a716-446655440005',
    'Sesi Belajar Bareng',
    'Ada yang lagi prokrastinasi juga ga? 😅 Butuh temen belajar buat besok nih!',
    'learning',
    '2025-11-01 13:00:00+00',
    '2025-11-01 16:00:00+00',
    'Library',
    'Jakarta',
    -6.2088,
    106.8456,
    4,
    true,
    'upcoming',
    'public',
    '2025-10-31 13:08:46.18918+00',
    '2025-10-31 13:08:46.18918+00'
);

-- 12. Watercolor painting for post 750e8400-e29b-41d4-a716-446655440009
INSERT INTO events (
    id, host_id, title, description, category, start_time, end_time,
    location_name, location_address, location_lat, location_lng,
    max_attendees, is_free, status, privacy, created_at, updated_at
) VALUES (
    '850e8400-e29b-41d4-a716-446655440009',
    '550e8400-e29b-41d4-a716-446655440003',
    'Workshop Lukis Cat Air',
    'Selesai lukisan cat air pertama gw! 🎨 Ga perfect sih tapi bangga banget. Art therapy itu real cuy!',
    'creative',
    '2025-11-09 14:00:00+00',
    '2025-11-09 17:00:00+00',
    'Art Studio',
    'Jakarta',
    -6.2088,
    106.8456,
    12,
    false,
    'upcoming',
    'public',
    '2025-10-31 14:08:46.18918+00',
    '2025-10-31 14:08:46.18918+00'
);

-- Now update all posts to link to their events
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440004' WHERE id = '750e8400-e29b-41d4-a716-446655440004';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440003' WHERE id = '750e8400-e29b-41d4-a716-446655440003';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440000' WHERE id = '750e8400-e29b-41d4-a716-446655440000';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440001' WHERE id = '750e8400-e29b-41d4-a716-446655440001';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440005' WHERE id = '750e8400-e29b-41d4-a716-446655440005';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440002' WHERE id = '750e8400-e29b-41d4-a716-446655440002';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440007' WHERE id = '750e8400-e29b-41d4-a716-446655440007';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440008' WHERE id = '750e8400-e29b-41d4-a716-446655440008';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440006' WHERE id = '750e8400-e29b-41d4-a716-446655440006';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440010' WHERE id = '750e8400-e29b-41d4-a716-446655440010';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440011' WHERE id = '750e8400-e29b-41d4-a716-446655440011';
UPDATE posts SET attached_event_id = '850e8400-e29b-41d4-a716-446655440009' WHERE id = '750e8400-e29b-41d4-a716-446655440009';

-- ============================================================================
-- SEED DATA: POST INTERACTIONS AND EVENT VARIATIONS
-- ============================================================================
-- This migration adds:
-- 1. Likes for posts and comments
-- 2. Shares for posts
-- 3. Varied event pricing (free and paid events)
-- 4. Event attendees with different capacity levels (full, almost full, available)
-- 5. Realistic interaction data for testing UI flows
-- ============================================================================

-- ============================================================================
-- SEED LIKES FOR POSTS
-- ============================================================================

DO $$
DECLARE
    post_record RECORD;
    user_record RECORD;
    like_count INT;
    user_ids UUID[];
BEGIN
    -- Get all user IDs
    SELECT ARRAY_AGG(id) INTO user_ids FROM users;

    -- Add likes to posts (random 5-100 likes per post)
    FOR post_record IN SELECT id, author_id, created_at FROM posts ORDER BY random()
    LOOP
        like_count := 5 + floor(random() * 96)::INT; -- 5 to 100 likes

        -- Add likes from random users
        FOR i IN 1..LEAST(like_count, array_length(user_ids, 1))
        LOOP
            -- Pick random user (not the author)
            BEGIN
                INSERT INTO likes (id, user_id, likeable_type, likeable_id, created_at)
                SELECT
                    uuid_generate_v4(),
                    user_ids[1 + floor(random() * array_length(user_ids, 1))::INT],
                    'post',
                    post_record.id,
                    post_record.created_at + (random() * INTERVAL '7 days')
                WHERE user_ids[1 + floor(random() * array_length(user_ids, 1))::INT] != post_record.author_id
                ON CONFLICT DO NOTHING;
            EXCEPTION WHEN OTHERS THEN
                -- Skip if duplicate
                CONTINUE;
            END;
        END LOOP;
    END LOOP;
END $$;

-- ============================================================================
-- SEED COMMENTS FOR POSTS
-- ============================================================================

DO $$
DECLARE
    post_record RECORD;
    user_ids UUID[];
    comment_count INT;
    comment_id UUID;
    comment_texts TEXT[] := ARRAY[
        'Wah seru banget ini! Aku ikut ya 🔥',
        'Keren! Kapan lagi nih ada acara kayak gini?',
        'Boleh ajak temen ga?',
        'Lokasi dimana ya? Aksesnya gampang ga?',
        'Budget total berapa kira-kira?',
        'Masih ada slot ga? Pengen ikut nih',
        'Kemarin ikut yang kayak gini asik banget!',
        'Ini cocok buat pemula ga ya?',
        'Ada dress code tertentu ga?',
        'Parkiran ada ga di lokasi?',
        'Wah pas banget nih sama jadwal gue!',
        'Boleh dateng sendiri kan? Atau harus grup?',
        'Ditunggu event selanjutnya ya!',
        'Mantap! See you there guys 🎉',
        'Akhirnya ada acara di daerah sini juga',
        'Bisa refund ga kalo ternyata ga bisa dateng?',
        'Min age berapa ya?',
        'Bakal ada makan/minum ga?',
        'Indoor atau outdoor nih?',
        'Recommended banget sih ini!',
        'Kemarin ikut dan ga nyesel!',
        'Gue booking buat 3 orang ya',
        'Masih newbie nih, boleh ikut kan?',
        'Event keren! Sukses ya 🚀',
        'Thanks for organizing!',
        'Cant wait! 🙌',
        'Udah register, excited banget!',
        'Pertama kali ikut event gini, wish me luck!',
        'Ajak temen-temen ah biar rame',
        'Location-nya strategis ga sih?'
    ];
    comment_text TEXT;
BEGIN
    -- Get all user IDs
    SELECT ARRAY_AGG(id) INTO user_ids FROM users;

    -- Add comments to posts (random 2-15 comments per post)
    FOR post_record IN SELECT id, author_id, created_at FROM posts ORDER BY random() LIMIT 100
    LOOP
        comment_count := 2 + floor(random() * 14)::INT; -- 2 to 15 comments

        FOR i IN 1..comment_count
        LOOP
            comment_id := uuid_generate_v4();
            comment_text := comment_texts[1 + floor(random() * array_length(comment_texts, 1))::INT];

            -- Insert comment
            INSERT INTO comments (id, post_id, user_id, content, created_at, updated_at, likes_count)
            SELECT
                comment_id,
                post_record.id,
                user_ids[1 + floor(random() * array_length(user_ids, 1))::INT],
                comment_text,
                post_record.created_at + (random() * INTERVAL '5 days'),
                post_record.created_at + (random() * INTERVAL '5 days'),
                floor(random() * 20)::INT -- 0-20 likes per comment
            WHERE user_ids[1 + floor(random() * array_length(user_ids, 1))::INT] != post_record.author_id;

            -- Add likes to some comments (30% chance)
            IF random() < 0.3 THEN
                INSERT INTO likes (id, user_id, likeable_type, likeable_id, created_at)
                SELECT
                    uuid_generate_v4(),
                    user_ids[1 + floor(random() * array_length(user_ids, 1))::INT],
                    'comment',
                    comment_id,
                    post_record.created_at + (random() * INTERVAL '6 days')
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END LOOP;
END $$;

-- ============================================================================
-- SEED SHARES FOR POSTS
-- ============================================================================

DO $$
DECLARE
    post_record RECORD;
    user_ids UUID[];
    share_count INT;
BEGIN
    -- Get all user IDs
    SELECT ARRAY_AGG(id) INTO user_ids FROM users;

    -- Add shares to posts (random 0-20 shares per post)
    FOR post_record IN SELECT id, author_id, created_at FROM posts ORDER BY random()
    LOOP
        share_count := floor(random() * 21)::INT; -- 0 to 20 shares

        FOR i IN 1..share_count
        LOOP
            BEGIN
                INSERT INTO shares (id, user_id, post_id, created_at)
                SELECT
                    uuid_generate_v4(),
                    user_ids[1 + floor(random() * array_length(user_ids, 1))::INT],
                    post_record.id,
                    post_record.created_at + (random() * INTERVAL '7 days')
                WHERE user_ids[1 + floor(random() * array_length(user_ids, 1))::INT] != post_record.author_id
                ON CONFLICT DO NOTHING;
            EXCEPTION WHEN OTHERS THEN
                CONTINUE;
            END;
        END LOOP;
    END LOOP;
END $$;

-- ============================================================================
-- UPDATE EVENT PRICING (Mix of Free and Paid Events)
-- ============================================================================

-- Make some events paid with varied pricing
UPDATE events
SET
    is_free = FALSE,
    price = CASE
        WHEN random() < 0.3 THEN 25000 + (floor(random() * 15) * 5000) -- 25k - 100k (coffee, food)
        WHEN random() < 0.6 THEN 50000 + (floor(random() * 20) * 10000) -- 50k - 250k (workshops, classes)
        ELSE 100000 + (floor(random() * 40) * 25000) -- 100k - 1M (sports, events)
    END,
    ticketing_enabled = TRUE
WHERE random() < 0.4; -- 40% of events are paid

-- Update tickets_sold will be set when we add attendees below

-- ============================================================================
-- SEED EVENT ATTENDEES WITH VARIED CAPACITY
-- ============================================================================

DO $$
DECLARE
    event_record RECORD;
    user_ids UUID[];
    target_attendees INT;
    capacity_pct FLOAT;
    attendee_user_id UUID;
BEGIN
    -- Get all user IDs
    SELECT ARRAY_AGG(id) INTO user_ids FROM users;

    -- Add attendees to events with different capacity levels
    FOR event_record IN
        SELECT id, host_id, max_attendees, created_at, start_time, price, is_free
        FROM events
        WHERE status = 'upcoming'
        ORDER BY start_time ASC
    LOOP
        -- Determine capacity percentage for this event
        -- 20% events = FULL (100% capacity)
        -- 30% events = ALMOST FULL (80-95% capacity)
        -- 50% events = AVAILABLE (10-70% capacity)

        IF random() < 0.2 THEN
            -- FULL: 100% capacity
            capacity_pct := 1.0;
        ELSIF random() < 0.5 THEN
            -- ALMOST FULL: 80-95% capacity
            capacity_pct := 0.8 + (random() * 0.15);
        ELSE
            -- AVAILABLE: 10-70% capacity
            capacity_pct := 0.1 + (random() * 0.6);
        END IF;

        target_attendees := GREATEST(1, floor(event_record.max_attendees * capacity_pct)::INT);

        -- Add attendees (random users, not including host)
        FOR i IN 1..target_attendees
        LOOP
            attendee_user_id := user_ids[1 + floor(random() * array_length(user_ids, 1))::INT];

            -- Skip if it's the host
            IF attendee_user_id = event_record.host_id THEN
                CONTINUE;
            END IF;

            BEGIN
                INSERT INTO event_attendees (id, event_id, user_id, joined_at, status)
                VALUES (
                    uuid_generate_v4(),
                    event_record.id,
                    attendee_user_id,
                    event_record.created_at + (random() * (event_record.start_time - event_record.created_at)),
                    'confirmed'
                )
                ON CONFLICT (event_id, user_id) DO NOTHING;
            EXCEPTION WHEN OTHERS THEN
                CONTINUE;
            END;
        END LOOP;

        -- Update tickets_sold for paid events
        IF NOT event_record.is_free THEN
            UPDATE events
            SET tickets_sold = (
                SELECT COUNT(*)
                FROM event_attendees
                WHERE event_id = event_record.id AND status = 'confirmed'
            )
            WHERE id = event_record.id;
        END IF;
    END LOOP;
END $$;

-- ============================================================================
-- UPDATE ALL COUNTERS TO REFLECT NEW DATA
-- ============================================================================

-- Update likes count for all posts
UPDATE posts SET likes_count = (
    SELECT COUNT(*) FROM likes
    WHERE likeable_type = 'post' AND likeable_id = posts.id
);

-- Update comments count for all posts
UPDATE posts SET comments_count = (
    SELECT COUNT(*) FROM comments
    WHERE post_id = posts.id
);

-- Update shares count for all posts
UPDATE posts SET shares_count = (
    SELECT COUNT(*) FROM shares
    WHERE post_id = posts.id
);

-- Update reposts count for all posts (if any)
UPDATE posts SET reposts_count = (
    SELECT COUNT(*) FROM reposts
    WHERE post_id = posts.id
);

-- Update likes count for all comments
UPDATE comments SET likes_count = (
    SELECT COUNT(*) FROM likes
    WHERE likeable_type = 'comment' AND likeable_id = comments.id
);

-- Update attendees count for all events
UPDATE events SET attendees_count = (
    SELECT COUNT(*) FROM event_attendees
    WHERE event_id = events.id AND status = 'confirmed'
);

-- Update events_attended in user_stats
UPDATE user_stats SET events_attended = (
    SELECT COUNT(*) FROM event_attendees
    WHERE user_id = user_stats.user_id AND status = 'confirmed'
);

-- ============================================================================
-- ADD SOME SAMPLE EVENT VARIATIONS FOR TESTING
-- ============================================================================

-- Ensure we have at least one of each type for testing:

-- 1. FULL PAID EVENT (for testing "Event Penuh" flow)
DO $$
DECLARE
    full_event_id UUID;
    host_id UUID;
    user_ids UUID[];
BEGIN
    SELECT id INTO host_id FROM users ORDER BY random() LIMIT 1;
    SELECT ARRAY_AGG(id) INTO user_ids FROM users WHERE id != host_id LIMIT 30;

    -- Create a full paid event
    INSERT INTO events (
        id, host_id, title, description, category, start_time, end_time,
        location_name, location_address, location_lat, location_lng,
        max_attendees, price, is_free, status, privacy, ticketing_enabled, tickets_sold
    ) VALUES (
        uuid_generate_v4(), host_id,
        'Workshop Premium: Advanced Web Development - SOLD OUT! 🔥',
        'Workshop eksklusif untuk advanced web development. Materi lengkap, hands-on project, sertifikat, dan coffee break. Limited seats!',
        'workshop',
        NOW() + INTERVAL '7 days',
        NOW() + INTERVAL '7 days 4 hours',
        'CoWork Space Central',
        'Jl. Gatot Subroto No. 123, Jakarta Selatan',
        -6.2297, 106.8456,
        30, 350000, FALSE, 'upcoming', 'public', TRUE, 30
    ) RETURNING id INTO full_event_id;

    -- Fill it up completely
    FOR i IN 1..30 LOOP
        INSERT INTO event_attendees (id, event_id, user_id, joined_at, status)
        VALUES (
            uuid_generate_v4(), full_event_id, user_ids[i],
            NOW() - (random() * INTERVAL '5 days'), 'confirmed'
        ) ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- 2. ALMOST FULL FREE EVENT (for testing "Hampir Penuh" flow)
DO $$
DECLARE
    almost_full_event_id UUID;
    host_id UUID;
    user_ids UUID[];
BEGIN
    SELECT id INTO host_id FROM users ORDER BY random() LIMIT 1;
    SELECT ARRAY_AGG(id) INTO user_ids FROM users WHERE id != host_id LIMIT 48;

    INSERT INTO events (
        id, host_id, title, description, category, start_time, end_time,
        location_name, location_address, location_lat, location_lng,
        max_attendees, price, is_free, status, privacy, ticketing_enabled, tickets_sold
    ) VALUES (
        uuid_generate_v4(), host_id,
        'Sunday Football Match - Tinggal 2 Slot! ⚽',
        'Main futsal bareng di lapangan indoor. Gratis! Tinggal 2 slot lagi nih guys, buruan daftar!',
        'sports',
        NOW() + INTERVAL '3 days',
        NOW() + INTERVAL '3 days 2 hours',
        'Arena Futsal Indoor',
        'Jl. Sport Center No. 45, Jakarta Barat',
        -6.1751, 106.8272,
        50, NULL, TRUE, 'upcoming', 'public', FALSE, 0
    ) RETURNING id INTO almost_full_event_id;

    -- Fill to 96% (48 out of 50)
    FOR i IN 1..48 LOOP
        INSERT INTO event_attendees (id, event_id, user_id, joined_at, status)
        VALUES (
            uuid_generate_v4(), almost_full_event_id, user_ids[i],
            NOW() - (random() * INTERVAL '2 days'), 'confirmed'
        ) ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- 3. AVAILABLE PAID EVENT (for testing "Masih Longgar" flow)
DO $$
DECLARE
    available_event_id UUID;
    host_id UUID;
    user_ids UUID[];
BEGIN
    SELECT id INTO host_id FROM users ORDER BY random() LIMIT 1;
    SELECT ARRAY_AGG(id) INTO user_ids FROM users WHERE id != host_id LIMIT 12;

    INSERT INTO events (
        id, host_id, title, description, category, start_time, end_time,
        location_name, location_address, location_lat, location_lng,
        max_attendees, price, is_free, status, privacy, ticketing_enabled, tickets_sold
    ) VALUES (
        uuid_generate_v4(), host_id,
        'Coffee & Networking - Masih Banyak Slot! ☕',
        'Ngopi santai sambil networking. Meet new people, share stories, have fun! Early bird price hanya 25k.',
        'networking',
        NOW() + INTERVAL '5 days',
        NOW() + INTERVAL '5 days 3 hours',
        'Kopi Kenangan Premium',
        'Jl. Sudirman No. 789, Jakarta Pusat',
        -6.2088, 106.8456,
        100, 25000, FALSE, 'upcoming', 'public', TRUE, 12
    ) RETURNING id INTO available_event_id;

    -- Fill to 12% (12 out of 100)
    FOR i IN 1..12 LOOP
        INSERT INTO event_attendees (id, event_id, user_id, joined_at, status)
        VALUES (
            uuid_generate_v4(), available_event_id, user_ids[i],
            NOW() - (random() * INTERVAL '1 day'), 'confirmed'
        ) ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ============================================================================
-- FINAL UPDATE: Ensure all counters are accurate
-- ============================================================================

UPDATE events SET attendees_count = (
    SELECT COUNT(*) FROM event_attendees
    WHERE event_id = events.id AND status = 'confirmed'
);

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Seeded:
-- - Likes for posts (5-100 likes per post)
-- - Comments for posts (2-15 comments per post, some with likes)
-- - Shares for posts (0-20 shares per post)
-- - Event pricing variations (40% paid events with prices 25k-1M)
-- - Event attendees with varied capacity:
--   * 20% FULL events (100% capacity)
--   * 30% ALMOST FULL events (80-95% capacity)
--   * 50% AVAILABLE events (10-70% capacity)
-- - 3 specific test events:
--   * 1 FULL paid event (350k, 30/30 attendees)
--   * 1 ALMOST FULL free event (48/50 attendees)
--   * 1 AVAILABLE paid event (25k, 12/100 attendees)
-- - Updated all counters (likes, comments, shares, attendees)
--
-- Ready for UI testing! 🎉
-- ============================================================================

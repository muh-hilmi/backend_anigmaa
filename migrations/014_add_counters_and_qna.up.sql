-- ============================================================================
-- ADD MISSING COUNTER FIELDS AND EVENT Q&A TABLE
-- ============================================================================
-- This migration adds:
-- 1. attendees_count field to events table (missing but referenced in code)
-- 2. event_qna table for Q&A functionality
-- 3. Seed data for Q&A
-- 4. Updates all counters to reflect existing data
-- ============================================================================

-- ============================================================================
-- ADD ATTENDEES COUNT TO EVENTS TABLE
-- ============================================================================

-- Add attendees_count column to events table
ALTER TABLE events ADD COLUMN IF NOT EXISTS attendees_count INTEGER DEFAULT 0;

-- Update attendees count for all existing events
UPDATE events SET attendees_count = (
    SELECT COUNT(*) FROM event_attendees
    WHERE event_id = events.id AND status = 'confirmed'
);

-- ============================================================================
-- CREATE EVENT Q&A TABLE
-- ============================================================================

-- Create event_qna table for Q&A functionality
CREATE TABLE IF NOT EXISTS event_qna (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT,
    answered_by UUID REFERENCES users(id) ON DELETE SET NULL,
    answered_at TIMESTAMP WITH TIME ZONE,
    is_answered BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for event_qna
CREATE INDEX IF NOT EXISTS idx_event_qna_event ON event_qna(event_id);
CREATE INDEX IF NOT EXISTS idx_event_qna_user ON event_qna(user_id);
CREATE INDEX IF NOT EXISTS idx_event_qna_is_answered ON event_qna(is_answered);

-- Create trigger to update updated_at for event_qna
DROP TRIGGER IF EXISTS update_event_qna_updated_at ON event_qna;
CREATE TRIGGER update_event_qna_updated_at BEFORE UPDATE ON event_qna
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- SEED DATA: Q&A FOR EVENTS (BAHASA GEN Z INDO)
-- ============================================================================

-- Q&A for popular events
DO $$
DECLARE
    event_record RECORD;
    question_texts TEXT[] := ARRAY[
        'Boleh bawa temen ga nih? Atau harus daftar sendiri-sendiri?',
        'Budget total kira-kira abis berapa ya kalo ikut?',
        'Dress code ada ga? Casual aja boleh?',
        'Newbie friendly ga sih? Gw baru pertama kali nih',
        'Parkiran ada ga ya di lokasi? Atau mending naik transportasi umum?',
        'Bisa refund ga kalo ternyata ga bisa dateng?',
        'Ada minimum age requirement ga?',
        'Bakal ada makan/minum atau bawa sendiri?',
        'Lokasi indoor atau outdoor? Takut hujan soalnya',
        'Kalo telat dateng masih bisa join ga?',
        'Ada grup WA atau Discord buat koordinasi?',
        'Perlu bawa apa aja nih? Ada list requirements?',
        'Acara mulai jam berapa dan selesai jam berapa?',
        'Bisa dateng sendirian atau harus grup?',
        'Ada fasilitas wifi ga di lokasi?'
    ];
    answer_texts TEXT[] := ARRAY[
        'Boleh banget! Makin rame makin seru cuy 🎉',
        'Total sekitar 50-100rb aja, tergantung pilihan kamu',
        'Santai aja, casual totally fine! Yang penting nyaman',
        'Super newbie friendly! Kita welcome semua level kok',
        'Ada parkir, tapi limited. Mending transportasi umum',
        'Bisa refund sampe H-3 sebelum event ya',
        'Min 17 tahun, tapi yang penting mature aja vibes-nya',
        'Udah termasuk snacks! Tapi boleh bawa sendiri juga',
        'Indoor semua, ga perlu khawatir cuaca!',
        'Masih bisa, tapi sayang nanti ketinggalan opening',
        'Ada! Link-nya bakal dikirim setelah daftar',
        'Cuma bawa diri sendiri + semangat! Kita udah sediain sisanya',
        'Mulai jam 2 siang, selesai sekitar jam 6 sore',
        'Sendirian welcome! Banyak yang dateng solo kok',
        'Ada wifi kenceng, jangan khawatir!'
    ];
    question_user_id UUID;
    answer_by_id UUID;
    q_index INT;
    a_index INT;
BEGIN
    -- Add Q&A to random events (about 50% of events get Q&A)
    FOR event_record IN
        SELECT id, host_id, created_at
        FROM events
        WHERE status = 'upcoming'
        ORDER BY random()
        LIMIT 50
    LOOP
        -- Add 2-5 Q&A per event
        FOR i IN 1..(2 + floor(random() * 4)) LOOP
            -- Pick random user for question (not host)
            SELECT id INTO question_user_id
            FROM users
            WHERE id != event_record.host_id
            ORDER BY random()
            LIMIT 1;

            -- Pick random question text
            q_index := 1 + floor(random() * array_length(question_texts, 1));

            -- 80% chance the question is answered
            IF random() < 0.8 THEN
                -- Host answers (or random user for variety)
                IF random() < 0.7 THEN
                    answer_by_id := event_record.host_id;
                ELSE
                    SELECT id INTO answer_by_id FROM users ORDER BY random() LIMIT 1;
                END IF;

                -- Pick random answer text
                a_index := 1 + floor(random() * array_length(answer_texts, 1));

                INSERT INTO event_qna (
                    event_id, user_id, question, answer, answered_by, answered_at, is_answered,
                    created_at, updated_at
                )
                VALUES (
                    event_record.id,
                    question_user_id,
                    question_texts[q_index],
                    answer_texts[a_index],
                    answer_by_id,
                    event_record.created_at + ((random() * INTERVAL '3 days')),
                    TRUE,
                    event_record.created_at + ((random() * INTERVAL '1 day')),
                    event_record.created_at + ((random() * INTERVAL '3 days'))
                );
            ELSE
                -- Unanswered question
                INSERT INTO event_qna (
                    event_id, user_id, question, is_answered,
                    created_at, updated_at
                )
                VALUES (
                    event_record.id,
                    question_user_id,
                    question_texts[q_index],
                    FALSE,
                    event_record.created_at + ((random() * INTERVAL '1 day')),
                    event_record.created_at + ((random() * INTERVAL '1 day'))
                );
            END IF;
        END LOOP;
    END LOOP;
END $$;

-- ============================================================================
-- UPDATE ALL COUNTERS (to ensure existing data is reflected)
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

-- Update likes count for all comments
UPDATE comments SET likes_count = (
    SELECT COUNT(*) FROM likes
    WHERE likeable_type = 'comment' AND likeable_id = comments.id
);

-- Update reposts count for all posts
UPDATE posts SET reposts_count = (
    SELECT COUNT(*) FROM reposts
    WHERE post_id = posts.id
);

-- Update shares count for all posts
UPDATE posts SET shares_count = (
    SELECT COUNT(*) FROM shares
    WHERE post_id = posts.id
);

-- Update attendees count for all events (re-run to ensure it's correct)
UPDATE events SET attendees_count = (
    SELECT COUNT(*) FROM event_attendees
    WHERE event_id = events.id AND status = 'confirmed'
);

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Added:
-- - attendees_count column to events table
-- - event_qna table with indexes and triggers
-- - ~150-250 Q&A entries across ~50 events
-- - Updated all counters to reflect existing interaction data
--
-- Q&A Distribution:
-- - 50 events with Q&A
-- - 2-5 Q&A per event
-- - 80% answered, 20% unanswered
-- - Mix of host and community answers
-- ============================================================================

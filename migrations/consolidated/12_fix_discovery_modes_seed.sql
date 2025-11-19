-- ============================================================================
-- FIX DISCOVERY MODES: ADD ATTENDEES & VARIED CREATED_AT
-- ============================================================================
-- This migration fixes the discover tab by:
-- 1. Adding attendees to existing e0000... events (varying popularity)
-- 2. Updating created_at timestamps to be varied (1-30 days ago)
-- 3. This enables trending/for_you/chill modes to show different results
-- ============================================================================


-- ============================================================================
-- STEP 1: UPDATE CREATED_AT TO VARY (1-30 days ago)
-- ============================================================================

-- Very recent events (1-3 days ago) - should rank high in for_you
UPDATE events SET created_at = NOW() - INTERVAL '1 day' WHERE id = 'e0000001-0000-0000-0000-000000000001';
UPDATE events SET created_at = NOW() - INTERVAL '2 days' WHERE id = 'e0000002-0000-0000-0000-000000000002';
UPDATE events SET created_at = NOW() - INTERVAL '1 day' WHERE id = 'e0000028-0000-0000-0000-000000000028';
UPDATE events SET created_at = NOW() - INTERVAL '3 days' WHERE id = 'e0000011-0000-0000-0000-000000000011';

-- Recent events (4-10 days ago)
UPDATE events SET created_at = NOW() - INTERVAL '5 days' WHERE id = 'e0000003-0000-0000-0000-000000000003';
UPDATE events SET created_at = NOW() - INTERVAL '6 days' WHERE id = 'e0000008-0000-0000-0000-000000000008';
UPDATE events SET created_at = NOW() - INTERVAL '7 days' WHERE id = 'e0000010-0000-0000-0000-000000000010';
UPDATE events SET created_at = NOW() - INTERVAL '8 days' WHERE id = 'e0000014-0000-0000-0000-000000000014';
UPDATE events SET created_at = NOW() - INTERVAL '9 days' WHERE id = 'e0000020-0000-0000-0000-000000000020';
UPDATE events SET created_at = NOW() - INTERVAL '10 days' WHERE id = 'e0000022-0000-0000-0000-000000000022';

-- Medium age events (11-20 days ago)
UPDATE events SET created_at = NOW() - INTERVAL '12 days' WHERE id = 'e0000004-0000-0000-0000-000000000004';
UPDATE events SET created_at = NOW() - INTERVAL '13 days' WHERE id = 'e0000005-0000-0000-0000-000000000005';
UPDATE events SET created_at = NOW() - INTERVAL '14 days' WHERE id = 'e0000007-0000-0000-0000-000000000007';
UPDATE events SET created_at = NOW() - INTERVAL '15 days' WHERE id = 'e0000009-0000-0000-0000-000000000009';
UPDATE events SET created_at = NOW() - INTERVAL '16 days' WHERE id = 'e0000012-0000-0000-0000-000000000012';
UPDATE events SET created_at = NOW() - INTERVAL '17 days' WHERE id = 'e0000015-0000-0000-0000-000000000015';
UPDATE events SET created_at = NOW() - INTERVAL '18 days' WHERE id = 'e0000018-0000-0000-0000-000000000018';
UPDATE events SET created_at = NOW() - INTERVAL '19 days' WHERE id = 'e0000021-0000-0000-0000-000000000021';

-- Older events (21-30 days ago) - should rank lower
UPDATE events SET created_at = NOW() - INTERVAL '22 days' WHERE id = 'e0000006-0000-0000-0000-000000000006';
UPDATE events SET created_at = NOW() - INTERVAL '23 days' WHERE id = 'e0000013-0000-0000-0000-000000000013';
UPDATE events SET created_at = NOW() - INTERVAL '24 days' WHERE id = 'e0000016-0000-0000-0000-000000000016';
UPDATE events SET created_at = NOW() - INTERVAL '25 days' WHERE id = 'e0000017-0000-0000-0000-000000000017';
UPDATE events SET created_at = NOW() - INTERVAL '26 days' WHERE id = 'e0000019-0000-0000-0000-000000000019';
UPDATE events SET created_at = NOW() - INTERVAL '27 days' WHERE id = 'e0000023-0000-0000-0000-000000000023';
UPDATE events SET created_at = NOW() - INTERVAL '28 days' WHERE id = 'e0000024-0000-0000-0000-000000000024';
UPDATE events SET created_at = NOW() - INTERVAL '29 days' WHERE id = 'e0000025-0000-0000-0000-000000000025';
UPDATE events SET created_at = NOW() - INTERVAL '30 days' WHERE id = 'e0000026-0000-0000-0000-000000000026';
UPDATE events SET created_at = NOW() - INTERVAL '30 days' WHERE id = 'e0000027-0000-0000-0000-000000000027';
UPDATE events SET created_at = NOW() - INTERVAL '29 days' WHERE id = 'e0000029-0000-0000-0000-000000000029';
UPDATE events SET created_at = NOW() - INTERVAL '28 days' WHERE id = 'e0000030-0000-0000-0000-000000000030';


-- ============================================================================
-- STEP 2: ADD ATTENDEES TO EVENTS (Varying popularity levels)
-- ============================================================================

-- VERY POPULAR EVENTS (40-50 attendees) - Should appear in TRENDING
-- e0000008: Mobile Legends Tournament (45 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000008-0000-0000-0000-000000000008', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '6 days'),
('e0000008-0000-0000-0000-000000000008', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '5 days'),
('e0000008-0000-0000-0000-000000000008', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '5 days'),
('e0000008-0000-0000-0000-000000000008', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '4 days'),
('e0000008-0000-0000-0000-000000000008', '55555555-5555-5555-5555-555555555555', 'confirmed', NOW() - INTERVAL '4 days'),
('e0000008-0000-0000-0000-000000000008', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '3 days'),
('e0000008-0000-0000-0000-000000000008', '77777777-7777-7777-7777-777777777777', 'confirmed', NOW() - INTERVAL '3 days'),
('e0000008-0000-0000-0000-000000000008', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000008-0000-0000-0000-000000000008', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000008-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000008-0000-0000-0000-000000000008', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000008-0000-0000-0000-000000000008', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '12 hours'),
('e0000008-0000-0000-0000-000000000008', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed', NOW() - INTERVAL '12 hours'),
('e0000008-0000-0000-0000-000000000008', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed', NOW() - INTERVAL '10 hours'),
('e0000008-0000-0000-0000-000000000008', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '8 hours'),
('e0000008-0000-0000-0000-000000000008', '10101010-1010-1010-1010-101010101010', 'confirmed', NOW() - INTERVAL '6 hours'),
('e0000008-0000-0000-0000-000000000008', '20202020-2020-2020-2020-202020202020', 'confirmed', NOW() - INTERVAL '4 hours'),
('e0000008-0000-0000-0000-000000000008', '30303030-3030-3030-3030-303030303030', 'confirmed', NOW() - INTERVAL '2 hours'),
('e0000008-0000-0000-0000-000000000008', '40404040-4040-4040-4040-404040404040', 'confirmed', NOW() - INTERVAL '1 hour'),
('e0000008-0000-0000-0000-000000000008', '50505050-5050-5050-5050-505050505050', 'pending', NOW() - INTERVAL '30 minutes'),
('e0000008-0000-0000-0000-000000000008', '60606060-6060-6060-6060-606060606060', 'pending', NOW() - INTERVAL '20 minutes'),
('e0000008-0000-0000-0000-000000000008', '70707070-7070-7070-7070-707070707070', 'pending', NOW() - INTERVAL '10 minutes'),
('e0000008-0000-0000-0000-000000000008', '80808080-8080-8080-8080-808080808080', 'pending', NOW() - INTERVAL '5 minutes')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000011: Sunday Morning Run Club (42 attendees, FREE)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000011-0000-0000-0000-000000000011', '55555555-5555-5555-5555-555555555555', 'confirmed', NOW() - INTERVAL '3 days'),
('e0000011-0000-0000-0000-000000000011', '20202020-2020-2020-2020-202020202020', 'confirmed', NOW() - INTERVAL '3 days'),
('e0000011-0000-0000-0000-000000000011', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000011-0000-0000-0000-000000000011', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000011-0000-0000-0000-000000000011', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000011-0000-0000-0000-000000000011', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000011-0000-0000-0000-000000000011', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000011-0000-0000-0000-000000000011', '77777777-7777-7777-7777-777777777777', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000011-0000-0000-0000-000000000011', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000011-0000-0000-0000-000000000011', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '12 hours'),
('e0000011-0000-0000-0000-000000000011', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '12 hours'),
('e0000011-0000-0000-0000-000000000011', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '10 hours'),
('e0000011-0000-0000-0000-000000000011', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '8 hours'),
('e0000011-0000-0000-0000-000000000011', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed', NOW() - INTERVAL '6 hours'),
('e0000011-0000-0000-0000-000000000011', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed', NOW() - INTERVAL '4 hours'),
('e0000011-0000-0000-0000-000000000011', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '2 hours'),
('e0000011-0000-0000-0000-000000000011', '10101010-1010-1010-1010-101010101010', 'confirmed', NOW() - INTERVAL '1 hour'),
('e0000011-0000-0000-0000-000000000011', '30303030-3030-3030-3030-303030303030', 'pending', NOW() - INTERVAL '30 minutes'),
('e0000011-0000-0000-0000-000000000011', '40404040-4040-4040-4040-404040404040', 'pending', NOW() - INTERVAL '15 minutes'),
('e0000011-0000-0000-0000-000000000011', '50505050-5050-5050-5050-505050505050', 'pending', NOW() - INTERVAL '5 minutes')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000015: Indie Music Night (38 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000015-0000-0000-0000-000000000015', '77777777-7777-7777-7777-777777777777', 'confirmed', NOW() - INTERVAL '17 days'),
('e0000015-0000-0000-0000-000000000015', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'confirmed', NOW() - INTERVAL '16 days'),
('e0000015-0000-0000-0000-000000000015', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '15 days'),
('e0000015-0000-0000-0000-000000000015', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '14 days'),
('e0000015-0000-0000-0000-000000000015', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '13 days'),
('e0000015-0000-0000-0000-000000000015', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '12 days'),
('e0000015-0000-0000-0000-000000000015', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '11 days'),
('e0000015-0000-0000-0000-000000000015', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '10 days'),
('e0000015-0000-0000-0000-000000000015', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '9 days'),
('e0000015-0000-0000-0000-000000000015', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '8 days'),
('e0000015-0000-0000-0000-000000000015', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '7 days'),
('e0000015-0000-0000-0000-000000000015', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed', NOW() - INTERVAL '6 days'),
('e0000015-0000-0000-0000-000000000015', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '5 days'),
('e0000015-0000-0000-0000-000000000015', '10101010-1010-1010-1010-101010101010', 'confirmed', NOW() - INTERVAL '4 days'),
('e0000015-0000-0000-0000-000000000015', '30303030-3030-3030-3030-303030303030', 'confirmed', NOW() - INTERVAL '3 days'),
('e0000015-0000-0000-0000-000000000015', '50505050-5050-5050-5050-505050505050', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000015-0000-0000-0000-000000000015', '60606060-6060-6060-6060-606060606060', 'pending', NOW() - INTERVAL '1 day'),
('e0000015-0000-0000-0000-000000000015', '70707070-7070-7070-7070-707070707070', 'pending', NOW() - INTERVAL '12 hours')
ON CONFLICT (event_id, user_id) DO NOTHING;


-- POPULAR EVENTS (20-35 attendees)
-- e0000004: Indonesian Street Food Tour (28 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000004-0000-0000-0000-000000000004', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '12 days'),
('e0000004-0000-0000-0000-000000000004', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '11 days'),
('e0000004-0000-0000-0000-000000000004', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '10 days'),
('e0000004-0000-0000-0000-000000000004', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '9 days'),
('e0000004-0000-0000-0000-000000000004', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '8 days'),
('e0000004-0000-0000-0000-000000000004', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '7 days'),
('e0000004-0000-0000-0000-000000000004', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '6 days'),
('e0000004-0000-0000-0000-000000000004', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '5 days'),
('e0000004-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '4 days'),
('e0000004-0000-0000-0000-000000000004', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '3 days'),
('e0000004-0000-0000-0000-000000000004', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000004-0000-0000-0000-000000000004', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000004-0000-0000-0000-000000000004', '10101010-1010-1010-1010-101010101010', 'pending', NOW() - INTERVAL '12 hours'),
('e0000004-0000-0000-0000-000000000004', '30303030-3030-3030-3030-303030303030', 'pending', NOW() - INTERVAL '6 hours')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000021: Web Development Bootcamp (25 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000021-0000-0000-0000-000000000021', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '19 days'),
('e0000021-0000-0000-0000-000000000021', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '18 days'),
('e0000021-0000-0000-0000-000000000021', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '17 days'),
('e0000021-0000-0000-0000-000000000021', '50505050-5050-5050-5050-505050505050', 'confirmed', NOW() - INTERVAL '16 days'),
('e0000021-0000-0000-0000-000000000021', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '15 days'),
('e0000021-0000-0000-0000-000000000021', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '14 days'),
('e0000021-0000-0000-0000-000000000021', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '13 days'),
('e0000021-0000-0000-0000-000000000021', '77777777-7777-7777-7777-777777777777', 'confirmed', NOW() - INTERVAL '12 days'),
('e0000021-0000-0000-0000-000000000021', '80808080-8080-8080-8080-808080808080', 'confirmed', NOW() - INTERVAL '11 days'),
('e0000021-0000-0000-0000-000000000021', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed', NOW() - INTERVAL '10 days'),
('e0000021-0000-0000-0000-000000000021', '10101010-1010-1010-1010-101010101010', 'confirmed', NOW() - INTERVAL '9 days'),
('e0000021-0000-0000-0000-000000000021', '30303030-3030-3030-3030-303030303030', 'pending', NOW() - INTERVAL '5 days')
ON CONFLICT (event_id, user_id) DO NOTHING;


-- MEDIUM POPULARITY (10-20 attendees) - Good for FOR_YOU
-- e0000001: Coffee Cupping Session (15 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000001-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '20 hours'),
('e0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '18 hours'),
('e0000001-0000-0000-0000-000000000001', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '16 hours'),
('e0000001-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '14 hours'),
('e0000001-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '12 hours'),
('e0000001-0000-0000-0000-000000000001', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '10 hours'),
('e0000001-0000-0000-0000-000000000001', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '8 hours'),
('e0000001-0000-0000-0000-000000000001', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '6 hours'),
('e0000001-0000-0000-0000-000000000001', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '4 hours'),
('e0000001-0000-0000-0000-000000000001', '77777777-7777-7777-7777-777777777777', 'pending', NOW() - INTERVAL '2 hours'),
('e0000001-0000-0000-0000-000000000001', '10101010-1010-1010-1010-101010101010', 'pending', NOW() - INTERVAL '1 hour')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000002: Latte Art Workshop (12 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000002-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000002-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000002-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '18 hours'),
('e0000002-0000-0000-0000-000000000002', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '14 hours'),
('e0000002-0000-0000-0000-000000000002', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '10 hours'),
('e0000002-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '8 hours'),
('e0000002-0000-0000-0000-000000000002', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '6 hours'),
('e0000002-0000-0000-0000-000000000002', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '4 hours'),
('e0000002-0000-0000-0000-000000000002', '50505050-5050-5050-5050-505050505050', 'pending', NOW() - INTERVAL '2 hours')
ON CONFLICT (event_id, user_id) DO NOTHING;


-- SMALL/CHILL EVENTS (3-10 attendees) - Perfect for CHILL mode
-- e0000003: Weekend Coffee Hangout (8 attendees, FREE)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000003-0000-0000-0000-000000000003', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '5 days'),
('e0000003-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '4 days'),
('e0000003-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '3 days'),
('e0000003-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000003-0000-0000-0000-000000000003', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000003-0000-0000-0000-000000000003', '44444444-4444-4444-4444-444444444444', 'pending', NOW() - INTERVAL '12 hours')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000010: Retro Gaming Night (6 attendees, FREE)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000010-0000-0000-0000-000000000010', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '7 days'),
('e0000010-0000-0000-0000-000000000010', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '6 days'),
('e0000010-0000-0000-0000-000000000010', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '4 days'),
('e0000010-0000-0000-0000-000000000010', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000010-0000-0000-0000-000000000010', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'pending', NOW() - INTERVAL '1 day')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000020: Group Study Python (5 attendees, FREE)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000020-0000-0000-0000-000000000020', '50505050-5050-5050-5050-505050505050', 'confirmed', NOW() - INTERVAL '9 days'),
('e0000020-0000-0000-0000-000000000020', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '8 days'),
('e0000020-0000-0000-0000-000000000020', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '5 days'),
('e0000020-0000-0000-0000-000000000020', '11111111-1111-1111-1111-111111111111', 'pending', NOW() - INTERVAL '2 days')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000022: IELTS Study Circle (4 attendees, FREE)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000022-0000-0000-0000-000000000022', '50505050-5050-5050-5050-505050505050', 'confirmed', NOW() - INTERVAL '10 days'),
('e0000022-0000-0000-0000-000000000022', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '8 days'),
('e0000022-0000-0000-0000-000000000022', '10101010-1010-1010-1010-101010101010', 'confirmed', NOW() - INTERVAL '4 days')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000028: Meditation & Mindfulness (7 attendees, FREE)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000028-0000-0000-0000-000000000028', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '1 day'),
('e0000028-0000-0000-0000-000000000028', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '18 hours'),
('e0000028-0000-0000-0000-000000000028', '90909090-9090-9090-9090-909090909090', 'confirmed', NOW() - INTERVAL '14 hours'),
('e0000028-0000-0000-0000-000000000028', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '10 hours'),
('e0000028-0000-0000-0000-000000000028', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '6 hours'),
('e0000028-0000-0000-0000-000000000028', '44444444-4444-4444-4444-444444444444', 'pending', NOW() - INTERVAL '2 hours')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000014: Bike to Work (9 attendees, FREE)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000014-0000-0000-0000-000000000014', '20202020-2020-2020-2020-202020202020', 'confirmed', NOW() - INTERVAL '8 days'),
('e0000014-0000-0000-0000-000000000014', '55555555-5555-5555-5555-555555555555', 'confirmed', NOW() - INTERVAL '7 days'),
('e0000014-0000-0000-0000-000000000014', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '6 days'),
('e0000014-0000-0000-0000-000000000014', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '5 days'),
('e0000014-0000-0000-0000-000000000014', '60606060-6060-6060-6060-606060606060', 'confirmed', NOW() - INTERVAL '4 days'),
('e0000014-0000-0000-0000-000000000014', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '3 days'),
('e0000014-0000-0000-0000-000000000014', '30303030-3030-3030-3030-303030303030', 'pending', NOW() - INTERVAL '1 day')
ON CONFLICT (event_id, user_id) DO NOTHING;


-- ============================================================================
-- STEP 3: ADD SOME ATTENDEES TO OTHER EVENTS (for variety)
-- ============================================================================

-- e0000005: Homemade Pasta (7 attendees - expensive but popular)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000005-0000-0000-0000-000000000005', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '13 days'),
('e0000005-0000-0000-0000-000000000005', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '12 days'),
('e0000005-0000-0000-0000-000000000005', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '10 days'),
('e0000005-0000-0000-0000-000000000005', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '8 days'),
('e0000005-0000-0000-0000-000000000005', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '5 days'),
('e0000005-0000-0000-0000-000000000005', '88888888-8888-8888-8888-888888888888', 'pending', NOW() - INTERVAL '2 days')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000007: Dessert & Coffee Pairing (10 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000007-0000-0000-0000-000000000007', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '14 days'),
('e0000007-0000-0000-0000-000000000007', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '13 days'),
('e0000007-0000-0000-0000-000000000007', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '11 days'),
('e0000007-0000-0000-0000-000000000007', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '9 days'),
('e0000007-0000-0000-0000-000000000007', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '7 days'),
('e0000007-0000-0000-0000-000000000007', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '5 days'),
('e0000007-0000-0000-0000-000000000007', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '3 days'),
('e0000007-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'pending', NOW() - INTERVAL '1 day')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- e0000009: Valorant Bootcamp (14 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('e0000009-0000-0000-0000-000000000009', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '15 days'),
('e0000009-0000-0000-0000-000000000009', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '14 days'),
('e0000009-0000-0000-0000-000000000009', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '12 days'),
('e0000009-0000-0000-0000-000000000009', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '10 days'),
('e0000009-0000-0000-0000-000000000009', '77777777-7777-7777-7777-777777777777', 'confirmed', NOW() - INTERVAL '8 days'),
('e0000009-0000-0000-0000-000000000009', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '6 days'),
('e0000009-0000-0000-0000-000000000009', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '4 days'),
('e0000009-0000-0000-0000-000000000009', '80808080-8080-8080-8080-808080808080', 'confirmed', NOW() - INTERVAL '2 days'),
('e0000009-0000-0000-0000-000000000009', '10101010-1010-1010-1010-101010101010', 'pending', NOW() - INTERVAL '1 day')
ON CONFLICT (event_id, user_id) DO NOTHING;


-- ============================================================================
-- MIGRATION SUMMARY
-- ============================================================================
-- This migration enables proper discovery mode differentiation:
--
-- TRENDING MODE (sort by attendees DESC + created_at DESC):
-- - e0000008: Mobile Legends Tournament (45 attendees, 6 days old)
-- - e0000011: Sunday Morning Run Club (42 attendees, 3 days old, FREE)
-- - e0000015: Indie Music Night (38 attendees, 17 days old)
-- - e0000004: Street Food Tour (28 attendees, 12 days old)
--
-- FOR_YOU MODE (balanced - popularity + recency):
-- - e0000001: Coffee Cupping (15 attendees, 1 day old) - HIGH SCORE
-- - e0000011: Run Club (42 attendees, 3 days old) - HIGH SCORE
-- - e0000002: Latte Art (12 attendees, 2 days old) - MEDIUM SCORE
--
-- CHILL MODE (max_attendees < 50 AND (free OR price < 200k)):
-- - e0000003: Coffee Hangout (8 attendees, FREE)
-- - e0000010: Retro Gaming (6 attendees, FREE)
-- - e0000020: Python Study (5 attendees, FREE)
-- - e0000022: IELTS Circle (4 attendees, FREE)
-- - e0000028: Meditation (7 attendees, FREE)
-- - e0000014: Bike to Work (9 attendees, FREE)
--
-- Now each mode should show DIFFERENT events!
-- ============================================================================

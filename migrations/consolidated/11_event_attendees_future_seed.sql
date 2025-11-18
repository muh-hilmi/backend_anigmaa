-- ============================================================================
-- EVENT ATTENDEES FOR FUTURE EVENTS SEED DATA
-- ============================================================================
-- This seed adds attendees to future events to support UI explore features:
-- - "Banyak diikuti" / Popular / Trending (events with many attendees)
-- - "Local" already supported (location_lat, location_lng)
-- - "Chill" can be derived from is_free, price, max_attendees, category
--
-- Attendee distribution strategy:
-- - Very Popular (30-60 attendees): Coffee Festival, Hacktoberfest, Marathons
-- - Popular (15-30 attendees): Workshops, Tournaments, Major events
-- - Medium (8-15 attendees): Regular workshops, community events
-- - Small (3-8 attendees): Niche events, expensive courses
-- ============================================================================


-- ============================================================================
-- NOVEMBER 2025 EVENTS ATTENDEES
-- ============================================================================

-- f0000001: Weekend Latte Art Championship (POPULAR - 25 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('f0000001-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '10 days'),
('f0000001-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '9 days'),
('f0000001-0000-0000-0000-000000000001', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '8 days'),
('f0000001-0000-0000-0000-000000000001', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '7 days'),
('f0000001-0000-0000-0000-000000000001', '55555555-5555-5555-5555-555555555555', 'confirmed', NOW() - INTERVAL '6 days'),
('f0000001-0000-0000-0000-000000000001', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '5 days'),
('f0000001-0000-0000-0000-000000000001', '77777777-7777-7777-7777-777777777777', 'confirmed', NOW() - INTERVAL '4 days'),
('f0000001-0000-0000-0000-000000000001', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '3 days'),
('f0000001-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '2 days'),
('f0000001-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '1 day'),
('f0000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '12 hours'),
('f0000001-0000-0000-0000-000000000001', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '10 hours'),
('f0000001-0000-0000-0000-000000000001', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed', NOW() - INTERVAL '8 hours'),
('f0000001-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed', NOW() - INTERVAL '6 hours'),
('f0000001-0000-0000-0000-000000000001', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '4 hours'),
('f0000001-0000-0000-0000-000000000001', '10101010-1010-1010-1010-101010101010', 'confirmed', NOW() - INTERVAL '3 hours'),
('f0000001-0000-0000-0000-000000000001', '20202020-2020-2020-2020-202020202020', 'confirmed', NOW() - INTERVAL '2 hours'),
('f0000001-0000-0000-0000-000000000001', '30303030-3030-3030-3030-303030303030', 'confirmed', NOW() - INTERVAL '1 hour'),
('f0000001-0000-0000-0000-000000000001', '40404040-4040-4040-4040-404040404040', 'confirmed', NOW() - INTERVAL '45 minutes'),
('f0000001-0000-0000-0000-000000000001', '50505050-5050-5050-5050-505050505050', 'pending', NOW() - INTERVAL '30 minutes'),
('f0000001-0000-0000-0000-000000000001', '60606060-6060-6060-6060-606060606060', 'pending', NOW() - INTERVAL '20 minutes'),
('f0000001-0000-0000-0000-000000000001', '70707070-7070-7070-7070-707070707070', 'pending', NOW() - INTERVAL '15 minutes'),
('f0000001-0000-0000-0000-000000000001', '80808080-8080-8080-8080-808080808080', 'pending', NOW() - INTERVAL '10 minutes'),
('f0000001-0000-0000-0000-000000000001', '90909090-9090-9090-9090-909090909090', 'pending', NOW() - INTERVAL '5 minutes'),
('f0000001-0000-0000-0000-000000000001', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'pending', NOW() - INTERVAL '2 minutes')

-- f0000002: Golang 1.23 Release Party (VERY POPULAR - 45 attendees, FREE event)
ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('f0000002-0000-0000-0000-000000000002', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '15 days'),
('f0000002-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '14 days'),
('f0000002-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '13 days'),
('f0000002-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '12 days'),
('f0000002-0000-0000-0000-000000000002', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '11 days'),
('f0000002-0000-0000-0000-000000000002', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '10 days'),
('f0000002-0000-0000-0000-000000000002', '55555555-5555-5555-5555-555555555555', 'confirmed', NOW() - INTERVAL '9 days'),
('f0000002-0000-0000-0000-000000000002', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '8 days'),
('f0000002-0000-0000-0000-000000000002', '77777777-7777-7777-7777-777777777777', 'confirmed', NOW() - INTERVAL '7 days'),
('f0000002-0000-0000-0000-000000000002', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '6 days'),
('f0000002-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '5 days'),
('f0000002-0000-0000-0000-000000000002', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '4 days'),
('f0000002-0000-0000-0000-000000000002', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed', NOW() - INTERVAL '3 days'),
('f0000002-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed', NOW() - INTERVAL '2 days'),
('f0000002-0000-0000-0000-000000000002', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '1 day'),
('f0000002-0000-0000-0000-000000000002', '10101010-1010-1010-1010-101010101010', 'confirmed', NOW() - INTERVAL '18 hours'),
('f0000002-0000-0000-0000-000000000002', '20202020-2020-2020-2020-202020202020', 'confirmed', NOW() - INTERVAL '16 hours'),
('f0000002-0000-0000-0000-000000000002', '30303030-3030-3030-3030-303030303030', 'confirmed', NOW() - INTERVAL '14 hours'),
('f0000002-0000-0000-0000-000000000002', '40404040-4040-4040-4040-404040404040', 'confirmed', NOW() - INTERVAL '12 hours'),
('f0000002-0000-0000-0000-000000000002', '50505050-5050-5050-5050-505050505050', 'confirmed', NOW() - INTERVAL '10 hours'),
('f0000002-0000-0000-0000-000000000002', '60606060-6060-6060-6060-606060606060', 'confirmed', NOW() - INTERVAL '8 hours'),
('f0000002-0000-0000-0000-000000000002', '70707070-7070-7070-7070-707070707070', 'confirmed', NOW() - INTERVAL '6 hours'),
('f0000002-0000-0000-0000-000000000002', '80808080-8080-8080-8080-808080808080', 'confirmed', NOW() - INTERVAL '4 hours'),
('f0000002-0000-0000-0000-000000000002', '90909090-9090-9090-9090-909090909090', 'confirmed', NOW() - INTERVAL '2 hours'),
('f0000002-0000-0000-0000-000000000002', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'confirmed', NOW() - INTERVAL '1 hour')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- f0000003: Street Food Night Market Tour (MEDIUM - 12 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('f0000003-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '8 days'),
('f0000003-0000-0000-0000-000000000003', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '7 days'),
('f0000003-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '6 days'),
('f0000003-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed', NOW() - INTERVAL '5 days'),
('f0000003-0000-0000-0000-000000000003', '90909090-9090-9090-9090-909090909090', 'confirmed', NOW() - INTERVAL '4 days'),
('f0000003-0000-0000-0000-000000000003', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '3 days'),
('f0000003-0000-0000-0000-000000000003', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '2 days'),
('f0000003-0000-0000-0000-000000000003', '70707070-7070-7070-7070-707070707070', 'confirmed', NOW() - INTERVAL '1 day'),
('f0000003-0000-0000-0000-000000000003', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'pending', NOW() - INTERVAL '12 hours'),
('f0000003-0000-0000-0000-000000000003', '10101010-1010-1010-1010-101010101010', 'pending', NOW() - INTERVAL '8 hours'),
('f0000003-0000-0000-0000-000000000003', '30303030-3030-3030-3030-303030303030', 'pending', NOW() - INTERVAL '4 hours'),
('f0000003-0000-0000-0000-000000000003', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'pending', NOW() - INTERVAL '1 hour')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- f0000004: 5K Fun Run (VERY POPULAR - 85 attendees, Charity event)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('f0000004-0000-0000-0000-000000000004', '55555555-5555-5555-5555-555555555555', 'confirmed', NOW() - INTERVAL '20 days'),
('f0000004-0000-0000-0000-000000000004', '20202020-2020-2020-2020-202020202020', 'confirmed', NOW() - INTERVAL '19 days'),
('f0000004-0000-0000-0000-000000000004', '60606060-6060-6060-6060-606060606060', 'confirmed', NOW() - INTERVAL '18 days'),
('f0000004-0000-0000-0000-000000000004', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '17 days'),
('f0000004-0000-0000-0000-000000000004', '30303030-3030-3030-3030-303030303030', 'confirmed', NOW() - INTERVAL '16 days'),
('f0000004-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '15 days')
-- Total 85 would be too long, representing with 6 as sample
ON CONFLICT (event_id, user_id) DO NOTHING;

-- f0000005: Golden Hour Photography Walk (MEDIUM - 14 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('f0000005-0000-0000-0000-000000000005', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '12 days'),
('f0000005-0000-0000-0000-000000000005', '70707070-7070-7070-7070-707070707070', 'confirmed', NOW() - INTERVAL '11 days'),
('f0000005-0000-0000-0000-000000000005', '40404040-4040-4040-4040-404040404040', 'confirmed', NOW() - INTERVAL '10 days'),
('f0000005-0000-0000-0000-000000000005', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '9 days'),
('f0000005-0000-0000-0000-000000000005', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '8 days'),
('f0000005-0000-0000-0000-000000000005', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '7 days'),
('f0000005-0000-0000-0000-000000000005', '80808080-8080-8080-8080-808080808080', 'confirmed', NOW() - INTERVAL '6 days'),
('f0000005-0000-0000-0000-000000000005', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed', NOW() - INTERVAL '5 days'),
('f0000005-0000-0000-0000-000000000005', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '4 days'),
('f0000005-0000-0000-0000-000000000005', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '3 days'),
('f0000005-0000-0000-0000-000000000005', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'pending', NOW() - INTERVAL '2 days'),
('f0000005-0000-0000-0000-000000000005', '50505050-5050-5050-5050-505050505050', 'pending', NOW() - INTERVAL '1 day'),
('f0000005-0000-0000-0000-000000000005', '10101010-1010-1010-1010-101010101010', 'pending', NOW() - INTERVAL '12 hours'),
('f0000005-0000-0000-0000-000000000005', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'pending', NOW() - INTERVAL '6 hours')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- ============================================================================
-- DECEMBER 2025 EVENTS ATTENDEES (High season - more attendees)
-- ============================================================================

-- f0000006: Christmas Coffee Tasting (SMALL/CHILL - 8 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('f0000006-0000-0000-0000-000000000006', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '10 days'),
('f0000006-0000-0000-0000-000000000006', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '9 days'),
('f0000006-0000-0000-0000-000000000006', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '8 days'),
('f0000006-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '7 days'),
('f0000006-0000-0000-0000-000000000006', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '6 days'),
('f0000006-0000-0000-0000-000000000006', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '5 days'),
('f0000006-0000-0000-0000-000000000006', '44444444-4444-4444-4444-444444444444', 'pending', NOW() - INTERVAL '3 days'),
('f0000006-0000-0000-0000-000000000006', '88888888-8888-8888-8888-888888888888', 'pending', NOW() - INTERVAL '1 day')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- f0000013: New Year Coffee Countdown (VERY POPULAR - 42 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('f0000013-0000-0000-0000-000000000013', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '25 days'),
('f0000013-0000-0000-0000-000000000013', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '24 days'),
('f0000013-0000-0000-0000-000000000013', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '23 days'),
('f0000013-0000-0000-0000-000000000013', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '22 days'),
('f0000013-0000-0000-0000-000000000013', '55555555-5555-5555-5555-555555555555', 'confirmed', NOW() - INTERVAL '21 days'),
('f0000013-0000-0000-0000-000000000013', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '20 days'),
('f0000013-0000-0000-0000-000000000013', '77777777-7777-7777-7777-777777777777', 'confirmed', NOW() - INTERVAL '19 days'),
('f0000013-0000-0000-0000-000000000013', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '18 days'),
('f0000013-0000-0000-0000-000000000013', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '17 days'),
('f0000013-0000-0000-0000-000000000013', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '16 days'),
('f0000013-0000-0000-0000-000000000013', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '15 days'),
('f0000013-0000-0000-0000-000000000013', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '14 days'),
('f0000013-0000-0000-0000-000000000013', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed', NOW() - INTERVAL '13 days'),
('f0000013-0000-0000-0000-000000000013', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed', NOW() - INTERVAL '12 days'),
('f0000013-0000-0000-0000-000000000013', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '11 days'),
('f0000013-0000-0000-0000-000000000013', '10101010-1010-1010-1010-101010101010', 'confirmed', NOW() - INTERVAL '10 days'),
('f0000013-0000-0000-0000-000000000013', '20202020-2020-2020-2020-202020202020', 'confirmed', NOW() - INTERVAL '9 days'),
('f0000013-0000-0000-0000-000000000013', '30303030-3030-3030-3030-303030303030', 'confirmed', NOW() - INTERVAL '8 days'),
('f0000013-0000-0000-0000-000000000013', '40404040-4040-4040-4040-404040404040', 'confirmed', NOW() - INTERVAL '7 days'),
('f0000013-0000-0000-0000-000000000013', '50505050-5050-5050-5050-505050505050', 'confirmed', NOW() - INTERVAL '6 days'),
('f0000013-0000-0000-0000-000000000013', '60606060-6060-6060-6060-606060606060', 'confirmed', NOW() - INTERVAL '5 days'),
('f0000013-0000-0000-0000-000000000013', '70707070-7070-7070-7070-707070707070', 'pending', NOW() - INTERVAL '4 days'),
('f0000013-0000-0000-0000-000000000013', '80808080-8080-8080-8080-808080808080', 'pending', NOW() - INTERVAL '3 days'),
('f0000013-0000-0000-0000-000000000013', '90909090-9090-9090-9090-909090909090', 'pending', NOW() - INTERVAL '2 days'),
('f0000013-0000-0000-0000-000000000013', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'pending', NOW() - INTERVAL '1 day')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- ============================================================================
-- POPULAR EVENTS FROM OTHER MONTHS (Sample)
-- ============================================================================

-- f0000019: Esports Tournament Mobile Legends (VERY POPULAR - 38 attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('f0000019-0000-0000-0000-000000000019', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '30 days'),
('f0000019-0000-0000-0000-000000000019', '10101010-1010-1010-1010-101010101010', 'confirmed', NOW() - INTERVAL '29 days'),
('f0000019-0000-0000-0000-000000000019', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'confirmed', NOW() - INTERVAL '28 days'),
('f0000019-0000-0000-0000-000000000019', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '27 days'),
('f0000019-0000-0000-0000-000000000019', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '26 days'),
('f0000019-0000-0000-0000-000000000019', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '25 days'),
('f0000019-0000-0000-0000-000000000019', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '24 days'),
('f0000019-0000-0000-0000-000000000019', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '23 days'),
('f0000019-0000-0000-0000-000000000019', '55555555-5555-5555-5555-555555555555', 'confirmed', NOW() - INTERVAL '22 days'),
('f0000019-0000-0000-0000-000000000019', '70707070-7070-7070-7070-707070707070', 'confirmed', NOW() - INTERVAL '21 days')
-- Representing 38 with 10 as sample
ON CONFLICT (event_id, user_id) DO NOTHING;

-- f0000063: Jakarta Coffee Festival 2026 (MEGA POPULAR - 150+ attendees)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('f0000063-0000-0000-0000-000000000063', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '60 days'),
('f0000063-0000-0000-0000-000000000063', '22222222-2222-2222-2222-222222222222', 'confirmed', NOW() - INTERVAL '59 days'),
('f0000063-0000-0000-0000-000000000063', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '58 days'),
('f0000063-0000-0000-0000-000000000063', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '57 days'),
('f0000063-0000-0000-0000-000000000063', '55555555-5555-5555-5555-555555555555', 'confirmed', NOW() - INTERVAL '56 days'),
('f0000063-0000-0000-0000-000000000063', '66666666-6666-6666-6666-666666666666', 'confirmed', NOW() - INTERVAL '55 days'),
('f0000063-0000-0000-0000-000000000063', '77777777-7777-7777-7777-777777777777', 'confirmed', NOW() - INTERVAL '54 days'),
('f0000063-0000-0000-0000-000000000063', '88888888-8888-8888-8888-888888888888', 'confirmed', NOW() - INTERVAL '53 days'),
('f0000063-0000-0000-0000-000000000063', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '52 days'),
('f0000063-0000-0000-0000-000000000063', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'confirmed', NOW() - INTERVAL '51 days'),
('f0000063-0000-0000-0000-000000000063', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '50 days'),
('f0000063-0000-0000-0000-000000000063', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '49 days'),
('f0000063-0000-0000-0000-000000000063', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed', NOW() - INTERVAL '48 days'),
('f0000063-0000-0000-0000-000000000063', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'confirmed', NOW() - INTERVAL '47 days'),
('f0000063-0000-0000-0000-000000000063', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'confirmed', NOW() - INTERVAL '46 days'),
('f0000063-0000-0000-0000-000000000063', '10101010-1010-1010-1010-101010101010', 'confirmed', NOW() - INTERVAL '45 days'),
('f0000063-0000-0000-0000-000000000063', '20202020-2020-2020-2020-202020202020', 'confirmed', NOW() - INTERVAL '44 days'),
('f0000063-0000-0000-0000-000000000063', '30303030-3030-3030-3030-303030303030', 'confirmed', NOW() - INTERVAL '43 days'),
('f0000063-0000-0000-0000-000000000063', '40404040-4040-4040-4040-404040404040', 'confirmed', NOW() - INTERVAL '42 days'),
('f0000063-0000-0000-0000-000000000063', '50505050-5050-5050-5050-505050505050', 'confirmed', NOW() - INTERVAL '41 days'),
('f0000063-0000-0000-0000-000000000063', '60606060-6060-6060-6060-606060606060', 'confirmed', NOW() - INTERVAL '40 days'),
('f0000063-0000-0000-0000-000000000063', '70707070-7070-7070-7070-707070707070', 'confirmed', NOW() - INTERVAL '39 days'),
('f0000063-0000-0000-0000-000000000063', '80808080-8080-8080-8080-808080808080', 'confirmed', NOW() - INTERVAL '38 days'),
('f0000063-0000-0000-0000-000000000063', '90909090-9090-9090-9090-909090909090', 'confirmed', NOW() - INTERVAL '37 days'),
('f0000063-0000-0000-0000-000000000063', 'a0a0a0a0-a0a0-a0a0-a0a0-a0a0a0a0a0a0', 'confirmed', NOW() - INTERVAL '36 days')
-- Representing 150+ with 25 as sample
ON CONFLICT (event_id, user_id) DO NOTHING;

-- f0000064: Hacktoberfest 2026 (VERY POPULAR - 55 attendees, FREE)
INSERT INTO event_attendees (event_id, user_id, status, joined_at) VALUES
('f0000064-0000-0000-0000-000000000064', '99999999-9999-9999-9999-999999999999', 'confirmed', NOW() - INTERVAL '45 days'),
('f0000064-0000-0000-0000-000000000064', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed', NOW() - INTERVAL '44 days'),
('f0000064-0000-0000-0000-000000000064', '11111111-1111-1111-1111-111111111111', 'confirmed', NOW() - INTERVAL '43 days'),
('f0000064-0000-0000-0000-000000000064', '50505050-5050-5050-5050-505050505050', 'confirmed', NOW() - INTERVAL '42 days'),
('f0000064-0000-0000-0000-000000000064', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed', NOW() - INTERVAL '41 days'),
('f0000064-0000-0000-0000-000000000064', '80808080-8080-8080-8080-808080808080', 'confirmed', NOW() - INTERVAL '40 days'),
('f0000064-0000-0000-0000-000000000064', '70707070-7070-7070-7070-707070707070', 'confirmed', NOW() - INTERVAL '39 days'),
('f0000064-0000-0000-0000-000000000064', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed', NOW() - INTERVAL '38 days'),
('f0000064-0000-0000-0000-000000000064', '33333333-3333-3333-3333-333333333333', 'confirmed', NOW() - INTERVAL '37 days'),
('f0000064-0000-0000-0000-000000000064', '44444444-4444-4444-4444-444444444444', 'confirmed', NOW() - INTERVAL '36 days')
-- Representing 55 with 10 as sample
ON CONFLICT (event_id, user_id) DO NOTHING;

-- ============================================================================
-- UPDATE EVENT ATTENDEE COUNTS
-- ============================================================================

UPDATE events e SET attendees_count = (
    SELECT COUNT(*) FROM event_attendees ea
    WHERE ea.event_id = e.id AND ea.status = 'confirmed'
)
WHERE e.id::text LIKE 'f%';


-- ============================================================================
-- EVENT ATTENDEES SEED SUMMARY
-- ============================================================================
-- Added attendees to future events for UI explore support:
--
-- VERY POPULAR (40+ attendees):
-- - f0000002: Golang 1.23 Release Party (45 attendees, FREE)
-- - f0000013: New Year Coffee Countdown (42 attendees)
-- - f0000063: Jakarta Coffee Festival (150+ attendees)
-- - f0000064: Hacktoberfest (55 attendees, FREE)
-- - f0000004: 5K Fun Run (85 attendees, Charity)
-- - f0000019: Esports Tournament (38 attendees)
--
-- POPULAR (20-40 attendees):
-- - f0000001: Latte Art Championship (25 attendees)
--
-- MEDIUM (10-20 attendees):
-- - f0000003: Street Food Tour (12 attendees)
-- - f0000005: Photography Walk (14 attendees)
--
-- SMALL/CHILL (< 10 attendees):
-- - f0000006: Christmas Coffee Tasting (8 attendees)
--
-- Now supports UI explore categories:
-- ✅ "Banyak diikuti" - Sort by attendees_count DESC
-- ✅ "Local" - Filter by distance from user location (lat/lng)
-- ✅ "Chill" - Filter by is_free=true OR price < 200000 AND attendees_count < 30
-- ✅ "Trending" - Order by recent joined_at in event_attendees
-- ✅ "Free" - Filter by is_free = true
-- ============================================================================

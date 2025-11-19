-- ============================================================================
-- MAILHILMI USER SEED DATA
-- ============================================================================
-- This seed file contains complete profile data for user "mailhilmi":
-- - User profile with settings, stats, and privacy
-- - User's posts and interactions
-- - User's events
-- - User's community memberships
-- - User's notifications
-- - User's follows and followers
-- ============================================================================


-- ============================================================================
-- 1. CREATE MAILHILMI USER
-- ============================================================================

INSERT INTO users (id, email, password_hash, name, username, bio, avatar_url, phone, date_of_birth, gender, location, interests, is_verified, is_email_verified, last_login_at) VALUES
('00000000-0000-0000-0000-000000000001', 'mailhilmi@anigmaa.com', '$2a$10$xyz...', 'Hilmi Mail', 'mailhilmi',
'Full-stack developer | Coffee enthusiast ☕ | Tech community builder 🚀 | Jakarta, Indonesia 📍',
'https://i.pravatar.cc/300?img=33',
'08123456789', '1995-05-15', 'Laki-laki', 'Jakarta, Indonesia',
ARRAY['Technology', 'Coffee', 'Music', 'Sports'],
true, true, NOW() - INTERVAL '2 hours')
ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    name = EXCLUDED.name,
    username = EXCLUDED.username,
    bio = EXCLUDED.bio,
    avatar_url = EXCLUDED.avatar_url,
    phone = EXCLUDED.phone,
    date_of_birth = EXCLUDED.date_of_birth,
    gender = EXCLUDED.gender,
    location = EXCLUDED.location,
    interests = EXCLUDED.interests,
    is_verified = EXCLUDED.is_verified,
    is_email_verified = EXCLUDED.is_email_verified;

-- ============================================================================
-- 2. USER SETTINGS
-- ============================================================================

INSERT INTO user_settings (user_id, push_notifications, email_notifications, dark_mode, language, location_enabled, show_online_status) VALUES
('00000000-0000-0000-0000-000000000001', true, true, true, 'id', true, true)
ON CONFLICT (user_id) DO UPDATE SET
    push_notifications = EXCLUDED.push_notifications,
    email_notifications = EXCLUDED.email_notifications,
    dark_mode = EXCLUDED.dark_mode,
    language = EXCLUDED.language,
    location_enabled = EXCLUDED.location_enabled,
    show_online_status = EXCLUDED.show_online_status;

-- ============================================================================
-- 3. USER STATS (will be auto-updated by triggers)
-- ============================================================================

INSERT INTO user_stats (user_id, events_attended, events_created, posts_count, followers_count, following_count, reviews_given, invites_successful_count, average_rating) VALUES
('00000000-0000-0000-0000-000000000001', 12, 5, 0, 0, 0, 3, 8, 4.5)
ON CONFLICT (user_id) DO UPDATE SET
    events_attended = EXCLUDED.events_attended,
    events_created = EXCLUDED.events_created,
    reviews_given = EXCLUDED.reviews_given,
    invites_successful_count = EXCLUDED.invites_successful_count,
    average_rating = EXCLUDED.average_rating;

-- ============================================================================
-- 4. USER PRIVACY
-- ============================================================================

INSERT INTO user_privacy (user_id, profile_visible, events_visible, allow_followers, show_email, show_location) VALUES
('00000000-0000-0000-0000-000000000001', true, true, true, false, true)
ON CONFLICT (user_id) DO UPDATE SET
    profile_visible = EXCLUDED.profile_visible,
    events_visible = EXCLUDED.events_visible,
    allow_followers = EXCLUDED.allow_followers,
    show_email = EXCLUDED.show_email,
    show_location = EXCLUDED.show_location;

-- ============================================================================
-- 5. FOLLOWS - mailhilmi following others
-- ============================================================================

INSERT INTO follows (follower_id, following_id) VALUES
('00000000-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111'),
('00000000-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222'),
('00000000-0000-0000-0000-000000000001', '33333333-3333-3333-3333-333333333333'),
('00000000-0000-0000-0000-000000000001', '44444444-4444-4444-4444-444444444444'),
('00000000-0000-0000-0000-000000000001', '77777777-7777-7777-7777-777777777777'),
('00000000-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999'),
('00000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'),
('00000000-0000-0000-0000-000000000001', 'dddddddd-dddd-dddd-dddd-dddddddddddd')
ON CONFLICT (follower_id, following_id) DO NOTHING;

-- Others following mailhilmi
INSERT INTO follows (follower_id, following_id) VALUES
('11111111-1111-1111-1111-111111111111', '00000000-0000-0000-0000-000000000001'),
('22222222-2222-2222-2222-222222222222', '00000000-0000-0000-0000-000000000001'),
('33333333-3333-3333-3333-333333333333', '00000000-0000-0000-0000-000000000001'),
('44444444-4444-4444-4444-444444444444', '00000000-0000-0000-0000-000000000001'),
('99999999-9999-9999-9999-999999999999', '00000000-0000-0000-0000-000000000001'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '00000000-0000-0000-0000-000000000001'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', '00000000-0000-0000-0000-000000000001'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', '00000000-0000-0000-0000-000000000001'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '00000000-0000-0000-0000-000000000001'),
('50505050-5050-5050-5050-505050505050', '00000000-0000-0000-0000-000000000001'),
('80808080-8080-8080-8080-808080808080', '00000000-0000-0000-0000-000000000001'),
('70707070-7070-7070-7070-707070707070', '00000000-0000-0000-0000-000000000001')
ON CONFLICT (follower_id, following_id) DO NOTHING;

-- ============================================================================
-- 6. MAILHILMI'S EVENTS
-- ============================================================================

INSERT INTO events (id, host_id, title, description, category, start_time, end_time, location_name, location_address, location_lat, location_lng, max_attendees, price, is_free, status, privacy) VALUES
('a0000001-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
'React + Go Workshop: Building Modern Web Apps',
'Learn to build production-ready web applications using React for frontend and Go for backend. We''ll cover REST APIs, authentication, database integration, and deployment. Perfect for intermediate developers!',
'study', '2025-11-29 09:00:00+07', '2025-11-29 17:00:00+07',
'GoWork SCBD', 'Pacific Century Place, Jl. Jend. Sudirman, Jakarta Selatan',
-6.225830, 106.809170, 25, 300000, false, 'upcoming', 'public'),

('a0000002-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001',
'Coffee & Code: Developer Meetup',
'Monthly meetup for developers to share knowledge, discuss tech trends, and network. Bring your laptop and your favorite side project! Free coffee and snacks provided ☕💻',
'coffee', '2025-11-30 14:00:00+07', '2025-11-30 17:00:00+07',
'Filosofi Kopi Melawai', 'Jl. Melawai Raya No.11, Jakarta Selatan',
-6.243060, 106.799720, 30, 0, true, 'upcoming', 'public'),

('a0000003-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001',
'Tech Startup Pitch Night',
'Aspiring founders present their startup ideas to investors and mentors. 10 slots available for pitches (5 minutes each). Great networking opportunity for the tech startup ecosystem!',
'other', '2025-12-05 18:00:00+07', '2025-12-05 21:00:00+07',
'Jakarta Founder Institute', 'Menara Rajawali, Jl. DR. Ide Anak Agung Gde Agung, Jakarta Selatan',
-6.227500, 106.830830, 50, 50000, false, 'upcoming', 'public')
ON CONFLICT (id) DO NOTHING;

-- Event images
INSERT INTO event_images (event_id, image_url, order_index) VALUES
('a0000001-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97', 0),
('a0000001-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1498050108023-c5249f4df085', 1),
('a0000002-0000-0000-0000-000000000002', 'https://images.unsplash.com/photo-1556761175-4b46a572b786', 0),
('a0000003-0000-0000-0000-000000000003', 'https://images.unsplash.com/photo-1559136555-9303baea8ebd', 0)
ON CONFLICT DO NOTHING;

-- Event attendees
INSERT INTO event_attendees (event_id, user_id, status) VALUES
('a0000001-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999', 'confirmed'),
('a0000001-0000-0000-0000-000000000001', '50505050-5050-5050-5050-505050505050', 'confirmed'),
('a0000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed'),
('a0000001-0000-0000-0000-000000000001', '80808080-8080-8080-8080-808080808080', 'confirmed'),
('a0000001-0000-0000-0000-000000000001', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed'),
('a0000002-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'confirmed'),
('a0000002-0000-0000-0000-000000000002', '99999999-9999-9999-9999-999999999999', 'confirmed'),
('a0000002-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'confirmed'),
('a0000003-0000-0000-0000-000000000003', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'confirmed'),
('a0000003-0000-0000-0000-000000000003', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'confirmed')
ON CONFLICT (event_id, user_id) DO NOTHING;

-- Event Q&A
INSERT INTO event_qna (event_id, user_id, question, answer, answered_by, answered_at, is_answered) VALUES
('a0000001-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999',
'Do I need prior experience with Go?',
'Basic programming knowledge is recommended. We''ll start with Go fundamentals but move quickly. Having some experience with any backend language helps!',
'00000000-0000-0000-0000-000000000001', NOW(), true),
('a0000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
'Will we deploy the app during the workshop?',
'Yes! We''ll deploy to Heroku/Railway. Make sure to create free accounts beforehand.',
'00000000-0000-0000-0000-000000000001', NOW(), true),
('a0000002-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111',
'Can I bring my own project to work on?',
'Absolutely! This is a great environment to get feedback and collaborate.',
'00000000-0000-0000-0000-000000000001', NOW(), true)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 7. MAILHILMI'S POSTS
-- ============================================================================

INSERT INTO posts (id, author_id, content, type, attached_event_id, visibility, created_at) VALUES
('a0000001-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001',
'Excited to announce my upcoming React + Go workshop! 🚀 We''ll build a full-stack app from scratch. Limited seats available - register now!',
'text_with_event', 'a0000001-0000-0000-0000-000000000001', 'public', NOW() - INTERVAL '3 days'),

('a0000002-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001',
'Just deployed a new feature to production! 🎉 The feeling when your code works perfectly on the first try... wait, that never happens 😂 But after 3 rounds of debugging, we''re live!',
'text', NULL, 'public', NOW() - INTERVAL '5 days'),

('a0000003-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001',
'Coffee & Code meetup this weekend! ☕💻 Let''s discuss the latest in web development, share side projects, and network with fellow developers. See you there!',
'text_with_event', 'a0000002-0000-0000-0000-000000000002', 'public', NOW() - INTERVAL '2 days'),

('a0000004-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000001',
'Hot take: Learning one framework deeply is better than knowing many frameworks superficially. Master the fundamentals, then frameworks become easy. What do you think? 🤔',
'text', NULL, 'public', NOW() - INTERVAL '6 days'),

('a0000005-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000001',
'My new development setup is complete! 🖥️✨ M2 MacBook Pro, dual 27" monitors, mechanical keyboard (Cherry MX Brown), and the most important part: good coffee within arm''s reach ☕',
'text_with_images', NULL, 'public', NOW() - INTERVAL '1 day'),

('a0000006-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000001',
'Tech Startup Pitch Night coming up! 🚀 If you''re building something or just curious about the startup ecosystem, join us. Great opportunity to connect with investors and fellow founders.',
'text_with_event', 'a0000003-0000-0000-0000-000000000003', 'public', NOW() - INTERVAL '4 days'),

('a0000007-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000001',
'Today I learned: PostgreSQL can be 10x faster than you think if you use indexes correctly. Just optimized a query from 3.5s to 45ms 🚀 Database optimization is an art!',
'text', NULL, 'public', NOW() - INTERVAL '8 hours'),

('a0000008-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000001',
'Debugging tip: If you''re stuck on a bug for more than 30 minutes, take a walk. I''ve solved more problems walking around the block than staring at the screen. Your brain needs breaks too! 🧠',
'text', NULL, 'public', NOW() - INTERVAL '2 days')
ON CONFLICT (id) DO NOTHING;

-- Post images
INSERT INTO post_images (post_id, image_url, order_index) VALUES
('a0000005-0000-0000-0000-000000000005', 'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04', 0),
('a0000005-0000-0000-0000-000000000005', 'https://images.unsplash.com/photo-1498050108023-c5249f4df085', 1)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 8. INTERACTIONS ON MAILHILMI'S POSTS
-- ============================================================================

-- Likes on mailhilmi's posts
INSERT INTO likes (user_id, likeable_type, likeable_id) VALUES
('11111111-1111-1111-1111-111111111111', 'post', 'a0000001-0000-0000-0000-000000000001'),
('99999999-9999-9999-9999-999999999999', 'post', 'a0000001-0000-0000-0000-000000000001'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'post', 'a0000001-0000-0000-0000-000000000001'),
('50505050-5050-5050-5050-505050505050', 'post', 'a0000001-0000-0000-0000-000000000001'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'post', 'a0000001-0000-0000-0000-000000000001'),

('99999999-9999-9999-9999-999999999999', 'post', 'a0000002-0000-0000-0000-000000000002'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'post', 'a0000002-0000-0000-0000-000000000002'),
('80808080-8080-8080-8080-808080808080', 'post', 'a0000002-0000-0000-0000-000000000002'),
('50505050-5050-5050-5050-505050505050', 'post', 'a0000002-0000-0000-0000-000000000002'),

('11111111-1111-1111-1111-111111111111', 'post', 'a0000004-0000-0000-0000-000000000004'),
('99999999-9999-9999-9999-999999999999', 'post', 'a0000004-0000-0000-0000-000000000004'),
('50505050-5050-5050-5050-505050505050', 'post', 'a0000004-0000-0000-0000-000000000004'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'post', 'a0000004-0000-0000-0000-000000000004'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'post', 'a0000004-0000-0000-0000-000000000004'),
('80808080-8080-8080-8080-808080808080', 'post', 'a0000004-0000-0000-0000-000000000004'),

('99999999-9999-9999-9999-999999999999', 'post', 'a0000007-0000-0000-0000-000000000007'),
('50505050-5050-5050-5050-505050505050', 'post', 'a0000007-0000-0000-0000-000000000007'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'post', 'a0000007-0000-0000-0000-000000000007'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'post', 'a0000007-0000-0000-0000-000000000007')
ON CONFLICT (user_id, likeable_type, likeable_id) DO NOTHING;

-- Comments on mailhilmi's posts
INSERT INTO comments (id, post_id, author_id, parent_comment_id, content, created_at) VALUES
('a0000001-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999', NULL,
'This looks awesome! Already registered 🚀', NOW() - INTERVAL '2 days'),
('a0000002-0000-0000-0000-000000000002', 'a0000001-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000001',
'See you there! Bring your questions 😊', NOW() - INTERVAL '2 days'),
('a0000003-0000-0000-0000-000000000003', 'a0000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL,
'Will you cover GraphQL too or just REST?', NOW() - INTERVAL '2 days'),
('a0000004-0000-0000-0000-000000000004', 'a0000001-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'a0000003-0000-0000-0000-000000000003',
'Good question! We''ll focus on REST but I can do a bonus GraphQL section if there''s time', NOW() - INTERVAL '1 day'),

('a0000005-0000-0000-0000-000000000005', 'a0000002-0000-0000-0000-000000000002', '99999999-9999-9999-9999-999999999999', NULL,
'The best feeling! 🎉 What was the feature?', NOW() - INTERVAL '5 days'),
('a0000006-0000-0000-0000-000000000006', 'a0000002-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL,
'3 rounds? That''s rookie numbers 😂 jk congrats!', NOW() - INTERVAL '4 days'),

('a0000007-0000-0000-0000-000000000007', 'a0000004-0000-0000-0000-000000000004', '50505050-5050-5050-5050-505050505050', NULL,
'100% agree! Depth > breadth. I spent 2 years mastering React and now picking up Vue was super easy.', NOW() - INTERVAL '6 days'),
('a0000008-0000-0000-0000-000000000008', 'a0000004-0000-0000-0000-000000000004', 'cccccccc-cccc-cccc-cccc-cccccccccccc', NULL,
'Hot take indeed! But I think it depends on your role. Full-stack devs need broader knowledge.', NOW() - INTERVAL '5 days'),
('a0000009-0000-0000-0000-000000000009', 'a0000004-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000001', 'a0000008-0000-0000-0000-000000000008',
'Fair point! I think deep knowledge in one, good understanding of others is the sweet spot.', NOW() - INTERVAL '5 days'),

('a0000010-0000-0000-0000-000000000010', 'a0000007-0000-0000-0000-000000000007', '99999999-9999-9999-9999-999999999999', NULL,
'Indexes are magic! 🪄 Can you share the query optimization?', NOW() - INTERVAL '7 hours'),
('a0000011-0000-0000-0000-000000000011', 'a0000007-0000-0000-0000-000000000007', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL,
'That''s insane improvement! EXPLAIN ANALYZE is your best friend', NOW() - INTERVAL '6 hours')
ON CONFLICT (id) DO NOTHING;

-- Likes on comments
INSERT INTO likes (user_id, likeable_type, likeable_id) VALUES
('00000000-0000-0000-0000-000000000001', 'comment', 'a0000001-0000-0000-0000-000000000001'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'comment', 'a0000001-0000-0000-0000-000000000001'),
('99999999-9999-9999-9999-999999999999', 'comment', 'a0000007-0000-0000-0000-000000000007'),
('11111111-1111-1111-1111-111111111111', 'comment', 'a0000007-0000-0000-0000-000000000007'),
('50505050-5050-5050-5050-505050505050', 'comment', 'a0000007-0000-0000-0000-000000000007')
ON CONFLICT (user_id, likeable_type, likeable_id) DO NOTHING;

-- ============================================================================
-- 9. MAILHILMI'S INTERACTIONS WITH OTHER POSTS
-- ============================================================================

-- Mailhilmi likes other posts
INSERT INTO likes (user_id, likeable_type, likeable_id) VALUES
('00000000-0000-0000-0000-000000000001', 'post', 'a0000001-0000-0000-0000-000000000001'),
('00000000-0000-0000-0000-000000000001', 'post', 'a0000003-0000-0000-0000-000000000003'),
('00000000-0000-0000-0000-000000000001', 'post', 'a0000008-0000-0000-0000-000000000008'),
('00000000-0000-0000-0000-000000000001', 'post', 'a0000011-0000-0000-0000-000000000011'),
('00000000-0000-0000-0000-000000000001', 'post', 'a0000017-0000-0000-0000-000000000017'),
('00000000-0000-0000-0000-000000000001', 'post', 'a0000021-0000-0000-0000-000000000021'),
('00000000-0000-0000-0000-000000000001', 'post', 'a0000034-0000-0000-0000-000000000034'),
('00000000-0000-0000-0000-000000000001', 'post', 'a0000042-0000-0000-0000-000000000042')
ON CONFLICT (user_id, likeable_type, likeable_id) DO NOTHING;

-- Mailhilmi comments on other posts
INSERT INTO comments (post_id, author_id, parent_comment_id, content, created_at) VALUES
('a0000008-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000001', NULL,
'Congrats on the deployment! 🎉 What stack did you use?', NOW() - INTERVAL '1 day'),
('a0000017-0000-0000-0000-000000000017', '00000000-0000-0000-0000-000000000001', NULL,
'Amazing news! Would love to hear more about your startup journey at my next meetup!', NOW() - INTERVAL '2 days'),
('a0000034-0000-0000-0000-000000000034', '00000000-0000-0000-0000-000000000001', NULL,
'The missing semicolon strikes again 😂 Classic developer life!', NOW() - INTERVAL '16 hours')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 10. COMMUNITIES
-- ============================================================================

INSERT INTO communities (id, name, slug, description, avatar_url, cover_url, creator_id, privacy, created_at) VALUES
('c0000001-0000-0000-0000-000000000001', 'Jakarta Developers', 'jakarta-developers',
'Community for software developers in Jakarta. Share knowledge, collaborate on projects, and grow together! 💻',
'https://images.unsplash.com/photo-1522071820081-009f0129c71c',
'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',
'00000000-0000-0000-0000-000000000001', 'public', NOW() - INTERVAL '6 months'),

('c0000002-0000-0000-0000-000000000002', 'Coffee & Tech', 'coffee-and-tech',
'Where caffeine meets code ☕💻 For developers who love good coffee!',
'https://images.unsplash.com/photo-1511920170033-f8396924c348',
'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
'00000000-0000-0000-0000-000000000001', 'public', NOW() - INTERVAL '4 months'),

('c0000003-0000-0000-0000-000000000003', 'Startup Founders Indonesia', 'startup-founders-id',
'Connect with fellow startup founders, share experiences, and support each other on the entrepreneurship journey 🚀',
'https://images.unsplash.com/photo-1559136555-9303baea8ebd',
'https://images.unsplash.com/photo-1552664730-d307ca884978',
'dddddddd-dddd-dddd-dddd-dddddddddddd', 'public', NOW() - INTERVAL '8 months')
ON CONFLICT (id) DO NOTHING;

-- Community members
INSERT INTO community_members (community_id, user_id, role) VALUES
-- Jakarta Developers (mailhilmi is owner)
('c0000001-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'owner'),
('c0000001-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999', 'admin'),
('c0000001-0000-0000-0000-000000000001', '50505050-5050-5050-5050-505050505050', 'moderator'),
('c0000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'member'),
('c0000001-0000-0000-0000-000000000001', '80808080-8080-8080-8080-808080808080', 'member'),
('c0000001-0000-0000-0000-000000000001', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'member'),
('c0000001-0000-0000-0000-000000000001', '10101010-1010-1010-1010-101010101010', 'member'),

-- Coffee & Tech (mailhilmi is owner)
('c0000002-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', 'owner'),
('c0000002-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'admin'),
('c0000002-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'member'),
('c0000002-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222', 'member'),

-- Startup Founders (mailhilmi is member)
('c0000003-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001', 'member'),
('c0000003-0000-0000-0000-000000000003', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'owner'),
('c0000003-0000-0000-0000-000000000003', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'admin'),
('c0000003-0000-0000-0000-000000000003', '99999999-9999-9999-9999-999999999999', 'member')
ON CONFLICT (community_id, user_id) DO NOTHING;

-- ============================================================================
-- 11. NOTIFICATIONS FOR MAILHILMI
-- ============================================================================

INSERT INTO notifications (user_id, actor_id, type, title, message, link, metadata, is_read, created_at) VALUES
-- Recent notifications (unread)
('00000000-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999', 'like_post',
'Doni Rahman liked your post',
'Liked: "Today I learned: PostgreSQL can be 10x faster..."',
'/posts/a0000007-0000-0000-0000-000000000007',
'{"post_id": "a0000007-0000-0000-0000-000000000007", "post_preview": "Today I learned: PostgreSQL can be 10x faster..."}',
false, NOW() - INTERVAL '2 hours'),

('00000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'comment_post',
'Rizki Maulana commented on your post',
'"That''s insane improvement! EXPLAIN ANALYZE is your best friend"',
'/posts/a0000007-0000-0000-0000-000000000007',
'{"post_id": "a0000007-0000-0000-0000-000000000007", "comment_id": "a0000011-0000-0000-0000-000000000011"}',
false, NOW() - INTERVAL '6 hours'),

('00000000-0000-0000-0000-000000000001', '70707070-7070-7070-7070-707070707070', 'follow',
'Putri Maharani started following you',
NULL,
'/users/70707070-7070-7070-7070-707070707070',
'{"follower_id": "70707070-7070-7070-7070-707070707070"}',
false, NOW() - INTERVAL '8 hours'),

('00000000-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999', 'event_reminder',
'Event starting tomorrow',
'Coffee & Code: Developer Meetup starts tomorrow at 2:00 PM',
'/events/a0000002-0000-0000-0000-000000000002',
'{"event_id": "a0000002-0000-0000-0000-000000000002", "event_title": "Coffee & Code: Developer Meetup"}',
false, NOW() - INTERVAL '12 hours'),

-- Older notifications (read)
('00000000-0000-0000-0000-000000000001', '50505050-5050-5050-5050-505050505050', 'like_post',
'Yuni Astuti liked your post',
'Liked: "Hot take: Learning one framework deeply is better..."',
'/posts/a0000004-0000-0000-0000-000000000004',
'{"post_id": "a0000004-0000-0000-0000-000000000004"}',
true, NOW() - INTERVAL '1 day'),

('00000000-0000-0000-0000-000000000001', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'comment_post',
'Sarah Amelia commented on your post',
'"Hot take indeed! But I think it depends on your role..."',
'/posts/a0000004-0000-0000-0000-000000000004',
'{"post_id": "a0000004-0000-0000-0000-000000000004", "comment_id": "a0000008-0000-0000-0000-000000000008"}',
true, NOW() - INTERVAL '5 days'),

('00000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'follow',
'Novi Indah started following you',
NULL,
'/users/eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
'{"follower_id": "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee"}',
true, NOW() - INTERVAL '2 days'),

('00000000-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'like_post',
'Rudi Hartono liked your post',
'Liked: "Excited to announce my upcoming React + Go workshop!"',
'/posts/a0000001-0000-0000-0000-000000000001',
'{"post_id": "a0000001-0000-0000-0000-000000000001"}',
true, NOW() - INTERVAL '3 days'),

('00000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'comment_post',
'Rizki Maulana commented on your post',
'"Will you cover GraphQL too or just REST?"',
'/posts/a0000001-0000-0000-0000-000000000001',
'{"post_id": "a0000001-0000-0000-0000-000000000001", "comment_id": "a0000003-0000-0000-0000-000000000003"}',
true, NOW() - INTERVAL '2 days'),

('00000000-0000-0000-0000-000000000001', '99999999-9999-9999-9999-999999999999', 'community_post',
'New post in Jakarta Developers',
'Doni Rahman posted: "New Golang 1.22 features are amazing! 🚀"',
'/communities/c0000001-0000-0000-0000-000000000001',
'{"community_id": "c0000001-0000-0000-0000-000000000001"}',
true, NOW() - INTERVAL '4 days'),

('00000000-0000-0000-0000-000000000001', NULL, 'system',
'Welcome to Anigmaa!',
'Complete your profile to get the most out of the platform',
'/profile/edit',
'{"action": "complete_profile"}',
true, NOW() - INTERVAL '30 days')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 12. UPDATE STATISTICS
-- ============================================================================

-- Update event attendee counts
UPDATE events e SET attendees_count = (
    SELECT COUNT(*) FROM event_attendees ea
    WHERE ea.event_id = e.id AND ea.status = 'confirmed'
)
WHERE e.host_id = '00000000-0000-0000-0000-000000000001';

-- Update user stats for followers/following
UPDATE user_stats
SET followers_count = (
    SELECT COUNT(*) FROM follows WHERE following_id = '00000000-0000-0000-0000-000000000001'
),
following_count = (
    SELECT COUNT(*) FROM follows WHERE follower_id = '00000000-0000-0000-0000-000000000001'
)
WHERE user_id = '00000000-0000-0000-0000-000000000001';


-- ============================================================================
-- MAILHILMI USER SEED SUMMARY
-- ============================================================================
-- User: mailhilmi (00000000-0000-0000-0000-000000000001)
-- - Complete profile with settings, stats, and privacy
-- - 12 followers, following 8 users
-- - 3 hosted events with attendees and Q&A
-- - 8 posts (mix of text, images, and event promotions)
-- - Active in 3 communities (owner of 2, member of 1)
-- - 11 notifications (4 unread, 7 read)
-- - Likes and comments on other users' content

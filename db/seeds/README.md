# Database Seed Data

Seed data lengkap untuk development dan testing.

## 📊 Isi Seed Data

### 1. Comprehensive Seed (`01_comprehensive_seed.sql`)
Data lengkap untuk testing aplikasi:
- **25 users** dengan profile, settings, stats, dan privacy
- **30 events** di berbagai kategori (coffee, food, gaming, sports, music, movies, study, art, other)
- **50 posts** dengan berbagai tipe (text, images, events)
- **60+ event attendees** (joins)
- **22 event Q&A** (pertanyaan dan jawaban)
- **70+ likes** pada posts
- **42 comments** (termasuk nested comments)
- **30+ likes** pada comments
- **20 follows** (social connections)

### 2. Mailhilmi User Seed (`02_mailhilmi_user_seed.sql`)
Data lengkap untuk user `mailhilmi`:
- Complete user profile dengan settings, stats, dan privacy
- 12 followers, following 8 users
- 3 hosted events dengan attendees dan Q&A
- 8 posts (text, images, event promotions)
- Member dari 3 communities (owner 2, member 1)
- 11 notifications (4 unread, 7 read)
- Active interactions (likes, comments)

## 🗄️ Migrations

### Required Migrations (jalankan berurutan):
1. `01_user_service.up.sql` - User tables
2. `02_event_service.up.sql` - Event tables
3. `03_post_service.up.sql` - Post tables
4. `04_ticket_service.up.sql` - Ticket tables
5. `05_community_notification_service.up.sql` - Communities & Notifications (BARU!)

## 🚀 Cara Menggunakan

### Opsi 1: Manual dengan psql

```bash
# 1. Jalankan migrations terlebih dahulu
psql -h localhost -U your_user -d your_database -f migrations/consolidated/01_user_service.up.sql
psql -h localhost -U your_user -d your_database -f migrations/consolidated/02_event_service.up.sql
psql -h localhost -U your_user -d your_database -f migrations/consolidated/03_post_service.up.sql
psql -h localhost -U your_user -d your_database -f migrations/consolidated/04_ticket_service.up.sql
psql -h localhost -U your_user -d your_database -f migrations/consolidated/05_community_notification_service.up.sql

# 2. Jalankan seed data
psql -h localhost -U your_user -d your_database -f db/seeds/01_comprehensive_seed.sql
psql -h localhost -U your_user -d your_database -f db/seeds/02_mailhilmi_user_seed.sql
```

### Opsi 2: Dengan Docker Compose

```bash
# 1. Start database
docker-compose up -d postgres

# 2. Tunggu database ready
sleep 5

# 3. Run migrations
docker-compose exec postgres psql -U anigmaa -d anigmaa_db -f /migrations/consolidated/01_user_service.up.sql
# ... (ulangi untuk semua migrations)

# 4. Run seeds
docker-compose exec postgres psql -U anigmaa -d anigmaa_db -f /db/seeds/01_comprehensive_seed.sql
docker-compose exec postgres psql -U anigmaa -d anigmaa_db -f /db/seeds/02_mailhilmi_user_seed.sql
```

### Opsi 3: One-liner (jika ada script)

```bash
make seed  # atau
npm run db:seed
```

## 📝 Catatan

### Fitur Baru: Communities & Notifications

Migration `05_community_notification_service.up.sql` menambahkan:

**Communities:**
- Table `communities` untuk grup/komunitas
- Table `community_members` untuk membership dengan roles (owner, admin, moderator, member)
- Privacy levels: public, private, secret
- Auto-updating member counts

**Notifications:**
- Table `notifications` untuk sistem notifikasi
- Tipe notifikasi: like_post, comment_post, mention, follow, event_invitation, event_reminder, event_update, community_invitation, community_post, system
- Metadata JSON untuk data tambahan
- Optimized indexes untuk unread notifications

### User Profile

Database sudah handle user profile dengan lengkap:
- **users**: Data dasar (email, username, bio, avatar)
- **user_settings**: Preferences (notifications, dark mode, language)
- **user_stats**: Statistics (events, posts, followers, reviews)
- **user_privacy**: Privacy settings (profile visibility, show email)

### Reset Database

Untuk reset database:

```bash
# Drop semua tables
psql -h localhost -U your_user -d your_database -f migrations/consolidated/05_community_notification_service.down.sql
psql -h localhost -U your_user -d your_database -f migrations/consolidated/04_ticket_service.down.sql
psql -h localhost -U your_user -d your_database -f migrations/consolidated/03_post_service.down.sql
psql -h localhost -U your_user -d your_database -f migrations/consolidated/02_event_service.down.sql
psql -h localhost -U your_user -d your_database -f migrations/consolidated/01_user_service.down.sql

# Kemudian jalankan ulang migrations dan seeds
```

## 🔍 Testing

Setelah seed data dijalankan, test dengan queries berikut:

```sql
-- Check user count
SELECT COUNT(*) FROM users;  -- Should be 26 (25 + mailhilmi)

-- Check mailhilmi profile
SELECT * FROM users WHERE username = 'mailhilmi';

-- Check mailhilmi's posts
SELECT * FROM posts WHERE author_id = '00000000-0000-0000-0000-000000000001';

-- Check unread notifications for mailhilmi
SELECT * FROM notifications
WHERE user_id = '00000000-0000-0000-0000-000000000001'
AND is_read = false;

-- Check mailhilmi's communities
SELECT c.* FROM communities c
JOIN community_members cm ON c.id = cm.community_id
WHERE cm.user_id = '00000000-0000-0000-0000-000000000001';

-- Check event counts
SELECT COUNT(*) FROM events;  -- Should be 33 (30 + 3 from mailhilmi)

-- Check post counts
SELECT COUNT(*) FROM posts;  -- Should be 58 (50 + 8 from mailhilmi)
```

## 📧 Support

Jika ada issue atau pertanyaan, silakan buat issue di repository.

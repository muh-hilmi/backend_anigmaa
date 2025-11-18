# Seed Data Files

Dokumentasi lengkap untuk seed data yang tersedia di database.

## Daftar Seed Files

### 1. `07_comprehensive_seed.sql`
**25 users + 50 events + 50 posts + interaksi**

Seed data comprehensive yang mencakup:
- 25 pengguna dengan profil lengkap (sudah ada bio untuk semua user)
- 50 events (mix antara completed dan upcoming events)
- 50 posts dengan berbagai tipe (text, images, event promotions)
- Likes, comments, dan interaksi antar user
- Event attendees dan Q&A

### 2. `08_mailhilmi_user_seed.sql`
**Data lengkap untuk user mailhilmi**

Seed khusus untuk user mailhilmi (00000000-0000-0000-0000-000000000001):
- Profil lengkap dengan bio: "Full-stack developer | Coffee enthusiast ☕ | Tech community builder 🚀 | Jakarta, Indonesia 📍"
- User settings, stats, dan privacy
- 3 events yang di-host
- 8 posts dengan berbagai konten
- 12 followers, following 8 users
- Member di 3 communities (owner di 2 community)
- 11 notifications (4 unread, 7 read)

### 3. `09_communities_seed.sql` ⭐ NEW
**12 communities dengan ~80 memberships**

Communities yang dibuat mencakup berbagai kategori:

#### Tech & Developer (3 communities)
- **Jakarta Tech Meetup** - Monthly meetup untuk software engineers
- **React Indonesia** - React.js community
- **Backend Engineers Indonesia** - Backend developer community

#### Coffee & Food (2 communities)
- **Jakarta Coffee Enthusiasts** - Specialty coffee lovers
- **Foodie Jakarta** - Food spots dan kuliner

#### Sports & Fitness (2 communities)
- **Jakarta Runners Club** - Running community
- **Badminton Jakarta** - Badminton players

#### Creative & Arts (2 communities)
- **Jakarta Photographers** - Photography community
- **Digital Artists Indonesia** - Digital artists & illustrators

#### Gaming & Entertainment (2 communities)
- **Gamers Jakarta** - Gaming community (PC, console, mobile)
- **Anime & Manga Indonesia** - Anime & manga enthusiasts

#### Lifestyle & Wellness (1 community)
- **Yoga & Mindfulness Jakarta** - Yoga & wellness community

Setiap community memiliki:
- Owner, admin, moderator, dan members dengan role yang jelas
- Member count yang auto-calculated
- Timestamps yang realistis
- Avatar dan cover image

### 4. `10_future_events_seed.sql` ⭐ NEW
**65 future events untuk 12 bulan ke depan (Nov 2025 - Oct 2026)**

Perfect untuk debugging dan testing event discovery features!

### 5. `11_event_attendees_future_seed.sql` ⭐ NEW
**Event attendees untuk future events - Support UI Explore!**

File ini menambahkan attendees ke future events untuk mendukung fitur UI explore:
- **"Banyak diikuti" / Popular / Trending**
- **"Local"** (sudah ada di event location data)
- **"Chill"** (casual events)

#### Distribusi per Kategori:
- **Coffee**: 12 events (latte art, cupping, roasting, brewing methods)
- **Food**: 11 events (various cuisines, cooking classes)
- **Study**: 12 events (tech workshops, bootcamps, seminars)
- **Sports**: 13 events (running, cycling, esports, traditional sports)
- **Other**: 17 events (photography, art, content creation, wellness)

#### Distribusi per Bulan:
- Nov 2025: 5 events
- Dec 2025: 8 events (holiday season special)
- Jan 2026: 6 events (New Year momentum)
- Feb 2026: 5 events (Valentine's theme)
- Mar 2026: 6 events
- Apr 2026: 5 events
- May 2026: 6 events
- Jun 2026: 5 events
- Jul 2026: 6 events
- Aug 2026: 5 events (Independence Day theme)
- Sep 2026: 5 events
- Oct 2026: 3 events

#### Highlight Events:
- **Weekend Latte Art Championship** (Nov 22, 2025)
- **Golang 1.23 Release Party** (Nov 24, 2025)
- **New Year Coffee Countdown Party** (Dec 31, 2025)
- **Half Marathon** (Jan 4, 2026)
- **Microservices Architecture Workshop** (Jan 10-11, 2026 - 2 days)
- **Barista Certification Course** (Jan 20-22, 2026 - 3 days)
- **Jakarta Coffee Festival 2026** (Oct 10-11, 2026 - 2 days, 5000 max attendees)

Fitur Events:
- Semua events set ke status 'upcoming'
- Diverse price points (gratis sampai 3.5M IDR)
- Lokasi spread across Jakarta dan sekitarnya
- Event images dari Unsplash
- Realistic start_time dan end_time
- Max attendees yang bervariasi

## UI Explore Support ⭐

Seed data sekarang **FULLY SUPPORT** untuk semua kategorisasi UI explore!

### ✅ SUPPORTED CATEGORIES:

#### 1. **"Banyak diikuti" / Popular / Trending**
```sql
-- Query untuk events paling populer
SELECT * FROM events
WHERE status = 'upcoming'
ORDER BY attendees_count DESC
LIMIT 10;
```

Event populer dalam seed:
- **Jakarta Coffee Festival 2026**: 150+ attendees (MEGA)
- **5K Fun Run Charity**: 85 attendees
- **Hacktoberfest Jakarta**: 55 attendees (FREE!)
- **Golang 1.23 Release Party**: 45 attendees (FREE!)
- **New Year Coffee Countdown**: 42 attendees

#### 2. **"Local" / Nearby**
```sql
-- Query untuk events di sekitar user (contoh: radius 5km)
SELECT *, (
    6371 * acos(
        cos(radians(-6.2088)) * cos(radians(location_lat)) *
        cos(radians(location_lng) - radians(106.8456)) +
        sin(radians(-6.2088)) * sin(radians(location_lat))
    )
) AS distance
FROM events
WHERE status = 'upcoming'
HAVING distance < 5
ORDER BY distance;
```

Semua events punya:
- `location_lat` (latitude)
- `location_lng` (longitude)
- `location_name` dan `location_address`
- Lokasi real di Jakarta & sekitarnya

#### 3. **"Chill" / Casual**
```sql
-- Query untuk chill events
SELECT * FROM events
WHERE status = 'upcoming'
AND (
    is_free = true
    OR price < 200000
)
AND attendees_count < 30
AND category IN ('coffee', 'food', 'other')
ORDER BY start_time;
```

Karakteristik "chill" events:
- Free atau harga terjangkau (< 200K)
- Peserta tidak terlalu banyak (< 30 orang)
- Kategori casual (coffee, food, other)
- Contoh: Coffee tasting, food tour, photography walk

#### 4. **"Trending" / Recently Popular**
```sql
-- Query untuk trending (banyak yang join akhir-akhir ini)
SELECT e.*, COUNT(ea.id) as recent_joins
FROM events e
LEFT JOIN event_attendees ea ON e.id = ea.event_id
WHERE e.status = 'upcoming'
AND ea.joined_at > NOW() - INTERVAL '7 days'
GROUP BY e.id
ORDER BY recent_joins DESC;
```

Event attendees punya `joined_at` timestamp!

#### 5. **"Free Events"**
```sql
-- Query untuk free events
SELECT * FROM events
WHERE status = 'upcoming'
AND is_free = true
ORDER BY start_time;
```

Free events dalam seed:
- Golang 1.23 Release Party
- Hacktoberfest Jakarta
- Coffee & Code Meetup
- Bike to Work Community Ride

#### 6. **"This Weekend" / "This Month"**
```sql
-- Events this weekend
SELECT * FROM events
WHERE status = 'upcoming'
AND start_time BETWEEN DATE_TRUNC('week', NOW()) + INTERVAL '5 days'
                   AND DATE_TRUNC('week', NOW()) + INTERVAL '7 days'
ORDER BY start_time;

-- Events this month
SELECT * FROM events
WHERE status = 'upcoming'
AND start_time BETWEEN DATE_TRUNC('month', NOW())
                   AND DATE_TRUNC('month', NOW()) + INTERVAL '1 month'
ORDER BY start_time;
```

65 events spread dari Nov 2025 - Oct 2026!

### Event Distribution untuk Testing:

| Category | Count | Example |
|----------|-------|---------|
| **MEGA Popular** (100+) | 1 | Jakarta Coffee Festival (150+) |
| **Very Popular** (40-99) | 5 | Golang Party, Fun Run, Hacktoberfest |
| **Popular** (20-39) | 3 | Latte Art Championship, Esports |
| **Medium** (10-19) | 4 | Street Food Tour, Photography Walk |
| **Small/Chill** (< 10) | 3 | Coffee Tasting, Workshops |

### Location Distribution:
- **Jakarta Selatan**: ~35% (SCBD, Senopati, Kemang, etc)
- **Jakarta Pusat**: ~25% (Monas, Thamrin, Senayan)
- **Jakarta Barat**: ~10% (Kota Tua, Taman Anggrek)
- **Jakarta Utara**: ~5% (Ancol)
- **Outside Jakarta**: ~25% (Bogor, Tangerang, Bandung)

## Cara Menjalankan Seed

### Option 1: Manual via psql
```bash
# Jalankan satu per satu sesuai urutan
psql -U postgres -d anigmaa -f migrations/consolidated/07_comprehensive_seed.sql
psql -U postgres -d anigmaa -f migrations/consolidated/08_mailhilmi_user_seed.sql
psql -U postgres -d anigmaa -f migrations/consolidated/09_communities_seed.sql
psql -U postgres -d anigmaa -f migrations/consolidated/10_future_events_seed.sql
psql -U postgres -d anigmaa -f migrations/consolidated/11_event_attendees_future_seed.sql  # PENTING untuk UI explore!
```

### Option 2: Via Docker
```bash
# Jika menggunakan docker-compose
docker-compose exec postgres psql -U postgres -d anigmaa -f /migrations/consolidated/09_communities_seed.sql
docker-compose exec postgres psql -U postgres -d anigmaa -f /migrations/consolidated/10_future_events_seed.sql
docker-compose exec postgres psql -U postgres -d anigmaa -f /migrations/consolidated/11_event_attendees_future_seed.sql
```

### Option 3: Jalankan semua sekaligus
```bash
cat migrations/consolidated/07_comprehensive_seed.sql \
    migrations/consolidated/08_mailhilmi_user_seed.sql \
    migrations/consolidated/09_communities_seed.sql \
    migrations/consolidated/10_future_events_seed.sql \
    migrations/consolidated/11_event_attendees_future_seed.sql \
    | psql -U postgres -d anigmaa
```

### Option 4: Jalankan hanya seed baru (communities + future events)
```bash
cat migrations/consolidated/09_communities_seed.sql \
    migrations/consolidated/10_future_events_seed.sql \
    migrations/consolidated/11_event_attendees_future_seed.sql \
    | psql -U postgres -d anigmaa
```

## Catatan Penting

1. **User Bio**: Semua 25 users di `07_comprehensive_seed.sql` sudah memiliki bio data yang lengkap dan variatif
2. **ON CONFLICT DO NOTHING**: Semua seed menggunakan `ON CONFLICT` clause sehingga aman untuk di-run multiple times
3. **Transactions**: Semua seed dibungkus dalam `BEGIN` dan `COMMIT` untuk data consistency
4. **Auto-calculated Stats**: Community member counts dan event attendees_count di-update otomatis
5. **Realistic Data**: Semua timestamps, prices, locations, dan attendee distributions dibuat realistis untuk testing yang lebih baik
6. **UI Explore Ready**: File `11_event_attendees_future_seed.sql` WAJIB di-run untuk support fitur "Banyak diikuti", "Trending", dll

## Testing Scenarios

Dengan seed data ini, Anda bisa test:

### 🔥 UI Explore Features (NEW!)
- **"Banyak diikuti"**: Sort by attendees_count DESC
- **"Local/Nearby"**: Filter by distance using lat/lng (Haversine formula)
- **"Chill"**: Filter by is_free OR price < 200K AND attendees < 30
- **"Trending"**: Recent joins (joined_at dalam 7 hari terakhir)
- **"Free Events"**: Filter by is_free = true
- **"This Weekend"**: Filter by date range
- **"Popular Categories"**: Group by category with count

### Event Discovery
- Filter by category (coffee, food, study, sports, other)
- Filter by date range (next week, next month, next year)
- Filter by price (free, paid, price range)
- Search by location (exact match or radius)
- Upcoming vs completed events
- Sort by popularity (attendees_count)
- Sort by date (upcoming first, soonest first)

### Community Features
- Browse communities by category
- Join/leave communities
- View community members with different roles
- Community stats (member count)
- Search communities

### User Profiles
- User with complete bio
- User stats (followers, following, events, posts)
- User settings dan privacy
- User's attended events
- User's hosted events

### Social Features
- Following/followers relationships
- Likes and comments
- Post creation and interactions
- Event attendees with status (confirmed, pending)
- Notifications

## Summary

Total seed data yang tersedia:
- **Users**: 25 users + 1 mailhilmi user = **26 users** (semua punya bio!)
- **Events**: ~50 past events + 65 future events = **115 events**
- **Event Attendees**: ~200+ attendees across events (support UI explore!)
- **Posts**: 50+ posts
- **Communities**: 12 communities
- **Community Memberships**: ~80 memberships with roles
- **Social Interactions**: Likes, comments, follows, notifications

### Seed Files List:
1. `07_comprehensive_seed.sql` - 25 users, 50 events, 50 posts, interaksi
2. `08_mailhilmi_user_seed.sql` - Data lengkap user mailhilmi
3. `09_communities_seed.sql` - 12 communities, 80 memberships ⭐ NEW
4. `10_future_events_seed.sql` - 65 future events (12 bulan) ⭐ NEW
5. `11_event_attendees_future_seed.sql` - Event attendees untuk UI explore ⭐ NEW

### ✅ Fitur yang FULLY SUPPORTED:
- ✅ UI Explore: Banyak diikuti, Local, Chill, Trending, Free
- ✅ Event Discovery: Filter, Search, Sort
- ✅ Communities: Browse, Join, Members
- ✅ Social: Follows, Likes, Comments, Notifications
- ✅ User Profiles: Bio, Stats, Settings

Seed data ini **comprehensive dan realistic** untuk development, testing, dan debugging! 🚀

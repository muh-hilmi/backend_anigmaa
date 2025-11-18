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

## Cara Menjalankan Seed

### Option 1: Manual via psql
```bash
# Jalankan satu per satu sesuai urutan
psql -U postgres -d anigmaa -f migrations/consolidated/07_comprehensive_seed.sql
psql -U postgres -d anigmaa -f migrations/consolidated/08_mailhilmi_user_seed.sql
psql -U postgres -d anigmaa -f migrations/consolidated/09_communities_seed.sql
psql -U postgres -d anigmaa -f migrations/consolidated/10_future_events_seed.sql
```

### Option 2: Via Docker
```bash
# Jika menggunakan docker-compose
docker-compose exec postgres psql -U postgres -d anigmaa -f /migrations/consolidated/09_communities_seed.sql
docker-compose exec postgres psql -U postgres -d anigmaa -f /migrations/consolidated/10_future_events_seed.sql
```

### Option 3: Jalankan semua sekaligus
```bash
cat migrations/consolidated/09_communities_seed.sql \
    migrations/consolidated/10_future_events_seed.sql \
    | psql -U postgres -d anigmaa
```

## Catatan Penting

1. **User Bio**: Semua 25 users di `07_comprehensive_seed.sql` sudah memiliki bio data yang lengkap dan variatif
2. **ON CONFLICT DO NOTHING**: Semua seed menggunakan `ON CONFLICT` clause sehingga aman untuk di-run multiple times
3. **Transactions**: Semua seed dibungkus dalam `BEGIN` dan `COMMIT` untuk data consistency
4. **Auto-calculated Stats**: Community member counts di-update otomatis
5. **Realistic Data**: Semua timestamps, prices, dan locations dibuat realistis untuk testing yang lebih baik

## Testing Scenarios

Dengan seed data ini, Anda bisa test:

### Event Discovery
- Filter by category (coffee, food, study, sports, other)
- Filter by date range (next week, next month, next year)
- Filter by price (free, paid, price range)
- Search by location
- Upcoming vs completed events

### Community Features
- Browse communities by category
- Join/leave communities
- View community members with different roles
- Community stats (member count)

### User Profiles
- User with complete bio
- User stats (followers, following, events, posts)
- User settings dan privacy

### Social Features
- Following/followers relationships
- Likes and comments
- Post creation and interactions
- Event attendees

## Summary

Total seed data yang tersedia:
- **Users**: 25 users + 1 mailhilmi user
- **Events**: ~50 past events + 65 future events = **115 events**
- **Posts**: 50+ posts
- **Communities**: 12 communities
- **Memberships**: ~80 community memberships
- **Interactions**: Likes, comments, follows, notifications

Seed data ini comprehensive dan realistic untuk development, testing, dan debugging! 🚀

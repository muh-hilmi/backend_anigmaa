# Auto-Migration Setup

## Cara Kerja

Aplikasi backend sekarang **otomatis menjalankan migration** setiap kali distart. Tidak perlu lagi menjalankan migration secara manual!

## Fitur

✅ **Auto-run migrations** - Semua file `.sql` di folder `migrations/` otomatis dijalankan
✅ **Tracking system** - Menggunakan tabel `schema_migrations` untuk tracking migration yang sudah dijalankan
✅ **Skip duplicate** - Migration yang sudah dijalankan tidak akan dijalankan lagi
✅ **Transaction-safe** - Setiap migration dijalankan dalam transaction, jadi kalau gagal akan rollback
✅ **Sorted execution** - Migration dijalankan berdasarkan urutan alfabet (001, 002, dst)

## File Migration

Migration file di folder `migrations/` akan dijalankan otomatis:

- `001_create_users_table.up.sql` - Create table users
- `002_create_events_table.up.sql` - Create table events
- `003_create_posts_table.up.sql` - Create table posts
- `...`
- `011_enhanced_seed_data.sql` - Seed data awal
- `012_add_bulk_events_and_posts.sql` - **100 events + 300 posts (Bahasa Gen Z Indo)** ⭐

## Cara Menggunakan

### 1. Jalankan aplikasi seperti biasa:

```bash
# Dengan docker-compose
docker-compose up --build

# Atau langsung
go run cmd/server/main.go
```

### 2. Lihat log startup

Anda akan melihat output seperti ini:

```
✓ Connected to PostgreSQL database
🔄 Starting database migrations...
✓ Executed migration: 001_create_users_table.up.sql
✓ Executed migration: 002_create_events_table.up.sql
...
✓ Executed migration: 012_add_bulk_events_and_posts.sql
✓ Successfully executed 12 migration(s)
```

### 3. Refresh aplikasi Flutter

Setelah backend start dengan migration baru, data seed yang baru (100 events + 300 posts dalam bahasa Gen Z Indo) akan langsung tersedia di database!

## Troubleshooting

### Jika ingin reset database dan jalankan ulang migration:

```bash
# Stop containers
docker-compose down

# Hapus volume database (akan menghapus semua data!)
docker-compose down -v

# Start ulang (migration akan dijalankan dari awal)
docker-compose up --build
```

### Jika ingin tambah migration baru:

1. Buat file baru di `migrations/` dengan format: `013_nama_migration.sql`
2. Restart aplikasi
3. Migration baru akan otomatis dijalankan!

## Struktur Kode

- **Migration runner**: `internal/infrastructure/database/migrate.go`
- **Main startup**: `cmd/server/main.go:71-74`
- **Migration files**: `migrations/*.sql`

---

**Catatan**: File `.down.sql` tidak dijalankan otomatis. Ini untuk rollback manual jika diperlukan.

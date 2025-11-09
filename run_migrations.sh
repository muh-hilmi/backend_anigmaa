#!/bin/bash
# Script untuk menjalankan migrations secara manual

echo "🚀 Starting migrations..."
echo ""

# Migration 015: Username and Profile Stats
echo "📝 Running migration 015: Username and Profile Stats..."
docker compose exec -T postgres psql -U postgres -d anigmaa < migrations/015_add_username_and_profile_stats.up.sql
if [ $? -eq 0 ]; then
    echo "✅ Migration 015 completed successfully!"
else
    echo "❌ Migration 015 failed!"
    exit 1
fi

echo ""

# Migration 016: Seed Data
echo "📝 Running migration 016: Seed Interactions and Events..."
docker compose exec -T postgres psql -U postgres -d anigmaa < migrations/016_seed_interactions_and_events.up.sql
if [ $? -eq 0 ]; then
    echo "✅ Migration 016 completed successfully!"
else
    echo "❌ Migration 016 failed!"
    exit 1
fi

echo ""
echo "🎉 All migrations completed!"
echo ""

# Verify results
echo "📊 Verification Results:"
echo ""

echo "1️⃣ Checking likes count..."
docker compose exec postgres psql -U postgres -d anigmaa -t -c "SELECT COUNT(*) AS total_likes FROM likes;"

echo "2️⃣ Checking comments count..."
docker compose exec postgres psql -U postgres -d anigmaa -t -c "SELECT COUNT(*) AS total_comments FROM comments;"

echo "3️⃣ Checking shares count..."
docker compose exec postgres psql -U postgres -d anigmaa -t -c "SELECT COUNT(*) AS total_shares FROM shares;"

echo "4️⃣ Checking users with username..."
docker compose exec postgres psql -U postgres -d anigmaa -t -c "SELECT COUNT(*) AS users_with_username FROM users WHERE username IS NOT NULL;"

echo "5️⃣ Top 5 Events by Attendance:"
docker compose exec postgres psql -U postgres -d anigmaa -c "SELECT title, attendees_count, max_attendees, CASE WHEN price IS NULL THEN 'FREE' ELSE 'Rp ' || price::TEXT END as price FROM events WHERE attendees_count > 0 ORDER BY attendees_count DESC LIMIT 5;"

echo ""
echo "✨ Done! Your database is ready for testing!"

#!/bin/bash
# Script untuk run migration 012

# Check if docker-compose is running
if docker-compose ps | grep -q "postgres"; then
    echo "Running migration 012..."
    docker-compose exec postgres psql -U postgres -d anigmaa_db -f /migrations/012_add_bulk_events_and_posts.sql
else
    echo "PostgreSQL container not running. Please start it first:"
    echo "docker-compose up -d postgres"
fi

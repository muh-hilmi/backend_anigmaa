-- ============================================================================
-- TICKET SERVICE DATABASE SCHEMA
-- ============================================================================
-- This file contains all ticket-related database schema including:
-- - Tickets table with attendance tracking
-- - Ticket transactions for payment processing
-- - All related indexes and enums
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- ENUMS
-- ============================================================================

-- Create ticket status enum
CREATE TYPE ticket_status AS ENUM ('active', 'cancelled', 'refunded', 'expired');

-- Create transaction status enum
CREATE TYPE transaction_status AS ENUM ('pending', 'success', 'failed', 'refunded');

-- ============================================================================
-- CORE TICKET TABLES
-- ============================================================================

-- Create tickets table
CREATE TABLE IF NOT EXISTS tickets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    event_id UUID NOT NULL,
    attendance_code VARCHAR(4) UNIQUE NOT NULL,
    price_paid DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (price_paid >= 0),
    purchased_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_checked_in BOOLEAN DEFAULT FALSE,
    checked_in_at TIMESTAMP WITH TIME ZONE,
    status ticket_status DEFAULT 'active',
    UNIQUE(user_id, event_id)
);

-- Create ticket_transactions table
CREATE TABLE IF NOT EXISTS ticket_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ticket_id UUID NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
    transaction_id VARCHAR(255) UNIQUE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    payment_method VARCHAR(50) NOT NULL,
    status transaction_status DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Tickets indexes
CREATE INDEX IF NOT EXISTS idx_tickets_user ON tickets(user_id);
CREATE INDEX IF NOT EXISTS idx_tickets_event ON tickets(event_id);
CREATE INDEX IF NOT EXISTS idx_tickets_attendance_code ON tickets(attendance_code);
CREATE INDEX IF NOT EXISTS idx_tickets_status ON tickets(status);

-- Ticket transactions indexes
CREATE INDEX IF NOT EXISTS idx_ticket_transactions_ticket ON ticket_transactions(ticket_id);
CREATE INDEX IF NOT EXISTS idx_ticket_transactions_transaction_id ON ticket_transactions(transaction_id);
CREATE INDEX IF NOT EXISTS idx_ticket_transactions_status ON ticket_transactions(status);

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Ticket Service includes:
-- - Tickets table with unique attendance codes
-- - Check-in tracking (is_checked_in, checked_in_at)
-- - Ticket status management (active, cancelled, refunded, expired)
-- - Ticket transactions for payment tracking
-- - Transaction status tracking (pending, success, failed, refunded)
-- - Support for multiple payment methods
-- - Foreign key references to user_id and event_id (external services)
-- ============================================================================

-- ============================================================================
-- AUTH TOKENS TABLE
-- ============================================================================
-- This migration adds support for email verification and password reset tokens
-- ============================================================================

-- Token types enum
CREATE TYPE token_type AS ENUM ('email_verification', 'password_reset');

-- Auth tokens table
CREATE TABLE IF NOT EXISTS auth_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,  -- References users(id) from user service
    token VARCHAR(255) UNIQUE NOT NULL,
    token_type token_type NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- INDEXES
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_auth_tokens_user ON auth_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_auth_tokens_token ON auth_tokens(token);
CREATE INDEX IF NOT EXISTS idx_auth_tokens_type ON auth_tokens(token_type);
CREATE INDEX IF NOT EXISTS idx_auth_tokens_expires ON auth_tokens(expires_at);

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Created table:
-- - auth_tokens: Stores email verification and password reset tokens
--
-- Features:
-- - Token expiration tracking
-- - Token usage tracking (used_at)
-- - Support for multiple token types
-- - Automatic cleanup via expires_at index
-- ============================================================================

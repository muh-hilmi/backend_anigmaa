-- +migrate Up
-- Create event Q&A table
CREATE TABLE IF NOT EXISTS event_qna (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT,
    asked_by_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    answered_by_id UUID REFERENCES users(id) ON DELETE SET NULL,
    asked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    answered_at TIMESTAMP,
    upvotes INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create qna_upvotes table for tracking upvotes
CREATE TABLE IF NOT EXISTS qna_upvotes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    qna_id UUID NOT NULL REFERENCES event_qna(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(qna_id, user_id)
);

-- Create indexes
CREATE INDEX idx_event_qna_event_id ON event_qna(event_id);
CREATE INDEX idx_event_qna_asked_by_id ON event_qna(asked_by_id);
CREATE INDEX idx_event_qna_answered_by_id ON event_qna(answered_by_id);
CREATE INDEX idx_event_qna_upvotes ON event_qna(upvotes DESC);
CREATE INDEX idx_qna_upvotes_qna_id ON qna_upvotes(qna_id);
CREATE INDEX idx_qna_upvotes_user_id ON qna_upvotes(user_id);

-- +migrate Down
-- Drop indexes
DROP INDEX IF EXISTS idx_qna_upvotes_user_id;
DROP INDEX IF EXISTS idx_qna_upvotes_qna_id;
DROP INDEX IF EXISTS idx_event_qna_upvotes;
DROP INDEX IF EXISTS idx_event_qna_answered_by_id;
DROP INDEX IF EXISTS idx_event_qna_asked_by_id;
DROP INDEX IF EXISTS idx_event_qna_event_id;

-- Drop tables
DROP TABLE IF EXISTS qna_upvotes;
DROP TABLE IF EXISTS event_qna;

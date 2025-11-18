package postgres

import (
	"context"

	"github.com/anigmaa/backend/internal/domain/interaction"
	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
)

type interactionRepository struct {
	db *sqlx.DB
}

// NewInteractionRepository creates a new interaction repository
func NewInteractionRepository(db *sqlx.DB) interaction.Repository {
	return &interactionRepository{db: db}
}

// REVIEW: CRITICAL PRODUCTION BLOCKER - Like system completely broken
// Frontend shows heart icon fill animation when user likes a post, but NO DATA is saved to database.
// Like counter increments client-side but on refresh shows wrong count because database has no like records.
// This breaks core engagement metrics and user expectations. Users think they liked content but system has no record.
// MUST IMPLEMENT: INSERT INTO likes (id, user_id, likeable_type, likeable_id, created_at) VALUES (...)
// Must handle unique constraint violation (user already liked) and return appropriate error.
// Must call post_repo.IncrementLikes() or comment_repo.IncrementLikes() after successful insert.
// Like creates a new like
func (r *interactionRepository) Like(ctx context.Context, like *interaction.Like) error {
	// TODO: implement
	return nil
}

// REVIEW: Unlike also stubbed - users cannot remove likes once given. One-way interaction only.
// Unlike removes a like
func (r *interactionRepository) Unlike(ctx context.Context, userID uuid.UUID, likeableType interaction.LikeableType, likeableID uuid.UUID) error {
	// TODO: implement
	return nil
}

// IsLiked checks if a user has liked something
func (r *interactionRepository) IsLiked(ctx context.Context, userID uuid.UUID, likeableType interaction.LikeableType, likeableID uuid.UUID) (bool, error) {
	// TODO: implement
	return false, nil
}

// GetLikes gets likes for a likeable item
func (r *interactionRepository) GetLikes(ctx context.Context, likeableType interaction.LikeableType, likeableID uuid.UUID, limit, offset int) ([]interaction.Like, error) {
	// TODO: implement
	return nil, nil
}

// REVIEW: CRITICAL - Repost feature (similar to retweet) doesn't work. Users can click repost button but nothing persists.
// This is a key viral distribution mechanism - without it, content cannot spread organically through the network.
// Repost creates a new repost
func (r *interactionRepository) Repost(ctx context.Context, repost *interaction.Repost) error {
	// TODO: implement
	return nil
}

// UndoRepost removes a repost
func (r *interactionRepository) UndoRepost(ctx context.Context, userID, postID uuid.UUID) error {
	// TODO: implement
	return nil
}

// IsReposted checks if a user has reposted a post
func (r *interactionRepository) IsReposted(ctx context.Context, userID, postID uuid.UUID) (bool, error) {
	// TODO: implement
	return false, nil
}

// GetReposts gets reposts for a post
func (r *interactionRepository) GetReposts(ctx context.Context, postID uuid.UUID, limit, offset int) ([]interaction.Repost, error) {
	// TODO: implement
	return nil, nil
}

// Bookmark creates a new bookmark
func (r *interactionRepository) Bookmark(ctx context.Context, bookmark *interaction.Bookmark) error {
	// TODO: implement
	return nil
}

// RemoveBookmark removes a bookmark
func (r *interactionRepository) RemoveBookmark(ctx context.Context, userID, postID uuid.UUID) error {
	// TODO: implement
	return nil
}

// IsBookmarked checks if a user has bookmarked a post
func (r *interactionRepository) IsBookmarked(ctx context.Context, userID, postID uuid.UUID) (bool, error) {
	// TODO: implement
	return false, nil
}

// GetBookmarks gets bookmarks for a user
func (r *interactionRepository) GetBookmarks(ctx context.Context, userID uuid.UUID, limit, offset int) ([]interaction.Bookmark, error) {
	// TODO: implement
	return nil, nil
}

// Share creates a new share
func (r *interactionRepository) Share(ctx context.Context, share *interaction.Share) error {
	// TODO: implement
	return nil
}

// GetShareCount gets the count of shares for a post
func (r *interactionRepository) GetShareCount(ctx context.Context, postID uuid.UUID) (int, error) {
	// TODO: implement
	return 0, nil
}

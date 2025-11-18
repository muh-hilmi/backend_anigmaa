package postgres

import (
	"context"

	"github.com/anigmaa/backend/internal/domain/comment"
	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
)

type commentRepository struct {
	db *sqlx.DB
}

// NewCommentRepository creates a new comment repository
func NewCommentRepository(db *sqlx.DB) comment.Repository {
	return &commentRepository{db: db}
}

// Create creates a new comment
func (r *commentRepository) Create(ctx context.Context, c *comment.Comment) error {
	// TODO: implement
	return nil
}

// GetByID gets a comment by ID
func (r *commentRepository) GetByID(ctx context.Context, commentID uuid.UUID) (*comment.Comment, error) {
	// TODO: implement
	return nil, nil
}

// GetWithDetails gets a comment with full details
func (r *commentRepository) GetWithDetails(ctx context.Context, commentID, userID uuid.UUID) (*comment.CommentWithDetails, error) {
	// TODO: implement
	return nil, nil
}

// Update updates a comment
func (r *commentRepository) Update(ctx context.Context, c *comment.Comment) error {
	// TODO: implement
	return nil
}

// Delete deletes a comment
func (r *commentRepository) Delete(ctx context.Context, commentID uuid.UUID) error {
	// TODO: implement
	return nil
}

// GetByPost gets comments for a post
func (r *commentRepository) GetByPost(ctx context.Context, postID, userID uuid.UUID, limit, offset int) ([]comment.CommentWithDetails, error) {
	query := `
		SELECT
			c.id,
			c.post_id,
			c.author_id,
			c.parent_comment_id,
			c.content,
			c.likes_count,
			c.created_at,
			c.updated_at,
			u.name as author_name,
			u.avatar_url as author_avatar,
			u.is_verified as author_is_verified,
			COALESCE(
				(SELECT COUNT(*) FROM likes
				 WHERE likeable_id = c.id
				 AND likeable_type = 'comment'
				 AND user_id = $1),
				0
			) > 0 as is_liked_by_user
		FROM comments c
		INNER JOIN users u ON c.author_id = u.id
		WHERE c.post_id = $2
		ORDER BY c.created_at DESC
		LIMIT $3 OFFSET $4
	`

	rows, err := r.db.QueryxContext(ctx, query, userID, postID, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var comments []comment.CommentWithDetails
	for rows.Next() {
		var c comment.CommentWithDetails

		err := rows.Scan(
			&c.ID,
			&c.PostID,
			&c.AuthorID,
			&c.ParentCommentID,
			&c.Content,
			&c.LikesCount,
			&c.CreatedAt,
			&c.UpdatedAt,
			&c.AuthorName,
			&c.AuthorAvatarURL,
			&c.AuthorIsVerified,
			&c.IsLikedByUser,
		)
		if err != nil {
			return nil, err
		}

		comments = append(comments, c)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	if comments == nil {
		comments = []comment.CommentWithDetails{}
	}

	return comments, nil
}

// GetReplies gets replies to a comment
func (r *commentRepository) GetReplies(ctx context.Context, parentCommentID, userID uuid.UUID, limit, offset int) ([]comment.CommentWithDetails, error) {
	// TODO: implement
	return nil, nil
}

// GetCount gets the count of comments for a post
func (r *commentRepository) GetCount(ctx context.Context, postID uuid.UUID) (int, error) {
	// TODO: implement
	return 0, nil
}

// IncrementLikes increments the likes count
func (r *commentRepository) IncrementLikes(ctx context.Context, commentID uuid.UUID) error {
	// TODO: implement
	return nil
}

// DecrementLikes decrements the likes count
func (r *commentRepository) DecrementLikes(ctx context.Context, commentID uuid.UUID) error {
	// TODO: implement
	return nil
}

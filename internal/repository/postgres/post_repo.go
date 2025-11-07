package postgres

import (
	"context"
	"encoding/json"
	"time"

	"github.com/anigmaa/backend/internal/domain/post"
	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
)

type postRepository struct {
	db *sqlx.DB
}

// NewPostRepository creates a new post repository
func NewPostRepository(db *sqlx.DB) post.Repository {
	return &postRepository{db: db}
}

// Create creates a new post
func (r *postRepository) Create(ctx context.Context, p *post.Post) error {
	// TODO: implement
	return nil
}

// GetByID gets a post by ID
func (r *postRepository) GetByID(ctx context.Context, postID uuid.UUID) (*post.Post, error) {
	// TODO: implement
	return nil, nil
}

// GetWithDetails gets a post with full details
func (r *postRepository) GetWithDetails(ctx context.Context, postID, userID uuid.UUID) (*post.PostWithDetails, error) {
	// TODO: implement
	return nil, nil
}

// Update updates a post
func (r *postRepository) Update(ctx context.Context, p *post.Post) error {
	// TODO: implement
	return nil
}

// Delete deletes a post
func (r *postRepository) Delete(ctx context.Context, postID uuid.UUID) error {
	// TODO: implement
	return nil
}

// List lists posts with filters
func (r *postRepository) List(ctx context.Context, filter *post.PostFilter, userID uuid.UUID) ([]post.PostWithDetails, error) {
	// TODO: implement
	return nil, nil
}

// GetFeed gets the feed for a user
func (r *postRepository) GetFeed(ctx context.Context, userID uuid.UUID, limit, offset int) ([]post.PostWithDetails, error) {
	query := `
		SELECT
			p.id, p.author_id, p.content, p.type, p.attached_event_id,
			p.original_post_id, p.visibility, p.created_at, p.updated_at,
			p.likes_count, p.comments_count, p.reposts_count, p.shares_count,
			u.name as author_name, u.avatar_url as author_avatar_url, u.is_verified as author_is_verified,
			EXISTS(SELECT 1 FROM likes WHERE user_id = $1 AND likeable_type = 'post' AND likeable_id = p.id) as is_liked_by_user,
			EXISTS(SELECT 1 FROM bookmarks WHERE user_id = $1 AND post_id = p.id) as is_bookmarked_by_user,
			EXISTS(SELECT 1 FROM reposts WHERE user_id = $1 AND post_id = p.id) as is_reposted_by_user,
			COALESCE(
				(SELECT json_agg(image_url ORDER BY order_index)
				 FROM post_images WHERE post_id = p.id), '[]'::json
			) as image_urls,
			e.id as event_id, e.title as event_title, e.description as event_description,
			e.category as event_category, e.start_time as event_start_time, e.end_time as event_end_time,
			e.location_name as event_location_name, e.location_address as event_location_address,
			e.location_lat as event_location_lat, e.location_lng as event_location_lng,
			e.host_id as event_host_id, eh.name as event_host_name, eh.avatar_url as event_host_avatar_url,
			e.max_attendees as event_max_attendees, e.price as event_price, e.is_free as event_is_free,
			e.status as event_status, e.privacy as event_privacy,
			COALESCE(
				(SELECT json_agg(image_url ORDER BY order_index)
				 FROM event_images WHERE event_id = e.id), '[]'::json
			) as event_image_urls
		FROM posts p
		INNER JOIN users u ON p.author_id = u.id
		LEFT JOIN events e ON p.attached_event_id = e.id
		LEFT JOIN users eh ON e.host_id = eh.id
		WHERE p.visibility = 'public'
		ORDER BY p.created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := r.db.QueryxContext(ctx, query, userID, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var posts []post.PostWithDetails
	for rows.Next() {
		var p post.PostWithDetails
		var imageURLs []byte
		var eventImageURLs []byte

		// Event fields (nullable)
		var eventID, eventHostID *uuid.UUID
		var eventTitle, eventDescription, eventCategory *string
		var eventStartTime, eventEndTime *time.Time
		var eventLocationName, eventLocationAddress *string
		var eventLocationLat, eventLocationLng *float64
		var eventHostName, eventHostAvatarURL *string
		var eventMaxAttendees *int
		var eventPrice *float64
		var eventIsFree *bool
		var eventStatus, eventPrivacy *string

		err := rows.Scan(
			&p.ID, &p.AuthorID, &p.Content, &p.Type, &p.AttachedEventID,
			&p.OriginalPostID, &p.Visibility, &p.CreatedAt, &p.UpdatedAt,
			&p.LikesCount, &p.CommentsCount, &p.RepostsCount, &p.SharesCount,
			&p.AuthorName, &p.AuthorAvatarURL, &p.AuthorIsVerified,
			&p.IsLikedByUser, &p.IsBookmarkedByUser, &p.IsRepostedByUser,
			&imageURLs,
			&eventID, &eventTitle, &eventDescription, &eventCategory,
			&eventStartTime, &eventEndTime,
			&eventLocationName, &eventLocationAddress, &eventLocationLat, &eventLocationLng,
			&eventHostID, &eventHostName, &eventHostAvatarURL,
			&eventMaxAttendees, &eventPrice, &eventIsFree,
			&eventStatus, &eventPrivacy,
			&eventImageURLs,
		)
		if err != nil {
			return nil, err
		}

		// Parse image URLs from JSON
		if len(imageURLs) > 0 && string(imageURLs) != "[]" {
			if err := json.Unmarshal(imageURLs, &p.ImageURLs); err == nil {
				// Successfully unmarshaled
			}
		}

		// Populate attached event if exists
		if eventID != nil && eventTitle != nil {
			eventSummary := &post.EventSummary{
				ID:       *eventID,
				Title:    *eventTitle,
				IsFree:   *eventIsFree,
			}

			// Set basic fields
			if eventCategory != nil {
				eventSummary.Category = *eventCategory
			}
			if eventDescription != nil {
				eventSummary.Description = *eventDescription
			}
			if eventStatus != nil {
				eventSummary.Status = *eventStatus
			}
			if eventPrivacy != nil {
				eventSummary.Privacy = *eventPrivacy
			}
			if eventMaxAttendees != nil {
				eventSummary.MaxAttendees = *eventMaxAttendees
			}

			// Set event times
			if eventStartTime != nil {
				eventSummary.StartTime = *eventStartTime
			}
			if eventEndTime != nil {
				eventSummary.EndTime = *eventEndTime
			}

			// Set location
			if eventLocationName != nil {
				eventSummary.Location = *eventLocationName
			}
			if eventLocationAddress != nil {
				eventSummary.LocationAddress = *eventLocationAddress
			}
			if eventLocationLat != nil {
				eventSummary.LocationLat = *eventLocationLat
			}
			if eventLocationLng != nil {
				eventSummary.LocationLng = *eventLocationLng
			}

			// Set price if not free
			if !*eventIsFree && eventPrice != nil {
				eventSummary.Price = eventPrice
			}

			// Parse event image URLs
			if len(eventImageURLs) > 0 && string(eventImageURLs) != "[]" {
				var imageUrls []string
				if err := json.Unmarshal(eventImageURLs, &imageUrls); err == nil {
					eventSummary.ImageURLs = imageUrls
				}
			}

			// Set host info
			if eventHostID != nil && eventHostName != nil {
				eventSummary.HostID = *eventHostID
				eventSummary.HostName = *eventHostName
				eventSummary.HostAvatarURL = eventHostAvatarURL
			}

			p.AttachedEvent = eventSummary
		}

		posts = append(posts, p)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return posts, nil
}

// GetUserPosts gets posts by a specific user
func (r *postRepository) GetUserPosts(ctx context.Context, authorID, viewerID uuid.UUID, limit, offset int) ([]post.PostWithDetails, error) {
	// TODO: implement
	return nil, nil
}

// AddImages adds images to a post
func (r *postRepository) AddImages(ctx context.Context, images []post.PostImage) error {
	// TODO: implement
	return nil
}

// GetImages gets images for a post
func (r *postRepository) GetImages(ctx context.Context, postID uuid.UUID) ([]string, error) {
	// TODO: implement
	return nil, nil
}

// IncrementLikes increments the likes count
func (r *postRepository) IncrementLikes(ctx context.Context, postID uuid.UUID) error {
	// TODO: implement
	return nil
}

// DecrementLikes decrements the likes count
func (r *postRepository) DecrementLikes(ctx context.Context, postID uuid.UUID) error {
	// TODO: implement
	return nil
}

// IncrementComments increments the comments count
func (r *postRepository) IncrementComments(ctx context.Context, postID uuid.UUID) error {
	// TODO: implement
	return nil
}

// DecrementComments decrements the comments count
func (r *postRepository) DecrementComments(ctx context.Context, postID uuid.UUID) error {
	// TODO: implement
	return nil
}

// IncrementReposts increments the reposts count
func (r *postRepository) IncrementReposts(ctx context.Context, postID uuid.UUID) error {
	// TODO: implement
	return nil
}

// DecrementReposts decrements the reposts count
func (r *postRepository) DecrementReposts(ctx context.Context, postID uuid.UUID) error {
	// TODO: implement
	return nil
}

// IncrementShares increments the shares count
func (r *postRepository) IncrementShares(ctx context.Context, postID uuid.UUID) error {
	// TODO: implement
	return nil
}

package event

import (
	"time"

	"github.com/google/uuid"
)

// EventStatus represents the status of an event
type EventStatus string

// REVIEW: ENUM VALUE MISMATCH - Backend uses "completed" but frontend EventStatus enum might use "ended".
// Check frontend enum definition and ensure consistency. When backend returns event with status="completed",
// frontend must be able to parse it correctly. If frontend expects "ended", this will cause parsing failures.
// Standardize on ONE value across both systems - recommend "completed" as it's more semantically accurate.
const (
	StatusUpcoming  EventStatus = "upcoming"
	StatusOngoing   EventStatus = "ongoing"
	StatusCompleted EventStatus = "completed"
	StatusCancelled EventStatus = "cancelled"
)

// EventPrivacy represents the privacy level of an event
type EventPrivacy string

const (
	PrivacyPublic      EventPrivacy = "public"
	PrivacyPrivate     EventPrivacy = "private"
	PrivacyFriendsOnly EventPrivacy = "friends_only"
)

// EventCategory represents the category/vibe of an event
type EventCategory string

const (
	CategoryMeetup     EventCategory = "meetup"
	CategorySports     EventCategory = "sports"
	CategoryWorkshop   EventCategory = "workshop"
	CategoryNetworking EventCategory = "networking"
	CategoryFood       EventCategory = "food"
	CategoryCreative   EventCategory = "creative"
	CategoryOutdoor    EventCategory = "outdoor"
	CategoryFitness    EventCategory = "fitness"
	CategoryLearning   EventCategory = "learning"
	CategorySocial     EventCategory = "social"
)

// Event represents a hangout event
type Event struct {
	ID               uuid.UUID     `json:"id" db:"id"`
	HostID           uuid.UUID     `json:"host_id" db:"host_id"`
	Title            string        `json:"title" db:"title"`
	Description      string        `json:"description" db:"description"`
	Category         EventCategory `json:"category" db:"category"`
	StartTime        time.Time     `json:"start_time" db:"start_time"`
	EndTime          time.Time     `json:"end_time" db:"end_time"`
	LocationName     string        `json:"location_name" db:"location_name"`
	LocationAddress  string        `json:"location_address" db:"location_address"`
	LocationLat      float64       `json:"location_lat" db:"location_lat"`
	LocationLng      float64       `json:"location_lng" db:"location_lng"`
	MaxAttendees     int           `json:"max_attendees" db:"max_attendees"`
	Price            *float64      `json:"price,omitempty" db:"price"`
	IsFree           bool          `json:"is_free" db:"is_free"`
	Status           EventStatus   `json:"status" db:"status"`
	Privacy          EventPrivacy  `json:"privacy" db:"privacy"`
	Requirements     *string       `json:"requirements,omitempty" db:"requirements"`
	TicketingEnabled bool          `json:"ticketing_enabled" db:"ticketing_enabled"`
	TicketsSold      int           `json:"tickets_sold" db:"tickets_sold"`
	CreatedAt        time.Time     `json:"created_at" db:"created_at"`
	UpdatedAt        time.Time     `json:"updated_at" db:"updated_at"`
}

// EventWithDetails includes additional event information
type EventWithDetails struct {
	Event
	HostName        string    `json:"host_name" db:"host_name"`
	HostAvatarURL   *string   `json:"host_avatar_url" db:"host_avatar_url"`
	ImageURLs       []string  `json:"image_urls" db:"-"`
	AttendeesCount  int       `json:"attendees_count" db:"attendees_count"`
	IsUserAttending bool      `json:"is_user_attending" db:"is_user_attending"`
	IsUserHost      bool      `json:"is_user_host" db:"is_user_host"`
	Distance        *float64  `json:"distance,omitempty" db:"distance"` // Distance in km from user
}

// EventAttendee represents an event attendee
type EventAttendee struct {
	ID        uuid.UUID       `json:"id" db:"id"`
	EventID   uuid.UUID       `json:"event_id" db:"event_id"`
	UserID    uuid.UUID       `json:"user_id" db:"user_id"`
	JoinedAt  time.Time       `json:"joined_at" db:"joined_at"`
	Status    AttendeeStatus  `json:"status" db:"status"`
}

// AttendeeStatus represents the status of an attendee
type AttendeeStatus string

const (
	AttendeePending   AttendeeStatus = "pending"
	AttendeeConfirmed AttendeeStatus = "confirmed"
	AttendeeCancelled AttendeeStatus = "cancelled"
)

// EventImage represents an event image
type EventImage struct {
	ID       uuid.UUID `json:"id" db:"id"`
	EventID  uuid.UUID `json:"event_id" db:"event_id"`
	ImageURL string    `json:"image_url" db:"image_url"`
	Order    int       `json:"order" db:"order_index"`
}

// CreateEventRequest represents event creation data
type CreateEventRequest struct {
	Title            string        `json:"title" binding:"required,min=3,max=100"`
	Description      string        `json:"description" binding:"required,min=10"`
	Category         EventCategory `json:"category" binding:"required"`
	StartTime        time.Time     `json:"start_time" binding:"required"`
	EndTime          time.Time     `json:"end_time" binding:"required"`
	LocationName     string        `json:"location_name" binding:"required"`
	LocationAddress  string        `json:"location_address" binding:"required"`
	LocationLat      float64       `json:"location_lat" binding:"required,min=-90,max=90"`
	LocationLng      float64       `json:"location_lng" binding:"required,min=-180,max=180"`
	MaxAttendees     int           `json:"max_attendees" binding:"required,min=2,max=1000"`
	Price            *float64      `json:"price,omitempty" binding:"omitempty,min=0"`
	IsFree           bool          `json:"is_free"`
	Privacy          EventPrivacy  `json:"privacy" binding:"required"`
	Requirements     *string       `json:"requirements,omitempty"`
	TicketingEnabled bool          `json:"ticketing_enabled"`
	ImageURLs        []string      `json:"image_urls,omitempty"`
}

// UpdateEventRequest represents event update data
type UpdateEventRequest struct {
	Title            *string        `json:"title,omitempty" binding:"omitempty,min=3,max=100"`
	Description      *string        `json:"description,omitempty" binding:"omitempty,min=10"`
	Category         *EventCategory `json:"category,omitempty"`
	StartTime        *time.Time     `json:"start_time,omitempty"`
	EndTime          *time.Time     `json:"end_time,omitempty"`
	LocationName     *string        `json:"location_name,omitempty"`
	LocationAddress  *string        `json:"location_address,omitempty"`
	LocationLat      *float64       `json:"location_lat,omitempty" binding:"omitempty,min=-90,max=90"`
	LocationLng      *float64       `json:"location_lng,omitempty" binding:"omitempty,min=-180,max=180"`
	MaxAttendees     *int           `json:"max_attendees,omitempty" binding:"omitempty,min=2,max=1000"`
	Price            *float64       `json:"price,omitempty" binding:"omitempty,min=0"`
	Privacy          *EventPrivacy  `json:"privacy,omitempty"`
	Requirements     *string        `json:"requirements,omitempty"`
	Status           *EventStatus   `json:"status,omitempty"`
}

// EventFilter represents event filtering options
type EventFilter struct {
	Category  *EventCategory `form:"category"`
	StartDate *time.Time     `form:"start_date"`
	EndDate   *time.Time     `form:"end_date"`
	IsFree    *bool          `form:"is_free"`
	Status    *EventStatus   `form:"status"`
	Lat       *float64       `form:"lat"`
	Lng       *float64       `form:"lng"`
	Radius    *float64       `form:"radius"` // in kilometers
	Limit     int            `form:"limit"`
	Offset    int            `form:"offset"`
}

// Business logic methods
func (e *Event) IsFull() bool {
	return e.TicketsSold >= e.MaxAttendees
}

func (e *Event) IsStartingSoon() bool {
	return time.Until(e.StartTime) < 2*time.Hour
}

func (e *Event) IsOngoing() bool {
	now := time.Now()
	return now.After(e.StartTime) && now.Before(e.EndTime)
}

func (e *Event) IsCompleted() bool {
	return time.Now().After(e.EndTime)
}

func (e *Event) SpotsLeft() int {
	return e.MaxAttendees - e.TicketsSold
}

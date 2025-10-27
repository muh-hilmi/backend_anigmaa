package user

import (
	"time"

	"github.com/google/uuid"
)

// User represents a user in the system
type User struct {
	ID              uuid.UUID  `json:"id" db:"id"`
	Email           string     `json:"email" db:"email"`
	PasswordHash    string     `json:"-" db:"password_hash"`
	Name            string     `json:"name" db:"name"`
	Bio             *string    `json:"bio,omitempty" db:"bio"`
	AvatarURL       *string    `json:"avatar_url,omitempty" db:"avatar_url"`
	CreatedAt       time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at" db:"updated_at"`
	LastLoginAt     *time.Time `json:"last_login_at,omitempty" db:"last_login_at"`
	IsVerified      bool       `json:"is_verified" db:"is_verified"`
	IsEmailVerified bool       `json:"is_email_verified" db:"is_email_verified"`
}

// UserSettings contains user preferences
type UserSettings struct {
	UserID             uuid.UUID `json:"user_id" db:"user_id"`
	PushNotifications  bool      `json:"push_notifications" db:"push_notifications"`
	EmailNotifications bool      `json:"email_notifications" db:"email_notifications"`
	DarkMode           bool      `json:"dark_mode" db:"dark_mode"`
	Language           string    `json:"language" db:"language"`
	LocationEnabled    bool      `json:"location_enabled" db:"location_enabled"`
	ShowOnlineStatus   bool      `json:"show_online_status" db:"show_online_status"`
}

// UserStats contains user statistics
type UserStats struct {
	UserID         uuid.UUID `json:"user_id" db:"user_id"`
	EventsAttended int       `json:"events_attended" db:"events_attended"`
	EventsCreated  int       `json:"events_created" db:"events_created"`
	FollowersCount int       `json:"followers_count" db:"followers_count"`
	FollowingCount int       `json:"following_count" db:"following_count"`
	ReviewsGiven   int       `json:"reviews_given" db:"reviews_given"`
	AverageRating  float64   `json:"average_rating" db:"average_rating"`
}

// UserPrivacy contains privacy settings
type UserPrivacy struct {
	UserID         uuid.UUID `json:"user_id" db:"user_id"`
	ProfileVisible bool      `json:"profile_visible" db:"profile_visible"`
	EventsVisible  bool      `json:"events_visible" db:"events_visible"`
	AllowFollowers bool      `json:"allow_followers" db:"allow_followers"`
	ShowEmail      bool      `json:"show_email" db:"show_email"`
	ShowLocation   bool      `json:"show_location" db:"show_location"`
}

// Follow represents a follow relationship
type Follow struct {
	ID          uuid.UUID `json:"id" db:"id"`
	FollowerID  uuid.UUID `json:"follower_id" db:"follower_id"`
	FollowingID uuid.UUID `json:"following_id" db:"following_id"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}

// UserProfile is a complete user profile with stats and settings
type UserProfile struct {
	User     User         `json:"user"`
	Settings UserSettings `json:"settings"`
	Stats    UserStats    `json:"stats"`
	Privacy  UserPrivacy  `json:"privacy"`
}

// RegisterRequest represents user registration data
type RegisterRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=8"`
	Name     string `json:"name" binding:"required,min=2"`
}

// LoginRequest represents user login credentials
type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

// UpdateProfileRequest represents profile update data
type UpdateProfileRequest struct {
	Name      *string `json:"name,omitempty" binding:"omitempty,min=2"`
	Bio       *string `json:"bio,omitempty"`
	AvatarURL *string `json:"avatar_url,omitempty"`
}

// UpdateSettingsRequest represents settings update data
type UpdateSettingsRequest struct {
	PushNotifications  *bool   `json:"push_notifications,omitempty"`
	EmailNotifications *bool   `json:"email_notifications,omitempty"`
	DarkMode           *bool   `json:"dark_mode,omitempty"`
	Language           *string `json:"language,omitempty"`
	LocationEnabled    *bool   `json:"location_enabled,omitempty"`
	ShowOnlineStatus   *bool   `json:"show_online_status,omitempty"`
}

// GoogleAuthRequest represents Google authentication data
type GoogleAuthRequest struct {
	IDToken string `json:"idToken" binding:"required"`
}

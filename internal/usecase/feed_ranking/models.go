package feed_ranking

import (
	"time"
)

// RankingRequest represents the JSON input for the ranking agent
type RankingRequest struct {
	UserProfile UserProfile    `json:"user_profile"`
	Contents    Contents       `json:"contents"`
	TodayWindow *TodayWindow   `json:"today_window,omitempty"`
}

// UserProfile contains user preferences and history for personalization
type UserProfile struct {
	ID              string             `json:"id"`
	PreferredTags   map[string]float64 `json:"preferred_tags"`    // tag -> weight
	LikedContents   []string           `json:"liked_contents"`    // content IDs
	FollowedAuthors []string           `json:"followed_authors"`  // author IDs
	AvgViewTimeMs   int64              `json:"avg_view_time_ms"`  // user engagement level
	SkipRate        float64            `json:"skip_rate"`         // content skip rate
	Location        *Location          `json:"location,omitempty"`
	Timezone        string             `json:"timezone"`
}

// Location represents geographic coordinates
type Location struct {
	City      string   `json:"city,omitempty"`
	Latitude  *float64 `json:"latitude,omitempty"`
	Longitude *float64 `json:"longitude,omitempty"`
}

// Contents contains all candidate events and posts
type Contents struct {
	Events []Event `json:"events"`
	Posts  []Post  `json:"posts"`
}

// Event represents an event with metrics
type Event struct {
	ID          string     `json:"id"`
	Title       string     `json:"title"`
	Description string     `json:"description"`
	CreatedAt   time.Time  `json:"created_at"`
	StartTime   time.Time  `json:"start_time"`
	City        string     `json:"city,omitempty"`
	PriceCents  int        `json:"price_cents"` // 0 = free
	Capacity    int        `json:"capacity"`    // max attendees
	Mood        string     `json:"mood,omitempty"`
	Tags        []string   `json:"tags"`
	Metrics     Metrics    `json:"metrics"`
	Visibility  string     `json:"visibility"` // public, private, followers
	Status      string     `json:"status"`     // published, draft, cancelled
	AuthorID    string     `json:"author_id,omitempty"`
	Location    *Location  `json:"location,omitempty"`
}

// Post represents a post with metrics
type Post struct {
	ID         string    `json:"id"`
	Caption    string    `json:"caption"`
	CreatedAt  time.Time `json:"created_at"`
	Tags       []string  `json:"tags"`
	Metrics    Metrics   `json:"metrics"`
	Visibility string    `json:"visibility"` // public, private, followers
	Status     string    `json:"status"`     // published, draft
	AuthorID   string    `json:"author_id,omitempty"`
}

// Metrics contains engagement signals
type Metrics struct {
	Views24h   int   `json:"views_24h"`
	Likes24h   int   `json:"likes_24h"`
	Shares24h  int   `json:"shares_24h"`
	Saves      int   `json:"saves"`      // bookmarks
	AvgViewMs  int64 `json:"avg_view_ms"` // average view time
	Comments   int   `json:"comments,omitempty"`
}

// TodayWindow defines the time range for "today" in user's timezone
type TodayWindow struct {
	StartUTC time.Time `json:"start_utc"`
	EndUTC   time.Time `json:"end_utc"`
}

// RankingResponse represents the JSON output with ranked content IDs
type RankingResponse struct {
	TrendingEvent   []string `json:"trending_event"`   // global trending event
	ForYouPosts     []string `json:"for_you_posts"`    // personalized posts
	ForYouEvents    []string `json:"for_you_events"`   // personalized events
	ChillEvents     []string `json:"chill_events"`     // intimate/relaxed events
	HariIniEvents   []string `json:"hari_ini_events"`  // events happening today
	GratisEvents    []string `json:"gratis_events"`    // free events
	BayarEvents     []string `json:"bayar_events"`     // paid events
}

// ScoredContent holds a content ID with its computed score
type ScoredContent struct {
	ID    string
	Score float64
}

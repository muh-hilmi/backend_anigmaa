package discovery

import (
	"context"
	"errors"
	"math"
	"time"

	"github.com/anigmaa/backend/internal/domain/event"
	"github.com/anigmaa/backend/internal/domain/user"
	"github.com/google/uuid"
)

var (
	ErrNoEventsFound = errors.New("no matching events found")
	ErrUserNotFound  = errors.New("user not found")
)

// MatchPreferences represents user preferences for event matching
type MatchPreferences struct {
	Categories   []event.EventCategory `json:"categories,omitempty"`
	MaxDistance  *float64              `json:"max_distance,omitempty"`   // in kilometers
	MaxPrice     *float64              `json:"max_price,omitempty"`
	FreeOnly     bool                  `json:"free_only"`
	StartTimeMin *time.Time            `json:"start_time_min,omitempty"`
	StartTimeMax *time.Time            `json:"start_time_max,omitempty"`
}

// MatchResult represents a matched event with score
type MatchResult struct {
	Event    *event.EventWithDetails `json:"event"`
	Score    float64                 `json:"score"`     // 0-100
	Distance *float64                `json:"distance,omitempty"` // in kilometers
	Reason   string                  `json:"reason"`    // Why this event was matched
}

// Matcher handles event discovery and matching logic
type Matcher struct {
	eventRepo event.Repository
	userRepo  user.Repository
}

// NewMatcher creates a new discovery matcher
func NewMatcher(eventRepo event.Repository, userRepo user.Repository) *Matcher {
	return &Matcher{
		eventRepo: eventRepo,
		userRepo:  userRepo,
	}
}

// FindMatch finds matching events for a user (the "gabut button" feature)
// This is a simple matching algorithm that can be enhanced over time
func (m *Matcher) FindMatch(ctx context.Context, userID uuid.UUID, userLat, userLng *float64, prefs *MatchPreferences) ([]MatchResult, error) {
	// Get user to personalize results
	currentUser, err := m.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, ErrUserNotFound
	}

	// Build event filter
	filter := &event.EventFilter{
		Status: func() *event.EventStatus { s := event.StatusUpcoming; return &s }(),
		Limit:  50, // Get more events to score and rank
		Offset: 0,
	}

	// Apply preferences
	if prefs != nil {
		if len(prefs.Categories) > 0 {
			// For simplicity, just use the first category
			// In production, you'd want to query multiple categories
			filter.Category = &prefs.Categories[0]
		}

		if prefs.FreeOnly {
			isFree := true
			filter.IsFree = &isFree
		}

		if prefs.StartTimeMin != nil {
			filter.StartDate = prefs.StartTimeMin
		}

		if prefs.StartTimeMax != nil {
			filter.EndDate = prefs.StartTimeMax
		}

		// If user location and max distance provided, use nearby search
		if userLat != nil && userLng != nil && prefs.MaxDistance != nil {
			filter.Lat = userLat
			filter.Lng = userLng
			filter.Radius = prefs.MaxDistance
		}
	}

	// Get candidate events
	events, err := m.eventRepo.List(ctx, filter)
	if err != nil {
		return nil, err
	}

	if len(events) == 0 {
		return nil, ErrNoEventsFound
	}

	// Score and rank events
	results := make([]MatchResult, 0, len(events))
	for _, evt := range events {
		score, reason := m.scoreEvent(ctx, &evt, currentUser, userLat, userLng, prefs)

		// Apply filters
		if prefs != nil {
			// Filter by price
			if prefs.MaxPrice != nil && evt.Price != nil && *evt.Price > *prefs.MaxPrice {
				continue
			}

			// Already filtered by max distance in query, but double-check
			if prefs.MaxDistance != nil && evt.Distance != nil && *evt.Distance > *prefs.MaxDistance {
				continue
			}
		}

		results = append(results, MatchResult{
			Event:    &evt,
			Score:    score,
			Distance: evt.Distance,
			Reason:   reason,
		})
	}

	if len(results) == 0 {
		return nil, ErrNoEventsFound
	}

	// Sort by score (descending)
	sortByScore(results)

	// Return top matches (limit to 10)
	maxResults := 10
	if len(results) > maxResults {
		results = results[:maxResults]
	}

	return results, nil
}

// FindQuickMatch finds a single best match for instant "I'm bored" discovery
func (m *Matcher) FindQuickMatch(ctx context.Context, userID uuid.UUID, userLat, userLng *float64) (*MatchResult, error) {
	// Quick match with minimal preferences - find something happening soon and nearby
	now := time.Now()
	maxTime := now.Add(24 * time.Hour) // Events in the next 24 hours

	prefs := &MatchPreferences{
		StartTimeMin: &now,
		StartTimeMax: &maxTime,
	}

	// If location provided, prioritize nearby events
	if userLat != nil && userLng != nil {
		maxDist := 10.0 // 10km radius
		prefs.MaxDistance = &maxDist
	}

	matches, err := m.FindMatch(ctx, userID, userLat, userLng, prefs)
	if err != nil {
		return nil, err
	}

	if len(matches) == 0 {
		return nil, ErrNoEventsFound
	}

	// Return the best match
	return &matches[0], nil
}

// GetRecommendations gets personalized event recommendations
func (m *Matcher) GetRecommendations(ctx context.Context, userID uuid.UUID, userLat, userLng *float64, limit int) ([]MatchResult, error) {
	if limit <= 0 {
		limit = 10
	}
	if limit > 50 {
		limit = 50
	}

	// Get user's interests and history to personalize
	// For now, use simple preferences
	prefs := &MatchPreferences{
		FreeOnly: false, // Include both free and paid
	}

	matches, err := m.FindMatch(ctx, userID, userLat, userLng, prefs)
	if err != nil {
		return nil, err
	}

	// Limit results
	if len(matches) > limit {
		matches = matches[:limit]
	}

	return matches, nil
}

// scoreEvent scores an event for a user (0-100)
// This is a simple scoring algorithm that can be enhanced
func (m *Matcher) scoreEvent(
	ctx context.Context,
	evt *event.EventWithDetails,
	currentUser *user.User,
	userLat, userLng *float64,
	prefs *MatchPreferences,
) (float64, string) {
	score := 50.0 // Base score
	reasons := make([]string, 0)

	// Distance scoring (max 25 points)
	if evt.Distance != nil {
		distanceScore := calculateDistanceScore(*evt.Distance)
		score += distanceScore
		if distanceScore > 15 {
			reasons = append(reasons, "Very close to you")
		} else if distanceScore > 5 {
			reasons = append(reasons, "Nearby")
		}
	}

	// Time scoring (max 20 points)
	timeScore, timeReason := calculateTimeScore(evt.StartTime)
	score += timeScore
	if timeReason != "" {
		reasons = append(reasons, timeReason)
	}

	// Price scoring (max 15 points)
	if evt.IsFree {
		score += 15
		reasons = append(reasons, "Free event")
	} else if evt.Price != nil && *evt.Price <= 50000 { // Under 50k IDR
		score += 10
		reasons = append(reasons, "Affordable")
	}

	// Category preference (max 20 points)
	if prefs != nil && len(prefs.Categories) > 0 {
		for _, prefCat := range prefs.Categories {
			if evt.Category == prefCat {
				score += 20
				reasons = append(reasons, "Matches your interests")
				break
			}
		}
	}

	// Popularity scoring (max 10 points)
	if evt.AttendeesCount > 0 {
		popularityScore := math.Min(float64(evt.AttendeesCount)/float64(evt.MaxAttendees)*10, 10)
		score += popularityScore
		if popularityScore > 7 {
			reasons = append(reasons, "Popular event")
		}
	}

	// Spots remaining (max 10 points)
	spotsLeft := evt.MaxAttendees - evt.AttendeesCount
	if spotsLeft > 10 {
		score += 10
		reasons = append(reasons, "Plenty of spots available")
	} else if spotsLeft > 0 {
		score += 5
		reasons = append(reasons, "Limited spots remaining")
	}

	// Build reason string
	reason := "Great match"
	if len(reasons) > 0 {
		reason = reasons[0]
		if len(reasons) > 1 {
			reason += " • " + reasons[1]
		}
	}

	// Ensure score is within 0-100
	if score > 100 {
		score = 100
	}
	if score < 0 {
		score = 0
	}

	return score, reason
}

// calculateDistanceScore calculates score based on distance (0-25 points)
func calculateDistanceScore(distance float64) float64 {
	// Closer is better
	if distance <= 1 {
		return 25.0 // Within 1km
	} else if distance <= 3 {
		return 20.0 // Within 3km
	} else if distance <= 5 {
		return 15.0 // Within 5km
	} else if distance <= 10 {
		return 10.0 // Within 10km
	} else if distance <= 20 {
		return 5.0 // Within 20km
	}
	return 0.0 // Far away
}

// calculateTimeScore calculates score based on start time (0-20 points)
func calculateTimeScore(startTime time.Time) (float64, string) {
	now := time.Now()
	hoursUntil := startTime.Sub(now).Hours()

	if hoursUntil < 0 {
		return 0, "" // Event already started
	} else if hoursUntil <= 2 {
		return 20, "Starting very soon"
	} else if hoursUntil <= 6 {
		return 18, "Starting soon"
	} else if hoursUntil <= 24 {
		return 15, "Happening today"
	} else if hoursUntil <= 72 {
		return 12, "Coming up this week"
	} else if hoursUntil <= 168 { // 7 days
		return 10, "Upcoming"
	}
	return 5, ""
}

// sortByScore sorts match results by score (descending)
func sortByScore(results []MatchResult) {
	// Simple bubble sort (for small datasets)
	// In production, use sort.Slice
	n := len(results)
	for i := 0; i < n-1; i++ {
		for j := 0; j < n-i-1; j++ {
			if results[j].Score < results[j+1].Score {
				results[j], results[j+1] = results[j+1], results[j]
			}
		}
	}
}

// CalculateDistance calculates distance between two coordinates using Haversine formula
// Returns distance in kilometers
func CalculateDistance(lat1, lng1, lat2, lng2 float64) float64 {
	const earthRadius = 6371.0 // Earth's radius in kilometers

	// Convert to radians
	lat1Rad := lat1 * math.Pi / 180
	lng1Rad := lng1 * math.Pi / 180
	lat2Rad := lat2 * math.Pi / 180
	lng2Rad := lng2 * math.Pi / 180

	// Haversine formula
	dlat := lat2Rad - lat1Rad
	dlng := lng2Rad - lng1Rad

	a := math.Sin(dlat/2)*math.Sin(dlat/2) +
		math.Cos(lat1Rad)*math.Cos(lat2Rad)*
			math.Sin(dlng/2)*math.Sin(dlng/2)

	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))

	distance := earthRadius * c
	return distance
}

// GetTrendingEvents gets currently trending events
func (m *Matcher) GetTrendingEvents(ctx context.Context, userID uuid.UUID, limit int) ([]event.EventWithDetails, error) {
	if limit <= 0 {
		limit = 10
	}
	if limit > 50 {
		limit = 50
	}

	// Get upcoming events
	filter := &event.EventFilter{
		Status: func() *event.EventStatus { s := event.StatusUpcoming; return &s }(),
		Limit:  limit * 2, // Get more to filter
		Offset: 0,
	}

	events, err := m.eventRepo.List(ctx, filter)
	if err != nil {
		return nil, err
	}

	// Sort by popularity (attendees count / max attendees ratio)
	// For simplicity, just filter events with good attendance
	trending := make([]event.EventWithDetails, 0)
	for _, evt := range events {
		if evt.AttendeesCount > 0 {
			ratio := float64(evt.AttendeesCount) / float64(evt.MaxAttendees)
			if ratio >= 0.3 { // At least 30% full
				trending = append(trending, evt)
			}
		}
	}

	// Limit results
	if len(trending) > limit {
		trending = trending[:limit]
	}

	return trending, nil
}

// GetEventsNearby gets events near a location
func (m *Matcher) GetEventsNearby(ctx context.Context, userID uuid.UUID, lat, lng, radiusKm float64, limit int) ([]event.EventWithDetails, error) {
	if limit <= 0 {
		limit = 20
	}
	if limit > 100 {
		limit = 100
	}

	return m.eventRepo.GetNearby(ctx, lat, lng, radiusKm, limit)
}

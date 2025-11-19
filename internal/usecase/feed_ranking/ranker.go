package feed_ranking

import (
	"math"
	"sort"
	"strings"
	"time"
)

// Ranker orchestrates the feed ranking for all feed types
type Ranker struct{}

// NewRanker creates a new feed ranker instance
func NewRanker() *Ranker {
	return &Ranker{}
}

// Rank processes the ranking request and returns ranked feeds
func (r *Ranker) Rank(req RankingRequest) RankingResponse {
	// Filter valid content (public + published only)
	validEvents := r.filterValidEvents(req.Contents.Events)
	validPosts := r.filterValidPosts(req.Contents.Posts)

	response := RankingResponse{
		TrendingEvent: r.rankTrendingEvent(validEvents),
		ForYouPosts:   r.rankForYouPosts(validPosts, req.UserProfile),
		ForYouEvents:  r.rankForYouEvents(validEvents, req.UserProfile),
		ChillEvents:   r.rankChillEvents(validEvents),
		HariIniEvents: r.rankHariIniEvents(validEvents, req.TodayWindow),
		GratisEvents:  r.rankGratisEvents(validEvents),
		BayarEvents:   r.rankBayarEvents(validEvents),
	}

	return response
}

// filterValidEvents returns only public and published events
func (r *Ranker) filterValidEvents(events []Event) []Event {
	valid := make([]Event, 0, len(events))
	for _, e := range events {
		if strings.ToLower(e.Visibility) == "public" && strings.ToLower(e.Status) == "published" {
			valid = append(valid, e)
		}
	}
	return valid
}

// filterValidPosts returns only public and published posts
func (r *Ranker) filterValidPosts(posts []Post) []Post {
	valid := make([]Post, 0, len(posts))
	for _, p := range posts {
		if strings.ToLower(p.Visibility) == "public" && strings.ToLower(p.Status) == "published" {
			valid = append(valid, p)
		}
	}
	return valid
}

// rankTrendingEvent ranks events by global velocity & engagement
// Priority: views_24h, likes_24h, shares_24h with recency boost
func (r *Ranker) rankTrendingEvent(events []Event) []string {
	scored := make([]ScoredContent, 0, len(events))

	for _, event := range events {
		score := r.calculateTrendingScore(event)
		scored = append(scored, ScoredContent{ID: event.ID, Score: score})
	}

	// Sort descending by score
	sort.Slice(scored, func(i, j int) bool {
		return scored[i].Score > scored[j].Score
	})

	return extractIDs(scored)
}

// calculateTrendingScore computes trending score with velocity + recency
func (r *Ranker) calculateTrendingScore(event Event) float64 {
	m := event.Metrics

	// Engagement velocity (24h metrics)
	velocityScore := float64(m.Views24h)*0.3 + float64(m.Likes24h)*5.0 + float64(m.Shares24h)*10.0

	// Recency boost (exponential decay: newer = higher score)
	hoursSinceCreation := time.Since(event.CreatedAt).Hours()
	recencyMultiplier := math.Exp(-hoursSinceCreation / 48.0) // decay over 2 days

	// Saves indicate strong interest
	saveBoost := float64(m.Saves) * 3.0

	return (velocityScore + saveBoost) * recencyMultiplier
}

// rankForYouPosts ranks posts by personalization signals
// Priority: user history (liked_contents, preferred_tags, followed_authors)
func (r *Ranker) rankForYouPosts(posts []Post, user UserProfile) []string {
	scored := make([]ScoredContent, 0, len(posts))

	for _, post := range posts {
		score := r.calculatePersonalizationScore(
			post.Tags,
			post.Metrics,
			post.AuthorID,
			user,
		)
		scored = append(scored, ScoredContent{ID: post.ID, Score: score})
	}

	sort.Slice(scored, func(i, j int) bool {
		return scored[i].Score > scored[j].Score
	})

	return extractIDs(scored)
}

// rankForYouEvents ranks events by personalization signals
func (r *Ranker) rankForYouEvents(events []Event, user UserProfile) []string {
	scored := make([]ScoredContent, 0, len(events))

	for _, event := range events {
		score := r.calculatePersonalizationScore(
			event.Tags,
			event.Metrics,
			event.AuthorID,
			user,
		)

		// Boost events with mood matching user preferences
		if moodWeight, exists := user.PreferredTags[strings.ToLower(event.Mood)]; exists {
			score *= (1.0 + moodWeight*0.2)
		}

		scored = append(scored, ScoredContent{ID: event.ID, Score: score})
	}

	sort.Slice(scored, func(i, j int) bool {
		return scored[i].Score > scored[j].Score
	})

	return extractIDs(scored)
}

// calculatePersonalizationScore computes user-content affinity
func (r *Ranker) calculatePersonalizationScore(tags []string, metrics Metrics, authorID string, user UserProfile) float64 {
	score := 0.0

	// Tag affinity (match content tags with user preferences)
	tagScore := 0.0
	for _, tag := range tags {
		if weight, exists := user.PreferredTags[strings.ToLower(tag)]; exists {
			tagScore += weight
		}
	}
	score += tagScore * 10.0 // amplify tag matches

	// Author following bonus (strong personalization signal)
	for _, followedAuthor := range user.FollowedAuthors {
		if followedAuthor == authorID {
			score += 100.0 // strong boost for followed authors
			break
		}
	}

	// Engagement quality
	// Saves/bookmarks indicate deep interest
	score += float64(metrics.Saves) * 5.0

	// Long view time indicates quality content
	if metrics.AvgViewMs > user.AvgViewTimeMs {
		viewTimeRatio := float64(metrics.AvgViewMs) / float64(user.AvgViewTimeMs)
		score += viewTimeRatio * 3.0
	}

	// Social proof (likes/shares)
	score += float64(metrics.Likes24h) * 2.0
	score += float64(metrics.Shares24h) * 4.0

	return score
}

// rankChillEvents ranks events with 'chill' mood or vibe
// Priority: mood='chill', capacity ~10 (6-12), high saves, low hype
func (r *Ranker) rankChillEvents(events []Event) []string {
	scored := make([]ScoredContent, 0, len(events))

	for _, event := range events {
		// Filter: only chill-related events
		isChillMood := strings.ToLower(event.Mood) == "chill"
		hasChillTag := r.hasChillTag(event.Tags)

		if !isChillMood && !hasChillTag {
			continue // skip non-chill events
		}

		score := r.calculateChillScore(event)
		scored = append(scored, ScoredContent{ID: event.ID, Score: score})
	}

	sort.Slice(scored, func(i, j int) bool {
		return scored[i].Score > scored[j].Score
	})

	return extractIDs(scored)
}

// hasChillTag checks if tags indicate chill/relax vibe
func (r *Ranker) hasChillTag(tags []string) bool {
	chillKeywords := []string{"chill", "relax", "casual", "hangout", "coffee", "lounge", "calm", "peaceful"}
	for _, tag := range tags {
		tagLower := strings.ToLower(tag)
		for _, keyword := range chillKeywords {
			if strings.Contains(tagLower, keyword) {
				return true
			}
		}
	}
	return false
}

// calculateChillScore computes chill vibe score
func (r *Ranker) calculateChillScore(event Event) float64 {
	score := 0.0

	// Ideal capacity: small intimate gatherings (6-12 people)
	if event.Capacity >= 6 && event.Capacity <= 12 {
		score += 50.0
	} else if event.Capacity >= 4 && event.Capacity <= 15 {
		score += 30.0 // still acceptable
	} else {
		score += 10.0 // larger events get lower score
	}

	// Explicit chill mood bonus
	if strings.ToLower(event.Mood) == "chill" {
		score += 40.0
	}

	// High saves indicate quality chill experience
	score += float64(event.Metrics.Saves) * 8.0

	// Long view time indicates interesting content
	score += float64(event.Metrics.AvgViewMs) / 1000.0 // convert ms to seconds

	// Downrank hype signals (too many views/shares = not chill)
	hypeScore := float64(event.Metrics.Views24h) + float64(event.Metrics.Shares24h)*5.0
	if hypeScore > 500 {
		score *= 0.7 // penalty for too much hype
	}

	return score
}

// rankHariIniEvents ranks events happening today (within today_window)
// Priority: start_time within user's local today
func (r *Ranker) rankHariIniEvents(events []Event, todayWindow *TodayWindow) []string {
	if todayWindow == nil {
		// If no window provided, use UTC midnight-to-midnight
		now := time.Now().UTC()
		start := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, time.UTC)
		end := start.Add(24 * time.Hour)
		todayWindow = &TodayWindow{StartUTC: start, EndUTC: end}
	}

	scored := make([]ScoredContent, 0, len(events))

	for _, event := range events {
		// Filter: only events starting within today's window
		if event.StartTime.Before(todayWindow.StartUTC) || event.StartTime.After(todayWindow.EndUTC) {
			continue
		}

		score := r.calculateHariIniScore(event, todayWindow)
		scored = append(scored, ScoredContent{ID: event.ID, Score: score})
	}

	sort.Slice(scored, func(i, j int) bool {
		return scored[i].Score > scored[j].Score
	})

	return extractIDs(scored)
}

// calculateHariIniScore prioritizes events starting soon
func (r *Ranker) calculateHariIniScore(event Event, todayWindow *TodayWindow) float64 {
	// Base score: engagement
	score := float64(event.Metrics.Likes24h)*2.0 + float64(event.Metrics.Saves)*5.0

	// Urgency boost: events starting sooner rank higher
	now := time.Now().UTC()
	hoursUntilStart := event.StartTime.Sub(now).Hours()

	if hoursUntilStart >= 0 && hoursUntilStart <= 24 {
		// Inverse score: sooner = higher
		urgencyBoost := (24.0 - hoursUntilStart) * 2.0
		score += urgencyBoost
	}

	return score
}

// rankGratisEvents ranks free events (price_cents == 0)
// Priority: free events with high engagement
func (r *Ranker) rankGratisEvents(events []Event) []string {
	scored := make([]ScoredContent, 0, len(events))

	for _, event := range events {
		if event.PriceCents != 0 {
			continue // skip paid events
		}

		// Score by engagement
		score := float64(event.Metrics.Views24h)*0.5 +
			float64(event.Metrics.Likes24h)*3.0 +
			float64(event.Metrics.Shares24h)*5.0 +
			float64(event.Metrics.Saves)*4.0

		scored = append(scored, ScoredContent{ID: event.ID, Score: score})
	}

	sort.Slice(scored, func(i, j int) bool {
		return scored[i].Score > scored[j].Score
	})

	return extractIDs(scored)
}

// rankBayarEvents ranks paid events (price_cents > 0)
// Priority: paid events with high engagement (value signals)
func (r *Ranker) rankBayarEvents(events []Event) []string {
	scored := make([]ScoredContent, 0, len(events))

	for _, event := range events {
		if event.PriceCents <= 0 {
			continue // skip free events
		}

		// Score by engagement + value signals
		score := float64(event.Metrics.Views24h)*0.5 +
			float64(event.Metrics.Likes24h)*3.0 +
			float64(event.Metrics.Shares24h)*5.0 +
			float64(event.Metrics.Saves)*6.0 // higher save weight (users willing to pay)

		// Quality signal: higher price may indicate premium event (cap influence)
		priceSignal := math.Log(float64(event.PriceCents) + 1.0)
		score += priceSignal * 0.5

		scored = append(scored, ScoredContent{ID: event.ID, Score: score})
	}

	sort.Slice(scored, func(i, j int) bool {
		return scored[i].Score > scored[j].Score
	})

	return extractIDs(scored)
}

// extractIDs converts scored content to ID list
func extractIDs(scored []ScoredContent) []string {
	ids := make([]string, len(scored))
	for i, sc := range scored {
		ids[i] = sc.ID
	}
	return ids
}

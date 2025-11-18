package postgres

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/anigmaa/backend/internal/domain/event"
	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
)

type eventRepository struct {
	db *sqlx.DB
}

func NewEventRepository(db *sqlx.DB) event.Repository {
	return &eventRepository{db: db}
}

func (r *eventRepository) Create(ctx context.Context, e *event.Event) error {
	query := `
		INSERT INTO events (id, host_id, title, description, category, start_time, end_time,
			location_name, location_address, location_lat, location_lng, location_geom,
			max_attendees, price, is_free, status, privacy, requirements, ticketing_enabled,
			tickets_sold, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, ST_SetSRID(ST_MakePoint($12, $11), 4326),
			$13, $14, $15, $16, $17, $18, $19, $20, $21, $22)
	`

	e.ID = uuid.New()
	e.CreatedAt = time.Now()
	e.UpdatedAt = time.Now()
	e.Status = event.StatusUpcoming
	e.TicketsSold = 0

	_, err := r.db.ExecContext(ctx, query,
		e.ID, e.HostID, e.Title, e.Description, e.Category, e.StartTime, e.EndTime,
		e.LocationName, e.LocationAddress, e.LocationLat, e.LocationLng,
		e.MaxAttendees, e.Price, e.IsFree, e.Status, e.Privacy, e.Requirements,
		e.TicketingEnabled, e.TicketsSold, e.CreatedAt, e.UpdatedAt,
	)

	return err
}

func (r *eventRepository) GetByID(ctx context.Context, id uuid.UUID) (*event.Event, error) {
	var e event.Event
	query := `SELECT id, host_id, title, description, category, start_time, end_time,
		location_name, location_address, location_lat, location_lng, max_attendees,
		price, is_free, status, privacy, requirements, ticketing_enabled, tickets_sold,
		created_at, updated_at FROM events WHERE id = $1`

	err := r.db.GetContext(ctx, &e, query, id)
	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("event not found")
	}

	return &e, err
}

func (r *eventRepository) GetWithDetails(ctx context.Context, eventID, userID uuid.UUID) (*event.EventWithDetails, error) {
	query := `
		SELECT e.id, e.host_id, e.title, e.description, e.category, e.start_time, e.end_time,
			e.location_name, e.location_address, e.location_lat, e.location_lng,
			e.max_attendees, e.price, e.is_free, e.status, e.privacy, e.requirements,
			e.ticketing_enabled, e.tickets_sold, e.created_at, e.updated_at,
			u.name as host_name, u.avatar_url as host_avatar_url,
			(SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'confirmed') as attendees_count,
			EXISTS(SELECT 1 FROM event_attendees WHERE event_id = e.id AND user_id = $2 AND status = 'confirmed') as is_user_attending,
			(e.host_id = $2) as is_user_host
		FROM events e
		INNER JOIN users u ON e.host_id = u.id
		WHERE e.id = $1
	`

	var details event.EventWithDetails
	err := r.db.GetContext(ctx, &details, query, eventID, userID)
	if err != nil {
		return nil, err
	}

	images, _ := r.GetImages(ctx, eventID)
	details.ImageURLs = images

	return &details, nil
}

func (r *eventRepository) Update(ctx context.Context, e *event.Event) error {
	query := `
		UPDATE events SET title = $1, description = $2, category = $3, start_time = $4,
			end_time = $5, location_name = $6, location_address = $7, location_lat = $8,
			location_lng = $9, location_geom = ST_SetSRID(ST_MakePoint($9, $8), 4326),
			max_attendees = $10, price = $11, privacy = $12, requirements = $13,
			status = $14, updated_at = $15
		WHERE id = $16
	`

	e.UpdatedAt = time.Now()
	_, err := r.db.ExecContext(ctx, query,
		e.Title, e.Description, e.Category, e.StartTime, e.EndTime,
		e.LocationName, e.LocationAddress, e.LocationLat, e.LocationLng,
		e.MaxAttendees, e.Price, e.Privacy, e.Requirements, e.Status,
		e.UpdatedAt, e.ID,
	)

	return err
}

func (r *eventRepository) Delete(ctx context.Context, id uuid.UUID) error {
	query := `DELETE FROM events WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, id)
	return err
}

func (r *eventRepository) List(ctx context.Context, filter *event.EventFilter) ([]event.EventWithDetails, error) {
	query := `
		SELECT e.id, e.host_id, e.title, e.description, e.category, e.start_time, e.end_time,
			e.location_name, e.location_address, e.location_lat, e.location_lng,
			e.max_attendees, e.price, e.is_free, e.status, e.privacy, e.requirements,
			e.ticketing_enabled, e.tickets_sold, e.created_at, e.updated_at,
			u.name as host_name, u.avatar_url as host_avatar_url,
			(SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'confirmed') as attendees_count
		FROM events e
		INNER JOIN users u ON e.host_id = u.id
		WHERE 1=1
	`

	args := []interface{}{}
	argCount := 1

	if filter.Category != nil {
		query += fmt.Sprintf(" AND e.category = $%d", argCount)
		args = append(args, *filter.Category)
		argCount++
	}

	if filter.IsFree != nil {
		query += fmt.Sprintf(" AND e.is_free = $%d", argCount)
		args = append(args, *filter.IsFree)
		argCount++
	}

	if filter.Status != nil {
		query += fmt.Sprintf(" AND e.status = $%d", argCount)
		args = append(args, *filter.Status)
		argCount++
	}

	query += " ORDER BY e.start_time ASC"

	if filter.Limit > 0 {
		query += fmt.Sprintf(" LIMIT $%d", argCount)
		args = append(args, filter.Limit)
		argCount++
	}

	if filter.Offset > 0 {
		query += fmt.Sprintf(" OFFSET $%d", argCount)
		args = append(args, filter.Offset)
	}

	var events []event.EventWithDetails
	err := r.db.SelectContext(ctx, &events, query, args...)
	return events, err
}

func (r *eventRepository) GetByHost(ctx context.Context, hostID uuid.UUID, limit, offset int) ([]event.EventWithDetails, error) {
	query := `
		SELECT e.id, e.host_id, e.title, e.description, e.category, e.start_time, e.end_time,
			e.location_name, e.location_address, e.location_lat, e.location_lng,
			e.max_attendees, e.price, e.is_free, e.status, e.privacy, e.requirements,
			e.ticketing_enabled, e.tickets_sold, e.created_at, e.updated_at,
			u.name as host_name, u.avatar_url as host_avatar_url,
			(SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'confirmed') as attendees_count
		FROM events e
		INNER JOIN users u ON e.host_id = u.id
		WHERE e.host_id = $1
		ORDER BY e.created_at DESC
		LIMIT $2 OFFSET $3
	`

	var events []event.EventWithDetails
	err := r.db.SelectContext(ctx, &events, query, hostID, limit, offset)
	return events, err
}

func (r *eventRepository) GetJoinedEvents(ctx context.Context, userID uuid.UUID, limit, offset int) ([]event.EventWithDetails, error) {
	query := `
		SELECT e.id, e.host_id, e.title, e.description, e.category, e.start_time, e.end_time,
			e.location_name, e.location_address, e.location_lat, e.location_lng,
			e.max_attendees, e.price, e.is_free, e.status, e.privacy, e.requirements,
			e.ticketing_enabled, e.tickets_sold, e.created_at, e.updated_at,
			u.name as host_name, u.avatar_url as host_avatar_url,
			(SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'confirmed') as attendees_count,
			true as is_user_attending
		FROM events e
		INNER JOIN users u ON e.host_id = u.id
		INNER JOIN event_attendees ea ON e.id = ea.event_id
		WHERE ea.user_id = $1 AND ea.status = 'confirmed'
		ORDER BY e.start_time ASC
		LIMIT $2 OFFSET $3
	`

	var events []event.EventWithDetails
	err := r.db.SelectContext(ctx, &events, query, userID, limit, offset)
	return events, err
}

func (r *eventRepository) GetNearby(ctx context.Context, lat, lng, radiusKm float64, limit int) ([]event.EventWithDetails, error) {
	query := `
		SELECT e.id, e.host_id, e.title, e.description, e.category, e.start_time, e.end_time,
			e.location_name, e.location_address, e.location_lat, e.location_lng,
			e.max_attendees, e.price, e.is_free, e.status, e.privacy, e.requirements,
			e.ticketing_enabled, e.tickets_sold, e.created_at, e.updated_at,
			u.name as host_name, u.avatar_url as host_avatar_url,
			(SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'confirmed') as attendees_count,
			ST_Distance(e.location_geom::geography, ST_SetSRID(ST_MakePoint($2, $1), 4326)::geography) / 1000 as distance
		FROM events e
		INNER JOIN users u ON e.host_id = u.id
		WHERE ST_DWithin(e.location_geom::geography, ST_SetSRID(ST_MakePoint($2, $1), 4326)::geography, $3 * 1000)
			AND e.status = 'upcoming'
		ORDER BY distance ASC
		LIMIT $4
	`

	var events []event.EventWithDetails
	err := r.db.SelectContext(ctx, &events, query, lat, lng, radiusKm, limit)
	return events, err
}

func (r *eventRepository) Join(ctx context.Context, attendee *event.EventAttendee) error {
	query := `
		INSERT INTO event_attendees (id, event_id, user_id, joined_at, status)
		VALUES ($1, $2, $3, $4, $5)
	`

	attendee.ID = uuid.New()
	attendee.JoinedAt = time.Now()
	attendee.Status = event.AttendeeConfirmed

	_, err := r.db.ExecContext(ctx, query, attendee.ID, attendee.EventID, attendee.UserID, attendee.JoinedAt, attendee.Status)
	return err
}

func (r *eventRepository) Leave(ctx context.Context, eventID, userID uuid.UUID) error {
	query := `DELETE FROM event_attendees WHERE event_id = $1 AND user_id = $2`
	_, err := r.db.ExecContext(ctx, query, eventID, userID)
	return err
}

func (r *eventRepository) GetAttendees(ctx context.Context, eventID uuid.UUID, limit, offset int) ([]event.EventAttendee, error) {
	query := `
		SELECT * FROM event_attendees
		WHERE event_id = $1 AND status = 'confirmed'
		ORDER BY joined_at DESC
		LIMIT $2 OFFSET $3
	`

	var attendees []event.EventAttendee
	err := r.db.SelectContext(ctx, &attendees, query, eventID, limit, offset)
	return attendees, err
}

func (r *eventRepository) IsAttending(ctx context.Context, eventID, userID uuid.UUID) (bool, error) {
	query := `SELECT EXISTS(SELECT 1 FROM event_attendees WHERE event_id = $1 AND user_id = $2 AND status = 'confirmed')`
	var exists bool
	err := r.db.GetContext(ctx, &exists, query, eventID, userID)
	return exists, err
}

func (r *eventRepository) GetAttendeesCount(ctx context.Context, eventID uuid.UUID) (int, error) {
	query := `SELECT COUNT(*) FROM event_attendees WHERE event_id = $1 AND status = 'confirmed'`
	var count int
	err := r.db.GetContext(ctx, &count, query, eventID)
	return count, err
}

func (r *eventRepository) AddImages(ctx context.Context, images []event.EventImage) error {
	query := `INSERT INTO event_images (id, event_id, image_url, order_index) VALUES ($1, $2, $3, $4)`

	for _, img := range images {
		img.ID = uuid.New()
		_, err := r.db.ExecContext(ctx, query, img.ID, img.EventID, img.ImageURL, img.Order)
		if err != nil {
			return err
		}
	}

	return nil
}

func (r *eventRepository) GetImages(ctx context.Context, eventID uuid.UUID) ([]string, error) {
	query := `SELECT image_url FROM event_images WHERE event_id = $1 ORDER BY order_index ASC`

	var images []string
	err := r.db.SelectContext(ctx, &images, query, eventID)
	return images, err
}

func (r *eventRepository) DeleteImage(ctx context.Context, imageID uuid.UUID) error {
	query := `DELETE FROM event_images WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, imageID)
	return err
}

func (r *eventRepository) UpdateStatus(ctx context.Context, eventID uuid.UUID, status event.EventStatus) error {
	query := `UPDATE events SET status = $1, updated_at = $2 WHERE id = $3`
	_, err := r.db.ExecContext(ctx, query, status, time.Now(), eventID)
	return err
}

func (r *eventRepository) GetUpcomingEvents(ctx context.Context, limit int) ([]event.EventWithDetails, error) {
	query := `
		SELECT e.*, u.name as host_name, u.avatar_url as host_avatar_url,
			(SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id) as attendees_count
		FROM events e
		INNER JOIN users u ON e.host_id = u.id
		WHERE e.status = 'upcoming' AND e.start_time > NOW()
		ORDER BY e.start_time ASC
		LIMIT $1
	`

	var events []event.EventWithDetails
	err := r.db.SelectContext(ctx, &events, query, limit)
	return events, err
}

func (r *eventRepository) GetLiveEvents(ctx context.Context, limit int) ([]event.EventWithDetails, error) {
	query := `
		SELECT e.*, u.name as host_name, u.avatar_url as host_avatar_url,
			(SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id) as attendees_count
		FROM events e
		INNER JOIN users u ON e.host_id = u.id
		WHERE e.status = 'ongoing' AND e.start_time <= NOW() AND e.end_time >= NOW()
		ORDER BY e.start_time DESC
		LIMIT $1
	`

	var events []event.EventWithDetails
	err := r.db.SelectContext(ctx, &events, query, limit)
	return events, err
}

// GetByHostID gets all events created by a host (for analytics)
func (r *eventRepository) GetByHostID(ctx context.Context, hostID uuid.UUID) ([]event.Event, error) {
	query := `
		SELECT id, host_id, title, description, category, start_time, end_time,
			location_name, location_address, location_lat, location_lng,
			max_attendees, price, is_free, status, privacy, requirements,
			ticketing_enabled, tickets_sold, created_at, updated_at
		FROM events
		WHERE host_id = $1
		ORDER BY start_time DESC
	`

	var events []event.Event
	err := r.db.SelectContext(ctx, &events, query, hostID)
	if err != nil {
		return nil, err
	}

	return events, nil
}

// CountEvents counts total events matching filter
func (r *eventRepository) CountEvents(ctx context.Context, filter *event.EventFilter) (int, error) {
	query := `SELECT COUNT(*) FROM events WHERE 1=1`
	args := []interface{}{}
	argCount := 1

	if filter.Category != nil {
		query += fmt.Sprintf(" AND category = $%d", argCount)
		args = append(args, *filter.Category)
		argCount++
	}
	if filter.Status != nil {
		query += fmt.Sprintf(" AND status = $%d", argCount)
		args = append(args, *filter.Status)
		argCount++
	}
	if filter.IsFree != nil {
		query += fmt.Sprintf(" AND is_free = $%d", argCount)
		args = append(args, *filter.IsFree)
		argCount++
	}
	if filter.StartDate != nil {
		query += fmt.Sprintf(" AND start_time >= $%d", argCount)
		args = append(args, *filter.StartDate)
		argCount++
	}
	if filter.EndDate != nil {
		query += fmt.Sprintf(" AND end_time <= $%d", argCount)
		args = append(args, *filter.EndDate)
		argCount++
	}

	var count int
	err := r.db.QueryRowContext(ctx, query, args...).Scan(&count)
	return count, err
}

// CountHostedEvents counts total events by a host
func (r *eventRepository) CountHostedEvents(ctx context.Context, hostID uuid.UUID) (int, error) {
	query := `SELECT COUNT(*) FROM events WHERE host_id = $1`
	var count int
	err := r.db.QueryRowContext(ctx, query, hostID).Scan(&count)
	return count, err
}

// CountJoinedEvents counts total events a user has joined
func (r *eventRepository) CountJoinedEvents(ctx context.Context, userID uuid.UUID) (int, error) {
	query := `
		SELECT COUNT(*)
		FROM event_attendees ea
		WHERE ea.user_id = $1 AND ea.status = 'confirmed'
	`
	var count int
	err := r.db.QueryRowContext(ctx, query, userID).Scan(&count)
	return count, err
}

// CountAttendees counts total attendees for an event
func (r *eventRepository) CountAttendees(ctx context.Context, eventID uuid.UUID) (int, error) {
	query := `
		SELECT COUNT(*)
		FROM event_attendees
		WHERE event_id = $1 AND status = 'confirmed'
	`
	var count int
	err := r.db.QueryRowContext(ctx, query, eventID).Scan(&count)
	return count, err
}

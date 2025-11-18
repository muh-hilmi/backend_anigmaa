package ticket

import (
	"context"
	"errors"
	"time"

	"github.com/anigmaa/backend/internal/domain/event"
	"github.com/anigmaa/backend/internal/domain/ticket"
	"github.com/anigmaa/backend/internal/domain/user"
	"github.com/anigmaa/backend/pkg/utils"
	"github.com/google/uuid"
)

var (
	ErrTicketNotFound        = errors.New("ticket not found")
	ErrEventNotFound         = errors.New("event not found")
	ErrEventFull             = errors.New("event is full")
	ErrAlreadyPurchased      = errors.New("already purchased ticket for this event")
	ErrInvalidAttendanceCode = errors.New("invalid attendance code")
	ErrAlreadyCheckedIn      = errors.New("ticket already checked in")
	ErrTicketNotActive       = errors.New("ticket is not active")
	ErrCannotRefund          = errors.New("ticket cannot be refunded")
	ErrEventStarted          = errors.New("event has already started")
	ErrUnauthorized          = errors.New("unauthorized")
)

// Usecase handles ticket business logic
type Usecase struct {
	ticketRepo ticket.Repository
	eventRepo  event.Repository
	userRepo   user.Repository
}

// NewUsecase creates a new ticket usecase
func NewUsecase(ticketRepo ticket.Repository, eventRepo event.Repository, userRepo user.Repository) *Usecase {
	return &Usecase{
		ticketRepo: ticketRepo,
		eventRepo:  eventRepo,
		userRepo:   userRepo,
	}
}

// PurchaseTicket purchases a ticket for an event
func (uc *Usecase) PurchaseTicket(ctx context.Context, userID uuid.UUID, req *ticket.PurchaseTicketRequest) (*ticket.Ticket, error) {
	// Get event
	evt, err := uc.eventRepo.GetByID(ctx, req.EventID)
	if err != nil {
		return nil, ErrEventNotFound
	}

	// Check if event is full
	if evt.IsFull() {
		return nil, ErrEventFull
	}

	// Check if user already has a ticket for this event
	existingTicket, err := uc.ticketRepo.GetUserTicketForEvent(ctx, userID, req.EventID)
	if err == nil && existingTicket != nil {
		return nil, ErrAlreadyPurchased
	}

	// Verify user exists
	_, err = uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, errors.New("user not found")
	}

	// Generate attendance code
	attendanceCode, err := utils.GenerateAttendanceCode()
	if err != nil {
		return nil, err
	}

	// Determine price
	pricePaid := 0.0
	if !evt.IsFree && evt.Price != nil {
		pricePaid = *evt.Price
	}

	// Create ticket
	now := time.Now()
	newTicket := &ticket.Ticket{
		ID:             uuid.New(),
		UserID:         userID,
		EventID:        req.EventID,
		AttendanceCode: attendanceCode,
		PricePaid:      pricePaid,
		PurchasedAt:    now,
		IsCheckedIn:    false,
		Status:         ticket.StatusActive,
	}

	if err := uc.ticketRepo.Create(ctx, newTicket); err != nil {
		return nil, err
	}

	// For paid events, create a transaction record
	if !evt.IsFree && pricePaid > 0 {
		transaction := &ticket.TicketTransaction{
			ID:            uuid.New(),
			TicketID:      newTicket.ID,
			TransactionID: uuid.New().String(), // In production, this would be Midtrans transaction ID
			Amount:        pricePaid,
			PaymentMethod: "midtrans", // Default, would be from req.PaymentMethod
			Status:        ticket.TransactionSuccess,
			CreatedAt:     now,
			CompletedAt:   &now,
		}

		if req.PaymentMethod != nil {
			transaction.PaymentMethod = *req.PaymentMethod
		}

		if err := uc.ticketRepo.CreateTransaction(ctx, transaction); err != nil {
			// Log error but don't fail ticket creation
		}
	}

	// Join the event (create attendee record)
	attendee := &event.EventAttendee{
		ID:       uuid.New(),
		EventID:  req.EventID,
		UserID:   userID,
		JoinedAt: now,
		Status:   event.AttendeeConfirmed,
	}
	if err := uc.eventRepo.Join(ctx, attendee); err != nil {
		// Log error but don't fail
	}

	// Increment events attended for user stats
	if err := uc.userRepo.IncrementEventsAttended(ctx, userID); err != nil {
		// Log error but don't fail
	}

	return newTicket, nil
}

// GetTicketByID gets a ticket by ID
func (uc *Usecase) GetTicketByID(ctx context.Context, ticketID uuid.UUID) (*ticket.Ticket, error) {
	t, err := uc.ticketRepo.GetByID(ctx, ticketID)
	if err != nil {
		return nil, ErrTicketNotFound
	}
	return t, nil
}

// GetTicketWithDetails gets a ticket with details
func (uc *Usecase) GetTicketWithDetails(ctx context.Context, ticketID, userID uuid.UUID) (*ticket.TicketWithDetails, error) {
	t, err := uc.ticketRepo.GetWithDetails(ctx, ticketID)
	if err != nil {
		return nil, ErrTicketNotFound
	}

	// Verify user owns this ticket
	if t.UserID != userID {
		return nil, ErrUnauthorized
	}

	return t, nil
}

// GetUserTickets gets all tickets for a user
func (uc *Usecase) GetUserTickets(ctx context.Context, userID uuid.UUID, limit, offset int) ([]ticket.TicketWithDetails, error) {
	if limit <= 0 {
		limit = 20
	}
	if limit > 100 {
		limit = 100
	}

	return uc.ticketRepo.GetByUser(ctx, userID, limit, offset)
}

// GetEventTickets gets all tickets for an event (host only)
func (uc *Usecase) GetEventTickets(ctx context.Context, eventID, requestingUserID uuid.UUID, limit, offset int) ([]ticket.TicketWithDetails, error) {
	// Get event
	evt, err := uc.eventRepo.GetByID(ctx, eventID)
	if err != nil {
		return nil, ErrEventNotFound
	}

	// Check if requesting user is the host
	if evt.HostID != requestingUserID {
		return nil, ErrUnauthorized
	}

	if limit <= 0 {
		limit = 50
	}
	if limit > 100 {
		limit = 100
	}

	return uc.ticketRepo.GetByEvent(ctx, eventID, limit, offset)
}

// CheckIn checks in a ticket using attendance code
func (uc *Usecase) CheckIn(ctx context.Context, eventID uuid.UUID, req *ticket.CheckInRequest) (*ticket.Ticket, error) {
	// Validate attendance code format
	if !utils.ValidateAttendanceCode(req.AttendanceCode) {
		return nil, ErrInvalidAttendanceCode
	}

	// Get ticket by attendance code
	t, err := uc.ticketRepo.GetByAttendanceCode(ctx, req.AttendanceCode)
	if err != nil {
		return nil, ErrTicketNotFound
	}

	// Verify ticket is for the correct event
	if t.EventID != eventID {
		return nil, ErrTicketNotFound
	}

	// Check if ticket is active
	if t.Status != ticket.StatusActive {
		return nil, ErrTicketNotActive
	}

	// Check if already checked in
	if t.IsCheckedIn {
		return nil, ErrAlreadyCheckedIn
	}

	// Perform check-in
	if err := uc.ticketRepo.CheckIn(ctx, t.ID); err != nil {
		return nil, err
	}

	// Get updated ticket
	updatedTicket, err := uc.ticketRepo.GetByID(ctx, t.ID)
	if err != nil {
		return nil, err
	}

	return updatedTicket, nil
}

// CancelTicket cancels a ticket and issues refund (if applicable)
func (uc *Usecase) CancelTicket(ctx context.Context, ticketID, userID uuid.UUID) error {
	// Get ticket
	t, err := uc.ticketRepo.GetByID(ctx, ticketID)
	if err != nil {
		return ErrTicketNotFound
	}

	// Verify user owns this ticket
	if t.UserID != userID {
		return ErrUnauthorized
	}

	// Check if ticket can be cancelled
	if !t.CanBeRefunded() {
		return ErrCannotRefund
	}

	// Get event to check timing
	evt, err := uc.eventRepo.GetByID(ctx, t.EventID)
	if err != nil {
		return ErrEventNotFound
	}

	// Check if event has already started
	if evt.IsStartingSoon() || evt.IsOngoing() || evt.IsCompleted() {
		return ErrEventStarted
	}

	// Update ticket status
	t.Status = ticket.StatusCancelled
	if err := uc.ticketRepo.Update(ctx, t); err != nil {
		return err
	}

	// Leave the event
	if err := uc.eventRepo.Leave(ctx, t.EventID, userID); err != nil {
		// Log error but don't fail
	}

	// For paid tickets, create refund transaction
	if t.PricePaid > 0 {
		// Get original transaction
		// In production, you would initiate actual refund through payment gateway
		refundTransaction := &ticket.TicketTransaction{
			ID:            uuid.New(),
			TicketID:      t.ID,
			TransactionID: uuid.New().String(), // Would be from payment gateway
			Amount:        t.PricePaid,
			PaymentMethod: "midtrans",
			Status:        ticket.TransactionRefunded,
			CreatedAt:     time.Now(),
			CompletedAt:   nil, // Completed when refund is processed
		}

		if err := uc.ticketRepo.CreateTransaction(ctx, refundTransaction); err != nil {
			// Log error but don't fail cancellation
		}
	}

	return nil
}

// GetCheckedInCount gets the number of checked-in attendees for an event
func (uc *Usecase) GetCheckedInCount(ctx context.Context, eventID, requestingUserID uuid.UUID) (int, error) {
	// Get event
	evt, err := uc.eventRepo.GetByID(ctx, eventID)
	if err != nil {
		return 0, ErrEventNotFound
	}

	// Check if requesting user is the host
	if evt.HostID != requestingUserID {
		return 0, ErrUnauthorized
	}

	return uc.ticketRepo.GetCheckedInCount(ctx, eventID)
}

// VerifyTicket verifies a ticket is valid for an event
func (uc *Usecase) VerifyTicket(ctx context.Context, ticketID, eventID uuid.UUID) (bool, error) {
	// Get ticket
	t, err := uc.ticketRepo.GetByID(ctx, ticketID)
	if err != nil {
		return false, ErrTicketNotFound
	}

	// Check if ticket is for the correct event
	if t.EventID != eventID {
		return false, nil
	}

	// Check if ticket is valid
	return t.IsValid(), nil
}

// GetAttendanceCode gets the attendance code for a ticket (user must own the ticket)
func (uc *Usecase) GetAttendanceCode(ctx context.Context, ticketID, userID uuid.UUID) (string, error) {
	// Get ticket
	t, err := uc.ticketRepo.GetByID(ctx, ticketID)
	if err != nil {
		return "", ErrTicketNotFound
	}

	// Verify user owns this ticket
	if t.UserID != userID {
		return "", ErrUnauthorized
	}

	return t.AttendanceCode, nil
}

// GetTransaction gets a transaction by transaction ID
func (uc *Usecase) GetTransaction(ctx context.Context, transactionID string, userID uuid.UUID) (*ticket.TicketTransaction, error) {
	// Get transaction
	transaction, err := uc.ticketRepo.GetTransaction(ctx, transactionID)
	if err != nil {
		return nil, errors.New("transaction not found")
	}

	// Get ticket to verify ownership
	t, err := uc.ticketRepo.GetByID(ctx, transaction.TicketID)
	if err != nil {
		return nil, ErrTicketNotFound
	}

	// Verify user owns the ticket
	if t.UserID != userID {
		return nil, ErrUnauthorized
	}

	return transaction, nil
}

// ProcessPaymentCallback handles payment gateway callback
// This would be called by Midtrans webhook in production
func (uc *Usecase) ProcessPaymentCallback(ctx context.Context, transactionID string, status ticket.TransactionStatus) error {
	// Get transaction
	transaction, err := uc.ticketRepo.GetTransaction(ctx, transactionID)
	if err != nil {
		return errors.New("transaction not found")
	}

	// Update transaction status
	if err := uc.ticketRepo.UpdateTransactionStatus(ctx, transactionID, status); err != nil {
		return err
	}

	// If payment failed, cancel the ticket
	if status == ticket.TransactionFailed {
		t, err := uc.ticketRepo.GetByID(ctx, transaction.TicketID)
		if err != nil {
			return err
		}

		t.Status = ticket.StatusCancelled
		if err := uc.ticketRepo.Update(ctx, t); err != nil {
			return err
		}

		// Remove from event attendees
		if err := uc.eventRepo.Leave(ctx, t.EventID, t.UserID); err != nil {
			// Log error but don't fail
		}
	}

	return nil
}

// GetUpcomingTickets gets upcoming tickets for a user
func (uc *Usecase) GetUpcomingTickets(ctx context.Context, userID uuid.UUID, limit int) ([]ticket.TicketWithDetails, error) {
	if limit <= 0 {
		limit = 10
	}
	if limit > 50 {
		limit = 50
	}

	// Get all user tickets and filter for upcoming events
	tickets, err := uc.ticketRepo.GetByUser(ctx, userID, limit*2, 0) // Get more to filter
	if err != nil {
		return nil, err
	}

	// Filter for upcoming events
	upcoming := make([]ticket.TicketWithDetails, 0)
	now := time.Now()
	for _, t := range tickets {
		if t.EventStartTime.After(now) && t.Status == ticket.StatusActive {
			upcoming = append(upcoming, t)
			if len(upcoming) >= limit {
				break
			}
		}
	}

	return upcoming, nil
}

// GetPastTickets gets past tickets for a user
func (uc *Usecase) GetPastTickets(ctx context.Context, userID uuid.UUID, limit int) ([]ticket.TicketWithDetails, error) {
	if limit <= 0 {
		limit = 10
	}
	if limit > 50 {
		limit = 50
	}

	// Get all user tickets and filter for past events
	tickets, err := uc.ticketRepo.GetByUser(ctx, userID, limit*2, 0) // Get more to filter
	if err != nil {
		return nil, err
	}

	// Filter for past events
	past := make([]ticket.TicketWithDetails, 0)
	now := time.Now()
	for _, t := range tickets {
		if t.EventStartTime.Before(now) {
			past = append(past, t)
			if len(past) >= limit {
				break
			}
		}
	}

	return past, nil
}

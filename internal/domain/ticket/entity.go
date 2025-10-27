package ticket

import (
	"time"

	"github.com/google/uuid"
)

// TicketStatus represents the status of a ticket
type TicketStatus string

const (
	StatusActive    TicketStatus = "active"
	StatusCancelled TicketStatus = "cancelled"
	StatusRefunded  TicketStatus = "refunded"
	StatusExpired   TicketStatus = "expired"
)

// Ticket represents an event ticket
type Ticket struct {
	ID             uuid.UUID    `json:"id" db:"id"`
	UserID         uuid.UUID    `json:"user_id" db:"user_id"`
	EventID        uuid.UUID    `json:"event_id" db:"event_id"`
	AttendanceCode string       `json:"attendance_code" db:"attendance_code"`
	PricePaid      float64      `json:"price_paid" db:"price_paid"`
	PurchasedAt    time.Time    `json:"purchased_at" db:"purchased_at"`
	IsCheckedIn    bool         `json:"is_checked_in" db:"is_checked_in"`
	CheckedInAt    *time.Time   `json:"checked_in_at,omitempty" db:"checked_in_at"`
	Status         TicketStatus `json:"status" db:"status"`
}

// TicketWithDetails includes additional ticket information
type TicketWithDetails struct {
	Ticket
	UserName        string    `json:"user_name"`
	UserEmail       string    `json:"user_email"`
	EventTitle      string    `json:"event_title"`
	EventStartTime  time.Time `json:"event_start_time"`
	EventLocation   string    `json:"event_location"`
}

// TransactionStatus represents the payment transaction status
type TransactionStatus string

const (
	TransactionPending  TransactionStatus = "pending"
	TransactionSuccess  TransactionStatus = "success"
	TransactionFailed   TransactionStatus = "failed"
	TransactionRefunded TransactionStatus = "refunded"
)

// TicketTransaction represents a ticket purchase transaction
type TicketTransaction struct {
	ID            uuid.UUID         `json:"id" db:"id"`
	TicketID      uuid.UUID         `json:"ticket_id" db:"ticket_id"`
	TransactionID string            `json:"transaction_id" db:"transaction_id"` // Midtrans ID
	Amount        float64           `json:"amount" db:"amount"`
	PaymentMethod string            `json:"payment_method" db:"payment_method"`
	Status        TransactionStatus `json:"status" db:"status"`
	CreatedAt     time.Time         `json:"created_at" db:"created_at"`
	CompletedAt   *time.Time        `json:"completed_at,omitempty" db:"completed_at"`
}

// PurchaseTicketRequest represents ticket purchase data
type PurchaseTicketRequest struct {
	EventID       uuid.UUID `json:"event_id" binding:"required"`
	PaymentMethod *string   `json:"payment_method,omitempty"` // null for free events
}

// CheckInRequest represents check-in data
type CheckInRequest struct {
	AttendanceCode string `json:"attendance_code" binding:"required,len=4"`
}

// Business logic methods
func (t *Ticket) IsFree() bool {
	return t.PricePaid == 0
}

func (t *Ticket) IsValid() bool {
	return t.Status == StatusActive && !t.IsCheckedIn
}

func (t *Ticket) CanBeRefunded() bool {
	return t.Status == StatusActive && !t.IsCheckedIn
}

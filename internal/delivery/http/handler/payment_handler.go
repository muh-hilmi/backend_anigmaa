package handler

import (
	"net/http"
	"time"

	"github.com/anigmaa/backend/internal/domain/event"
	"github.com/anigmaa/backend/internal/domain/ticket"
	"github.com/anigmaa/backend/internal/domain/user"
	"github.com/anigmaa/backend/internal/infrastructure/payment"
	"github.com/anigmaa/backend/pkg/response"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// PaymentHandler handles payment-related HTTP requests
type PaymentHandler struct {
	midtransClient *payment.MidtransClient
	ticketRepo     ticket.Repository
	eventRepo      event.Repository
	userRepo       user.Repository
}

// NewPaymentHandler creates a new payment handler
func NewPaymentHandler(midtransClient *payment.MidtransClient, ticketRepo ticket.Repository, eventRepo event.Repository, userRepo user.Repository) *PaymentHandler {
	return &PaymentHandler{
		midtransClient: midtransClient,
		ticketRepo:     ticketRepo,
		eventRepo:      eventRepo,
		userRepo:       userRepo,
	}
}

// MidtransWebhook godoc
// @Summary Midtrans payment notification webhook
// @Description Handle payment notifications from Midtrans
// @Tags payments
// @Accept json
// @Produce json
// @Param notification body payment.TransactionStatus true "Payment notification"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /webhooks/midtrans [post]
func (h *PaymentHandler) MidtransWebhook(c *gin.Context) {
	// Parse notification from Midtrans
	var notification payment.TransactionStatus
	if err := c.ShouldBindJSON(&notification); err != nil {
		response.BadRequest(c, "Invalid notification format", err.Error())
		return
	}

	// Verify signature
	isValid := h.midtransClient.VerifySignature(
		notification.OrderID,
		notification.StatusCode,
		notification.GrossAmount,
		notification.SignatureKey,
	)

	if !isValid {
		response.BadRequest(c, "Invalid signature", "Webhook signature verification failed")
		return
	}

	// Map Midtrans transaction status to our transaction status
	var txnStatus ticket.TransactionStatus
	switch notification.TransactionStatus {
	case "capture":
		// For credit card, check fraud status
		if notification.FraudStatus == "challenge" {
			txnStatus = ticket.TransactionPending // Wait for manual review
		} else if notification.FraudStatus == "accept" {
			txnStatus = ticket.TransactionSuccess
		} else {
			txnStatus = ticket.TransactionFailed
		}
	case "settlement":
		txnStatus = ticket.TransactionSuccess
	case "pending":
		txnStatus = ticket.TransactionPending
	case "deny", "cancel", "expire":
		txnStatus = ticket.TransactionFailed
	case "refund":
		txnStatus = ticket.TransactionRefunded
	default:
		// Unknown status, log and return success to prevent retries
		c.JSON(http.StatusOK, gin.H{"status": "ok", "message": "Unknown transaction status"})
		return
	}

	// Update transaction status in database
	err := h.ticketRepo.UpdateTransactionStatus(c.Request.Context(), notification.TransactionID, txnStatus)
	if err != nil {
		// Log error but still return 200 to Midtrans to prevent retries
		c.JSON(http.StatusOK, gin.H{"status": "ok", "message": "Transaction not found, ignoring"})
		return
	}

	// If payment is successful, we need to activate the ticket
	if txnStatus == ticket.TransactionSuccess {
		// Get transaction to find the ticket ID
		transaction, err := h.ticketRepo.GetTransaction(c.Request.Context(), notification.TransactionID)
		if err != nil {
			// Transaction not found, but we already updated status, so return success
			c.JSON(http.StatusOK, gin.H{"status": "ok", "message": "Transaction processed"})
			return
		}

		// Get the ticket
		tkt, err := h.ticketRepo.GetByID(c.Request.Context(), transaction.TicketID)
		if err != nil {
			// Ticket not found, but transaction is updated, return success
			c.JSON(http.StatusOK, gin.H{"status": "ok", "message": "Transaction processed"})
			return
		}

		// Update ticket status to active (it might have been pending)
		tkt.Status = ticket.StatusActive
		err = h.ticketRepo.Update(c.Request.Context(), tkt)
		if err != nil {
			// Failed to update ticket, but transaction is recorded, log and return success
			c.JSON(http.StatusOK, gin.H{"status": "ok", "message": "Transaction processed, ticket update pending"})
			return
		}

		// Update transaction completed_at timestamp
		now := time.Now()
		transaction.CompletedAt = &now
		_ = h.ticketRepo.CreateTransaction(c.Request.Context(), transaction)

		// Join the event (create attendee record)
		attendee := &event.EventAttendee{
			ID:       uuid.New(),
			EventID:  tkt.EventID,
			UserID:   tkt.UserID,
			JoinedAt: now,
			Status:   event.AttendeeConfirmed,
		}
		_ = h.eventRepo.Join(c.Request.Context(), attendee)

		// Increment events attended for user stats
		_ = h.userRepo.IncrementEventsAttended(c.Request.Context(), tkt.UserID)
	}

	// If payment failed, cancel the ticket
	if txnStatus == ticket.TransactionFailed {
		// Get transaction to find the ticket ID
		transaction, err := h.ticketRepo.GetTransaction(c.Request.Context(), notification.TransactionID)
		if err == nil {
			// Get the ticket
			tkt, err := h.ticketRepo.GetByID(c.Request.Context(), transaction.TicketID)
			if err == nil {
				// Update ticket status to cancelled
				tkt.Status = ticket.StatusCancelled
				_ = h.ticketRepo.Update(c.Request.Context(), tkt)
			}
		}
	}

	// Return success to Midtrans
	response.Success(c, http.StatusOK, "Payment notification processed successfully", gin.H{
		"order_id":           notification.OrderID,
		"transaction_status": txnStatus,
	})
}

// GetTransactionStatus godoc
// @Summary Get transaction status
// @Description Get the current status of a transaction by order ID
// @Tags payments
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param order_id path string true "Order ID"
// @Success 200 {object} response.Response{data=payment.TransactionStatus}
// @Failure 400 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /payments/transactions/{order_id}/status [get]
func (h *PaymentHandler) GetTransactionStatus(c *gin.Context) {
	orderID := c.Param("order_id")
	if orderID == "" {
		response.BadRequest(c, "Order ID is required", "")
		return
	}

	// Query Midtrans for transaction status
	status, err := h.midtransClient.GetTransactionStatus(c.Request.Context(), orderID)
	if err != nil {
		response.InternalError(c, "Failed to get transaction status", err.Error())
		return
	}

	response.Success(c, http.StatusOK, "Transaction status retrieved successfully", status)
}

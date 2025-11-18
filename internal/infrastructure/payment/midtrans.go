package payment

import (
	"bytes"
	"context"
	"crypto/sha512"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/anigmaa/backend/config"
	"github.com/google/uuid"
)

// MidtransClient handles Midtrans API interactions
type MidtransClient struct {
	serverKey    string
	clientKey    string
	isProduction bool
	httpClient   *http.Client
}

// NewMidtransClient creates a new Midtrans client
func NewMidtransClient(cfg *config.MidtransConfig) *MidtransClient {
	return &MidtransClient{
		serverKey:    cfg.ServerKey,
		clientKey:    cfg.ClientKey,
		isProduction: cfg.IsProduction,
		httpClient: &http.Client{
			Timeout: 30 * time.Second,
		},
	}
}

// getBaseURL returns the appropriate Midtrans API URL
func (m *MidtransClient) getBaseURL() string {
	if m.isProduction {
		return "https://app.midtrans.com"
	}
	return "https://app.sandbox.midtrans.com"
}

// SnapRequest represents the Snap API request
type SnapRequest struct {
	TransactionDetails TransactionDetails `json:"transaction_details"`
	CustomerDetails    CustomerDetails    `json:"customer_details"`
	ItemDetails        []ItemDetail       `json:"item_details"`
	Callbacks          *Callbacks         `json:"callbacks,omitempty"`
}

// TransactionDetails contains transaction information
type TransactionDetails struct {
	OrderID     string  `json:"order_id"`
	GrossAmount float64 `json:"gross_amount"`
}

// CustomerDetails contains customer information
type CustomerDetails struct {
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name,omitempty"`
	Email     string `json:"email"`
	Phone     string `json:"phone,omitempty"`
}

// ItemDetail contains item information
type ItemDetail struct {
	ID       string  `json:"id"`
	Price    float64 `json:"price"`
	Quantity int     `json:"quantity"`
	Name     string  `json:"name"`
}

// Callbacks contains callback URLs
type Callbacks struct {
	Finish string `json:"finish,omitempty"`
}

// SnapResponse represents the Snap API response
type SnapResponse struct {
	Token       string `json:"token"`
	RedirectURL string `json:"redirect_url"`
}

// CreateSnapToken creates a Snap payment token
func (m *MidtransClient) CreateSnapToken(ctx context.Context, req *SnapRequest) (*SnapResponse, error) {
	url := fmt.Sprintf("%s/snap/v1/transactions", m.getBaseURL())

	// Marshal request
	jsonData, err := json.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal request: %w", err)
	}

	// Create HTTP request
	httpReq, err := http.NewRequestWithContext(ctx, "POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	// Set headers
	httpReq.Header.Set("Content-Type", "application/json")
	httpReq.Header.Set("Accept", "application/json")
	httpReq.SetBasicAuth(m.serverKey, "")

	// Send request
	resp, err := m.httpClient.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("failed to send request: %w", err)
	}
	defer resp.Body.Close()

	// Read response
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read response: %w", err)
	}

	// Check status code
	if resp.StatusCode != http.StatusOK && resp.StatusCode != http.StatusCreated {
		return nil, fmt.Errorf("midtrans API error (status %d): %s", resp.StatusCode, string(body))
	}

	// Parse response
	var snapResp SnapResponse
	if err := json.Unmarshal(body, &snapResp); err != nil {
		return nil, fmt.Errorf("failed to unmarshal response: %w", err)
	}

	return &snapResp, nil
}

// TransactionStatus represents transaction status from webhook/notification
type TransactionStatus struct {
	TransactionID     string  `json:"transaction_id"`
	OrderID           string  `json:"order_id"`
	GrossAmount       string  `json:"gross_amount"`
	PaymentType       string  `json:"payment_type"`
	TransactionTime   string  `json:"transaction_time"`
	TransactionStatus string  `json:"transaction_status"`
	FraudStatus       string  `json:"fraud_status,omitempty"`
	StatusCode        string  `json:"status_code"`
	SignatureKey      string  `json:"signature_key"`
}

// GetTransactionStatus fetches transaction status from Midtrans
func (m *MidtransClient) GetTransactionStatus(ctx context.Context, orderID string) (*TransactionStatus, error) {
	url := fmt.Sprintf("%s/v2/%s/status", m.getBaseURL(), orderID)

	// Create HTTP request
	httpReq, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	// Set headers
	httpReq.Header.Set("Accept", "application/json")
	httpReq.SetBasicAuth(m.serverKey, "")

	// Send request
	resp, err := m.httpClient.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("failed to send request: %w", err)
	}
	defer resp.Body.Close()

	// Read response
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read response: %w", err)
	}

	// Check status code
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("midtrans API error (status %d): %s", resp.StatusCode, string(body))
	}

	// Parse response
	var status TransactionStatus
	if err := json.Unmarshal(body, &status); err != nil {
		return nil, fmt.Errorf("failed to unmarshal response: %w", err)
	}

	return &status, nil
}

// VerifySignature verifies the webhook signature from Midtrans
func (m *MidtransClient) VerifySignature(orderID, statusCode, grossAmount, signatureKey string) bool {
	// Signature verification: SHA512(order_id + status_code + gross_amount + server_key)
	payload := orderID + statusCode + grossAmount + m.serverKey
	expectedSig := fmt.Sprintf("%x", sha512Sum(payload))
	return expectedSig == signatureKey
}

// Helper function for SHA512 hashing
func sha512Sum(data string) []byte {
	h := sha512.New()
	h.Write([]byte(data))
	return h.Sum(nil)
}

// GenerateOrderID generates a unique order ID for transactions
func GenerateOrderID(ticketID uuid.UUID) string {
	timestamp := time.Now().Unix()
	return fmt.Sprintf("TKT-%s-%d", ticketID.String()[:8], timestamp)
}

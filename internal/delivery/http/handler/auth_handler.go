package handler

import (
	"net/http"

	"github.com/anigmaa/backend/internal/delivery/http/middleware"
	"github.com/anigmaa/backend/internal/domain/user"
	userUsecase "github.com/anigmaa/backend/internal/usecase/user"
	"github.com/anigmaa/backend/pkg/response"
	"github.com/anigmaa/backend/pkg/validator"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// AuthHandler handles authentication-related HTTP requests
type AuthHandler struct {
	userUsecase *userUsecase.Usecase
	validator   *validator.Validator
}

// NewAuthHandler creates a new authentication handler
func NewAuthHandler(userUsecase *userUsecase.Usecase, validator *validator.Validator) *AuthHandler {
	return &AuthHandler{
		userUsecase: userUsecase,
		validator:   validator,
	}
}

// Register godoc
// @Summary Register a new user
// @Description Register a new user with email and password
// @Tags auth
// @Accept json
// @Produce json
// @Param request body user.RegisterRequest true "Registration data"
// @Success 201 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 409 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /auth/register [post]
func (h *AuthHandler) Register(c *gin.Context) {
	var req user.RegisterRequest

	// Parse request body
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request body", err.Error())
		return
	}

	// Validate request
	if err := h.validator.Validate(&req); err != nil {
		response.BadRequest(c, "Validation failed", err.Error())
		return
	}

	// Call usecase
	authResp, err := h.userUsecase.Register(c.Request.Context(), &req)
	if err != nil {
		if err == userUsecase.ErrEmailAlreadyExists {
			response.Conflict(c, "Email already exists", err.Error())
			return
		}
		response.InternalError(c, "Failed to register user", err.Error())
		return
	}

	response.Success(c, http.StatusCreated, "User registered successfully", authResp)
}

// Login godoc
// @Summary Login user
// @Description Authenticate user with email and password
// @Tags auth
// @Accept json
// @Produce json
// @Param request body user.LoginRequest true "Login credentials"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /auth/login [post]
func (h *AuthHandler) Login(c *gin.Context) {
	var req user.LoginRequest

	// Parse request body
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request body", err.Error())
		return
	}

	// Validate request
	if err := h.validator.Validate(&req); err != nil {
		response.BadRequest(c, "Validation failed", err.Error())
		return
	}

	// Call usecase
	authResp, err := h.userUsecase.Login(c.Request.Context(), &req)
	if err != nil {
		if err == userUsecase.ErrInvalidCredentials {
			response.Unauthorized(c, "Invalid email or password")
			return
		}
		response.InternalError(c, "Failed to login", err.Error())
		return
	}

	response.Success(c, http.StatusOK, "Login successful", authResp)
}

// Logout godoc
// @Summary Logout user
// @Description Logout the current user (invalidate token)
// @Tags auth
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 {object} response.Response
// @Failure 401 {object} response.Response
// @Router /auth/logout [post]
func (h *AuthHandler) Logout(c *gin.Context) {
	// In a stateless JWT system, logout is typically handled on the client side
	// The client should remove the token from storage
	// For server-side logout, you would need to implement token blacklisting
	// using Redis or similar storage

	response.Success(c, http.StatusOK, "Logout successful", nil)
}

// RefreshToken godoc
// @Summary Refresh access token
// @Description Get a new access token using a refresh token
// @Tags auth
// @Accept json
// @Produce json
// @Param request body map[string]string true "Refresh token"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /auth/refresh [post]
func (h *AuthHandler) RefreshToken(c *gin.Context) {
	var req struct {
		RefreshToken string `json:"refresh_token" binding:"required"`
	}

	// Parse request body
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request body", err.Error())
		return
	}

	// Call usecase
	authResp, err := h.userUsecase.RefreshToken(c.Request.Context(), req.RefreshToken)
	if err != nil {
		if err == userUsecase.ErrUnauthorized {
			response.Unauthorized(c, "Invalid or expired refresh token")
			return
		}
		response.InternalError(c, "Failed to refresh token", err.Error())
		return
	}

	response.Success(c, http.StatusOK, "Token refreshed successfully", authResp)
}

// ForgotPassword godoc
// @Summary Request password reset
// @Description Send password reset email
// @Tags auth
// @Accept json
// @Produce json
// @Param request body map[string]string true "Email"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 404 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /auth/forgot-password [post]
func (h *AuthHandler) ForgotPassword(c *gin.Context) {
	var req struct {
		Email string `json:"email" binding:"required,email"`
	}

	// Parse request body
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request body", err.Error())
		return
	}

	// TODO: Implement password reset logic
	// 1. Verify user exists
	// 2. Generate reset token
	// 3. Send reset email
	// 4. Store reset token with expiration

	// For now, return success (in production, implement actual logic)
	response.Success(c, http.StatusOK, "Password reset email sent", nil)
}

// ResetPassword godoc
// @Summary Reset password
// @Description Reset password using reset token
// @Tags auth
// @Accept json
// @Produce json
// @Param request body map[string]string true "Reset data"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /auth/reset-password [post]
func (h *AuthHandler) ResetPassword(c *gin.Context) {
	var req struct {
		Token       string `json:"token" binding:"required"`
		NewPassword string `json:"new_password" binding:"required,min=8"`
	}

	// Parse request body
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request body", err.Error())
		return
	}

	// TODO: Implement password reset logic
	// 1. Verify reset token
	// 2. Check token expiration
	// 3. Hash new password
	// 4. Update user password
	// 5. Invalidate reset token

	// For now, return success (in production, implement actual logic)
	response.Success(c, http.StatusOK, "Password reset successful", nil)
}

// VerifyEmail godoc
// @Summary Verify email
// @Description Verify user email using verification token
// @Tags auth
// @Accept json
// @Produce json
// @Param request body map[string]string true "Verification token"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /auth/verify-email [post]
func (h *AuthHandler) VerifyEmail(c *gin.Context) {
	var req struct {
		Token string `json:"token" binding:"required"`
	}

	// Parse request body
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request body", err.Error())
		return
	}

	// TODO: Implement email verification logic
	// 1. Verify token
	// 2. Extract user ID from token
	// 3. Mark email as verified

	// For now, parse token as user ID (in production, implement proper token verification)
	userID, err := uuid.Parse(req.Token)
	if err != nil {
		response.BadRequest(c, "Invalid verification token", err.Error())
		return
	}

	// Call usecase
	if err := h.userUsecase.VerifyEmail(c.Request.Context(), userID); err != nil {
		if err == userUsecase.ErrUserNotFound {
			response.NotFound(c, "User not found")
			return
		}
		response.InternalError(c, "Failed to verify email", err.Error())
		return
	}

	response.Success(c, http.StatusOK, "Email verified successfully", nil)
}

// GetMe godoc
// @Summary Get current user
// @Description Get the profile of the currently authenticated user
// @Tags auth
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 {object} response.Response{data=user.UserProfile}
// @Failure 401 {object} response.Response
// @Failure 404 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /auth/me [get]
func (h *AuthHandler) GetMe(c *gin.Context) {
	// Get user ID from context
	userIDStr, exists := middleware.GetUserID(c)
	if !exists {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		response.BadRequest(c, "Invalid user ID", err.Error())
		return
	}

	// Call usecase
	profile, err := h.userUsecase.GetProfile(c.Request.Context(), userID)
	if err != nil {
		if err == userUsecase.ErrUserNotFound {
			response.NotFound(c, "User not found")
			return
		}
		response.InternalError(c, "Failed to get user profile", err.Error())
		return
	}

	response.Success(c, http.StatusOK, "Profile retrieved successfully", profile)
}

// LoginWithGoogle godoc
// @Summary Login with Google
// @Description Authenticate user with Google ID token
// @Tags auth
// @Accept json
// @Produce json
// @Param request body user.GoogleAuthRequest true "Google ID token"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /auth/google [post]
func (h *AuthHandler) LoginWithGoogle(c *gin.Context) {
	var req user.GoogleAuthRequest

	// Parse request body
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request body", err.Error())
		return
	}

	// Validate request
	if err := h.validator.Validate(&req); err != nil {
		response.BadRequest(c, "Validation failed", err.Error())
		return
	}

	// Call usecase
	authResp, err := h.userUsecase.LoginWithGoogle(c.Request.Context(), &req)
	if err != nil {
		response.Error(c, http.StatusUnauthorized, err.Error(), "UNAUTHORIZED", "")
		return
	}

	response.Success(c, http.StatusOK, "Login successful", authResp)
}

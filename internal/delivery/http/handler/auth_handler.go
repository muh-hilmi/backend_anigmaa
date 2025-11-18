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

	// Call usecase to generate and send reset token
	token, err := h.userUsecase.SendPasswordResetEmail(c.Request.Context(), req.Email)
	if err != nil {
		if err == userUsecase.ErrUserNotFound {
			// For security, don't reveal if email exists or not
			response.Success(c, http.StatusOK, "If the email exists, a password reset link has been sent", nil)
			return
		}
		response.InternalError(c, "Failed to send password reset email", err.Error())
		return
	}

	// In production, the token would be sent via email
	// For development/testing, return the token in the response
	response.Success(c, http.StatusOK, "Password reset email sent", gin.H{
		"token": token, // Remove this in production
	})
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

	// Call usecase to reset password with token
	if err := h.userUsecase.ResetPasswordWithToken(c.Request.Context(), req.Token, req.NewPassword); err != nil {
		if err == userUsecase.ErrInvalidToken {
			response.Unauthorized(c, "Invalid or expired reset token")
			return
		}
		if err == userUsecase.ErrTokenAlreadyUsed {
			response.BadRequest(c, "Reset token has already been used", err.Error())
			return
		}
		response.InternalError(c, "Failed to reset password", err.Error())
		return
	}

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

	// Call usecase to verify email with token
	if err := h.userUsecase.VerifyEmailWithToken(c.Request.Context(), req.Token); err != nil {
		if err == userUsecase.ErrInvalidToken {
			response.Unauthorized(c, "Invalid or expired verification token")
			return
		}
		if err == userUsecase.ErrTokenAlreadyUsed {
			response.BadRequest(c, "Verification token has already been used", err.Error())
			return
		}
		if err == userUsecase.ErrUserNotFound {
			response.NotFound(c, "User not found")
			return
		}
		response.InternalError(c, "Failed to verify email", err.Error())
		return
	}

	response.Success(c, http.StatusOK, "Email verified successfully", nil)
}

// ResendVerificationEmail godoc
// @Summary Resend verification email
// @Description Resend email verification token to the current user
// @Tags auth
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /auth/resend-verification [post]
func (h *AuthHandler) ResendVerificationEmail(c *gin.Context) {
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

	// Call usecase to generate and send verification token
	token, err := h.userUsecase.SendVerificationEmail(c.Request.Context(), userID)
	if err != nil {
		if err == userUsecase.ErrUserNotFound {
			response.NotFound(c, "User not found")
			return
		}
		response.InternalError(c, "Failed to send verification email", err.Error())
		return
	}

	// In production, the token would be sent via email
	// For development/testing, return the token in the response
	response.Success(c, http.StatusOK, "Verification email sent", gin.H{
		"token": token, // Remove this in production
	})
}

// ChangePassword godoc
// @Summary Change password
// @Description Change the current user's password
// @Tags auth
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body user.ChangePasswordRequest true "Password change data"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /auth/change-password [post]
func (h *AuthHandler) ChangePassword(c *gin.Context) {
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

	var req user.ChangePasswordRequest

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
	if err := h.userUsecase.ChangePassword(c.Request.Context(), userID, &req); err != nil {
		if err == userUsecase.ErrInvalidCredentials {
			response.Unauthorized(c, "Current password is incorrect")
			return
		}
		if err == userUsecase.ErrUserNotFound {
			response.NotFound(c, "User not found")
			return
		}
		response.InternalError(c, "Failed to change password", err.Error())
		return
	}

	response.Success(c, http.StatusOK, "Password changed successfully", nil)
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

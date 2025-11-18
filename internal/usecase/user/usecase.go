package user

import (
	"context"
	"errors"
	"time"
	"encoding/json"
	"io"
	"net/http"
	"fmt"
	"strings"
	"regexp"
	"math/rand"

	"github.com/anigmaa/backend/internal/domain/user"
	"github.com/anigmaa/backend/pkg/jwt"
	"github.com/anigmaa/backend/pkg/password"
	"github.com/google/uuid"
)

var (
	ErrUserNotFound           = errors.New("user not found")
	ErrEmailAlreadyExists     = errors.New("email already exists")
	ErrUsernameAlreadyExists  = errors.New("username already exists")
	ErrInvalidCredentials     = errors.New("invalid credentials")
	ErrUnauthorized           = errors.New("unauthorized")
	ErrAlreadyFollowing       = errors.New("already following this user")
	ErrNotFollowing           = errors.New("not following this user")
	ErrCannotFollowSelf       = errors.New("cannot follow yourself")
)

// Usecase handles user business logic
type Usecase struct {
	userRepo       user.Repository
	jwtManager     *jwt.JWTManager
	googleClientID string
}

// NewUsecase creates a new user usecase
func NewUsecase(userRepo user.Repository, jwtManager *jwt.JWTManager, googleClientID string) *Usecase {
	return &Usecase{
		userRepo:       userRepo,
		jwtManager:     jwtManager,
		googleClientID: googleClientID,
	}
}

// AuthResponse represents authentication response
type AuthResponse struct {
	AccessToken  string      `json:"access_token"`
	RefreshToken string      `json:"refresh_token"`
	User         *user.User  `json:"user"`
	ExpiresIn    int64       `json:"expires_in"` // seconds
}

// generateUsername creates a unique username from name
func (uc *Usecase) generateUsername(ctx context.Context, name string, providedUsername *string) (string, error) {
	// If username is provided, validate and use it
	if providedUsername != nil && *providedUsername != "" {
		// Check if username already exists
		existing, _ := uc.userRepo.GetByUsername(ctx, *providedUsername)
		if existing != nil {
			return "", ErrUsernameAlreadyExists
		}
		return *providedUsername, nil
	}

	// Generate username from name
	// Remove non-alphanumeric characters and convert to lowercase
	reg := regexp.MustCompile("[^a-zA-Z0-9]+")
	baseUsername := reg.ReplaceAllString(name, "")
	baseUsername = strings.ToLower(baseUsername)

	// Limit to 20 characters
	if len(baseUsername) > 20 {
		baseUsername = baseUsername[:20]
	}

	// If baseUsername is empty, use "user"
	if baseUsername == "" {
		baseUsername = "user"
	}

	// Try to find a unique username
	username := baseUsername
	counter := 0
	maxAttempts := 100

	for counter < maxAttempts {
		existing, _ := uc.userRepo.GetByUsername(ctx, username)
		if existing == nil {
			// Username is available
			return username, nil
		}

		// Username taken, try with random number
		counter++
		username = fmt.Sprintf("%s%d", baseUsername, rand.Intn(10000))
	}

	// If still not found, use UUID suffix
	return fmt.Sprintf("%s_%s", baseUsername, uuid.New().String()[:8]), nil
}

// Register registers a new user
func (uc *Usecase) Register(ctx context.Context, req *user.RegisterRequest) (*AuthResponse, error) {
	// Check if email already exists
	existingUser, err := uc.userRepo.GetByEmail(ctx, req.Email)
	if err == nil && existingUser != nil {
		return nil, ErrEmailAlreadyExists
	}

	// Generate unique username
	username, err := uc.generateUsername(ctx, req.Name, req.Username)
	if err != nil {
		return nil, err
	}

	// Hash password
	hashedPassword, err := password.Hash(req.Password)
	if err != nil {
		return nil, err
	}

	// Create user
	now := time.Now()
	newUser := &user.User{
		ID:              uuid.New(),
		Email:           req.Email,
		Username:        username,
		PasswordHash:    hashedPassword,
		Name:            req.Name,
		CreatedAt:       now,
		UpdatedAt:       now,
		IsVerified:      false,
		IsEmailVerified: false,
	}

	if err := uc.userRepo.Create(ctx, newUser); err != nil {
		return nil, err
	}

	// Generate tokens
	accessToken, err := uc.jwtManager.Generate(newUser.ID, newUser.Email)
	if err != nil {
		return nil, err
	}

	refreshToken, err := uc.jwtManager.GenerateRefreshToken(newUser.ID, newUser.Email)
	if err != nil {
		return nil, err
	}

	return &AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		User:         newUser,
		ExpiresIn:    3600, // 1 hour
	}, nil
}

// Login authenticates a user
func (uc *Usecase) Login(ctx context.Context, req *user.LoginRequest) (*AuthResponse, error) {
	// Get user by email
	existingUser, err := uc.userRepo.GetByEmail(ctx, req.Email)
	if err != nil {
		return nil, ErrInvalidCredentials
	}

	// Verify password
	if err := password.Verify(existingUser.PasswordHash, req.Password); err != nil {
		return nil, ErrInvalidCredentials
	}

	// Update last login
	now := time.Now()
	existingUser.LastLoginAt = &now
	if err := uc.userRepo.Update(ctx, existingUser); err != nil {
		// Log error but don't fail login
	}

	// Generate tokens
	accessToken, err := uc.jwtManager.Generate(existingUser.ID, existingUser.Email)
	if err != nil {
		return nil, err
	}

	refreshToken, err := uc.jwtManager.GenerateRefreshToken(existingUser.ID, existingUser.Email)
	if err != nil {
		return nil, err
	}

	return &AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		User:         existingUser,
		ExpiresIn:    3600, // 1 hour
	}, nil
}

// RefreshToken generates a new access token from a refresh token
func (uc *Usecase) RefreshToken(ctx context.Context, refreshToken string) (*AuthResponse, error) {
	// Verify refresh token
	claims, err := uc.jwtManager.Verify(refreshToken)
	if err != nil {
		return nil, ErrUnauthorized
	}

	// Get user
	existingUser, err := uc.userRepo.GetByID(ctx, claims.UserID)
	if err != nil {
		return nil, ErrUserNotFound
	}

	// Generate new tokens
	accessToken, err := uc.jwtManager.Generate(existingUser.ID, existingUser.Email)
	if err != nil {
		return nil, err
	}

	newRefreshToken, err := uc.jwtManager.GenerateRefreshToken(existingUser.ID, existingUser.Email)
	if err != nil {
		return nil, err
	}

	return &AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: newRefreshToken,
		User:         existingUser,
		ExpiresIn:    3600, // 1 hour
	}, nil
}

// GetProfile gets a user's complete profile
func (uc *Usecase) GetProfile(ctx context.Context, userID uuid.UUID) (*user.UserProfile, error) {
	profile, err := uc.userRepo.GetProfile(ctx, userID)
	if err != nil {
		return nil, ErrUserNotFound
	}
	return profile, nil
}

// GetProfileByUsername gets a user's complete profile by username
func (uc *Usecase) GetProfileByUsername(ctx context.Context, username string) (*user.UserProfile, error) {
	profile, err := uc.userRepo.GetProfileByUsername(ctx, username)
	if err != nil {
		return nil, ErrUserNotFound
	}
	return profile, nil
}

// GetByID gets a user by ID
func (uc *Usecase) GetByID(ctx context.Context, userID uuid.UUID) (*user.User, error) {
	existingUser, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, ErrUserNotFound
	}
	return existingUser, nil
}

// GetByUsername gets a user by username
func (uc *Usecase) GetByUsername(ctx context.Context, username string) (*user.User, error) {
	existingUser, err := uc.userRepo.GetByUsername(ctx, username)
	if err != nil {
		return nil, ErrUserNotFound
	}
	return existingUser, nil
}

// UpdateProfile updates a user's profile
func (uc *Usecase) UpdateProfile(ctx context.Context, userID uuid.UUID, req *user.UpdateProfileRequest) (*user.User, error) {
	// Get existing user
	existingUser, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, ErrUserNotFound
	}

	// Update fields if provided
	if req.Name != nil {
		existingUser.Name = *req.Name
	}
	if req.Username != nil {
		// Check if username is already taken by another user
		userByUsername, _ := uc.userRepo.GetByUsername(ctx, *req.Username)
		if userByUsername != nil && userByUsername.ID != userID {
			return nil, ErrUsernameAlreadyExists
		}
		existingUser.Username = *req.Username
	}
	if req.Bio != nil {
		existingUser.Bio = req.Bio
	}
	if req.AvatarURL != nil {
		existingUser.AvatarURL = req.AvatarURL
	}

	existingUser.UpdatedAt = time.Now()

	// Save changes
	if err := uc.userRepo.Update(ctx, existingUser); err != nil {
		return nil, err
	}

	return existingUser, nil
}

// UpdateSettings updates a user's settings
func (uc *Usecase) UpdateSettings(ctx context.Context, userID uuid.UUID, req *user.UpdateSettingsRequest) (*user.UserSettings, error) {
	// Get current settings from profile
	profile, err := uc.userRepo.GetProfile(ctx, userID)
	if err != nil {
		return nil, ErrUserNotFound
	}

	settings := profile.Settings

	// Update fields if provided
	if req.PushNotifications != nil {
		settings.PushNotifications = *req.PushNotifications
	}
	if req.EmailNotifications != nil {
		settings.EmailNotifications = *req.EmailNotifications
	}
	if req.DarkMode != nil {
		settings.DarkMode = *req.DarkMode
	}
	if req.Language != nil {
		settings.Language = *req.Language
	}
	if req.LocationEnabled != nil {
		settings.LocationEnabled = *req.LocationEnabled
	}
	if req.ShowOnlineStatus != nil {
		settings.ShowOnlineStatus = *req.ShowOnlineStatus
	}

	// Save changes
	if err := uc.userRepo.UpdateSettings(ctx, &settings); err != nil {
		return nil, err
	}

	return &settings, nil
}

// Follow follows a user
func (uc *Usecase) Follow(ctx context.Context, followerID, followingID uuid.UUID) error {
	// Check if trying to follow self
	if followerID == followingID {
		return ErrCannotFollowSelf
	}

	// Check if already following
	isFollowing, err := uc.userRepo.IsFollowing(ctx, followerID, followingID)
	if err != nil {
		return err
	}
	if isFollowing {
		return ErrAlreadyFollowing
	}

	// Check if user to follow exists
	_, err = uc.userRepo.GetByID(ctx, followingID)
	if err != nil {
		return ErrUserNotFound
	}

	// Create follow relationship
	return uc.userRepo.Follow(ctx, followerID, followingID)
}

// Unfollow unfollows a user
func (uc *Usecase) Unfollow(ctx context.Context, followerID, followingID uuid.UUID) error {
	// Check if following
	isFollowing, err := uc.userRepo.IsFollowing(ctx, followerID, followingID)
	if err != nil {
		return err
	}
	if !isFollowing {
		return ErrNotFollowing
	}

	// Remove follow relationship
	return uc.userRepo.Unfollow(ctx, followerID, followingID)
}

// GetFollowers gets a user's followers
func (uc *Usecase) GetFollowers(ctx context.Context, userID uuid.UUID, limit, offset int) ([]user.User, error) {
	// Check if user exists
	_, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, ErrUserNotFound
	}

	return uc.userRepo.GetFollowers(ctx, userID, limit, offset)
}

// GetFollowing gets users that a user is following
func (uc *Usecase) GetFollowing(ctx context.Context, userID uuid.UUID, limit, offset int) ([]user.User, error) {
	// Check if user exists
	_, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, ErrUserNotFound
	}

	return uc.userRepo.GetFollowing(ctx, userID, limit, offset)
}

// IsFollowing checks if a user is following another user
func (uc *Usecase) IsFollowing(ctx context.Context, followerID, followingID uuid.UUID) (bool, error) {
	return uc.userRepo.IsFollowing(ctx, followerID, followingID)
}

// SearchUsers searches for users by query
func (uc *Usecase) SearchUsers(ctx context.Context, query string, limit, offset int) ([]user.User, error) {
	if limit <= 0 {
		limit = 20
	}
	if limit > 100 {
		limit = 100
	}

	return uc.userRepo.SearchUsers(ctx, query, limit, offset)
}

// GetStats gets a user's statistics
func (uc *Usecase) GetStats(ctx context.Context, userID uuid.UUID) (*user.UserStats, error) {
	// Check if user exists
	_, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, ErrUserNotFound
	}

	return uc.userRepo.GetStats(ctx, userID)
}

// VerifyEmail marks a user's email as verified
func (uc *Usecase) VerifyEmail(ctx context.Context, userID uuid.UUID) error {
	existingUser, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return ErrUserNotFound
	}

	existingUser.IsEmailVerified = true
	existingUser.UpdatedAt = time.Now()

	return uc.userRepo.Update(ctx, existingUser)
}

// ChangePassword changes a user's password
func (uc *Usecase) ChangePassword(ctx context.Context, userID uuid.UUID, req *user.ChangePasswordRequest) error {
	// Get existing user
	existingUser, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return ErrUserNotFound
	}

	// Verify current password
	if err := password.Verify(existingUser.PasswordHash, req.CurrentPassword); err != nil {
		return ErrInvalidCredentials
	}

	// Hash new password
	hashedPassword, err := password.Hash(req.NewPassword)
	if err != nil {
		return err
	}

	// Update password
	existingUser.PasswordHash = hashedPassword
	existingUser.UpdatedAt = time.Now()

	return uc.userRepo.Update(ctx, existingUser)
}

// DeleteAccount deletes a user account
func (uc *Usecase) DeleteAccount(ctx context.Context, userID uuid.UUID) error {
	// Check if user exists
	_, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return ErrUserNotFound
	}

	return uc.userRepo.Delete(ctx, userID)
}

// GoogleTokenInfo represents the user info from Google ID token
// FlexibleBool can unmarshal from both boolean and string values
type FlexibleBool bool

// UnmarshalJSON implements custom unmarshaling for FlexibleBool
func (fb *FlexibleBool) UnmarshalJSON(data []byte) error {
	// Try to unmarshal as boolean first
	var b bool
	if err := json.Unmarshal(data, &b); err == nil {
		*fb = FlexibleBool(b)
		return nil
	}

	// If that fails, try as string
	var s string
	if err := json.Unmarshal(data, &s); err != nil {
		return err
	}

	// Convert string to bool
	*fb = FlexibleBool(s == "true" || s == "True" || s == "TRUE" || s == "1")
	return nil
}

type GoogleTokenInfo struct {
	Aud           string       `json:"aud"` // Audience
	Email         string       `json:"email"`
	EmailVerified FlexibleBool `json:"email_verified"`
	Name          string       `json:"name"`
	Picture       string       `json:"picture"`
	Sub           string       `json:"sub"` // Google user ID
}

// LoginWithGoogle authenticates a user using Google ID token
func (uc *Usecase) LoginWithGoogle(ctx context.Context, req *user.GoogleAuthRequest) (*AuthResponse, error) {
	// Verify Google ID token and get user info
	googleInfo, err := uc.verifyGoogleToken(req.IDToken)
	if err != nil {
		return nil, fmt.Errorf("failed to verify Google token: %w", err)
	}

	// Check if user exists
	existingUser, err := uc.userRepo.GetByEmail(ctx, googleInfo.Email)

	if err != nil {
		// User doesn't exist, create new user
		// Generate unique username
		username, err := uc.generateUsername(ctx, googleInfo.Name, nil)
		if err != nil {
			return nil, fmt.Errorf("failed to generate username: %w", err)
		}

		now := time.Now()
		newUser := &user.User{
			ID:              uuid.New(),
			Email:           googleInfo.Email,
			Username:        username,
			PasswordHash:    "", // No password for Google auth users
			Name:            googleInfo.Name,
			AvatarURL:       &googleInfo.Picture,
			CreatedAt:       now,
			UpdatedAt:       now,
			LastLoginAt:     &now,
			IsVerified:      true,
			IsEmailVerified: bool(googleInfo.EmailVerified),
		}

		if err := uc.userRepo.Create(ctx, newUser); err != nil {
			return nil, fmt.Errorf("failed to create user: %w", err)
		}

		existingUser = newUser
	} else {
		// User exists, update last login
		now := time.Now()
		existingUser.LastLoginAt = &now
		if err := uc.userRepo.Update(ctx, existingUser); err != nil {
			// Log error but don't fail login
		}
	}

	// Generate tokens
	accessToken, err := uc.jwtManager.Generate(existingUser.ID, existingUser.Email)
	if err != nil {
		return nil, fmt.Errorf("failed to generate access token: %w", err)
	}

	refreshToken, err := uc.jwtManager.GenerateRefreshToken(existingUser.ID, existingUser.Email)
	if err != nil {
		return nil, fmt.Errorf("failed to generate refresh token: %w", err)
	}

	return &AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		User:         existingUser,
		ExpiresIn:    3600, // 1 hour
	}, nil
}

// verifyGoogleToken verifies the Google ID token and returns user info
func (uc *Usecase) verifyGoogleToken(idToken string) (*GoogleTokenInfo, error) {
	// Call Google's tokeninfo endpoint to verify the token
	url := fmt.Sprintf("https://oauth2.googleapis.com/tokeninfo?id_token=%s", idToken)

	resp, err := http.Get(url)
	if err != nil {
		return nil, fmt.Errorf("failed to verify token: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("token verification failed: %s", string(body))
	}

	var tokenInfo GoogleTokenInfo
	if err := json.NewDecoder(resp.Body).Decode(&tokenInfo); err != nil {
		return nil, fmt.Errorf("failed to decode token info: %w", err)
	}

	// Verify audience matches our Google Client ID
	if uc.googleClientID != "" && tokenInfo.Aud != uc.googleClientID {
		return nil, fmt.Errorf("invalid audience: expected %s, got %s", uc.googleClientID, tokenInfo.Aud)
	}

	return &tokenInfo, nil
}

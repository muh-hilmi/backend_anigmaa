# Frontend Bug Fixes Guide
**Date:** 2025-11-12
**Project:** Anigmaa Flutter App
**Backend:** Backend API v1.0

---

## 🎯 Overview

This document provides comprehensive instructions for fixing frontend bugs identified in the API request document. The backend is now fully implemented and ready to support these fixes.

---

## 🐛 Bug #1: Remove ID Generation from CreatePostScreen ⚠️ HIGH PRIORITY

### **Issue:**
CreatePostScreen (line ~307) generates post IDs on the frontend using `temp_` prefix:
```dart
// ❌ WRONG - Frontend shouldn't generate IDs
final post = Post(
  id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
  authorId: currentUser.id,
  content: _contentController.text,
  // ...
);
```

### **Why This Is Wrong:**
1. **Security Risk:** Client-generated IDs can be manipulated
2. **Database Conflicts:** May cause ID collisions
3. **Bad Practice:** Backend should be single source of truth for IDs
4. **Already Fixed in Backend:** Backend ignores frontend IDs and generates new ones

### **Solution:**

#### **Step 1: Update Post Model (if needed)**
```dart
// lib/domain/entities/post.dart

class Post {
  final String? id;  // Make id nullable for creation
  final String authorId;
  final String content;
  final PostType type;
  // ... other fields

  Post({
    this.id,  // Optional during creation
    required this.authorId,
    required this.content,
    required this.type,
    // ...
  });
}
```

#### **Step 2: Update CreatePostRequest**
```dart
// lib/data/models/post_model.dart

class CreatePostRequest {
  final String content;
  final PostType type;
  final List<String>? imageUrls;
  final String? attachedEventId;
  final PostVisibility visibility;

  // ❌ NO ID FIELD HERE

  CreatePostRequest({
    required this.content,
    required this.type,
    this.imageUrls,
    this.attachedEventId,
    required this.visibility,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    'type': type.name,
    'image_urls': imageUrls,
    'attached_event_id': attachedEventId,
    'visibility': visibility.name,
    // ❌ DON'T send 'id' field
  };
}
```

#### **Step 3: Update CreatePostScreen**
```dart
// lib/presentation/screens/create_post_screen.dart

// ❌ REMOVE THIS:
// final post = Post(
//   id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
//   ...
// );

// ✅ REPLACE WITH:
Future<void> _submitPost() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final request = CreatePostRequest(
      content: _contentController.text,
      type: _selectedType,
      imageUrls: _uploadedImageUrls,
      attachedEventId: _selectedEvent?.id,
      visibility: _selectedVisibility,
    );

    // Backend will generate ID and return full post object
    final createdPost = await _postRepository.createPost(request);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, createdPost);  // Return created post with backend ID
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create post: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
```

#### **Step 4: Update Repository (PostRepository)**
```dart
// lib/data/repositories/post_repository.dart

class PostRepository {
  Future<Post> createPost(CreatePostRequest request) async {
    final response = await _apiClient.post(
      '/posts',
      data: request.toJson(),
    );

    // Backend returns full post with generated ID
    return Post.fromJson(response.data['data']);
  }
}
```

### **Expected Backend Response:**
```json
{
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",  // UUID from backend
    "author": {
      "id": "user-uuid",
      "name": "John Doe",
      "username": "johndoe",
      "avatar": "https://..."
    },
    "content": "Hello world!",
    "type": "text",
    "created_at": "2025-11-12T15:30:00Z",
    "likes_count": 0,
    "comments_count": 0,
    // ...
  }
}
```

---

## 🐛 Bug #2: Remove ID Generation from CreateEventScreen ⚠️ HIGH PRIORITY

### **Issue:**
CreateEventScreen (line ~1627) also generates event IDs on frontend.

### **Solution:**

#### **Step 1: Update CreateEventRequest**
```dart
// lib/data/models/event_model.dart

class CreateEventRequest {
  final String title;
  final String description;
  final EventCategory category;
  final DateTime startTime;
  final DateTime endTime;
  final LocationData location;
  // ... other fields

  // ❌ NO ID FIELD

  CreateEventRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.startTime,
    required this.endTime,
    required this.location,
    // ...
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'category': category.name,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime.toIso8601String(),
    'location': location.toJson(),
    // ❌ DON'T send 'id'
  };
}
```

#### **Step 2: Update CreateEventScreen**
```dart
// lib/presentation/screens/create_event_screen.dart

Future<void> _submitEvent() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    // ❌ REMOVE: id: 'temp_${DateTime.now().millisecondsSinceEpoch}'

    final request = CreateEventRequest(
      title: _titleController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      startTime: _startDateTime,
      endTime: _endDateTime,
      location: _locationData,
      maxAttendees: _maxAttendeesController.text.isEmpty
          ? null
          : int.parse(_maxAttendeesController.text),
      price: _isFree ? null : double.parse(_priceController.text),
      isFree: _isFree,
      requirements: _requirementsController.text.isEmpty
          ? null
          : _requirementsController.text,
      privacy: _selectedPrivacy,
      imageUrls: _uploadedImageUrls,
    );

    // Backend generates ID
    final createdEvent = await _eventRepository.createEvent(request);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event created successfully!')),
      );
      Navigator.pop(context, createdEvent);
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create event: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
```

---

## 🆕 Feature Request: Add Event Tagging to Posts

### **Overview:**
Users want to tag events when creating posts. This feature is already supported by the backend!

### **Backend Support:**
```dart
// Backend API already supports:
POST /api/v1/posts
{
  "content": "string",
  "type": "text",
  "attached_event_id": "uuid",  // ✅ Already implemented!
  "visibility": "public"
}
```

### **Implementation Steps:**

#### **Step 1: Update Post Entity**
```dart
// lib/domain/entities/post.dart

class Post {
  final String id;
  final String authorId;
  final String content;
  final PostType type;
  final EventSummary? attachedEvent;  // ✅ Add this field
  // ... other fields

  Post({
    required this.id,
    required this.authorId,
    required this.content,
    required this.type,
    this.attachedEvent,
    // ...
  });
}

// Add EventSummary entity
class EventSummary {
  final String id;
  final String title;
  final DateTime startTime;
  final String location;

  EventSummary({
    required this.id,
    required this.title,
    required this.startTime,
    required this.location,
  });

  factory EventSummary.fromJson(Map<String, dynamic> json) => EventSummary(
    id: json['id'],
    title: json['title'],
    startTime: DateTime.parse(json['start_time']),
    location: json['location'],
  );
}
```

#### **Step 2: Update CreatePostScreen UI**
```dart
// lib/presentation/screens/create_post_screen.dart

class _CreatePostScreenState extends State<CreatePostScreen> {
  Event? _selectedEvent;  // ✅ Add this
  bool _showEventPicker = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Content TextField
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'What\'s on your mind?'),
              maxLines: 5,
            ),

            SizedBox(height: 16),

            // ✅ ADD EVENT PICKER
            Card(
              child: ListTile(
                leading: Icon(Icons.event),
                title: Text(_selectedEvent == null
                    ? 'Tag an event (optional)'
                    : _selectedEvent!.title),
                subtitle: _selectedEvent == null
                    ? Text('Link this post to an event')
                    : Text('${_selectedEvent!.location} • ${_formatDate(_selectedEvent!.startTime)}'),
                trailing: _selectedEvent == null
                    ? Icon(Icons.add)
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => setState(() => _selectedEvent = null),
                      ),
                onTap: _selectedEvent == null ? _showEventPickerDialog : null,
              ),
            ),

            // Image upload section
            // ... existing code

            SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitPost,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEventPickerDialog() async {
    // Fetch user's events (created or joined)
    final events = await _eventRepository.getMyEvents();

    if (!mounted) return;

    final selected = await showDialog<Event>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Event'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                leading: Icon(Icons.event),
                title: Text(event.title),
                subtitle: Text('${event.location} • ${_formatDate(event.startTime)}'),
                onTap: () => Navigator.pop(context, event),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );

    if (selected != null) {
      setState(() => _selectedEvent = selected);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _submitPost() async {
    // ... validation

    final request = CreatePostRequest(
      content: _contentController.text,
      type: _selectedType,
      imageUrls: _uploadedImageUrls,
      attachedEventId: _selectedEvent?.id,  // ✅ Send event ID
      visibility: _selectedVisibility,
    );

    // ... rest of submit logic
  }
}
```

#### **Step 3: Display Tagged Event in Post Card**
```dart
// lib/presentation/widgets/post_card.dart

class PostCard extends StatelessWidget {
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.author.avatar ?? ''),
            ),
            title: Text(post.author.name),
            subtitle: Text(timeAgo(post.createdAt)),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(post.content),
          ),

          // ✅ DISPLAY TAGGED EVENT
          if (post.attachedEvent != null)
            Padding(
              padding: EdgeInsets.all(16),
              child: InkWell(
                onTap: () => _navigateToEvent(context, post.attachedEvent!.id),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.event, color: Theme.of(context).primaryColor),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.attachedEvent!.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${post.attachedEvent!.location} • ${_formatDate(post.attachedEvent!.startTime)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),

          // Images, likes, comments, etc.
          // ... rest of post card
        ],
      ),
    );
  }

  void _navigateToEvent(BuildContext context, String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(eventId: eventId),
      ),
    );
  }
}
```

---

## 🔄 Replace Mock Data with Backend API Calls

### **Areas Using Mock Data:**

#### **1. Communities (100% Mock)**
```dart
// ❌ BEFORE (Mock)
class CommunityRepository {
  Future<List<Community>> getCommunities() async {
    await Future.delayed(Duration(seconds: 1));
    return _mockCommunities;
  }
}

// ✅ AFTER (Real API)
class CommunityRepository {
  final ApiClient _apiClient;

  Future<List<Community>> getCommunities({
    String? search,
    String? privacy,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _apiClient.get(
      '/communities',
      queryParameters: {
        if (search != null) 'search': search,
        if (privacy != null) 'privacy': privacy,
        'limit': limit,
        'offset': offset,
      },
    );

    return (response.data['data'] as List)
        .map((json) => Community.fromJson(json))
        .toList();
  }

  Future<Community> createCommunity(CreateCommunityRequest request) async {
    final response = await _apiClient.post(
      '/communities',
      data: request.toJson(),
    );
    return Community.fromJson(response.data['data']);
  }

  Future<void> joinCommunity(String communityId) async {
    await _apiClient.post('/communities/$communityId/join');
  }

  Future<void> leaveCommunity(String communityId) async {
    await _apiClient.delete('/communities/$communityId/leave');
  }

  Future<List<Community>> getMyCommunities({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _apiClient.get(
      '/communities/my-communities',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    return (response.data['data'] as List)
        .map((json) => Community.fromJson(json))
        .toList();
  }
}
```

#### **2. Notifications (Mock Data)**
```dart
// ❌ REMOVE Mock
class NotificationRepository {
  Future<List<Notification>> getNotifications() async {
    // Remove mock data
    final response = await _apiClient.get('/notifications');
    return (response.data['data'] as List)
        .map((json) => Notification.fromJson(json))
        .toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _apiClient.post('/notifications/$notificationId/read');
  }

  Future<void> markAllAsRead() async {
    await _apiClient.post('/notifications/read-all');
  }
}
```

**Note:** Notifications API not yet implemented in backend (P2 priority). Use mock data until backend is ready.

#### **3. File Upload**
```dart
// ✅ Real API available
class UploadRepository {
  Future<String> uploadImage(File imageFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    final response = await _apiClient.post(
      '/upload/image',
      data: formData,
    );

    return response.data['data']['url'];  // Returns public URL
  }
}
```

---

## 🧪 Testing Checklist

### **After Fixing Bugs:**

#### **Test Post Creation:**
- [ ] Create text-only post
- [ ] Create post with images
- [ ] Create post with event tag
- [ ] Verify post ID is UUID (not temp_xxx)
- [ ] Check error handling for failed creation
- [ ] Verify success message shows

#### **Test Event Creation:**
- [ ] Create free event
- [ ] Create paid event
- [ ] Verify event ID is UUID
- [ ] Check date/time validation
- [ ] Test image upload

#### **Test Event Tagging:**
- [ ] Open event picker dialog
- [ ] Select an event
- [ ] Post shows tagged event card
- [ ] Click event card navigates to event detail
- [ ] Can remove tagged event before posting

#### **Test Communities:**
- [ ] List all communities
- [ ] Create new community
- [ ] Join/leave community
- [ ] View my communities
- [ ] Search communities

---

## 📝 Environment Configuration

### **Update API Base URL:**
```dart
// lib/core/config/api_config.dart

class ApiConfig {
  static const String baseUrl =
      'http://localhost:8081/api/v1';  // Development
      // 'https://anigmaa.muhhilmi.site/api/v1';  // Production
}
```

### **Update Dio Client:**
```dart
// lib/core/network/dio_client.dart

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors for auth token
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}
```

---

## 🚨 Important Notes

### **Backend ID Generation:**
- ✅ Backend ALWAYS generates IDs (UUID format)
- ✅ Backend IGNORES any ID sent from frontend
- ✅ Backend returns full object with generated ID
- ❌ Frontend should NEVER generate IDs for create operations

### **API Response Format:**
All backend responses follow this format:
```json
{
  "data": { /* or array */ },
  "message": "Success message"
}
```

Errors:
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message"
  }
}
```

### **Authentication:**
All endpoints (except login/register) require:
```dart
headers: {
  'Authorization': 'Bearer $jwtToken'
}
```

---

## 📚 API Documentation

Full API documentation available at:
- Swagger UI: `http://localhost:8081/swagger/index.html`
- API Spec: See `API_IMPLEMENTATION_REVIEW.md` in backend repo

---

## ✅ Priority Order

1. **HIGH:** Remove ID generation (Bug #1, #2)
2. **MEDIUM:** Add event tagging feature
3. **LOW:** Replace mock data (Communities first, then Notifications when backend ready)

---

## 🤝 Need Help?

If you encounter issues:
1. Check backend logs: `docker-compose logs -f backend`
2. Verify JWT token is valid
3. Check network requests in Flutter DevTools
4. Ensure backend is running on correct port
5. Verify CORS configuration

---

**Document Version:** 1.0
**Last Updated:** 2025-11-12
**Backend API Version:** 1.0
**Compatible Flutter SDK:** >=3.0.0

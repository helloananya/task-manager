# SmartPrep AI - API Cheat Sheet

## Quick Reference

### Base URL
```
Development: http://localhost:5000/api
Production: https://your-domain.com/api
```

### Authentication Header
```javascript
headers: {
  'Authorization': `Bearer ${token}`,
  'Content-Type': 'application/json'
}
```

## Endpoints Summary

### Authentication
| Method | Endpoint | Description | Auth |
|---------|-----------|-------------|------|
| POST | `/auth/register` | Create user | No |
| POST | `/auth/login` | Login user | No |
| GET | `/auth/me` | Get current user | Yes |
| PUT | `/auth/profile` | Update profile | Yes |

### Tasks
| Method | Endpoint | Description | Auth |
|---------|-----------|-------------|------|
| GET | `/tasks` | Get all tasks | Yes |
| POST | `/tasks` | Create task | Yes |
| PUT | `/tasks/:id` | Update task | Yes |
| DELETE | `/tasks/:id` | Delete task | Yes |
| POST | `/tasks/:id/complete` | Complete task | Yes |

### Optimization
| Method | Endpoint | Description | Auth |
|---------|-----------|-------------|------|
| POST | `/optimization/analyze` | Analyze tasks | Yes |
| POST | `/optimization/optimize` | Optimize tasks | Yes |
| POST | `/optimization/reset` | Reset optimization | Yes |
| GET | `/optimization/stats` | Get stats | Yes |

### Dashboard
| Method | Endpoint | Description | Auth |
|---------|-----------|-------------|------|
| GET | `/dashboard/stats` | Get dashboard data | Yes |
| GET | `/dashboard/subject-progress` | Subject progress | Yes |
| GET | `/dashboard/achievements` | Get achievements | Yes |
| GET | `/dashboard/weekly-chart` | Weekly data | Yes |
| GET | `/dashboard/daily-summary` | Daily summary | Yes |

### Flashcards
| Method | Endpoint | Description | Auth |
|---------|-----------|-------------|------|
| POST | `/flashcards/generate` | Generate cards | Yes |
| GET | `/flashcards` | Get cards | Yes |

## Request/Response Patterns

### Success Response
```json
{
  "status": "success",
  "message": "Operation successful",
  "data": { /* response data */ }
}
```

### Error Response
```json
{
  "status": "error",
  "message": "Error description",
  "errors": [ /* validation errors */ ]
}
```

### Validation Error
```json
{
  "status": "error",
  "message": "Validation failed",
  "errors": [
    {
      "msg": "Username is required",
      "param": "username",
      "location": "body"
    }
  ]
}
```

## Common Request Examples

### Register User
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "student1",
    "email": "student@example.com",
    "password": "password123",
    "class": "10th Grade",
    "examTarget": "JEE Main",
    "subjects": [
      {"name": "Mathematics", "strength": "Weak"},
      {"name": "Physics", "strength": "Medium"}
    ]
  }'
```

### Login
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student@example.com",
    "password": "password123"
  }'
```

### Create Task
```bash
curl -X POST http://localhost:5000/api/tasks \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "subject": "Mathematics",
    "topic": "Quadratic Equations",
    "duration": 45
  }'
```

### Optimize Tasks
```bash
curl -X POST http://localhost:5000/api/optimization/optimize \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}'
```

## Status Codes

| Code | Meaning | Action |
|-------|----------|---------|
| 200 | Success | Process response |
| 201 | Created | Resource created |
| 400 | Bad Request | Fix request data |
| 401 | Unauthorized | Login required |
| 403 | Forbidden | Check permissions |
| 404 | Not Found | Verify endpoint |
| 500 | Server Error | Try again later |

## Rate Limits

- **Authentication**: 5 attempts per 15 minutes
- **Task Creation**: 100 per hour
- **Optimization**: 10 per hour
- **Dashboard**: 100 per hour

## Error Messages

### Authentication Errors
- `"User already exists"` - Try different email/username
- `"Invalid credentials"` - Check email/password
- `"Token expired"` - Login again

### Task Errors
- `"Task not found"` - Verify task ID
- `"Not authorized"` - Check you own the task
- `"Already completed"` - Task already done

### Validation Errors
- `"Username is required"` - Add username
- `"Email must be valid"` - Fix email format
- `"Password must be at least 6 characters"` - Use longer password

## Data Models

### Task Object
```javascript
{
  "_id": "507f1f77bcf86cd799439011",
  "user": "507f1f77bcf86cd799439011",
  "subject": "Mathematics",
  "topic": "Study Chapter 1",
  "duration": 60,
  "priority": "medium",
  "status": "pending",
  "scheduledDate": "2026-04-04T10:00:00.000Z",
  "completedAt": null,
  "xpEarned": 0,
  "notes": "Complete exercises 1-10",
  "isOptimized": false,
  "createdAt": "2026-04-04T10:00:00.000Z",
  "updatedAt": "2026-04-04T10:00:00.000Z"
}
```

### User Object
```javascript
{
  "_id": "507f1f77bcf86cd799439011",
  "username": "student1",
  "email": "student@example.com",
  "class": "10th Grade",
  "examTarget": "JEE Main",
  "subjects": [
    {"name": "Mathematics", "strength": "Weak"},
    {"name": "Physics", "strength": "Medium"}
  ],
  "avatar": null,
  "settings": {
    "notifications": true,
    "soundEffects": true,
    "darkMode": false
  },
  "createdAt": "2026-04-04T10:00:00.000Z",
  "updatedAt": "2026-04-04T10:00:00.000Z"
}
```

### Achievement Object
```javascript
{
  "type": "First Task",
  "title": "First Step!",
  "description": "Completed your first study task",
  "achievedAt": "2026-04-04T10:00:00.000Z"
}
```

## Testing Commands

### Health Check
```bash
curl http://localhost:5000/api/health
```

### Test with Token
```bash
curl http://localhost:5000/api/tasks \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Test Authentication
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"password"}'
```

## Quick JavaScript Examples

### API Call with Axios
```javascript
import api from './services/api';

// Get tasks
const getTasks = async () => {
  const response = await api.get('/tasks');
  return response.data;
};

// Create task
const createTask = async (taskData) => {
  const response = await api.post('/tasks', taskData);
  return response.data;
};

// Complete task
const completeTask = async (taskId) => {
  const response = await api.post(`/tasks/${taskId}/complete`);
  return response.data;
};
```

### Error Handling
```javascript
try {
  const response = await api.get('/tasks');
  console.log('Success:', response.data);
} catch (error) {
  if (error.response?.status === 401) {
    // Handle unauthorized
    localStorage.removeItem('token');
    window.location.href = '/login';
  } else {
    console.error('API Error:', error.response?.data?.message);
  }
}
```

### Authentication Flow
```javascript
// Login
const login = async (email, password) => {
  const response = await api.post('/auth/login', { email, password });

  if (response.data.status === 'success') {
    const { user, token } = response.data.data;
    localStorage.setItem('token', token);
    localStorage.setItem('user', JSON.stringify(user));
    return { success: true, user };
  }

  return { success: false, error: 'Login failed' };
};

// Logout
const logout = () => {
  localStorage.removeItem('token');
  localStorage.removeItem('user');
  window.location.href = '/login';
};

// Check auth
const isAuthenticated = () => {
  return !!localStorage.getItem('token');
};
```

## Debugging Tips

### Enable Request Logging
```javascript
api.interceptors.request.use(config => {
  console.log('API Request:', config.method, config.url, config.data);
  return config;
});
```

### Enable Response Logging
```javascript
api.interceptors.response.use(response => {
  console.log('API Response:', response.status, response.data);
  return response;
});
```

### Test in Browser Console
```javascript
// After logging in
const token = localStorage.getItem('token');
console.log('Token:', token);

// Test API call
fetch('http://localhost:5000/api/tasks', {
  headers: {
    'Authorization': `Bearer ${token}`
  }
}).then(res => res.json()).then(data => console.log(data));
```

---

**Last Updated**: 2026-04-04
**API Version**: 1.0.0
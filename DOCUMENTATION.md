# SmartPrep AI - Complete Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [API Documentation](#api-documentation)
4. [Database Schema](#database-schema)
5. [Component Reference](#component-reference)
6. [Core Algorithms](#core-algorithms)
7. [Development Guide](#development-guide)
8. [Deployment Guide](#deployment-guide)
9. [Troubleshooting](#troubleshooting)

---

## Overview

### Project Description
SmartPrep AI is a personalized study planner that helps students optimize their learning experience through intelligent task scheduling, gamification, and progress tracking. The application uses AI-powered algorithms to analyze study patterns and provide actionable suggestions for improvement.

### Key Features
- **Smart Study Planning**: AI-optimized task scheduling based on subject strengths
- **Intelligent Suggestions**: Real-time feedback for time allocation balance
- **Gamification System**: XP, levels, streaks, and achievements
- **Progress Dashboard**: Comprehensive analytics and subject-wise progress
- **Flashcard Generator**: Create study cards from text content
- **Responsive Design**: Seamless experience across all devices

### Technology Stack

#### Frontend
- **React 18**: Functional components with hooks
- **Tailwind CSS**: Utility-first CSS framework with custom pastel theme
- **React Router 6**: Client-side routing
- **Axios**: HTTP client for API communication
- **Lucide React**: Icon library
- **Framer Motion**: Smooth animations (optional)

#### Backend
- **Node.js**: JavaScript runtime
- **Express.js**: Web application framework
- **MongoDB**: NoSQL database
- **Mongoose**: MongoDB object modeling
- **JWT**: Authentication tokens
- **bcryptjs**: Password hashing

---

## Architecture

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Client (React)                        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐│
│  │ Components │  │   Pages   │  │  Contexts  ││
│  └────────────┘  └────────────┘  └────────────┘│
│         │                 │                 │         │
│         └─────────────────┴─────────────────┘         │
│                        │                          │
└────────────────────────│───────────────────────────────────┘
                         │ REST API
┌────────────────────────│───────────────────────────────────┐
│              Server (Express)                           │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐│
│  │  Routes    │  │Controllers │  │ Middleware  ││
│  └────────────┘  └────────────┘  └────────────┘│
│         │                 │                 │         │
│  ┌─────┴───────────┴───────┬─────────┐│
│  │  Models                   │ Utils   ││
│  └────────────────────────────┴─────────┘│
│                │                           │
└────────────────┼───────────────────────────┘
                 │
         ┌────────┴────────┐
         │    MongoDB    │
         └───────────────┘
```

### Data Flow

1. **User Flow**:
   - Registration/Login → JWT Token
   - Token stored in localStorage
   - Protected routes require valid token

2. **Task Flow**:
   - Client creates task → API validates
   - Server assigns priority based on weak subjects
   - Task stored in MongoDB
   - Client updates UI with new task

3. **Optimization Flow**:
   - Client requests optimization → Server analyzes
   - Algorithms calculate optimal distribution
   - Suggestions generated based on analysis
   - Client displays optimized schedule

4. **Gamification Flow**:
   - Task completion → Server calculates XP
   - Achievements checked and awarded
   - Progress updated in database
   - Client updates UI with new stats

### State Management

#### React Context Hierarchy
```
AuthProvider (User, Auth)
  └── TaskProvider (Tasks, Optimization)
       └── GamificationProvider (XP, Level, Achievements)
            └── App Component
                 ├── Navbar
                 ├── Pages
                 └── Components
```

#### Local Storage Strategy
- **Auth**: User data and JWT token
- **Tasks**: Cache for offline/demo mode
- **Theme**: Light/Dark mode preference
- **Settings**: User preferences (notifications, sounds, etc.)

---

## API Documentation

### Base URL
- **Development**: `http://localhost:5000/api`
- **Production**: Configured via `VITE_API_URL` environment variable

### Authentication Endpoints

#### POST /api/auth/register
Register a new user account.

**Request Body**:
```json
{
  "username": "string (3-20 chars)",
  "email": "string (valid email)",
  "password": "string (min 6 chars)",
  "class": "string (enum)",
  "examTarget": "string (enum)",
  "subjects": [
    {
      "name": "string",
      "strength": "Weak|Medium|Strong"
    }
  ]
}
```

**Response**:
```json
{
  "status": "success",
  "message": "User registered successfully",
  "data": {
    "user": { /* user object */ },
    "token": "jwt_token_string"
  }
}
```

#### POST /api/auth/login
Authenticate existing user.

**Request Body**:
```json
{
  "email": "string",
  "password": "string"
}
```

**Response**:
```json
{
  "status": "success",
  "message": "Login successful",
  "data": {
    "user": { /* user object */ },
    "token": "jwt_token_string"
  }
}
```

#### GET /api/auth/me
Get current authenticated user.

**Headers**:
```
Authorization: Bearer <token>
```

**Response**:
```json
{
  "status": "success",
  "data": {
    "user": { /* user object */ }
  }
}
```

### Task Endpoints

#### GET /api/tasks
Get all tasks for authenticated user with insights.

**Query Parameters**:
- `status` (optional): Filter by status ('pending', 'completed', 'in_progress')
- `subject` (optional): Filter by subject name
- `date` (optional): Filter by scheduled date (YYYY-MM-DD)

**Response**:
```json
{
  "status": "success",
  "count": 10,
  "data": {
    "tasks": [
      {
        "_id": "string",
        "user": "string",
        "subject": "string",
        "topic": "string",
        "duration": 60,
        "priority": "medium",
        "status": "pending",
        "scheduledDate": "ISODateString",
        "completedAt": null,
        "xpEarned": 0,
        "notes": "string",
        "isOptimized": false,
        "createdAt": "ISODateString",
        "updatedAt": "ISODateString"
      }
    ],
    "insights": {
      "timeDistribution": {
        "Mathematics": 120,
        "Physics": 60
      },
      "weakSubjects": [
        {
          "subject": "Mathematics",
          "reason": "marked_weak",
          "priority": "high"
        }
      ],
      "timeBalance": {
        "isBalanced": false,
        "message": "Study schedule is imbalanced",
        "recommendations": [...]
      },
      "suggestions": [
        {
          "type": "weak_subject_focus",
          "priority": "high",
          "title": "Strengthen Your Foundation",
          "message": "Increase time for Mathematics (weak subject)"
        }
      ],
      "patterns": {
        "mostProductiveHour": "14:00",
        "averageSessionLength": 45,
        "peakSubjects": ["Mathematics", "Physics"],
        "studyConsistency": 71
      }
    }
  }
}
```

#### POST /api/tasks
Create a new study task.

**Request Body**:
```json
{
  "subject": "Mathematics",
  "topic": "Quadratic Equations",
  "duration": 45,
  "notes": "Complete exercises 1-10",
  "scheduledDate": "ISODateString"
}
```

**Response**:
```json
{
  "status": "success",
  "message": "Task created successfully",
  "data": {
    "task": { /* task object with auto-calculated priority */ }
  }
}
```

#### PUT /api/tasks/:id
Update an existing task.

**Request Body** (all optional):
```json
{
  "subject": "Physics",
  "topic": "Newton's Laws",
  "duration": 60,
  "priority": "high",
  "notes": "Revised study plan",
  "scheduledDate": "ISODateString",
  "status": "completed"
}
```

**Response**:
```json
{
  "status": "success",
  "message": "Task updated successfully",
  "data": {
    "task": { /* updated task object */ }
  }
}
```

#### DELETE /api/tasks/:id
Delete a task.

**Response**:
```json
{
  "status": "success",
  "message": "Task deleted successfully"
}
```

#### POST /api/tasks/:id/complete
Mark a task as completed and earn XP.

**Response**:
```json
{
  "status": "success",
  "message": "Task completed successfully",
  "data": {
    "task": { /* task object with completion data */ },
    "xpEarned": 10
  }
}
```

### Optimization Endpoints

#### POST /api/optimization/analyze
Analyze current tasks and provide suggestions.

**Request Body**:
```json
{
  "taskIds": ["id1", "id2"] // Optional - specific tasks to analyze
}
```

**Response**:
```json
{
  "status": "success",
  "message": "Analysis completed",
  "data": {
    "suggestions": [...],
    "weakSubjects": [...],
    "timeDistribution": {...},
    "subjectProgress": {...},
    "totalTasks": 5,
    "totalStudyTime": 300
  }
}
```

#### POST /api/optimization/optimize
Optimize task list based on analysis.

**Response**:
```json
{
  "status": "success",
  "message": "Tasks optimized successfully",
  "data": {
    "optimizedTasks": [
      {
        /* task object with priorityScore field */
      }
    ],
    "suggestions": [...],
    "optimalAllocation": {
      "Mathematics": { "allocatedTime": 90, "currentProgress": 0.3 },
      "Physics": { "allocatedTime": 60, "currentProgress": 0.7 }
    },
    "originalTotalTime": 300,
    "improvementMetrics": {
      "weakSubjectCoverage": 100,
      "balanceScore": 85
    },
    "xpBonus": 15
  }
}
```

#### POST /api/optimization/reset
Reset task optimization (undo).

**Request Body**:
```json
{
  "taskIds": ["id1", "id2"] // Optional
}
```

#### GET /api/optimization/stats
Get optimization statistics.

**Response**:
```json
{
  "status": "success",
  "data": {
    "totalTasks": 20,
    "optimizedTasks": 15,
    "completedTasks": 8,
    "weakSubjects": 2,
    "totalSubjects": 5,
    "optimizationRate": 75,
    "completionRate": 40,
    "totalXP": 120,
    "level": 2
  }
}
```

### Dashboard Endpoints

#### GET /api/dashboard/stats
Get dashboard statistics.

**Response**:
```json
{
  "status": "success",
  "data": {
    "overview": {
      "totalTasks": 25,
      "completedTasks": 15,
      "pendingTasks": 8,
      "inProgressTasks": 2,
      "completionRate": 60.0
    },
    "today": {
      "totalTasks": 5,
      "completedTasks": 3,
      "timeSpent": 120,
      "tasks": [...]
    },
    "weekly": {
      "tasksCompleted": 18,
      "totalXP": 180,
      "totalTime": 540
    },
    "gamification": {
      "xp": 120,
      "level": 2,
      "currentStreak": 5,
      "longestStreak": 7,
      "achievementCount": 3,
      "recentAchievements": [...]
    },
    "subjectProgress": [...]
  }
}
```

#### GET /api/dashboard/subject-progress
Get detailed subject progress.

**Response**:
```json
{
  "status": "success",
  "data": {
    "subjects": [
      {
        "name": "Mathematics",
        "strength": "Weak",
        "stats": {
          "totalTasks": 10,
          "completedTasks": 6,
          "completionRate": 60.0,
          "totalTimeSpent": 300,
          "averageSessionLength": 50
        },
        "activity": {
          "currentStreak": 3,
          "lastStudiedAt": "ISODateString",
          "lastWeekTime": 180,
          "lastMonthTime": 600
        },
        "performance": {
          "trend": "improving",
          "improvementPercentage": 25.5
        },
        "recentTasks": [...]
      }
    ],
    "totalSubjects": 5,
    "weakSubjects": 1,
    "strongSubjects": 2
  }
}
```

### Flashcard Endpoints

#### POST /api/flashcards/generate
Generate flashcards from text.

**Request Body**:
```json
{
  "text": "Photosynthesis is the process by which plants convert sunlight, water, and carbon dioxide into glucose and oxygen."
}
```

**Response**:
```json
{
  "status": "success",
  "message": "Generated 2 flashcards from text",
  "data": {
    "flashcards": [
      {
        "id": "unique_id",
        "question": "What is photosynthesis?",
        "answer": "It is the process by which plants convert sunlight, water, and carbon dioxide into glucose and oxygen.",
        "category": "definition",
        "difficulty": "medium"
      }
    ],
    "totalGenerated": 2
  }
}
```

---

## Database Schema

### User Model
```javascript
{
  _id: ObjectId,
  username: String (required, unique, 3-20 chars),
  email: String (required, unique, valid email),
  password: String (required, min 6 chars, hashed),
  class: String (required, enum),
  examTarget: String (required, enum),
  subjects: [{
    name: String (required),
    strength: String (enum: 'Weak'|'Medium'|'Strong', default: 'Medium')
  }],
  avatar: String (optional),
  settings: {
    notifications: Boolean (default: true),
    soundEffects: Boolean (default: true),
    darkMode: Boolean (default: false),
    autoOptimize: Boolean (default: false),
    studyReminders: Boolean (default: true)
  },
  createdAt: Date,
  updatedAt: Date
}
```

### Task Model
```javascript
{
  _id: ObjectId,
  user: ObjectId (ref: User, required),
  subject: String (required),
  topic: String (required, 3-100 chars),
  duration: Number (required, 5-240 minutes),
  priority: String (enum: 'low'|'medium'|'high'|'urgent', default: 'medium'),
  status: String (enum: 'pending'|'completed'|'in_progress', default: 'pending'),
  scheduledDate: Date (default: now),
  completedAt: Date,
  xpEarned: Number (default: 0),
  notes: String (optional, max 500 chars),
  isOptimized: Boolean (default: false),
  originalDuration: Number,
  createdAt: Date,
  updatedAt: Date
}
```

### Gamification Model
```javascript
{
  _id: ObjectId,
  user: ObjectId (ref: User, required, unique),
  xp: Number (default: 0, min: 0),
  level: Number (default: 1, min: 1),
  totalTasksCompleted: Number (default: 0, min: 0),
  currentStreak: Number (default: 0, min: 0),
  longestStreak: Number (default: 0, min: 0),
  lastActiveDate: Date,
  achievements: [{
    type: String (enum),
    achievedAt: Date,
    title: String,
    description: String,
    icon: String
  }],
  weeklyStats: [{
    week: String (ISO week),
    tasksCompleted: Number,
    xpEarned: Number,
    subjectsStudied: [{
      subject: String,
      timeSpent: Number
    }]
  }],
  subjectProgress: [{
    subject: String,
    tasksCompleted: Number,
    totalTimeSpent: Number,
    averagePerformance: Number,
    currentStreak: Number
  }],
  createdAt: Date,
  updatedAt: Date
}
```

### Subject Model
```javascript
{
  _id: ObjectId,
  user: ObjectId (ref: User, required),
  name: String (required),
  strength: String (enum: 'Weak'|'Medium'|'Strong', default: 'Medium'),
  totalTasks: Number (default: 0, min: 0),
  completedTasks: Number (default: 0, min: 0),
  totalTimeSpent: Number (default: 0, min: 0),
  averageTaskDuration: Number (default: 0, min: 0),
  currentStreak: Number (default: 0, min: 0),
  lastStudiedAt: Date,
  performanceTrend: String (enum: 'improving'|'stable'|'declining'|'insufficient_data'),
  improvementPercentage: Number (default: 0),
  createdAt: Date,
  updatedAt: Date
}
```

---

## Component Reference

### Common Components

#### Navbar
Main navigation component with dark mode toggle and user menu.

**Props**:
- `theme`: 'light' | 'dark'
- `onToggleTheme`: () => void

**Usage**:
```jsx
<Navbar theme={theme} onToggleTheme={toggleTheme} />
```

#### Button
Reusable button component with variants and states.

**Props**:
- `variant`: 'primary' | 'secondary' | 'accent' | 'ghost' | 'outline' | 'danger'
- `size`: 'small' | 'medium' | 'large'
- `loading`: boolean
- `disabled`: boolean
- `icon`: React component
- `iconPosition`: 'left' | 'right'
- `fullWidth`: boolean

**Usage**:
```jsx
<Button variant="primary" size="medium" loading={loading} icon={Plus}>
  Add Task
</Button>
```

#### Input
Form input with validation and icons.

**Props**:
- `type`: string
- `label`: string
- `placeholder`: string
- `value`: string
- `onChange`: (e) => void
- `error`: string
- `required`: boolean
- `icon`: React component
- `helperText`: string
- `size`: 'small' | 'medium' | 'large'

**Usage**:
```jsx
<Input
  type="email"
  label="Email"
  placeholder="Enter your email"
  value={email}
  onChange={handleChange}
  icon={Mail}
  required
/>
```

#### ProgressBar
Progress indicator with customizable appearance.

**Props**:
- `value`: number (0-100)
- `max`: number (default: 100)
- `size`: 'small' | 'medium' | 'large'
- `color`: 'primary' | 'secondary' | 'accent' | 'success' | 'warning' | 'error' | 'rainbow'
- `showLabel`: boolean
- `label`: string
- `animated`: boolean

**Usage**:
```jsx
<ProgressBar value={progress} color="primary" showLabel label="Level Progress" />
```

#### Card
Container component with consistent styling.

**Props**:
- `children`: React nodes
- `className`: string
- `onClick`: () => void
- `hoverable`: boolean

**Usage**:
```jsx
<Card hoverable onClick={handleClick}>
  <CardHeader>Title</CardHeader>
  <CardContent>Content</CardContent>
  <CardFooter>Actions</CardFooter>
</Card>
```

### Page Components

#### Planner
Main study planning interface.

**Features**:
- Task creation and management
- Real-time insights display
- AI optimization integration
- Task filtering by status

**State**:
```javascript
{
  tasks: Task[],
  insights: Insights | null,
  filter: 'all' | 'pending' | 'completed',
  showForm: boolean,
  optimizing: boolean
}
```

#### Dashboard
Progress and analytics display.

**Features**:
- Overview statistics
- Gamification overview
- Subject progress visualization
- Achievement display
- Weekly charts

#### Flashcards
Study card creation and practice.

**Features**:
- Text-to-flashcard generation
- Interactive study mode
- Card management
- Score tracking

#### Profile
User profile management.

**Features**:
- Profile information display
- Subject management
- Settings configuration
- Exam target tracking

---

## Core Algorithms

### Priority Score Calculation

**Purpose**: Calculate task priority based on multiple factors for intelligent scheduling.

**Algorithm**:
```javascript
function calculatePriorityScore(task, userProfile, subjectProgress) {
  let score = 50; // Base score

  // Factor 1: Subject strength (30 points)
  if (subject.strength === 'Weak') {
    score += 30;
  } else if (subject.strength === 'Medium') {
    score += 15;
  }

  // Factor 2: Current progress (0-20 points)
  const completionRate = getCompletionRate(subject);
  score -= (completionRate * 20);

  // Factor 3: Task duration (0-10 points)
  if (task.duration <= 30) score += 10;
  else if (task.duration <= 60) score += 5;

  // Factor 4: Days since last studied (0-20 points)
  const daysSinceLastStudy = getDaysSinceLastStudy(subject);
  score += Math.min(daysSinceLastStudy * 5, 20);

  return Math.min(Math.max(score, 0), 100); // Clamp 0-100
}
```

### Time Distribution Analysis

**Purpose**: Analyze how study time is distributed across subjects.

**Algorithm**:
```javascript
function calculateTimeDistribution(tasks) {
  const distribution = {};
  const totalStudyTime = 0;

  tasks.forEach(task => {
    if (task.status === 'completed') {
      distribution[task.subject] =
        (distribution[task.subject] || 0) + task.duration;
      totalStudyTime += task.duration;
    }
  });

  return {
    distribution,
    totalStudyTime,
    subjectCount: Object.keys(distribution).length
  };
}
```

### Weak Subject Identification

**Purpose**: Identify subjects that need more attention.

**Algorithm**:
```javascript
function identifyWeakSubjects(userProfile, tasks) {
  const weakSubjects = [];

  userProfile.subjects.forEach(subject => {
    // Check profile-stated weakness
    if (subject.strength === 'Weak') {
      weakSubjects.push({
        subject: subject.name,
        reason: 'marked_weak',
        priority: 'high'
      });
      return;
    }

    // Analyze performance
    const subjectTasks = tasks.filter(t => t.subject === subject.name);
    const completionRate =
      subjectTasks.length > 0
        ? (subjectTasks.filter(t => t.status === 'completed').length / subjectTasks.length) * 100
        : 100;

    if (completionRate < 50) {
      weakSubjects.push({
        subject: subject.name,
        reason: 'low_completion_rate',
        completionRate,
        priority: 'medium'
      });
    }
  });

  return weakSubjects;
}
```

### Optimization Engine

**Purpose**: Generate optimized study schedule.

**Algorithm**:
```javascript
function optimizeTaskList(tasks, userProfile, subjectProgress) {
  // Step 1: Calculate priority scores
  const tasksWithScores = tasks.map(task => ({
    ...task,
    priorityScore: calculatePriorityScore(task, userProfile, subjectProgress)
  }));

  // Step 2: Sort by priority (descending)
  tasksWithScores.sort((a, b) => b.priorityScore - a.priorityScore);

  // Step 3: Generate suggestions
  const suggestions = generateOptimizationSuggestions(
    userProfile,
    tasks,
    subjectProgress
  );

  // Step 4: Calculate optimal time allocation
  const totalTime = tasks.reduce((sum, task) => sum + task.duration, 0);
  const optimalAllocation = calculateOptimalTimeAllocation(
    userProfile,
    subjectProgress,
    totalTime
  );

  // Step 5: Calculate improvement metrics
  const improvementMetrics = {
    weakSubjectCoverage: calculateWeakSubjectCoverage(tasks, userProfile),
    balanceScore: calculateBalanceScore(tasks, userProfile)
  };

  return {
    optimizedTasks: tasksWithScores,
    suggestions,
    optimalAllocation,
    improvementMetrics
  };
}
```

### XP Calculation

**Purpose**: Calculate experience points for gamification.

**Algorithm**:
```javascript
function calculateXPForTask(task, userProfile) {
  let xp = 10; // Base XP

  // Weak subject bonus
  const subject = userProfile.subjects.find(s => s.name === task.subject);
  if (subject && subject.strength === 'Weak') {
    xp += 5;
  }

  return xp;
}

function calculateLevel(totalXP) {
  return Math.floor(totalXP / 100) + 1;
}

function getXPToNextLevel(totalXP) {
  const currentLevel = calculateLevel(totalXP);
  return (currentLevel * 100) - totalXP;
}
```

### Flashcard Generation

**Purpose**: Generate question-answer pairs from text.

**Algorithm**:
```javascript
function generateFlashcards(text) {
  const sentences = splitIntoSentences(text);
  const flashcards = [];

  sentences.forEach(sentence => {
    // Skip too short/long sentences
    if (sentence.length < 20 || sentence.length > 200) return;

    // Try pattern matching
    const qaPair = matchQAPattern(sentence);
    if (qaPair) {
      flashcards.push(qaPair);
    } else {
      // Fallback to generic question
      flashcards.push({
        question: generateGenericQuestion(sentence),
        answer: sentence,
        category: 'general',
        difficulty: 'medium'
      });
    }
  });

  return deduplicateFlashcards(flashcards).slice(0, 10);
}
```

---

## Development Guide

### Local Development Setup

1. **Install Dependencies**
   ```bash
   npm run install:all
   ```

2. **Environment Configuration**
   ```bash
   # Server (.env)
   PORT=5000
   MONGODB_URI=mongodb://localhost:27017/smartprep-ai
   JWT_SECRET=your_secret_key

   # Client (.env)
   VITE_API_URL=http://localhost:5000/api
   ```

3. **Start Development Servers**
   ```bash
   npm run dev
   # Opens:
   # - Frontend: http://localhost:5173
   # - Backend: http://localhost:5000
   ```

### Adding New Features

#### Backend Feature
1. Create model in `server/src/models/`
2. Add controller logic in `server/src/controllers/`
3. Define routes in `server/src/routes/`
4. Update main server to mount routes

#### Frontend Feature
1. Create component in `client/src/components/`
2. Create page in `client/src/pages/`
3. Add route in `client/src/App.jsx`
4. Update navigation in `client/src/components/common/Navbar.jsx`

### Code Style Guidelines

#### JavaScript/JSX
```jsx
// Use functional components with hooks
const MyComponent = ({ prop1, prop2 }) => {
  const [state, setState] = useState(null);

  useEffect(() => {
    // Effect logic
  }, [dependencies]);

  const handleClick = () => {
    // Event handler
  };

  return (
    <div onClick={handleClick}>
      {/* JSX content */}
    </div>
  );
};
```

#### Component Structure
```jsx
// Import statements first
import React from 'react';
import { useState } from 'react';

// Component definition
const ComponentName = ({ prop1, prop2 }) => {
  // Hooks
  const [state, setState] = useState(null);

  // Helper functions
  const helperFunction = () => {
    // Logic
  };

  // Event handlers
  const handleEvent = () => {
    // Handler logic
  };

  // Conditional rendering
  if (condition) {
    return <ConditionalComponent />;
  }

  // Main return
  return (
    <div className="container">
      {/* Content */}
    </div>
  );
};

export default ComponentName;
```

#### API Integration
```javascript
import api from '../services/api';

// GET request
const fetchData = async () => {
  try {
    const response = await api.get('/endpoint');
    // Handle success
    return response.data;
  } catch (error) {
    // Handle error
    console.error('API Error:', error);
  }
};

// POST request
const postData = async (data) => {
  try {
    const response = await api.post('/endpoint', data);
    return response.data;
  } catch (error) {
    console.error('API Error:', error);
  }
};
```

### Testing

#### Unit Testing
```javascript
import { render, screen } from '@testing-library/react';
import Component from './Component';

test('renders correctly', () => {
  render(<Component prop="value" />);
  expect(screen.getByText('expected text')).toBeInTheDocument();
});
```

#### API Testing
```bash
cd server
npm test
```

---

## Deployment Guide

### Frontend Deployment (Vercel)

1. **Build for Production**
   ```bash
   cd client
   npm run build
   ```

2. **Deploy to Vercel**
   - Connect Vercel to GitHub repository
   - Set build command: `npm run build`
   - Set output directory: `dist`
   - Add environment variables in Vercel dashboard

### Backend Deployment (Heroku)

1. **Prepare for Production**
   ```bash
   cd server
   # Update package.json
   "engines": { "node": ">=18" }
   ```

2. **Deploy to Heroku**
   ```bash
   heroku create smartprep-ai
   heroku addons:create mongolab
   heroku config:set JWT_SECRET=your_production_secret
   git push heroku main
   ```

3. **Configure Environment Variables**
   - `MONGODB_URI`: MongoDB connection string
   - `JWT_SECRET`: Production JWT secret
   - `CLIENT_URL`: Production frontend URL

### Database Setup (MongoDB Atlas)

1. **Create Atlas Cluster**
   - Create free cluster on MongoDB Atlas
   - Create database user
   - Get connection string

2. **Configure IP Whitelist**
   - Add Vercel/Heroku IP addresses
   - Set network access to allow from anywhere

3. **Update Environment**
   ```env
   MONGODB_URI=mongodb+srv://<username>:<password>@cluster.mongodb.net/smartprep-ai
   ```

---

## Troubleshooting

### Common Issues

#### MongoDB Connection Failed
**Symptoms**: Server fails to start with connection error

**Solutions**:
1. Verify MongoDB is running locally
2. Check connection string format
3. Ensure IP is whitelisted in Atlas
4. Check network firewall settings

#### CORS Errors
**Symptoms**: Browser console shows CORS policy errors

**Solutions**:
1. Verify `CLIENT_URL` matches frontend URL
2. Check CORS configuration in server
3. Ensure credentials flag is set correctly

#### Authentication Issues
**Symptoms**: Login fails or tokens not working

**Solutions**:
1. Check JWT_SECRET consistency
2. Verify token expiration time
3. Clear browser localStorage
4. Check bcrypt password hashing

#### Build Errors
**Symptoms**: `npm run build` fails

**Solutions**:
1. Clear node_modules and reinstall: `rm -rf node_modules package-lock.json && npm install`
2. Check Node.js version compatibility
3. Verify all dependencies are installed
4. Check for circular dependencies

### Performance Optimization

#### Frontend
1. **Code Splitting**
   ```javascript
   const LazyComponent = React.lazy(() => import('./Component'));
   ```

2. **Memoization**
   ```javascript
   const MemoComponent = React.memo(Component);
   ```

3. **Image Optimization**
   - Use WebP format
   - Compress images
   - Lazy load images

#### Backend
1. **Database Indexing**
   ```javascript
   taskSchema.index({ user: 1, status: 1 });
   ```

2. **Query Optimization**
   - Use lean() for smaller payloads
   - Limit fields with select()
   - Implement pagination

3. **Caching**
   - Implement Redis for session storage
   - Cache frequently accessed data
   - Use CDN for static assets

---

## Additional Resources

### Development Tools
- **VS Code Extensions**: ESLint, Prettier, Tailwind CSS IntelliSense
- **Browser DevTools**: React DevTools, Redux DevTools (if used)
- **Testing**: Jest, React Testing Library, Supertest

### Learning Resources
- [React Documentation](https://react.dev)
- [Node.js Documentation](https://nodejs.org/docs)
- [MongoDB Documentation](https://docs.mongodb.com)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

### Community
- GitHub Issues: Report bugs and request features
- Discussions: Ask questions and share ideas
- Contributing: Pull requests welcome

---

**Last Updated**: 2026-04-04
**Version**: 1.0.0
**Status**: Production Ready
# SmartPrep AI - Personalized Study Planner

A production-level web application that helps students plan, optimize, and track their studies using intelligent logic and gamification.

## 🎯 Features

- **Smart Study Planning**: AI-powered task optimization based on subject strengths
- **Intelligent Suggestions**: Real-time feedback for time allocation balance
- **Gamification System**: XP, levels, streaks, and achievements
- **Progress Dashboard**: Comprehensive analytics and subject-wise progress
- **Flashcard Generator**: Create study cards from text content
- **Modern UI**: Clean pastel theme with smooth animations
- **Responsive Design**: Works seamlessly on mobile, tablet, and desktop

## 🛠️ Tech Stack

### Frontend
- React 18 with Hooks
- Tailwind CSS with custom pastel theme
- React Router for navigation
- Axios for API calls
- Lucide React for icons

### Backend
- Node.js + Express
- MongoDB with Mongoose ODM
- JWT Authentication
- RESTful API design

### Design
- Mobile-first responsive design
- Pastel color palette
- Smooth animations and transitions
- Accessibility-focused

## 📦 Installation

### Prerequisites
- Node.js (v18 or higher)
- MongoDB (running locally or MongoDB Atlas connection string)
- npm or yarn

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd task-manager
   ```

2. **Install dependencies**
   ```bash
   npm run install:all
   # Or manually install for each folder:
   npm install
   cd client && npm install
   cd ../server && npm install
   ```

3. **Environment Configuration**

   **Server** (Create `server/.env`):
   ```env
   PORT=5000
   NODE_ENV=development
   MONGODB_URI=mongodb://localhost:27017/smartprep-ai
   JWT_SECRET=your_jwt_secret_key_here
   JWT_EXPIRE=7d
   CLIENT_URL=http://localhost:5173
   ```

   **Client** (Create `client/.env`):
   ```env
   VITE_API_URL=http://localhost:5000/api
   ```

4. **Start MongoDB**
   ```bash
   # If using local MongoDB
   mongod

   # Or update MONGODB_URI in server/.env to use MongoDB Atlas
   ```

5. **Run the application**
   ```bash
   # Run both client and server
   npm run dev

   # Or run separately:
   npm run server    # Backend on http://localhost:5000
   npm run client    # Frontend on http://localhost:5173
   ```

## 📁 Project Structure

```
smartprep-ai/
├── client/                 # React frontend
│   ├── src/
│   │   ├── components/      # Reusable UI components
│   │   ├── pages/         # Route pages
│   │   ├── contexts/      # React Context providers
│   │   ├── hooks/         # Custom React hooks
│   │   ├── utils/         # Utility functions
│   │   ├── services/      # API and storage services
│   │   └── styles/        # Global styles and themes
│   └── public/           # Static assets
├── server/                # Node.js backend
│   ├── src/
│   │   ├── config/        # Database and app config
│   │   ├── models/        # Mongoose models
│   │   ├── controllers/    # Business logic
│   │   ├── routes/         # API routes
│   │   ├── middleware/     # Express middleware
│   │   └── utils/         # Helper functions
│   └── .env.example      # Environment variables template
└── README.md
```

## 🚀 Usage

### First-Time Setup

1. Open http://localhost:5173 in your browser
2. Click "Get Started Free" to create an account
3. Fill in your profile details:
   - Username and email
   - Current class (6th grade to college)
   - Exam target (JEE, NEET, Boards, etc.)
   - Subjects with strength levels (Weak/Medium/Strong)
4. Complete profile setup to access main features

### Creating Study Tasks

1. Navigate to "Planner" from the navbar
2. Click "Add Task"
3. Fill in task details:
   - Subject (from your profile)
   - Topic (what you'll study)
   - Duration (5-240 minutes)
   - Optional notes
4. Click "Add Task" to save

### Using AI Optimization

1. Add multiple tasks or use existing pending tasks
2. Click "Optimize My Plan with AI"
3. The system will:
   - Analyze current time distribution
   - Identify weak subjects needing attention
   - Reorder tasks by priority
   - Adjust time allocation intelligently
4. Review suggestions and apply optimized schedule

### Earning XP and Leveling Up

- **+10 XP** for each completed task
- **+5 XP bonus** for weak subjects
- **+15 XP bonus** for using AI optimization
- **Level up** every 100 XP
- **Streak bonuses** for consistent study days

### Creating Flashcards

1. Navigate to "Flashcards" page
2. Click "Generate Flashcards"
3. Paste your study notes or text content
4. AI generates question-answer pairs automatically
5. Start studying in interactive flashcard mode

### Tracking Progress

- **Dashboard** shows:
  - Overall completion rate
  - Subject-wise progress bars
  - XP and level status
  - Current and longest streaks
  - Recent achievements
  - Weekly study patterns

## 🎨 Customization

### Theme
- Light/Dark mode toggle in navbar
- Pastel color palette:
  - Primary: Indigo (#A5B4FC)
  - Secondary: Pink (#FBCFE8)
  - Accent: Mint (#BBF7D0)
  - Highlight: Yellow (#FDE68A)

### Settings
- Notifications
- Sound effects
- Auto-optimization
- Study reminders

## 🧠 AI Features

### Time Distribution Analysis
- Calculates time spent per subject
- Identifies imbalances in study schedule
- Provides actionable suggestions

### Weak Subject Detection
- Based on profile-stated strength levels
- Performance-based analysis
- Prioritizes weak areas in optimization

### Smart Optimization Algorithm
1. **Analyze**: Current task distribution and subject progress
2. **Prioritize**: Weak subjects get higher priority scores
3. **Optimize**: Reorder tasks and adjust time allocation
4. **Suggest**: Provide clear recommendations for improvement

## 📊 API Endpoints

### Authentication
- `POST /api/auth/register` - Create new user
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Get current user
- `PUT /api/auth/profile` - Update profile

### Tasks
- `GET /api/tasks` - Get all tasks with insights
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/:id` - Update task
- `DELETE /api/tasks/:id` - Delete task
- `POST /api/tasks/:id/complete` - Complete task + earn XP

### Optimization
- `POST /api/optimization/analyze` - Analyze current tasks
- `POST /api/optimization/optimize` - Optimize task list
- `POST /api/optimization/reset` - Reset optimization
- `GET /api/optimization/stats` - Get optimization stats

### Dashboard
- `GET /api/dashboard/stats` - Get dashboard statistics
- `GET /api/dashboard/subject-progress` - Subject progress details
- `GET /api/dashboard/achievements` - User achievements
- `GET /api/dashboard/weekly-chart` - Weekly completion data
- `GET /api/dashboard/daily-summary` - Daily activity summary

### Flashcards
- `POST /api/flashcards/generate` - Generate from text
- `GET /api/flashcards` - Get user's flashcards

## 🔒 Security

- JWT token authentication
- Password hashing with bcryptjs
- Input validation with express-validator
- CORS configuration
- Secure HTTP headers

## 🧪 Testing

```bash
# Run server tests
cd server
npm test

# Run client tests
cd client
npm test
```

## 🚢 Deployment

### Frontend (Vercel/Netlify)
```bash
cd client
npm run build
# Deploy the /dist folder
```

### Backend (Heroku/Render)
```bash
cd server
# Update environment variables for production
npm start
```

### Database (MongoDB Atlas)
- Update `MONGODB_URI` in server/.env
- Configure IP whitelist in MongoDB Atlas
- Use connection string with credentials

## 📝 Development

### Adding New Features

1. **Backend**: Create new route in `server/src/routes/`
2. **Controllers**: Add logic in `server/src/controllers/`
3. **Frontend**: Create components in `client/src/components/`
4. **Pages**: Add routes in `client/src/App.jsx`

### Code Style
- Functional components with hooks
- Tailwind CSS for styling
- Clear, descriptive variable names
- Modular, reusable components

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - feel free to use this project for learning or production

## 👥 Acknowledgments

- UI design inspired by Notion, Duolingo, and Google Calendar
- Icons from Lucide React
- Built with modern web technologies and best practices

## 🆘 Support

For issues, questions, or contributions, please open an issue on the repository.

---

**Happy Studying! 📚✨**

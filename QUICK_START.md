# SmartPrep AI - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### 1. Clone and Install (2 minutes)
```bash
# Clone the repository
cd task-manager

# Install all dependencies
npm run install:all
```

### 2. Set Up Environment (1 minute)
```bash
# Create server/.env
cd server
cp .env.example .env

# Edit .env and add your MongoDB URI
MONGODB_URI=mongodb://localhost:27017/smartprep-ai
JWT_SECRET=your_super_secret_key_here

# Create client/.env
cd ../client
cp .env.example .env
# Edit .env (optional for local development)
VITE_API_URL=http://localhost:5000/api
```

### 3. Start MongoDB (30 seconds)
```bash
# Using local MongoDB
mongod

# Or update MONGODB_URI to use MongoDB Atlas
```

### 4. Run the App (30 seconds)
```bash
# Start both frontend and backend
npm run dev

# Open http://localhost:5173 in your browser
```

## 📱 First Steps in the App

### Create Your Account
1. Click "Get Started Free"
2. Fill in:
   - Username
   - Email
   - Password
   - Class (6th grade to college)
   - Exam target (JEE, NEET, Boards, etc.)
   - Subjects with strength levels

### Plan Your First Study Session
1. Go to "Planner" from the menu
2. Click "Add Task"
3. Enter:
   - Subject (from your profile)
   - Topic (what you'll study)
   - Duration (how long)
4. Click "Add Task"

### Try AI Optimization
1. Add 3-4 different tasks
2. Click "Optimize My Plan with AI"
3. Review the suggestions
4. See how tasks get reordered by priority

### Earn Your First XP
1. Click the circle next to a task
2. Mark it as complete
3. Watch your XP increase!
4. Check your progress in the Dashboard

## 🎯 Key Features to Try

### Smart Planning
- Add tasks for different subjects
- See real-time suggestions for balance
- Use AI optimization for better scheduling

### Gamification
- Complete tasks to earn XP
- Level up every 100 XP
- Build your study streak
- Unlock achievements

### Flashcards
- Go to Flashcards page
- Generate from your study notes
- Practice in study mode
- Track your score

### Progress Tracking
- View overall statistics
- Check subject-wise progress
- Monitor your achievements
- See weekly patterns

## 🔧 Common Tasks

### Reset Your Data
```javascript
// In browser console
localStorage.clear();
location.reload();
```

### Check API Connection
```bash
# Test backend
curl http://localhost:5000/api/health

# Should return:
# {"status":"success","message":"SmartPrep AI Server is running"}
```

### View Database
```bash
# Connect to MongoDB
mongosh

# Switch to database
use smartprep-ai

# View collections
show collections

# Example queries
db.users.find()
db.tasks.find()
```

## 🐛 Quick Fixes

### Port Already in Use
```bash
# Find what's using port 5000
lsof -i :5000

# Kill the process
kill -9 <PID>
```

### MongoDB Connection Issues
```bash
# Check if MongoDB is running
ps aux | grep mongod

# Start MongoDB if not running
mongod

# Check connection string format
# mongodb://localhost:27017/database_name
```

### Frontend Not Loading
```bash
# Clear cache and rebuild
cd client
rm -rf node_modules package-lock.json
npm install
npm run dev
```

## 📚 Learning Resources

### React Concepts
- **Components**: Reusable UI pieces
- **Hooks**: useState, useEffect, useContext
- **Context**: Global state management
- **Router**: Page navigation

### Backend Concepts
- **REST API**: HTTP methods (GET, POST, PUT, DELETE)
- **Middleware**: Request/response processing
- **Authentication**: JWT tokens
- **Database**: MongoDB with Mongoose

### Smart Prep Specifics
- **Optimization Algorithm**: Priority-based scheduling
- **Time Distribution**: Subject-wise analysis
- **Gamification**: XP and levels system
- **Flashcard Generation**: Text processing

## 🎓 Tips for Best Results

### Study Planning
- Add realistic time estimates
- Mix weak and strong subjects
- Schedule breaks between sessions
- Use suggestions to balance your time

### AI Optimization
- Run optimization after adding multiple tasks
- Review the suggestions carefully
- Apply optimizations for better efficiency
- Track improvement over time

### Gamification
- Complete tasks consistently for streaks
- Focus on weak subjects for bonus XP
- Use optimization feature for XP rewards
- Aim to unlock all achievements

### Flashcards
- Use clear, structured text for generation
- Practice regularly for better retention
- Review incorrect cards more often
- Create flashcards from important topics

## 🆘 Need Help?

### Documentation
- **Complete Guide**: See `DOCUMENTATION.md`
- **API Reference**: See API section in documentation
- **Component Guide**: See Component Reference section

### Support
- **Issues**: Report bugs in GitHub Issues
- **Questions**: Use GitHub Discussions
- **Features**: Request new features via Issues

## 🎉 You're Ready!

SmartPrep AI is now running and ready to help you study smarter!

**Next Steps**:
1. ✅ Create your profile
2. ✅ Add your first tasks
3. ✅ Try AI optimization
4. ✅ Earn XP and level up
5. ✅ Track your progress

**Remember**:
- Consistency is key to learning
- Use AI suggestions to improve
- Celebrate your achievements
- Have fun while studying!

---

**Happy Studying! 📚✨**
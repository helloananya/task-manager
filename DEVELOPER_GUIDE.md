# SmartPrep AI - Developer Guide

## Extending the Application

### Adding New Features

#### 1. Backend Extension

**Step 1: Create Model**
```javascript
// server/src/models/YourModel.js
import mongoose from 'mongoose';

const yourSchema = new mongoose.Schema({
  field1: { type: String, required: true },
  field2: { type: Number, default: 0 },
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }
}, {
  timestamps: true
});

export default mongoose.model('YourModel', yourSchema);
```

**Step 2: Create Controller**
```javascript
// server/src/controllers/yourController.js
import YourModel from '../models/YourModel';

export const createYourItem = async (req, res) => {
  try {
    const { field1, field2 } = req.body;
    const item = await YourModel.create({
      user: req.user.id,
      field1,
      field2
    });

    res.status(201).json({
      status: 'success',
      data: { item }
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Server error'
    });
  }
};
```

**Step 3: Create Routes**
```javascript
// server/src/routes/yourRoutes.js
import express from 'express';
import { protect } from '../middleware/auth';
import { createYourItem, getYourItems } from '../controllers/yourController';

const router = express.Router();

router.post('/', protect, createYourItem);
router.get('/', protect, getYourItems);

export default router;
```

**Step 4: Register Routes**
```javascript
// server/src/index.js
import yourRoutes from './routes/yourRoutes';

app.use('/api/your-endpoint', yourRoutes);
```

#### 2. Frontend Extension

**Step 1: Create Component**
```jsx
// client/src/components/yourComponent/YourComponent.jsx
import React, { useState } from 'react';

const YourComponent = ({ prop1, prop2 }) => {
  const [state, setState] = useState(null);

  return (
    <div className="your-component">
      {/* Component content */}
    </div>
  );
};

export default YourComponent;
```

**Step 2: Create Page**
```jsx
// client/src/pages/YourPage.jsx
import YourComponent from '../components/yourComponent/YourComponent';

const YourPage = () => {
  return (
    <div>
      <h1>Your Page</h1>
      <YourComponent />
    </div>
  );
};

export default YourPage;
```

**Step 3: Add Route**
```jsx
// client/src/App.jsx
import YourPage from './pages/YourPage';

// In Routes component
<Route path="/your-page" element={<ProtectedRoute><YourPage /></ProtectedRoute>} />
```

**Step 4: Update Navigation**
```jsx
// client/src/components/common/Navbar.jsx
const navigation = [
  // ... existing routes
  { name: 'Your Page', href: '/your-page', icon: YourIcon, protected: true }
];
```

### Customization Options

#### Theme Customization
```javascript
// client/src/styles/theme.js
export const THEME_CONFIG = {
  colors: {
    primary: '#A5B4FC',      // Change primary color
    secondary: '#FBCFE8',    // Change secondary color
    accent: '#BBF7D0',       // Change accent color
    highlight: '#FDE68A'      // Change highlight color
  },
  fonts: {
    primary: 'Inter',           // Change main font
    display: 'Poppins'         // Change display font
  }
};
```

#### Adding New Achievement Types
```javascript
// server/src/config/constants.js
export const ACHIEVEMENT_TYPES = {
  // ... existing achievements
  'NEW_ACHIEVEMENT': {
    title: 'New Achievement Title',
    description: 'Achievement description',
    icon: 'star'
  }
};
```

#### Extending XP System
```javascript
// server/src/controllers/gamificationController.js
export const calculateCustomXP = (action, user) => {
  let xp = 0;

  switch(action) {
    case 'CUSTOM_ACTION':
      xp = 20;
      break;
    // ... other cases
  }

  // Apply multipliers
  if (user.settings?.vip) {
    xp *= 2;
  }

  return xp;
};
```

### Testing Your Changes

#### Backend Testing
```javascript
// server/tests/yourController.test.js
import request from 'supertest';
import app from '../src/index';

describe('Your Controller', () => {
  it('should create item', async () => {
    const response = await request(app)
      .post('/api/your-endpoint')
      .set('Authorization', `Bearer ${token}`)
      .send({ field1: 'value' });

    expect(response.status).toBe(201);
    expect(response.body.status).toBe('success');
  });
});
```

#### Frontend Testing
```javascript
// client/src/components/__tests__/YourComponent.test.jsx
import { render, screen, fireEvent } from '@testing-library/react';
import YourComponent from '../YourComponent';

describe('YourComponent', () => {
  it('renders correctly', () => {
    render(<YourComponent prop1="test" />);
    expect(screen.getByText('expected text')).toBeInTheDocument();
  });

  it('handles user interaction', () => {
    render(<YourComponent />);
    const button = screen.getByRole('button');
    fireEvent.click(button);
    // Assert expected behavior
  });
});
```

### Performance Optimization

#### Caching Strategy
```javascript
// server/src/middleware/cache.js
import NodeCache from 'node-cache';

const cache = new NodeCache({ stdTTL: 600, checkperiod: 120 });

export const cacheMiddleware = (req, res, next) => {
  const key = req.originalUrl;
  const cached = cache.get(key);

  if (cached) {
    return res.json(cached);
  }

  res.sendResponse = res.json;
  res.json = (body) => {
    cache.set(key, body);
    return res.sendResponse(body);
  };

  next();
};
```

#### Database Optimization
```javascript
// server/src/models/YourModel.js
const yourSchema = new mongoose.Schema({
  // ... fields
}, {
  timestamps: true,
  // Add indexes
  indexes: [
    { user: 1, createdAt: -1 }
  ]
});
```

### Deployment Checklist

#### Pre-Deployment
- [ ] Update environment variables for production
- [ ] Set strong JWT_SECRET
- [ ] Configure MongoDB Atlas for production
- [ ] Test all API endpoints
- [ ] Run all tests
- [ ] Check for console errors
- [ ] Verify CORS settings
- [ ] Test authentication flow
- [ ] Check database connection
- [ ] Verify email notifications (if configured)

#### Post-Deployment
- [ ] Monitor server logs
- [ ] Check API response times
- [ ] Verify database operations
- [ ] Test authentication with real users
- [ ] Monitor error rates
- [ ] Check performance metrics
- [ ] Verify backup systems
- [ ] Test mobile responsiveness
- [ ] Verify all features work

### Security Best Practices

#### Authentication
- [ ] Always use HTTPS in production
- [ ] Implement rate limiting
- [ ] Use strong JWT secrets
- [ ] Set reasonable token expiration
- [ ] Implement password complexity requirements
- [ ] Hash passwords with bcrypt
- [ ] Never store plain passwords

#### API Security
- [ ] Validate all inputs
- [ ] Sanitize user data
- [ ] Implement CORS properly
- [ ] Rate limit endpoints
- [ ] Log security events
- [ ] Use parameterized queries
- [ ] Never expose stack traces

#### Data Protection
- [ ] Encrypt sensitive data
- [ ] Implement data retention policies
- [ ] Provide data export functionality
- [ ] Allow account deletion
- [ ] Comply with privacy regulations
- [ ] Regular backups
- [ ] Secure backup storage

### Monitoring and Analytics

#### Key Metrics to Track
- User registration rate
- Daily active users
- Task completion rate
- API response times
- Error rates by endpoint
- Database query performance
- Page load times
- Feature usage statistics

#### Alerting Setup
- Server down alerts
- High error rate alerts
- Slow response time alerts
- Database connection issues
- Failed authentication attempts
- Disk space warnings

### Contributing Guidelines

#### Code Style
- Use functional components
- Follow existing patterns
- Write clear, descriptive comments
- Use meaningful variable names
- Keep functions focused and small
- Handle errors gracefully
- Write tests for new features
- Update documentation

#### Pull Request Process
1. Create feature branch from main
2. Make your changes
3. Add tests
4. Update documentation
5. Submit PR with clear description
6. Address review comments
7. Ensure CI passes

### Common Development Patterns

#### Error Handling Pattern
```javascript
try {
  // Main logic
  const result = await someOperation();
  return { success: true, data: result };
} catch (error) {
  console.error('Operation failed:', error);
  return {
    success: false,
    error: error.message || 'Operation failed'
  };
}
```

#### API Response Pattern
```javascript
return res.json({
  status: success ? 'success' : 'error',
  message: success ? 'Operation successful' : 'Operation failed',
  data: success ? result : null,
  errors: errors.length > 0 ? errors : undefined
});
```

#### Validation Pattern
```javascript
const validateTask = (taskData) => {
  const errors = [];

  if (!taskData.subject) {
    errors.push({ field: 'subject', message: 'Subject is required' });
  }
  if (!taskData.topic || taskData.topic.length < 3) {
    errors.push({ field: 'topic', message: 'Topic must be at least 3 characters' });
  }

  return errors;
};
```

### Troubleshooting Common Issues

#### Build Failures
```bash
# Clear cache
rm -rf node_modules package-lock.json

# Reinstall
npm install

# Check Node version
node --version  # Should be >= 18

# Clear npm cache
npm cache clean --force
```

#### Database Connection Issues
```javascript
// Add connection retry logic
mongoose.connect(uri, {
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 45000,
  retryWrites: true
});
```

#### CORS Issues
```javascript
// Update CORS configuration
app.use(cors({
  origin: process.env.CLIENT_URL,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
```

### Resources for Further Learning

#### React
- [Official Documentation](https://react.dev)
- [React Hooks](https://react.dev/reference/react)
- [Testing Library](https://testing-library.com)
- [Router Documentation](https://reactrouter.com)

#### Node.js/Express
- [Express Guide](https://expressjs.com)
- [Node.js Best Practices](https://nodejs.org/en/docs/guides)
- [REST API Design](https://restfulapi.net)
- [Security Checklist](https://owasp.org/www-project-secure-coding-practices)

#### Database
- [MongoDB University](https://university.mongodb.com)
- [Mongoose Guide](https://mongoosejs.com/docs)
- [Database Optimization](https://docs.mongodb.com/manual/administration/analyzing-mongodb)
- [Aggregation Framework](https://docs.mongodb.com/manual/core/aggregation-pipeline)

---

**Happy Coding! 👨‍💻✨**
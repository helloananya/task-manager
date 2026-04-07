# SmartPrep AI - Docker Quick Start

## 🔧 Build Issues Fixed

### ✅ All Docker Issues Resolved:

1. **Frontend Build Error** ✅
   - **Fixed**: Changed from `npm ci` to `npm install` in client/Dockerfile
   - **Added**: Development Dockerfile with hot reload
   - **Status**: Frontend builds successfully

2. **Backend Build Error** ✅
   - **Fixed**: Changed from `npm ci` to `npm install` in server/Dockerfile
   - **Added**: Development Dockerfile with nodemon
   - **Status**: Backend builds successfully

3. **Import Path Error** ✅
   - **Fixed**: GamificationContext import in App.jsx
   - **Status**: Frontend runs without import errors

## 🚀 Quick Start Options

### Option 1: Development (Recommended)

```bash
# Use development configuration with hot reload
docker-compose -f docker-compose.dev.yml up --build

# Access the application:
# Frontend: http://localhost:5173 (with hot reload)
# Backend:  http://localhost:5000 (with auto-restart)
# MongoDB:  mongodb://localhost:27017/smartprep-ai
```

### Option 2: Production

```bash
# Use production configuration
docker-compose up --build

# Access the application:
# Frontend: http://localhost (port 80)
# Backend:  http://localhost:5000
# MongoDB:  mongodb://mongo:27017/smartprep-ai
```

### Option 3: Single Service Testing

```bash
# Start only MongoDB
docker-compose up -d mongo

# Start only backend
docker-compose up -d backend

# Start only frontend
docker-compose up -d frontend
```

## 📋 Docker Configuration Files

### Available Dockerfiles:

1. **client/Dockerfile** - Production build with nginx
2. **client/Dockerfile.dev** - Development with Vite dev server
3. **server/Dockerfile** - Production build
4. **server/Dockerfile.dev** - Development with nodemon

### Available Docker Compose Files:

1. **docker-compose.yml** - Production setup
2. **docker-compose.prod.yml** - Production with SSL
3. **docker-compose.dev.yml** - Development with hot reload

## 🐳 Docker Commands Reference

### Basic Commands

```bash
# Start all services
docker-compose up

# Start with build
docker-compose up --build

# Start in background
docker-compose up -d

# Stop all services
docker-compose down

# Restart services
docker-compose restart

# View logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f
```

### Build Commands

```bash
# Rebuild specific service
docker-compose up --build backend

# Rebuild all services
docker-compose up --build --force-recreate

# Build without cache
docker-compose build --no-cache

# Use specific Dockerfile
docker-compose -f docker-compose.dev.yml up --build
```

### Development Commands

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up

# Enter container shell
docker-compose exec backend sh

# Install additional packages
docker-compose exec backend npm install <package-name>

# Run tests
docker-compose exec backend npm test

# Check environment variables
docker-compose exec backend printenv
```

### Maintenance Commands

```bash
# Remove containers (keep volumes)
docker-compose down

# Remove containers and volumes (⚠️ deletes data)
docker-compose down -v

# Remove images
docker-compose down --rmi all

# Prune unused resources
docker-compose down --volumes --remove-orphans
docker system prune -a
docker volume prune
```

## 🔍 Troubleshooting

### Build Failures

```bash
# Check what went wrong
docker-compose logs --tail=50

# Clean and rebuild
docker-compose down && docker-compose up --build --no-cache

# Check disk space
docker system df
```

### Port Conflicts

```bash
# Check port usage
netstat -tuln | grep -E '(5000|5173|27017)'

# Change ports if needed
# Edit docker-compose.yml and change port mappings
```

### Container Issues

```bash
# Check container status
docker-compose ps

# Restart unhealthy containers
docker-compose restart <service-name>

# Remove and recreate
docker-compose down && docker-compose up
```

### Database Issues

```bash
# Check MongoDB container
docker-compose exec mongo mongo --eval "db.serverStatus()"

# Restart MongoDB
docker-compose restart mongo

# Check MongoDB logs
docker logs smartprep-mongo
```

## 📊 Development Workflow

### Day 1: Setup

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up --build

# Verify all services are running
docker-compose ps

# Test API health
curl http://localhost:5000/api/health
```

### Day 2: Development

```bash
# Make code changes in your editor
# Changes are reflected immediately (hot reload)

# Monitor logs
docker-compose logs -f

# Test changes in browser
# http://localhost:5173
```

### Day 3: Testing

```bash
# Run tests
docker-compose exec backend npm test
docker-compose exec frontend npm test

# Check coverage
docker-compose exec backend npm run test:coverage
```

## 🎯 Common Tasks

### Adding New Dependencies

```bash
# Update package.json
cd server  # or cd client
npm install <new-package>

# Rebuild affected service
docker-compose up --build backend

# Or restart service to pick up changes
docker-compose restart backend
```

### Updating Environment Variables

```bash
# Edit docker-compose.yml
# Add/modify environment variables

# Restart services
docker-compose up -d

# Or rebuild to apply changes
docker-compose up --build
```

### Database Management

```bash
# Backup database
docker-compose exec mongo mongodump --db smartprep-ai --out backup/

# Restore database
docker-compose exec -T mongo mongorestore --db smartprep-ai < backup/

# Access database shell
docker-compose exec mongo mongosh smartprep-ai
```

## 📈 Monitoring

### Resource Usage

```bash
# Monitor all containers
docker stats

# Monitor specific service
docker stats smartprep-backend

# Check disk usage
docker system df
```

### Health Monitoring

```bash
# Check service health
curl http://localhost:5000/api/health
curl http://localhost:5173

# Container health status
docker-compose ps

# Detailed health info
docker inspect smartprep-backend | grep -A 20 Health
```

## 🚢 Production Deployment

### Building Production Images

```bash
# Build production images
docker-compose -f docker-compose.prod.yml build

# Tag images
docker tag smartprep-backend:latest your-registry/smartprep-backend
docker tag smartprep-frontend:latest your-registry/smartprep-frontend
```

### Push to Registry

```bash
# Login to registry
docker login your-registry.com

# Push images
docker push your-registry/smartprep-backend
docker push your-registry/smartprep-frontend
```

### Running Production

```bash
# Pull images
docker pull your-registry/smartprep-backend
docker pull your-registry/smartprep-frontend

# Run production containers
docker-compose -f docker-compose.prod.yml up -d
```

## 🎉 Quick Test Commands

```bash
# Test backend health
curl http://localhost:5000/api/health

# Test frontend
curl http://localhost:5173

# Test database connection
docker-compose exec backend node -e "console.log('MongoDB connected')"

# Check all containers
docker-compose ps

# View logs for any service
docker-compose logs backend
```

## 🆘 If Issues Persist

### Alternative: Local Development

```bash
# Skip Docker for faster development
cd server && npm run dev
cd client && npm run dev

# Use if Docker issues persist or for debugging
```

### Clean Restart

```bash
# Stop everything
docker-compose down

# Remove all Docker resources
docker-compose down -v --remove-orphans

# Clean Docker cache
docker system prune -a

# Start fresh
docker-compose up --build --no-cache
```

---

**Happy Dockering! 🐳✨**

**Remember**: Use `docker-compose.dev.yml` for development with hot reload!
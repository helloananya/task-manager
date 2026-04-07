# SmartPrep AI - Docker Setup Guide

## Fixed Docker Issues

### ✅ Issues Resolved:

1. **Import Path Error** - Fixed GamificationContext import in App.jsx
2. **Build Directory Error** - Fixed `/app/build` to `/app/dist` path issue
3. **Cache Key Error** - Added proper .dockerignore files
4. **Missing Configuration** - Created proper nginx configuration
5. **Health Check Issues** - Added health checks to all services
6. **Multi-stage Build** - Optimized Docker build caching
7. **Environment Variables** - Properly configured all service dependencies

## Quick Start with Docker

### Option 1: Docker Compose (Recommended)

```bash
# Build and start all services
docker-compose up --build

# Access the application
# Frontend: http://localhost:5173
# Backend: http://localhost:5000
# API Health: http://localhost:5000/api/health
```

### Option 2: Individual Containers

```bash
# Start MongoDB only
docker-compose up -d mongo

# Start backend only
docker-compose up -d backend

# Start frontend only
docker-compose up -d frontend
```

## Docker Services

### Services Overview

#### MongoDB (mongo)
- **Image**: mongo:7
- **Port**: 27017
- **Volume**: mongo-data (persistent storage)
- **Network**: smartprep-network
- **Health**: Automatic container restart

#### Backend (backend)
- **Build**: Multi-stage Node.js build
- **Port**: 5000
- **Dependencies**: MongoDB
- **Environment Variables**:
  - `MONGODB_URI`: MongoDB connection string
  - `NODE_ENV`: development/production
  - `PORT`: Application port
  - `JWT_SECRET`: Authentication secret
  - `CLIENT_URL`: Frontend URL
- **Health Check**: `/api/health` endpoint
- **Network**: smartprep-network

#### Frontend (frontend)
- **Build**: Multi-stage Node.js + Nginx
- **Port**: 5173 (development) / 80 (production)
- **Dependencies**: Backend
- **Environment Variables**:
  - `VITE_API_URL`: Backend API URL
- **Health Check**: Nginx serving check
- **Network**: smartprep-network

## Common Docker Commands

### Build Commands

```bash
# Rebuild specific service
docker-compose up --build backend

# Rebuild all services
docker-compose up --build --force-recreate

# Build without cache
docker-compose build --no-cache
```

### Running Commands

```bash
# Start in detached mode
docker-compose up -d

# Start with logs
docker-compose up

# Stop all services
docker-compose down

# Restart specific service
docker-compose restart backend

# View logs
docker-compose logs backend
docker-compose logs -f frontend
```

### Debugging Commands

```bash
# Execute command in container
docker-compose exec backend sh

# View container processes
docker-compose ps

# Inspect container details
docker-compose exec backend ps aux

# Check container logs
docker logs smartprep-backend

# Check nginx logs
docker logs smartprep-frontend
```

### Maintenance Commands

```bash
# Remove all containers and networks
docker-compose down

# Remove volumes (⚠️ deletes data)
docker-compose down -v

# Remove images
docker-compose down --rmi all

# Prune unused images
docker system prune -a

# Prune unused volumes
docker volume prune
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker-compose logs backend

# Check container status
docker-compose ps

# Rebuild without cache
docker-compose up --build --no-cache

# Remove and recreate
docker-compose down && docker-compose up --build
```

### Port Conflicts

```bash
# Check what's using ports
netstat -tuln | grep -E '(5000|5173|27017)'

# Kill conflicting processes
kill -9 <PID>

# Change ports in docker-compose.yml
ports:
  - "5001:5000"  # Use different external port
```

### Build Failures

```bash
# Clean build cache
docker system prune -f

# Remove build artifacts
docker-compose down -v

# Check Docker disk space
docker system df

# Clear Docker cache
docker builder prune -a
```

### Network Issues

```bash
# Check network connectivity
docker network inspect smartprep-network

# Test connectivity between containers
docker-compose exec backend ping mongo

# Restart networks
docker network prune
docker-compose down && docker-compose up
```

### Database Connection Issues

```bash
# Check MongoDB container
docker-compose exec mongo mongo --eval "db.serverStatus()"

# Test connection from backend
docker-compose exec backend node -e "console.log('Mongo URI:', process.env.MONGODB_URI)"

# Check MongoDB logs
docker logs smartprep-mongo

# Reset MongoDB volume
docker-compose down -v
docker-compose up -d mongo
```

## Development vs Production

### Development Mode
```bash
# Development docker-compose
docker-compose -f docker-compose.dev.yml up
```

### Production Mode
```bash
# Production docker-compose
docker-compose -f docker-compose.prod.yml up
```

## Performance Optimization

### Reduce Image Size
```dockerfile
# Use alpine images
FROM node:18-alpine

# Multi-stage builds
FROM node:18-alpine AS build
FROM node:18-alpine AS production

# Clean up in each stage
RUN npm ci --only=production && \
    npm cache clean --force
```

### Improve Build Speed
```yaml
# Use build cache
volumes:
  - node_modules:/app/node_modules
  - npm_cache:/root/.npm

# Use bind mounts for development
volumes:
  - ./server:/app:cached
  - ./client:/app:cached
```

### Resource Limits
```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
```

## Security Best Practices

### Container Security
```dockerfile
# Use non-root user
RUN addgroup -g nodejs && adduser -g nodejs -u nodejs -s /bin/sh
USER nodejs

# Use specific versions
FROM node:18.17-alpine

# Minimal base images
FROM node:18-alpine AS production
```

### Environment Variables
```yaml
services:
  backend:
    environment:
      - MONGODB_URI=${MONGODB_URI:-mongodb://mongo:27017/smartprep-ai}
      - JWT_SECRET=${JWT_SECRET:-default_secret_change_me}
      - NODE_ENV=${NODE_ENV:-development}
```

### Network Security
```yaml
networks:
  smartprep-network:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 172.20.0.0/16
```

## Monitoring

### Health Checks
```bash
# Check service health
curl http://localhost:5000/api/health
curl http://localhost:5173

# Check Docker health
docker-compose ps

# Container resource usage
docker stats smartprep-backend
docker stats smartprep-frontend
```

### Logging
```bash
# View all logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f backend

# Export logs
docker-compose logs > logs.txt

# Log level configuration
services:
  backend:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## Deployment

### Push to Registry
```bash
# Build and push images
docker-compose build
docker tag smartprep-backend:latest your-registry/smartprep-backend
docker push your-registry/smartprep-backend
```

### Production Deployment
```bash
# Deploy with production docker-compose
docker-compose -f docker-compose.prod.yml up -d

# Scale services
docker-compose up -d --scale backend=3

# Update services
docker-compose up -d --no-deps backend
```

---

**Happy Dockering! 🐳✨**
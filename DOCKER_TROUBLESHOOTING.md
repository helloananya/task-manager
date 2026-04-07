# Docker Build Troubleshooting Guide

## Current Issue: npm ci Build Failure

**Error**: `process "/bin/sh -c npm ci && npm cache clean --force" did not complete successfully: exit code: 1`

### Root Causes:
1. **Missing package-lock.json** - `npm ci` requires exact dependency versions
2. **Corrupted package files** - package.json has syntax errors
3. **Dependency conflicts** - Incompatible package versions
4. **Node version mismatch** - Packages incompatible with Node.js 18
5. **Network issues** - Failed to download dependencies

## Quick Fixes

### Fix 1: Use Development Docker Compose (Recommended)

```bash
# Use the development configuration
docker-compose -f docker-compose.dev.yml up --build

# This uses hot reload and is more forgiving
```

### Fix 2: Clean Docker Cache

```bash
# Remove all Docker containers, images, and cache
docker-compose down -v
docker system prune -a
docker builder prune -a

# Rebuild from scratch
docker-compose up --build --no-cache
```

### Fix 3: Generate package-lock.json

```bash
# Go to client directory
cd client

# Generate lock file
npm install

# Now try building again
docker-compose up --build
```

### Fix 4: Check Package Files

```bash
# Check package.json syntax
cd client
cat package.json | python3 -m json.tool

# Validate package.json
npm run lint

# Check for duplicates
npm ls
```

### Fix 5: Use Node Version Compatible

```bash
# Check Node version in Dockerfile
# FROM node:18-alpine  # Correct for our package.json

# If using different Node version, update it
# FROM node:18.17-alpine  # Specific version
```

## Step-by-Step Debugging

### Step 1: Verify Docker Installation

```bash
# Check Docker version
docker --version
# Should be 20.10.0 or higher

# Check Docker Compose version
docker-compose --version
# Should be 2.20.0 or higher
```

### Step 2: Test Basic Node Container

```bash
# Test if Node.js container works
docker run --rm node:18-alpine npm --version

# Test if npm works
docker run --rm node:18-alpine npm install --version
```

### Step 3: Build One Service at a Time

```bash
# Build just MongoDB first
docker-compose build mongo

# Build just backend
docker-compose build backend

# Build just frontend (with simpler Dockerfile)
docker-compose build frontend
```

### Step 4: Check Build Logs

```bash
# View detailed build logs
docker-compose build --no-cache --progress=plain

# Follow build process
docker-compose up --build 2>&1 | tee build.log
```

### Step 5: Manual Build Test

```bash
# Enter container and build manually
docker run --rm -v $(pwd)/client:/app node:18-alpine sh -c "cd /app && npm install && npm run build"
```

## Common Build Error Solutions

### Error: "Cannot find module 'react'"

```bash
# Delete node_modules and reinstall
cd client
rm -rf node_modules package-lock.json
npm install

# Clear Docker cache and rebuild
docker system prune -a
docker-compose up --build --no-cache
```

### Error: "Port already in use"

```bash
# Kill processes using the ports
netstat -tuln | grep -E '(5173|5000)'
kill -9 <PID>

# Or change ports in docker-compose.yml
# "5174:5173" instead of "5173:5173"
```

### Error: "Failed to connect to MongoDB"

```bash
# Check if MongoDB is running
docker-compose ps mongo

# Check MongoDB logs
docker logs smartprep-mongo

# Restart MongoDB
docker-compose restart mongo
```

### Error: "No space left on device"

```bash
# Clean up Docker space
docker system prune -a
docker volume prune

# Check disk usage
docker system df

# Remove unused images
docker image prune -a
```

## Development-Specific Solutions

### Hot Module Replacement (HMR) Issues

```bash
# Use development docker-compose
docker-compose -f docker-compose.dev.yml up

# This includes volume mounts for live updates
# Frontend changes are reflected immediately
```

### Backend Development Issues

```bash
# Use nodemon for auto-restart
docker-compose exec backend npm install -g nodemon

# Check backend logs
docker-compose logs -f backend
```

### Database Connection During Development

```bash
# Access MongoDB container shell
docker-compose exec mongo mongosh

# Check database status
show dbs
use smartprep-ai
db.stats()
```

## Production Deployment Issues

### SSL/TLS Configuration

```bash
# Add SSL certificates
# Update nginx configuration with SSL paths

# Use environment variables for SSL paths
SSL_CERT_PATH=/path/to/cert.pem
SSL_KEY_PATH=/path/to/key.pem
```

### Environment Variable Configuration

```bash
# Test environment variables locally
docker-compose config

# Check if variables are set correctly
docker-compose exec backend printenv | grep MONGODB

# Validate required variables
docker-compose exec backend sh -c 'echo $JWT_SECRET'
```

## Performance Optimization

### Reduce Build Time

```bash
# Use bind mounts for development
volumes:
  - ./node_modules:/app/node_modules

# Use BuildKit for faster builds
export DOCKER_BUILDKIT=1
docker buildx build --buildkit
```

### Reduce Image Size

```bash
# Use .dockerignore to exclude unnecessary files
# Add node_modules, test files, documentation

# Use multi-stage builds properly
# Separate build and runtime stages

# Clean up in each stage
RUN npm ci --only=production && npm cache clean --force
```

### Memory Optimization

```bash
# Limit container memory
docker-compose up -d --scale backend=1

# Add memory limits to docker-compose.yml
deploy:
  resources:
    limits:
      memory: 512M
    reservations:
      memory: 256M
```

## Monitoring and Debugging

### Real-time Logs

```bash
# Follow all service logs
docker-compose logs -f

# Follow specific service
docker-compose logs -f frontend

# Export logs for analysis
docker-compose logs > docker-logs.txt
```

### Container Health

```bash
# Check container status
docker-compose ps

# Inspect unhealthy containers
docker inspect smartprep-frontend | grep -A 10 Health

# Restart unhealthy containers
docker-compose restart frontend
```

### Performance Metrics

```bash
# Monitor container resources
docker stats

# Check container processes
docker-compose exec backend ps aux

# Monitor build times
time docker-compose up --build
```

## Final Solution for npm ci Issue

### Recommended Approach:

1. **Use Development Docker Compose** (docker-compose.dev.yml)
   - Hot reload enabled
   - Volume mounts for live updates
   - No complex build caching

2. **Or Simplify Production Dockerfile**
   - Use `npm install` instead of `npm ci`
   - Better error handling
   - More forgiving of missing lock files

3. **Generate package-lock.json**
   ```bash
   cd client
   npm install
   docker-compose up --build
   ```

### Quick Test Commands:

```bash
# Test with development config (easiest)
docker-compose -f docker-compose.dev.yml up

# Clean rebuild
docker-compose down && docker-compose up --build --no-cache

# Single service test
docker-compose up backend mongo
```

---

**If issues persist, try local development without Docker first!** 🐳✨
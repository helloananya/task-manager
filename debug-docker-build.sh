#!/bin/bash

# Docker Build Debug Script for SmartPrep AI
# This script helps diagnose and fix common Docker build issues

echo "🔍 SmartPrep AI Docker Build Debug Script"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo -e "\n${GREEN}1. Checking Prerequisites...${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed${NC}"
    echo "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed${NC}"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# Check Docker version
echo -e "Docker version: ${GREEN}$(docker --version)${NC}"

# Check Docker Compose version
echo -e "Docker Compose version: ${GREEN}$(docker-compose --version)${NC}"

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ] && [ ! -f "docker-compose.dev.yml" ]; then
    echo -e "${YELLOW}⚠️  Warning: Not in project root directory${NC}"
    echo "Please run this script from the project root"
fi

echo -e "\n${GREEN}✓ Prerequisites check passed${NC}"

# Check for common issues
echo -e "\n${GREEN}2. Checking for Common Issues...${NC}"

# Check package.json files
echo -e "Checking package.json files..."

if [ -f "server/package.json" ]; then
    echo -e "${GREEN}✓ server/package.json exists${NC}"
    # Validate JSON
    if node -e "require('./server/package.json')" 2>/dev/null; then
        echo -e "${GREEN}✓ server/package.json is valid JSON${NC}"
    else
        echo -e "${RED}✗ server/package.json has syntax errors${NC}"
        echo "Run: cat server/package.json | python3 -m json.tool"
    fi
else
    echo -e "${RED}✗ server/package.json not found${NC}"
fi

if [ -f "client/package.json" ]; then
    echo -e "${GREEN}✓ client/package.json exists${NC}"
    # Validate JSON
    if node -e "require('./client/package.json')" 2>/dev/null; then
        echo -e "${GREEN}✓ client/package.json is valid JSON${NC}"
    else
        echo -e "${RED}✗ client/package.json has syntax errors${NC}"
        echo "Run: cat client/package.json | python3 -m json.tool"
    fi
else
    echo -e "${RED}✗ client/package.json not found${NC}"
fi

# Check Dockerfile existence
echo -e "\nChecking Dockerfiles..."

if [ -f "server/Dockerfile" ]; then
    echo -e "${GREEN}✓ server/Dockerfile exists${NC}"
else
    echo -e "${RED}✗ server/Dockerfile not found${NC}"
fi

if [ -f "client/Dockerfile" ]; then
    echo -e "${GREEN}✓ client/Dockerfile exists${NC}"
else
    echo -e "${RED}✗ client/Dockerfile not found${NC}"
fi

# Check Docker Compose files
if [ -f "docker-compose.yml" ]; then
    echo -e "${GREEN}✓ docker-compose.yml exists${NC}"
fi

if [ -f "docker-compose.dev.yml" ]; then
    echo -e "${GREEN}✓ docker-compose.dev.yml exists${NC}"
fi

# Clean up previous builds
echo -e "\n${GREEN}3. Cleaning up Previous Builds...${NC}"

# Stop any running containers
echo -e "Stopping any running containers..."
docker-compose down 2>/dev/null

# Remove old images (optional - comment out if you want to keep them)
read -p "Do you want to remove old Docker images? (y/n): " -n -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "Removing old images..."
    docker system prune -a
    echo -e "${GREEN}✓ Old images removed${NC}"
fi

# Test Docker build without cache
echo -e "\n${GREEN}4. Testing Docker Build...${NC}"

# Test backend build
echo -e "Testing server Dockerfile build..."
if docker build -f server/Dockerfile -t smartprep-backend-test . 2>&1 | tail -20; then
    BUILD_SUCCESS=$?
    echo -e "${GREEN}✓ Server Dockerfile test completed${NC}"
else
    echo -e "${RED}✗ Server Dockerfile test failed${NC}"
    BUILD_SUCCESS=false
fi

# Test frontend build
echo -e "Testing client Dockerfile build..."
if docker build -f client/Dockerfile -t smartprep-frontend-test . 2>&1 | tail -20; then
    BUILD_SUCCESS=$?
    echo -e "${GREEN}✓ Client Dockerfile test completed${NC}"
else
    echo -e "${RED}✗ Client Dockerfile test failed${NC}"
    BUILD_SUCCESS=false
fi

# Provide recommendations
echo -e "\n${GREEN}5. Build Recommendations:${NC}"

if [ "$BUILD_SUCCESS" = true ]; then
    echo -e "${GREEN}✅ Docker build tests passed!${NC}"
    echo -e "You can now run: docker-compose up --build"
else
    echo -e "${YELLOW}⚠️  Docker build tests failed${NC}"
    echo -e "\nPossible solutions:"
    echo -e "1. ${GREEN}Use development config${NC}: docker-compose -f docker-compose.dev.yml up --build"
    echo -e "2. ${GREEN}Try local development${NC}: cd server && npm run dev"
    echo -e "3. ${GREEN}Check Docker logs${NC}: docker-compose build --no-cache 2>&1 | tee build.log"
fi

# Check Docker disk space
echo -e "\n${GREEN}6. Docker System Status:${NC}"

DOCKER_SPACE=$(docker system df --format "{{.Size}}" 2>/dev/null || echo "Unknown")
echo -e "Docker disk usage: ${YELLOW}$DOCKER_SPACE${NC}"

# Check Docker cache
DOCKER_CACHE=$(du -sh /var/lib/docker 2>/dev/null || echo "Unknown")
echo -e "Docker cache size: ${YELLOW}$DOCKER_CACHE${NC}"

# Provide action items
echo -e "\n${GREEN}======================================${NC}"
echo -e "${GREEN}Recommended Actions:${NC}"

if [ "$BUILD_SUCCESS" = true ]; then
    echo -e "\n${GREEN}1. Start Development Environment:${NC}"
    echo -e "   docker-compose -f docker-compose.dev.yml up --build"
    echo -e "\n${GREEN}2. Or Build Production:${NC}"
    echo -e "   docker-compose up --build"
else
    echo -e "\n${YELLOW}1. Clean Docker Cache:${NC}"
    echo -e "   docker system prune -a"
    echo -e "   docker builder prune -a"
    echo -e "\n${YELLOW}2. Try Local Development:${NC}"
    echo -e "   cd server && npm install && npm run dev"
    echo -e "   cd client && npm install && npm run dev"
    echo -e "\n${YELLOW}3. Check Network Connection:${NC}"
    echo -e "   Ensure you have internet connection for npm install"
    echo -e "   Check firewall settings if using corporate network"
fi

# Check for running containers
RUNNING_CONTAINERS=$(docker-compose ps -q 2>/dev/null)
if [ ! -z "$RUNNING_CONTAINERS" ]; then
    echo -e "\n${YELLOW}⚠️  Warning: Containers are still running${NC}"
    echo -e "Running containers: $RUNNING_CONTAINERS"
    echo -e "Run: docker-compose down to stop them"
fi

echo -e "\n${GREEN}======================================${NC}"
echo -e "${GREEN}Debug script completed!${NC}"
echo -e "Check the output above for issues and recommendations${NC}"

# Ask if user wants to proceed with build
echo -e "\n${YELLOW}Do you want to proceed with the build now? (y/n):${NC} "
read -p "Proceed with development build? (y/n): " -n -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${GREEN}Starting development build...${NC}"
    docker-compose -f docker-compose.dev.yml up --build
    echo -e "${GREEN}✅ Build started! Check logs above for status${NC}"
elif [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}Build cancelled${NC}"
else
    echo -e "\n${RED}Skipping build${NC}"
fi

echo -e "\n${GREEN}======================================${NC}"
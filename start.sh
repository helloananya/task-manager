#!/bin/bash

# SmartPrep AI - Quick Start Script
# This script provides multiple startup options

echo "🚀 SmartPrep AI - Quick Start"
echo "======================================"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Docker
echo -e "\n${GREEN}1. Checking Docker Installation...${NC}"

if command_exists docker; then
    echo -e "${GREEN}✓ Docker is installed${NC}"
    docker --version
else
    echo -e "${RED}✗ Docker is not installed${NC}"
    echo -e "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check Docker Compose
echo -e "\n${GREEN}2. Checking Docker Compose...${NC}"

if command_exists docker-compose; then
    echo -e "${GREEN}✓ Docker Compose is installed${NC}"
    docker-compose --version
else
    echo -e "${RED}✗ Docker Compose is not installed${NC}"
    echo -e "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# Check MongoDB
echo -e "\n${GREEN}3. Checking MongoDB...${NC}"

MONGO_RUNNING=$(docker ps -q -f name=smartprep-mongo*)
if [ ! -z "$MONGO_RUNNING" ]; then
    echo -e "${YELLOW}⚠️  MongoDB container is already running${NC}"
else
    echo -e "${GREEN}✓ MongoDB is not running${NC}"
fi

# Check running containers
echo -e "\n${GREEN}4. Checking Running Containers...${NC}"

RUNNING_CONTAINERS=$(docker-compose ps -q 2>/dev/null)
if [ ! -z "$RUNNING_CONTAINERS" ]; then
    echo -e "${YELLOW}⚠️  Containers are already running${NC}"
    echo -e "Running containers: $RUNNING_CONTAINERS"
    echo -e "Run 'docker-compose down' first, or choose option 4 to restart"
else
    echo -e "${GREEN}✓ No containers running${NC}"
fi

echo -e "\n${GREEN}5. Available Startup Options:${NC}"

echo -e "${GREEN}1)${NC} Development Mode with Hot Reload (Recommended)"
echo -e "   - Fast development with instant code updates"
echo -e "   - Frontend: http://localhost:5173 (Vite dev server)"
echo -e "   - Backend:  http://localhost:5000 (nodemon auto-restart)"
echo -e "   - MongoDB: mongodb://localhost:27017/smartprep-ai"

echo -e "\n${GREEN}2)${NC} Production Mode"
echo -e "   - Optimized production builds"
echo -e "   - Nginx for frontend serving"
echo -e "   - Health checks enabled"
echo -e "   - Frontend: http://localhost (port 80)"
echo -e "   - Backend:  http://localhost:5000"

echo -e "\n${GREEN}3)${NC} Local Development (Fastest)"
echo -e "   - Skip Docker for faster development"
echo -e "   - Use npm scripts directly"
echo -e "   - No container overhead"
echo -e "   - Best for debugging"

echo -e "\n${GREEN}4)${NC} Build Only (No Start)"
echo -e "   - Build Docker images without running containers"
echo -e "   - Good for testing build process"
echo -e "   - Images: smartprep-backend, smartprep-frontend"

echo -e "\n${GREEN}5)${NC} Debug Docker Build"
echo -e "   - Run comprehensive Docker diagnostics"
echo -e "   - Test builds for both client and server"
echo -e "   - Provide detailed error reporting"

echo -e "\n${GREEN}6)${NC} Stop and Clean"
echo -e "   - Stop all running containers"
echo -e "   - Remove Docker volumes (⚠️ deletes data)"
echo -e "   - Clean Docker cache"

echo -e "\n${GREEN}7)${NC} Exit"
echo -e "   - Exit the script"

# Get user choice
echo -e "\n${YELLOW}Enter your choice (1-7):${NC} "
read -p "> " choice

# Process user choice
case $choice in
    1)
        echo -e "\n${GREEN}🚀 Starting Development Mode...${NC}"
        echo -e "Using docker-compose.dev.yml for hot reload..."
        docker-compose -f docker-compose.dev.yml up --build
        echo -e "\n${GREEN}✅ Development Mode Started!${NC}"
        echo -e "Frontend: ${GREEN}http://localhost:5173${NC} (hot reload enabled)"
        echo -e "Backend:  ${GREEN}http://localhost:5000${NC} (auto-restart enabled)"
        echo -e "MongoDB:    ${GREEN}mongodb://localhost:27017/smartprep-ai${NC}"
        echo -e "\n${YELLOW}💡 Tip: Code changes are reflected immediately!${NC}"
        ;;
    2)
        echo -e "\n${GREEN}🚀 Starting Production Mode...${NC}"
        echo -e "Building and starting production containers..."
        docker-compose up --build
        echo -e "\n${GREEN}✅ Production Mode Started!${NC}"
        echo -e "Frontend: ${GREEN}http://localhost${NC} (port 80)"
        echo -e "Backend:  ${GREEN}http://localhost:5000${NC}"
        ;;
    3)
        echo -e "\n${YELLOW}⚡ Starting Local Development...${NC}"
        echo -e "Starting backend locally (fastest option)..."
        cd server && npm run dev
        ;;
    4)
        echo -e "\n${YELLOW}🔄 Restarting Containers...${NC}"
        echo -e "Stopping and restarting all services..."
        docker-compose down
        docker-compose -f docker-compose.dev.yml up
        echo -e "\n${GREEN}✅ Containers restarted!${NC}"
        ;;
    5)
        echo -e "\n${BLUE}🔨 Building Docker Images...${NC}"
        echo -e "Building images without running containers..."
        docker-compose build
        echo -e "\n${GREEN}✅ Build completed!${NC}"
        echo -e "Images built: smartprep-backend, smartprep-frontend"
        echo -e "${YELLOW}💡 Run 'docker-compose up' to start containers${NC}"
        ;;
    6)
        echo -e "\n${RED}🧹 Cleaning Up Docker...${NC}"
        echo -e "Stopping containers and removing volumes..."
        docker-compose down -v
        echo -e "\n${GREEN}✅ Clean up completed!${NC}"
        echo -e "${YELLOW}⚠️  All data has been removed${NC}"
        ;;
    7)
        echo -e "\n${YELLOW}🐛 Starting Docker Debug...${NC}"
        chmod +x debug-docker-build.sh
        ./debug-docker-build.sh
        ;;
    *)
        echo -e "\n${RED}✗ Invalid choice${NC}"
        echo -e "Please enter a number between 1 and 7"
        ;;
esac

echo -e "\n${GREEN}======================================${NC}"
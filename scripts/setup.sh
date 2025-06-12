#!/bin/bash

# Enhanced MCP Server Setup Script

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 Enhanced MCP Server - Setup${NC}"
echo ""

# Check dependencies
echo -e "${BLUE}Checking dependencies...${NC}"

# Check Python
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 is not installed${NC}"
    exit 1
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed${NC}"
    exit 1
fi

# Check docker-compose
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ docker-compose is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All dependencies found${NC}"

# Create .env from example if it doesn't exist
if [ ! -f ".env" ]; then
    echo -e "${BLUE}Creating .env file...${NC}"
    cp .env.example .env
    echo -e "${YELLOW}⚠️  Please edit .env and add your AI API keys${NC}"
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo -e "${BLUE}Creating Python virtual environment...${NC}"
    python3 -m venv venv
fi

# Activate virtual environment
echo -e "${BLUE}Activating virtual environment...${NC}"
source venv/bin/activate

# Install Python dependencies
echo -e "${BLUE}Installing Python dependencies...${NC}"
pip install --upgrade pip
pip install -r requirements.txt

# Start databases
echo -e "${BLUE}Starting PostgreSQL and Redis...${NC}"
docker-compose up -d postgres redis

# Wait for databases to be ready
echo -e "${BLUE}Waiting for databases...${NC}"
sleep 10

# Initialize database
echo -e "${BLUE}Initializing database...${NC}"
python3 scripts/init_db.py

# Run tests
echo -e "${BLUE}Running tests...${NC}"
python3 -m pytest tests/ -v

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Edit .env and add your AI API keys"
echo "2. Test with: python3 src/cli.py status"
echo "3. Add to Claude Code:"
echo "   claude mcp add enhanced-context \"python3 $(pwd)/src/main.py --stdio\" --scope user"
echo ""
echo -e "${BLUE}CLI Usage:${NC}"
echo "  python3 src/cli.py status              # Check server status"
echo "  python3 src/cli.py show --ai gemini    # Show Gemini's context"
echo "  python3 src/cli.py clear --ai all      # Clear all AI contexts"
echo "  python3 src/cli.py test-ais            # Test AI connections"
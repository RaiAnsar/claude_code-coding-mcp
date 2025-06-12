#!/bin/bash

# Local setup script for testing with existing API keys

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Enhanced MCP Server - Local Setup${NC}"
echo ""

# Check if .env.local exists
if [ ! -f ".env.local" ]; then
    echo -e "${YELLOW}⚠️  No .env.local found${NC}"
    exit 1
fi

# Start databases with Docker
echo -e "${BLUE}Starting databases...${NC}"
docker-compose up -d postgres redis

# Wait for databases
echo "Waiting for databases to be ready..."
sleep 5

# Initialize database
echo -e "${BLUE}Initializing database...${NC}"
python3 scripts/init_db.py

# Install dependencies if needed
if [ ! -d "venv" ]; then
    echo -e "${BLUE}Creating virtual environment...${NC}"
    python3 -m venv venv
fi

echo -e "${BLUE}Installing dependencies...${NC}"
source venv/bin/activate
pip install -r requirements.txt

# Run tests
echo ""
echo -e "${BLUE}Testing AI connections...${NC}"
python3 test_local.py

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "To use the CLI:"
echo "  python3 src/cli.py --help"
echo ""
echo "To start the server:"
echo "  python3 src/main.py"
echo ""
echo "To test in Claude Code:"
echo "  claude mcp add enhanced-context --command \"python3 $(pwd)/src/main.py --stdio\" --scope user"
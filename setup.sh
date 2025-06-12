#!/bin/bash

# Enhanced MCP Server Setup Script
# Gives OTHER AIs memory when working with Claude Code

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    Enhanced MCP Server - AI Context Bridge Setup${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}This server gives Gemini, Grok, ChatGPT, and DeepSeek${NC}"
echo -e "${GREEN}the same persistent memory that Claude Code already has!${NC}"
echo ""

# Check Python version
echo -e "${BLUE}🔍 Checking Python version...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 is not installed. Please install Python 3.8 or higher.${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo -e "${GREEN}✅ Python $PYTHON_VERSION found${NC}"

# Check Node.js version
echo -e "${BLUE}🔍 Checking Node.js version...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed. Please install Node.js 16 or higher.${NC}"
    exit 1
fi

NODE_VERSION=$(node -v)
echo -e "${GREEN}✅ Node.js $NODE_VERSION found${NC}"

# Check Docker
echo -e "${BLUE}🔍 Checking Docker...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅ Docker found${NC}"
    DOCKER_AVAILABLE=true
else
    echo -e "${YELLOW}⚠️  Docker not found. You can still run without Docker.${NC}"
    DOCKER_AVAILABLE=false
fi

# Create installation directory
INSTALL_DIR="$HOME/.claude-mcp-servers/enhanced-context"
echo ""
echo -e "${BLUE}📁 Creating installation directory...${NC}"
mkdir -p "$INSTALL_DIR"

# Copy files
echo -e "${BLUE}📋 Copying server files...${NC}"
cp -r src "$INSTALL_DIR/"
cp requirements.txt "$INSTALL_DIR/"
cp package.json "$INSTALL_DIR/"

# Install Python dependencies
echo ""
echo -e "${BLUE}🐍 Installing Python dependencies...${NC}"
cd "$INSTALL_DIR"
python3 -m pip install --user -r requirements.txt

# Install Node dependencies (optional)
if [ -f "package.json" ]; then
    echo -e "${BLUE}📦 Installing Node.js dependencies...${NC}"
    npm install --production
fi

# Configure environment
echo ""
echo -e "${BLUE}⚙️  Setting up configuration...${NC}"

# Copy environment template
if [ ! -f "$INSTALL_DIR/.env" ]; then
    cat > "$INSTALL_DIR/.env" << 'EOF'
# Enhanced MCP Server Configuration

# Database (uses Docker by default, or install locally)
DATABASE_URL=postgresql://mcp_user:mcp_password@localhost:5432/mcp_dev
REDIS_URL=redis://localhost:6379

# Server
MCP_HOST=localhost
MCP_PORT=8000

# Features
ENABLE_DEBUGGING=true
ENABLE_CODE_ANALYSIS=true

# AI API Keys (add your keys here)
GEMINI_API_KEY=
GROK_API_KEY=
OPENAI_API_KEY=
DEEPSEEK_API_KEY=

# AI Models (customize if needed)
GEMINI_MODEL=gemini-2.0-flash
GROK_MODEL=grok-3
OPENAI_MODEL=gpt-4o
DEEPSEEK_MODEL=deepseek-chat
EOF
    echo -e "${GREEN}✅ Created .env file${NC}"
else
    echo -e "${YELLOW}⚠️  .env file already exists, skipping${NC}"
fi

# Configure Claude Code
echo ""
echo -e "${BLUE}🔧 Configuring Claude Code...${NC}"

# Check if Claude is installed
if ! command -v claude &> /dev/null; then
    echo -e "${RED}❌ Claude Code CLI not found. Please install it first.${NC}"
    echo -e "${YELLOW}   Visit: https://docs.anthropic.com/claude-code${NC}"
    exit 1
fi

# Add MCP server to Claude Code
echo -e "${BLUE}Adding Enhanced MCP server to Claude Code...${NC}"

claude mcp add enhanced-context \
    --command "python3 $INSTALL_DIR/src/main.py --stdio" \
    --scope user \
    --description "Gives OTHER AIs persistent memory across conversations"

echo ""
echo -e "${GREEN}✅ Enhanced MCP server added to Claude Code!${NC}"

# Database setup instructions
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📚 Database Setup${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

if [ "$DOCKER_AVAILABLE" = true ]; then
    echo -e "${GREEN}Option 1: Using Docker (Recommended)${NC}"
    echo -e "Run these commands to start the database:"
    echo ""
    echo -e "${YELLOW}cd $(pwd)${NC}"
    echo -e "${YELLOW}docker-compose up -d postgres redis${NC}"
    echo ""
else
    echo -e "${GREEN}You need to install PostgreSQL and Redis:${NC}"
    echo ""
    echo -e "${YELLOW}macOS:${NC}"
    echo "  brew install postgresql redis"
    echo "  brew services start postgresql"
    echo "  brew services start redis"
    echo ""
    echo -e "${YELLOW}Ubuntu/Debian:${NC}"
    echo "  sudo apt-get install postgresql redis-server"
    echo "  sudo systemctl start postgresql redis"
fi

# AI Configuration
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🤖 AI Configuration${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Add your AI API keys to: $INSTALL_DIR/.env${NC}"
echo ""
echo "Get API keys from:"
echo "  • Gemini: https://aistudio.google.com/apikey"
echo "  • Grok: https://console.x.ai/"
echo "  • OpenAI: https://platform.openai.com/api-keys"
echo "  • DeepSeek: https://platform.deepseek.com/"
echo ""
echo -e "${YELLOW}💡 You don't need all of them! Add only the ones you want to use.${NC}"

# Usage instructions
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🚀 How to Use${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Now when you talk to Claude, other AIs will remember past conversations!"
echo ""
echo "Examples:"
echo '  "Claude, ask Gemini to continue debugging from yesterday"'
echo '  "Have Grok review the changes ChatGPT suggested"'
echo '  "Ask all AIs what they think about this architecture"'
echo ""
echo "To clear context:"
echo '  "Claude, /clear all"      - Clears all AI contexts for this project'
echo '  "Claude, /clear gemini"   - Clears only Gemini context'
echo ""
echo -e "${GREEN}✨ Each project gets its own AI memory, just like Claude Code!${NC}"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Setup complete! Start using context-aware AIs with Claude Code!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
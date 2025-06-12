#!/bin/bash

# MCP AI Collab - Standalone Installation Script

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 MCP AI Collab - Standalone Installation${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create installation directory
INSTALL_DIR="$HOME/.mcp-ai-collab"
echo -e "${BLUE}Creating installation directory...${NC}"
mkdir -p "$INSTALL_DIR"

# Copy necessary files
echo -e "${BLUE}Copying files...${NC}"
cp "$SCRIPT_DIR/src/mcp_standalone.py" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/.env.example" "$INSTALL_DIR/.env.example"

# Create run script
echo -e "${BLUE}Creating run script...${NC}"
cat > "$INSTALL_DIR/run.sh" << 'EOF'
#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load environment variables
if [ -f "$DIR/.env" ]; then
    export $(cat "$DIR/.env" | grep -v '^#' | xargs)
fi

exec python3 "$DIR/mcp_standalone.py" --stdio
EOF

chmod +x "$INSTALL_DIR/run.sh"

# Create .env file if it doesn't exist
if [ ! -f "$INSTALL_DIR/.env" ]; then
    echo -e "${BLUE}Creating .env file...${NC}"
    cat > "$INSTALL_DIR/.env" << 'EOF'
# AI API Keys - Add your keys here
GEMINI_API_KEY=your-gemini-key-here
GROK_API_KEY=your-grok-key-here
OPENAI_API_KEY=your-openai-key-here
DEEPSEEK_API_KEY=your-deepseek-key-here

# Models
GEMINI_MODEL=gemini-2.0-flash
GROK_MODEL=grok-3
OPENAI_MODEL=gpt-4o-mini
DEEPSEEK_MODEL=deepseek-chat
EOF
    echo -e "${YELLOW}⚠️  Please edit $INSTALL_DIR/.env and add your API keys${NC}"
fi

# Install Python dependencies
echo -e "${BLUE}Installing Python dependencies...${NC}"
pip3 install aiohttp

# Add to Claude Code
echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo "To add to Claude Code, run:"
echo -e "${BLUE}claude mcp add mcp-ai-collab \"$INSTALL_DIR/run.sh\" --scope user${NC}"
echo ""
echo "Then restart Claude Code and use:"
echo "- /mcp to verify mcp-ai-collab is listed"
echo "- Ask Claude to use the new tools like 'ask_gemini', 'ask_grok', etc."
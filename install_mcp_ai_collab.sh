#!/bin/bash

# MCP AI Collab - Simple Installation Script

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Installing MCP AI Collab Server${NC}"
echo ""

# Installation directory
INSTALL_DIR="$HOME/.mcp-ai-collab"

# Create directory
echo -e "${BLUE}Creating installation directory...${NC}"
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Copy server file
echo -e "${BLUE}Copying server...${NC}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cp "$SCRIPT_DIR/src/mcp_server_clean.py" "$INSTALL_DIR/server.py"
chmod +x "$INSTALL_DIR/server.py"

# Create .env file from example if it doesn't exist
echo -e "${BLUE}Setting up environment...${NC}"
if [ ! -f "$INSTALL_DIR/.env" ]; then
    # Copy .env.example from script directory
    if [ -f "$SCRIPT_DIR/.env.example" ]; then
        cp "$SCRIPT_DIR/.env.example" "$INSTALL_DIR/.env"
    else
        # Create a minimal .env file if .env.example doesn't exist
        cat > "$INSTALL_DIR/.env" << EOF
# API Keys - ADD YOUR KEYS HERE
GEMINI_API_KEY=your-gemini-api-key-here
GROK_API_KEY=your-grok-api-key-here
OPENAI_API_KEY=your-openai-api-key-here
DEEPSEEK_API_KEY=your-deepseek-api-key-here

# AI Models
GEMINI_MODEL=gemini-2.0-flash
GROK_MODEL=grok-3
OPENAI_MODEL=gpt-4o-mini
DEEPSEEK_MODEL=deepseek-chat
EOF
    fi
    echo -e "${RED}❌ WARNING: No API keys configured!${NC}"
    echo -e "${YELLOW}⚠️  IMPORTANT: Edit $INSTALL_DIR/.env and add your API keys!${NC}"
    echo -e "${YELLOW}   Get your API keys from:${NC}"
    echo -e "${YELLOW}   - Gemini: https://aistudio.google.com/apikey${NC}"
    echo -e "${YELLOW}   - Grok: https://console.x.ai/${NC}"
    echo -e "${YELLOW}   - OpenAI: https://platform.openai.com/api-keys${NC}"
    echo -e "${YELLOW}   - DeepSeek: https://platform.deepseek.com/${NC}"
else
    echo -e "${GREEN}✓ Using existing .env file${NC}"
fi

# Create run script
echo -e "${BLUE}Creating run script...${NC}"
cat > "$INSTALL_DIR/run.sh" << 'EOF'
#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load environment variables
if [ -f "$DIR/.env" ]; then
    set -a
    source "$DIR/.env"
    set +a
fi

# Run the server
exec python3 "$DIR/server.py"
EOF

chmod +x "$INSTALL_DIR/run.sh"

# Install Python dependencies
echo -e "${BLUE}Installing dependencies...${NC}"
pip3 install --quiet google-generativeai openai

# Add to Claude Code
echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo -e "${BLUE}Adding to Claude Code...${NC}"
claude mcp add mcp-ai-collab "$INSTALL_DIR/run.sh" --scope user

echo ""
echo -e "${GREEN}✅ Done! Restart Claude Code and try:${NC}"
echo "1. Use the /mcp command to verify mcp-ai-collab is connected"
echo "2. Try: 'Use ask_gemini to tell me your favorite color'"
echo "3. Then: 'Use ask_gemini to remind me what color you mentioned'"
echo ""
echo "The AIs will now remember conversations per project!"
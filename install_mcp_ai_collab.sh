#!/bin/bash
# Simple installation script for Enhanced MCP Server (Simplified Version)

echo "Installing Simplified Enhanced MCP Server..."
echo "========================================"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "✓ Found Python $PYTHON_VERSION"

# Test if the server works
echo -e "\nTesting server startup..."
timeout 2 python3 "$SCRIPT_DIR/src/main_simple.py" --stdio < /dev/null
if [ $? -eq 124 ]; then
    echo "✓ Server starts correctly"
else
    echo "✗ Server failed to start"
    exit 1
fi

# Create storage directory
mkdir -p ~/.enhanced-mcp/contexts
echo "✓ Created storage directory: ~/.enhanced-mcp/contexts"

# Generate Claude configuration
echo -e "\nGenerating Claude configuration..."
cat << EOF > "$SCRIPT_DIR/claude_config_snippet.json"
{
  "mcpServers": {
    "enhanced-context-simple": {
      "command": "python3",
      "args": [
        "$SCRIPT_DIR/src/main_simple.py",
        "--stdio"
      ],
      "cwd": "$SCRIPT_DIR"
    }
  }
}
EOF

echo "✓ Configuration snippet saved to: claude_config_snippet.json"

# Instructions
echo -e "\n========================================"
echo "Installation complete!"
echo ""
echo "To finish setup, add the following to your Claude config:"
echo "  ~/Library/Application Support/Claude/claude_desktop_config.json"
echo ""
echo "Configuration snippet saved in: claude_config_snippet.json"
echo ""
echo "You can test the server with:"
echo "  python3 $SCRIPT_DIR/test_simple.py"
echo ""
echo "The server will store contexts in:"
echo "  ~/.enhanced-mcp/contexts/{project_name}/{ai_name}.json"
echo "========================================"
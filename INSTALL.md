# Installation Guide - Enhanced MCP Server

This guide will help you set up the Enhanced MCP Server that gives OTHER AIs (Gemini, Grok, ChatGPT, DeepSeek) persistent memory when working with Claude Code.

## 📋 Prerequisites

1. **Python 3.8+** - Check with `python3 --version`
2. **Node.js 16+** - Check with `node --version`
3. **Claude Code CLI** - Must be installed and working
4. **Docker** (optional but recommended) - For database setup
5. **Git** - To clone the repository

## 🚀 Quick Installation (5 minutes)

### Step 1: Clone and Setup

```bash
# Clone the repository
git clone https://github.com/RaiAnsar/claude_code-coding-mcp.git
cd claude_code-coding-mcp

# Run the automated setup
chmod +x setup.sh
./setup.sh
```

The setup script will:
- ✅ Check all prerequisites
- ✅ Install Python and Node dependencies
- ✅ Configure Claude Code integration
- ✅ Create configuration files

### Step 2: Database Setup

#### Option A: Using Docker (Recommended)
```bash
# Start PostgreSQL and Redis
docker-compose up -d postgres redis

# Verify they're running
docker ps
```

#### Option B: Manual Installation

**macOS:**
```bash
brew install postgresql@14 redis
brew services start postgresql@14
brew services start redis
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib redis-server
sudo systemctl start postgresql redis
```

### Step 3: Configure AI API Keys

Edit the `.env` file in the installation directory:

```bash
# Open the environment file
nano ~/.claude-mcp-servers/enhanced-context/.env
```

Add your API keys (you don't need all of them):
```env
# AI API Keys - Add only the ones you have
GEMINI_API_KEY=your_gemini_key_here      # From https://aistudio.google.com/apikey
GROK_API_KEY=your_grok_key_here          # From https://console.x.ai/
OPENAI_API_KEY=your_openai_key_here      # From https://platform.openai.com/api-keys
DEEPSEEK_API_KEY=your_deepseek_key_here  # From https://platform.deepseek.com/
```

### Step 4: Verify Installation

```bash
# Test the MCP server
python3 ~/.claude-mcp-servers/enhanced-context/src/main.py --version

# Check Claude Code configuration
claude mcp list
```

You should see "enhanced-context" in the list of MCP servers.

## 🧪 Testing the Setup

### Test 1: Basic Connection
Open a new terminal and start Claude Code:
```bash
claude
```

Then test:
```
You: /mcp
```

You should see "enhanced-context" listed.

### Test 2: AI Context
Try asking Claude to use another AI:
```
You: Claude, ask Gemini what 2+2 equals
```

If configured correctly, Gemini will respond through Claude.

### Test 3: Context Persistence
1. Ask an AI a question
2. Close Claude Code
3. Reopen Claude Code in the same directory
4. Ask the AI to continue the previous conversation

The AI should remember!

## 🔧 Troubleshooting

### Database Connection Issues

**Error:** "Failed to connect to PostgreSQL"
```bash
# Check if PostgreSQL is running
docker ps | grep postgres
# or
pg_isready

# Check logs
docker logs claude_code-coding-mcp_postgres_1
```

**Error:** "Redis connection failed"
```bash
# Test Redis connection
redis-cli ping
# Should return "PONG"
```

### MCP Server Not Found

**Error:** "MCP server 'enhanced-context' not found"
```bash
# Re-add the server
claude mcp add enhanced-context \
  --command "python3 $HOME/.claude-mcp-servers/enhanced-context/src/main.py --stdio" \
  --scope user

# Restart Claude Code
```

### API Key Issues

**Error:** "API key not configured for [AI_NAME]"
- Make sure you've added the API key to `.env`
- Restart the MCP server after adding keys
- Check key format (no quotes needed in .env)

### Python Dependencies

**Error:** "Module not found"
```bash
cd ~/.claude-mcp-servers/enhanced-context
pip3 install -r requirements.txt --user
```

## 📁 File Locations

- **Installation Directory:** `~/.claude-mcp-servers/enhanced-context/`
- **Configuration:** `~/.claude-mcp-servers/enhanced-context/.env`
- **Logs:** Check Claude Code output or run server manually
- **Database Data:** Docker volumes or system PostgreSQL

## 🔄 Updating

To update to the latest version:
```bash
cd ~/.claude-mcp-servers/enhanced-context
git pull origin main
pip3 install -r requirements.txt --user --upgrade
```

## 🆘 Getting Help

1. Check the [Troubleshooting](#-troubleshooting) section
2. Look at [GitHub Issues](https://github.com/RaiAnsar/claude_code-coding-mcp/issues)
3. Create a new issue with:
   - Your OS and versions (Python, Node, Claude Code)
   - Error messages
   - What you were trying to do

## ✅ Next Steps

Once installed, try these examples:

1. **Multi-AI Collaboration:**
   ```
   "Claude, ask all AIs for their opinion on this code structure"
   ```

2. **Continuing Conversations:**
   ```
   "Claude, have Gemini continue debugging from where we left off"
   ```

3. **Cross-AI Reviews:**
   ```
   "Claude, ask ChatGPT to review the changes Grok suggested"
   ```

Remember: Each project directory maintains its own AI contexts, just like Claude Code!
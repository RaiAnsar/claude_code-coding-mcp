# Enhanced MCP Server - AI Context Bridge 🚀

**Give OTHER AIs persistent memory and context awareness** when working with Claude Code. This server enables Gemini, Grok, ChatGPT, and DeepSeek to remember conversations and maintain project context across sessions!

## 🎯 What This Solves

When Claude talks to other AIs through MCP servers, those AIs have **no memory** of previous interactions. This server gives them persistent memory, just like Claude has!

### Before This Server:
```
You: "Claude, ask Gemini to continue debugging that function from earlier"
Gemini: "What function? I have no previous context..."
```

### With This Server:
```
You: "Claude, ask Gemini to continue debugging that function from earlier"
Gemini: "I see the function we were working on. The issue is on line 42..."
```

## 🚀 Quick Start (One-Click Setup)

```bash
# Clone the repository
git clone https://github.com/yourusername/claude_code-coding-mcp.git
cd claude_code-coding-mcp

# Run the one-click setup
./one_click_setup.sh
```

The setup script will:
1. Check all dependencies
2. Let you choose installation type (Quick/Full/Docker)
3. Guide you through API key configuration
4. Add the server to Claude Code automatically
5. Start any required services

## 📋 Installation Options

### Option 1: Quick Install (Simplest)
No databases required - uses file-based storage
```bash
./install_mcp_ai_collab.sh
```

### Option 2: Full Install (Recommended)
Uses Redis + PostgreSQL for better performance
```bash
./install_full.sh
```

### Option 3: Docker Install (Everything Containerized)
```bash
docker-compose up -d
```

### Option 4: Manual Installation

1. **Prerequisites:**
   - Python 3.8+
   - pip3
   - Claude Code CLI (`claude` command)
   - (Optional) Docker for databases

2. **Clone and Setup:**
   ```bash
   git clone https://github.com/yourusername/claude_code-coding-mcp.git
   cd claude_code-coding-mcp
   
   # Copy environment template
   cp .env.example .env
   
   # Edit .env and add your API keys
   nano .env
   ```

3. **Install Dependencies:**
   ```bash
   pip3 install google-generativeai openai
   
   # For full version also install:
   pip3 install redis asyncpg
   ```

4. **Add to Claude Code:**
   ```bash
   # For quick version:
   claude mcp add mcp-ai-collab "python3 $(pwd)/src/mcp_server_clean.py" --scope user
   
   # For full version:
   claude mcp add mcp-ai-collab "python3 $(pwd)/src/mcp_server_full.py" --scope user
   ```

5. **Start Databases (Full Version Only):**
   ```bash
   docker-compose up -d postgres redis
   ```

## 🔑 API Key Configuration

You'll need API keys for the AIs you want to use. Get them from:

- **Gemini**: https://aistudio.google.com/apikey
- **Grok**: https://console.x.ai/
- **OpenAI**: https://platform.openai.com/api-keys
- **DeepSeek**: https://platform.deepseek.com/

Add your keys to the `.env` file:
```env
GEMINI_API_KEY=your-actual-gemini-key
GROK_API_KEY=your-actual-grok-key
OPENAI_API_KEY=your-actual-openai-key
DEEPSEEK_API_KEY=your-actual-deepseek-key  # Optional
```

**Important:** Never commit your `.env` file with real API keys!

## 🌟 Features

### Core Features
- **Persistent AI Memory** - Each AI remembers all past conversations
- **Project-Based Context** - Separate memory for each project/directory
- **Cross-AI Collaboration** - AIs can build on each other's work
- **Automatic Context Management** - No manual context handling needed

### Available AI Tools

#### Basic Queries
- `ask_gemini` - Ask Google's Gemini a question
- `ask_grok` - Ask X.AI's Grok a question
- `ask_openai` - Ask OpenAI's ChatGPT a question
- `ask_all_ais` - Ask all AIs the same question and compare

#### Code Review & Analysis
- `gemini_code_review` - Get code review from Gemini
- `grok_code_review` - Get code review from Grok
- `openai_code_review` - Get code review from ChatGPT

#### Deep Thinking & Analysis
- `gemini_think_deep` - Extended reasoning with Gemini
- `grok_think_deep` - Extended reasoning with Grok
- `openai_think_deep` - Extended reasoning with ChatGPT

#### Brainstorming
- `gemini_brainstorm` - Creative solutions with Gemini
- `grok_brainstorm` - Creative solutions with Grok
- `openai_brainstorm` - Creative solutions with ChatGPT

#### Debugging
- `gemini_debug` - Debug help from Gemini
- `grok_debug` - Debug help from Grok
- `openai_debug` - Debug help from ChatGPT

#### Architecture & Design
- `gemini_architecture` - Architecture advice from Gemini
- `grok_architecture` - Architecture advice from Grok
- `openai_architecture` - Architecture advice from ChatGPT

#### Collaboration Tools
- `ai_debate` - Have two AIs debate a topic
- `collaborative_solve` - Multiple AIs work together
- `ai_consensus` - Get consensus from all AIs

## 💡 Usage Examples

### Basic Usage
```
You: "Claude, ask Gemini to analyze this function"
You: "Now ask Grok to review Gemini's suggestions"
You: "Have ChatGPT explain why they disagree"
```

### Continuing Previous Work
```
You: "Claude, ask Gemini to continue the refactoring from yesterday"
You: "Show me what Grok suggested last time about the API design"
```

### Multi-AI Collaboration
```
You: "Claude, ask all AIs how to optimize this algorithm"
You: "Have Gemini and Grok debate the best approach"
You: "Get consensus from all AIs on the architecture"
```

## 🏗️ Architecture

### Quick Version (File-Based)
```
Claude Code ←→ MCP Protocol ←→ Enhanced MCP Server
                                      ↓
                              AI Context Manager
                                      ↓
                              File-Based Storage
                               (JSON per project)
```

### Full Version (Database-Backed)
```
Claude Code ←→ MCP Protocol ←→ Enhanced MCP Server
                                      ↓
                              AI Context Manager
                                   ↓     ↓
                              Redis   PostgreSQL
                            (Cache)  (Persistent)
```

## 🔧 Configuration

### Environment Variables
See `.env.example` for all configuration options:

```env
# Database Configuration (Full Version)
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
REDIS_HOST=localhost
REDIS_PORT=6379

# AI Configuration
GEMINI_MODEL=gemini-2.0-flash
GROK_MODEL=grok-3
OPENAI_MODEL=gpt-4o-mini

# Features
ENABLE_DEBUGGING=true
ENABLE_CODE_ANALYSIS=true
```

### Docker Configuration
The `docker-compose.yml` includes:
- PostgreSQL with persistent volume
- Redis with append-only file
- Health checks for all services
- Automatic database initialization

## 🐛 Troubleshooting

### Common Issues

1. **"MCP server not found in Claude Code"**
   - Restart Claude Code after installation
   - Run `claude mcp list` to verify installation

2. **"API key not working"**
   - Check the `.env` file has correct keys
   - Ensure no extra spaces or quotes around keys
   - Verify keys are active on provider dashboards

3. **"Database connection failed"**
   - For Docker: `docker-compose ps` to check status
   - For local: Ensure PostgreSQL/Redis are running
   - Check firewall/port settings

4. **"No context being saved"**
   - Verify you're in a git repository or project folder
   - Check file permissions in installation directory
   - Look at logs in `~/.mcp-ai-collab/logs/`

### Debug Mode
Enable debug logging in `.env`:
```env
LOG_LEVEL=DEBUG
```

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 📊 Performance

- **Context Retrieval**: <100ms average
- **AI Response Time**: Depends on provider (1-5s typical)
- **Memory Usage**: ~50MB base + context size
- **Storage**: ~1MB per 100 conversations

## 🔒 Security

- **API Keys**: Never stored in code, only in `.env`
- **Context Isolation**: Each project has separate context
- **No External Sharing**: All data stays local
- **Encrypted Storage**: Optional encryption for contexts

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- Claude Code team for the MCP protocol
- All AI providers for their APIs
- Contributors and early testers

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/claude_code-coding-mcp/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/claude_code-coding-mcp/discussions)

---

**Made with ❤️ for developers who want ALL their AIs to have memory, not just Claude!**
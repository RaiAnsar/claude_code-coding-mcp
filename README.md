# MCP AI Collab - Persistent Memory for AI Assistants

Give Gemini, Grok, and ChatGPT persistent memory when working with Claude Code. Each AI remembers your conversations per project, just like Claude does.

## What It Does

When you use other AIs through Claude, they normally forget everything between calls. This MCP server fixes that:

- **Before**: "Hey Gemini, what did we discuss earlier?" → "I have no previous context..."
- **After**: "Hey Gemini, what did we discuss earlier?" → "We were debugging the auth function on line 42..."

## Features

- 🧠 **Persistent Memory**: Each AI remembers conversations per project
- 🚀 **Fast Performance**: Redis caching + PostgreSQL storage
- 🔧 **Easy Setup**: One-click installation script
- 🔒 **Secure**: Your API keys stay local, never exposed
- 📁 **Project Isolation**: Each project has separate AI memories

## Quick Start

```bash
# Clone and enter directory
git clone https://github.com/RaiAnsar/claude_code-coding-mcp.git
cd claude_code-coding-mcp

# Run interactive setup
./one_click_setup.sh
```

Choose option 2 for the full Redis/PostgreSQL version, or option 1 for a simpler file-based version.

## Configuration

Add your API keys to `.env`:

```env
GEMINI_API_KEY=your-key-here
GROK_API_KEY=your-key-here  
OPENAI_API_KEY=your-key-here
```

Get API keys from:
- [Google AI Studio](https://makersuite.google.com/app/apikey) (Gemini)
- [X.AI Platform](https://console.x.ai/) (Grok)
- [OpenAI Platform](https://platform.openai.com/api-keys) (ChatGPT)

## Usage

After installation and restarting Claude Code:

```
# Check database status
Use db_status

# Ask AIs with memory
Use ask_gemini to explain this code
Use ask_grok to continue our debugging session
Use ask_openai to review the changes we discussed

# View conversation history
Use show_context with ai "gemini"

# Clear memory
Use clear_context with ai "all"
```

## Requirements

- Python 3.8+
- Docker (for Redis/PostgreSQL version)
- Claude Code with MCP support

## Architecture

```
Claude Code → MCP Protocol → This Server → AI APIs
                                ↓
                        Redis + PostgreSQL
                        (Stores conversations)
```

## License

MIT - See [LICENSE](LICENSE)
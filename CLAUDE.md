# Claude Code Enhanced MCP Server - Project Context

## 🎯 Project Overview
This is an enhanced MCP (Model Context Protocol) server that gives OTHER AIs (Gemini, Grok, ChatGPT, DeepSeek) the same persistent memory that Claude Code already has. The goal is to create a true AI development team where every AI remembers past interactions.

## 🔑 Key Problems We're Solving
1. **Other AIs Have No Memory**: When Claude calls Gemini/Grok/ChatGPT through MCP, they start fresh every time
2. **Lost Context Between Calls**: Each AI request is completely isolated from previous ones
3. **No Shared Project Understanding**: AIs can't build on each other's work
4. **Repeated Analysis**: Same code gets re-analyzed because AIs don't remember
5. **Broken Debugging Sessions**: Can't continue debugging across conversations

## 🏗️ Architecture Decisions

### Context Persistence Strategy
- **Per-AI Context**: Each AI (Gemini, Grok, etc.) gets its own context namespace
- **Hybrid Storage**: Redis for active sessions (fast access) + PostgreSQL for long-term storage
- **Cross-AI Sharing**: Shared project context that all AIs can access
- **Session Continuity**: AI sessions persist across Claude conversations
- **Context Injection**: Automatically inject relevant history when calling any AI

### Technology Stack
- **Backend**: Python (FastAPI) for AI integration + Node.js for real-time features
- **Database**: PostgreSQL (conversations) + Redis (cache) + File System (projects)
- **Protocol**: JSON-RPC over stdio (MCP standard) + REST/WebSocket for extended features
- **Containerization**: Docker + Docker Compose for easy deployment

### Core Components
1. **Context Manager**: Handles all conversation persistence and retrieval
2. **Debug Engine**: Language-agnostic debugging with breakpoints and inspection
3. **Analysis Engine**: Code quality, security, and performance analysis
4. **Project Manager**: Scaffolding, templates, and project state management
5. **Test Framework**: AI-powered test generation and coverage analysis

## 📋 Development Guidelines

### Code Style
- Python: Follow PEP 8 with type hints
- JavaScript/TypeScript: Use ESLint with Airbnb config
- Clear docstrings for all public methods
- Comprehensive error handling with meaningful messages

### Testing Strategy
- Unit tests for all core components (pytest/Jest)
- Integration tests for MCP protocol compliance
- E2E tests for complete workflows
- Performance benchmarks for context retrieval

### Security Considerations
- JWT authentication for API access
- Sandboxed code execution for debugging
- Input validation for all user-provided code
- Rate limiting to prevent abuse

## 🔧 Key Commands & Scripts

```bash
# Development
npm run dev          # Start development server
npm run test         # Run test suite
npm run lint         # Check code quality

# Docker
docker-compose up    # Start all services
docker-compose down  # Stop all services

# Database
npm run db:migrate   # Run database migrations
npm run db:seed      # Seed development data
```

## 🚀 Quick Start for Development

1. **Install Dependencies**:
   ```bash
   npm install
   pip install -r requirements.txt
   ```

2. **Set Up Environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Start Services**:
   ```bash
   docker-compose up -d redis postgres
   npm run dev
   ```

## 📝 Important Context for Claude

### Current Implementation Status
- Basic MCP server structure: Not started
- Context persistence: Not started
- Debugging engine: Not started
- Code analysis: Not started

### User Preferences
- Natural language interaction preferred
- Focus on Python and JavaScript/TypeScript initially
- Integration with VS Code is high priority
- Performance is critical (sub-100ms response times)

### Related Projects
- **claude_code-multi-ai-mcp**: Multi-AI collaboration server (completed)
- **claude_code-gemini-mcp**: Simple Gemini integration (completed)
- This project builds on learnings from both

### Design Principles
1. **Developer First**: Every feature should enhance developer productivity
2. **Context Aware**: Use conversation context to provide smarter suggestions
3. **Extensible**: Plugin architecture for community contributions
4. **Fast**: Performance is a feature - optimize for speed
5. **Reliable**: Comprehensive error handling and recovery

## 🔗 Useful Resources
- [MCP Specification](https://github.com/anthropics/mcp)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Python Debugger Protocol](https://microsoft.github.io/debug-adapter-protocol/)
- [Tree-sitter](https://tree-sitter.github.io/tree-sitter/)

## 🤝 Collaboration Notes
- Use the multi-AI MCP server to get perspectives from Gemini, Grok, and ChatGPT
- Regular code reviews with AI assistance
- Performance profiling after each major feature
- User feedback integration through GitHub issues

## 🎨 Future Vision
This MCP server will become the foundation for next-generation AI-assisted development, where Claude Code can:
- Remember entire project contexts across months
- Debug code in real-time during conversations
- Automatically generate and run tests
- Profile and optimize performance
- Integrate seamlessly with CI/CD pipelines
- Provide intelligent refactoring suggestions based on conversation history

The ultimate goal is to make Claude Code feel like having a senior developer pair programming with you 24/7.
# Claude Code Enhanced MCP Server - Project Context

## 🎯 Project Overview
This is an enhanced MCP (Model Context Protocol) server designed to supercharge Claude Code with advanced development tools and persistent context. The goal is to transform Claude Code from a conversational AI into a full-fledged development companion.

## 🔑 Key Problems We're Solving
1. **Context Loss**: Current MCP implementations lose conversation context between API calls
2. **Limited Developer Tools**: Lack of debugging, profiling, and analysis capabilities
3. **No Project Continuity**: Can't maintain project state across sessions
4. **Manual Integration**: Difficult to integrate with existing development workflows

## 🏗️ Architecture Decisions

### Context Persistence Strategy
- **Hybrid Storage**: Redis for active sessions (fast access) + PostgreSQL for long-term storage
- **Session Management**: UUID-based sessions with automatic context loading
- **Conversation Threading**: Support for multiple conversation branches

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
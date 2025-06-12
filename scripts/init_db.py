#!/usr/bin/env python3
"""
Database initialization script for Enhanced MCP Server
Creates all necessary tables and initial data
"""

import asyncio
import os
import sys
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

import asyncpg
import redis.asyncio as redis
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://mcp_user:mcp_password@localhost:5432/mcp_dev")
REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379")


async def create_database():
    """Create database if it doesn't exist"""
    # Parse database URL
    import urllib.parse
    parsed = urllib.parse.urlparse(DATABASE_URL)
    
    # Connect to default postgres database
    default_url = f"postgresql://{parsed.username}:{parsed.password}@{parsed.hostname}:{parsed.port}/postgres"
    
    try:
        conn = await asyncpg.connect(default_url)
        
        # Check if database exists
        exists = await conn.fetchval(
            "SELECT EXISTS(SELECT 1 FROM pg_database WHERE datname = $1)",
            parsed.path[1:]  # Remove leading /
        )
        
        if not exists:
            print(f"Creating database: {parsed.path[1:]}")
            await conn.execute(f'CREATE DATABASE "{parsed.path[1:]}"')
        else:
            print(f"Database already exists: {parsed.path[1:]}")
            
        await conn.close()
    except Exception as e:
        print(f"Error creating database: {e}")
        print("Make sure PostgreSQL is running and credentials are correct")
        return False
    
    return True


async def init_tables():
    """Initialize all database tables"""
    try:
        # Connect to the database
        pool = await asyncpg.create_pool(DATABASE_URL, min_size=1, max_size=5)
        
        async with pool.acquire() as conn:
            print("Creating tables...")
            
            # Projects table
            await conn.execute("""
                CREATE TABLE IF NOT EXISTS projects (
                    project_id TEXT PRIMARY KEY,
                    project_path TEXT NOT NULL,
                    project_name TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
            print("✓ Created projects table")
            
            # Conversations table
            await conn.execute("""
                CREATE TABLE IF NOT EXISTS conversations (
                    session_id UUID PRIMARY KEY,
                    user_id TEXT,
                    metadata JSONB DEFAULT '{}',
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
            print("✓ Created conversations table")
            
            # Messages table
            await conn.execute("""
                CREATE TABLE IF NOT EXISTS messages (
                    id UUID PRIMARY KEY,
                    session_id UUID REFERENCES conversations(session_id) ON DELETE CASCADE,
                    role TEXT NOT NULL,
                    content TEXT NOT NULL,
                    metadata JSONB DEFAULT '{}',
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
            print("✓ Created messages table")
            
            # AI sessions table
            await conn.execute("""
                CREATE TABLE IF NOT EXISTS ai_sessions (
                    session_id TEXT PRIMARY KEY,
                    project_id TEXT REFERENCES projects(project_id) ON DELETE CASCADE,
                    ai_name TEXT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    cleared BOOLEAN DEFAULT FALSE,
                    UNIQUE(project_id, ai_name)
                )
            """)
            print("✓ Created ai_sessions table")
            
            # Project contexts table
            await conn.execute("""
                CREATE TABLE IF NOT EXISTS project_contexts (
                    session_id UUID PRIMARY KEY REFERENCES conversations(session_id) ON DELETE CASCADE,
                    project_data JSONB NOT NULL,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
            print("✓ Created project_contexts table")
            
            # Clear events table
            await conn.execute("""
                CREATE TABLE IF NOT EXISTS clear_events (
                    id SERIAL PRIMARY KEY,
                    project_id TEXT REFERENCES projects(project_id) ON DELETE CASCADE,
                    ai_name TEXT,
                    cleared_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    cleared_by TEXT
                )
            """)
            print("✓ Created clear_events table")
            
            # Create indexes
            print("\nCreating indexes...")
            await conn.execute("""
                CREATE INDEX IF NOT EXISTS idx_messages_session_id ON messages(session_id)
            """)
            await conn.execute("""
                CREATE INDEX IF NOT EXISTS idx_ai_sessions_project ON ai_sessions(project_id)
            """)
            await conn.execute("""
                CREATE INDEX IF NOT EXISTS idx_messages_timestamp ON messages(timestamp)
            """)
            await conn.execute("""
                CREATE INDEX IF NOT EXISTS idx_projects_last_accessed ON projects(last_accessed)
            """)
            print("✓ Created indexes")
            
        await pool.close()
        print("\n✅ Database initialization complete!")
        return True
        
    except Exception as e:
        print(f"\n❌ Error initializing tables: {e}")
        return False


async def test_redis():
    """Test Redis connection"""
    try:
        print("\nTesting Redis connection...")
        r = await redis.from_url(REDIS_URL)
        await r.ping()
        await r.close()
        print("✅ Redis connection successful!")
        return True
    except Exception as e:
        print(f"❌ Redis connection failed: {e}")
        print("Make sure Redis is running")
        return False


async def main():
    """Main initialization function"""
    print("🚀 Enhanced MCP Server - Database Initialization")
    print("=" * 50)
    
    # Create database
    if not await create_database():
        print("\n❌ Failed to create database. Exiting.")
        sys.exit(1)
    
    # Initialize tables
    if not await init_tables():
        print("\n❌ Failed to initialize tables. Exiting.")
        sys.exit(1)
    
    # Test Redis
    if not await test_redis():
        print("\n⚠️  Redis not available. The server will work but without caching.")
    
    print("\n✨ All set! The Enhanced MCP Server is ready to use.")
    print("\nNext steps:")
    print("1. Add your AI API keys to .env file")
    print("2. Start Claude Code and test with: /mcp")
    print("3. Try: 'Claude, ask Gemini to help with some code'")


if __name__ == "__main__":
    asyncio.run(main())
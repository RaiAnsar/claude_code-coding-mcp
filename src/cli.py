#!/usr/bin/env python3
"""
CLI Management Tool for Enhanced MCP Server
Manage AI contexts, view history, and control the server
"""

import asyncio
import click
import json
import os
import sys
from datetime import datetime
from pathlib import Path
from typing import Optional, List

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent))

from core.context_manager import ContextManager
from core.session_manager import SessionManager
from dotenv import load_dotenv
import asyncpg
import redis.asyncio as redis

# Load environment
load_dotenv()
load_dotenv('.env.local')  # Override with local settings


class MCPManager:
    """Manager for MCP server operations"""
    
    def __init__(self):
        self.context_manager = None
        self.session_manager = None
        
    async def initialize(self):
        """Initialize connections"""
        self.context_manager = ContextManager()
        self.session_manager = SessionManager()
        await self.context_manager.initialize()
        await self.session_manager.initialize()
        
    async def close(self):
        """Close connections"""
        if self.context_manager:
            await self.context_manager.close()
        if self.session_manager:
            await self.session_manager.close()


@click.group()
@click.pass_context
def cli(ctx):
    """Enhanced MCP Server Management CLI"""
    ctx.ensure_object(dict)
    ctx.obj['manager'] = MCPManager()


@cli.command()
@click.option('--project', '-p', default='.', help='Project directory (default: current)')
@click.pass_context
def status(ctx, project):
    """Show status of AI contexts for current project"""
    async def _status():
        manager = ctx.obj['manager']
        await manager.initialize()
        
        project_path = os.path.abspath(project)
        click.echo(f"\n📁 Project: {project_path}")
        click.echo("=" * 60)
        
        # Get project info
        info = await manager.session_manager.get_project_info(project_path)
        
        if not info:
            click.echo("❌ No AI sessions found for this project")
            return
            
        click.echo(f"📊 Project ID: {info['project_id']}")
        click.echo(f"📅 Created: {info['created_at'].strftime('%Y-%m-%d %H:%M:%S')}")
        click.echo(f"🕐 Last Active: {info['last_accessed'].strftime('%Y-%m-%d %H:%M:%S')}")
        click.echo(f"🧹 Total Clears: {info['total_clears']}")
        
        click.echo("\n🤖 AI Sessions:")
        click.echo("-" * 60)
        
        for ai_session in info['ai_sessions']:
            status_icon = "✅" if ai_session['active_sessions'] > 0 else "💤"
            click.echo(f"{status_icon} {ai_session['ai_name'].upper()}")
            click.echo(f"   Sessions: {ai_session['total_sessions']} total, {ai_session['active_sessions']} active")
            if ai_session['last_active']:
                click.echo(f"   Last Active: {ai_session['last_active'].strftime('%Y-%m-%d %H:%M:%S')}")
            
        await manager.close()
    
    asyncio.run(_status())


@cli.command()
@click.option('--project', '-p', default='.', help='Project directory')
@click.option('--ai', '-a', required=True, type=click.Choice(['gemini', 'grok', 'openai', 'deepseek', 'all']), help='AI to show context for')
@click.option('--limit', '-l', default=10, help='Number of messages to show')
@click.pass_context
def show(ctx, project, ai, limit):
    """Show conversation history for an AI"""
    async def _show():
        manager = ctx.obj['manager']
        await manager.initialize()
        
        project_path = os.path.abspath(project)
        
        if ai == 'all':
            ais = ['gemini', 'grok', 'openai', 'deepseek']
        else:
            ais = [ai]
            
        for ai_name in ais:
            click.echo(f"\n🤖 {ai_name.upper()} Context")
            click.echo("=" * 60)
            
            # Get session
            session = await manager.session_manager.get_or_create_session(
                ai_name, project_path, create_if_missing=False
            )
            
            if not session:
                click.echo(f"❌ No context found for {ai_name}")
                continue
                
            # Get context
            context = await manager.context_manager.get_context(session.session_id)
            
            if not context or not context.messages:
                click.echo(f"📭 No messages in context")
                continue
                
            # Show messages
            messages = context.messages[-limit:] if limit else context.messages
            for msg in messages:
                icon = "👤" if msg.role == "user" else "🤖"
                timestamp = msg.timestamp.strftime("%H:%M:%S")
                
                # Truncate long messages
                content = msg.content
                if len(content) > 200:
                    content = content[:200] + "..."
                    
                click.echo(f"\n[{timestamp}] {icon} {msg.role.upper()}")
                click.echo(content)
                
            click.echo(f"\n📊 Total messages: {len(context.messages)}")
            
        await manager.close()
    
    asyncio.run(_show())


@cli.command()
@click.option('--project', '-p', default='.', help='Project directory')
@click.option('--ai', '-a', required=True, type=click.Choice(['gemini', 'grok', 'openai', 'deepseek', 'all']), help='AI to clear')
@click.confirmation_option(prompt='Are you sure you want to clear AI context?')
@click.pass_context
def clear(ctx, project, ai):
    """Clear AI context for current project"""
    async def _clear():
        manager = ctx.obj['manager']
        await manager.initialize()
        
        project_path = os.path.abspath(project)
        
        if ai == 'all':
            await manager.session_manager.clear_all_ai_contexts(project_path)
            click.echo("✅ Cleared all AI contexts for this project")
        else:
            await manager.session_manager.clear_ai_context(ai, project_path)
            click.echo(f"✅ Cleared {ai.upper()} context for this project")
            
        await manager.close()
    
    asyncio.run(_clear())


@cli.command()
@click.pass_context
def list_projects(ctx):
    """List all projects with AI contexts"""
    async def _list():
        manager = ctx.obj['manager']
        await manager.initialize()
        
        # Query database for all projects
        async with manager.session_manager.pg_pool.acquire() as conn:
            rows = await conn.fetch("""
                SELECT p.*, COUNT(DISTINCT a.ai_name) as ai_count
                FROM projects p
                LEFT JOIN ai_sessions a ON p.project_id = a.project_id
                GROUP BY p.project_id, p.project_path, p.project_name, p.created_at, p.last_accessed
                ORDER BY p.last_accessed DESC
                LIMIT 20
            """)
            
        click.echo("\n📁 Projects with AI Contexts")
        click.echo("=" * 80)
        
        for row in rows:
            click.echo(f"\n📂 {row['project_name']}")
            click.echo(f"   Path: {row['project_path']}")
            click.echo(f"   AIs: {row['ai_count']} configured")
            click.echo(f"   Last Active: {row['last_accessed'].strftime('%Y-%m-%d %H:%M:%S')}")
            
        await manager.close()
    
    asyncio.run(_list())


@cli.command()
@click.option('--days', '-d', default=30, help='Delete sessions older than N days')
@click.confirmation_option(prompt='This will permanently delete old sessions. Continue?')
@click.pass_context
def cleanup(ctx, days):
    """Clean up old sessions"""
    async def _cleanup():
        manager = ctx.obj['manager']
        await manager.initialize()
        
        await manager.context_manager.cleanup_old_sessions(days)
        await manager.session_manager.cleanup_inactive_sessions(days * 24)
        
        click.echo(f"✅ Cleaned up sessions older than {days} days")
        
        await manager.close()
    
    asyncio.run(_cleanup())


@cli.command()
@click.pass_context
def test_ais(ctx):
    """Test connectivity to all configured AIs"""
    async def _test():
        from core.ai_router import AIContextRouter
        
        click.echo("\n🧪 Testing AI Connections")
        click.echo("=" * 60)
        
        router = AIContextRouter()
        await router.initialize()
        
        test_prompt = "Say 'Hello from Enhanced MCP Server' and nothing else."
        
        for ai_name, config in router.ai_configs.items():
            click.echo(f"\n🤖 Testing {ai_name.upper()}...")
            
            try:
                result = await router.route_request(
                    ai_name=ai_name,
                    method="ask",
                    params={"prompt": test_prompt}
                )
                
                if "error" in result:
                    click.echo(f"❌ Error: {result['error']}")
                else:
                    click.echo(f"✅ Success! Response: {result.get('content', 'No content')[:100]}")
                    
            except Exception as e:
                click.echo(f"❌ Failed: {str(e)}")
                
        await router.close()
    
    asyncio.run(_test())


@cli.command()
@click.pass_context
def server(ctx):
    """Start the MCP server (for testing)"""
    click.echo("🚀 Starting Enhanced MCP Server...")
    click.echo("Press Ctrl+C to stop")
    
    # Import and run the server
    from main import main
    main()


@cli.group()
def config():
    """Manage configuration"""
    pass


@config.command()
def show_config():
    """Show current configuration"""
    click.echo("\n⚙️  Current Configuration")
    click.echo("=" * 60)
    
    # Show environment variables
    env_vars = [
        "DATABASE_URL",
        "REDIS_URL",
        "GEMINI_API_KEY",
        "GROK_API_KEY", 
        "OPENAI_API_KEY",
        "DEEPSEEK_API_KEY"
    ]
    
    for var in env_vars:
        value = os.getenv(var, "Not set")
        if "API_KEY" in var and value != "Not set":
            # Mask API keys
            value = value[:10] + "..." + value[-4:]
        click.echo(f"{var}: {value}")


@config.command()
@click.option('--ai', '-a', required=True, type=click.Choice(['gemini', 'grok', 'openai', 'deepseek']))
@click.option('--key', '-k', required=True, help='API key')
def set_key(ai, key):
    """Set API key for an AI"""
    env_file = '.env.local'
    
    # Read existing env
    env_vars = {}
    if os.path.exists(env_file):
        with open(env_file, 'r') as f:
            for line in f:
                if '=' in line and not line.startswith('#'):
                    k, v = line.strip().split('=', 1)
                    env_vars[k] = v
    
    # Update key
    key_name = f"{ai.upper()}_API_KEY"
    env_vars[key_name] = key
    
    # Write back
    with open(env_file, 'w') as f:
        for k, v in env_vars.items():
            f.write(f"{k}={v}\n")
    
    click.echo(f"✅ Updated {key_name}")


if __name__ == '__main__':
    cli()
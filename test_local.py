#!/usr/bin/env python3
"""
Local test script to verify AI connections
"""

import asyncio
import os
import sys
from pathlib import Path

# Add src to path
sys.path.insert(0, str(Path(__file__).parent / "src"))

from dotenv import load_dotenv
load_dotenv('.env.local')

from core.ai_router import AIContextRouter
from core.context_manager import ContextManager
from core.session_manager import SessionManager
from core.mcp_protocol import MCPProtocolHandler


async def test_ai_connections():
    """Test direct AI connections"""
    print("🧪 Testing AI Connections\n")
    
    router = AIContextRouter()
    await router.initialize()
    
    # Test each AI
    test_cases = [
        ("gemini", "What is 2+2? Reply with just the number."),
        ("grok", "What is 3+3? Reply with just the number."),
        ("openai", "What is 4+4? Reply with just the number."),
    ]
    
    for ai_name, prompt in test_cases:
        print(f"Testing {ai_name.upper()}...")
        try:
            result = await router.route_request(
                ai_name=ai_name,
                method="ask",
                params={"prompt": prompt}
            )
            
            if "error" in result:
                print(f"❌ {ai_name}: {result['error']}")
            else:
                print(f"✅ {ai_name}: {result.get('content', 'No response')}")
        except Exception as e:
            print(f"❌ {ai_name}: Exception - {str(e)}")
        print()
    
    await router.close()


async def test_context_persistence():
    """Test context persistence across calls"""
    print("\n🧠 Testing Context Persistence\n")
    
    # Initialize services
    context_mgr = ContextManager()
    session_mgr = SessionManager()
    protocol = MCPProtocolHandler()
    router = AIContextRouter()
    
    await context_mgr.initialize()
    await session_mgr.initialize()
    await router.initialize()
    
    project_path = os.getcwd()
    
    # First interaction with Gemini
    print("1️⃣ First call to Gemini...")
    session = await session_mgr.get_or_create_session("gemini", project_path)
    
    # Add context
    await context_mgr.add_message(
        session.session_id,
        "user",
        "My favorite number is 42. Remember this."
    )
    
    # Make request
    result = await router.route_request(
        ai_name="gemini",
        method="ask",
        params={"prompt": "What is my favorite number?"},
        context={"session_id": session.session_id}
    )
    
    print(f"Response: {result.get('content', 'No response')}")
    
    # Store AI response
    await context_mgr.add_message(
        session.session_id,
        "assistant",
        result.get('content', '')
    )
    
    # Second interaction - should remember
    print("\n2️⃣ Second call to Gemini (should remember)...")
    
    # Get context
    context = await context_mgr.get_context(session.session_id)
    
    # Build context-aware request
    context_prompt = "Based on our previous conversation, what number did I mention?"
    if context and context.messages:
        history = "\n".join([f"{m.role}: {m.content}" for m in context.messages])
        context_prompt = f"Previous conversation:\n{history}\n\nNow answer: {context_prompt}"
    
    result2 = await router.route_request(
        ai_name="gemini",
        method="ask",
        params={"prompt": context_prompt}
    )
    
    print(f"Response: {result2.get('content', 'No response')}")
    
    # Clean up
    await context_mgr.close()
    await session_mgr.close()
    await router.close()


async def main():
    """Run all tests"""
    print("🚀 Enhanced MCP Server - Local Testing\n")
    print("=" * 60)
    
    # Test basic connectivity
    await test_ai_connections()
    
    # Test context persistence
    await test_context_persistence()
    
    print("\n✅ Testing complete!")


if __name__ == "__main__":
    asyncio.run(main())
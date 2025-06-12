# Security Policy

## API Key Security

### Never Commit API Keys
- **NEVER** commit real API keys to version control
- Always use environment variables or `.env` files
- The `.env` file is gitignored and should never be committed

### Obtaining API Keys Safely
1. Get API keys directly from official providers:
   - Gemini: https://aistudio.google.com/apikey
   - Grok: https://console.x.ai/
   - OpenAI: https://platform.openai.com/api-keys
   - DeepSeek: https://platform.deepseek.com/

2. Store them only in your local `.env` file
3. Never share API keys in issues, PRs, or discussions

### Protecting Your Keys
- Use environment-specific `.env` files
- Rotate keys regularly
- Monitor API usage on provider dashboards
- Revoke compromised keys immediately

## Reporting Security Issues

If you discover a security vulnerability:

1. **DO NOT** open a public issue
2. Email security concerns to: [maintainer email]
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Security Best Practices

### For Users
- Keep your `.env` file secure and private
- Use strong, unique API keys
- Monitor your API usage
- Update the server regularly

### For Contributors
- Never hardcode credentials
- Always use placeholders in examples
- Test with mock API keys
- Review code for accidental key exposure

## Data Privacy

- All AI conversations are stored locally
- No data is sent to external servers except AI providers
- Context is isolated per project
- Users have full control over their data

## Compliance

This project follows security best practices:
- No hardcoded credentials
- Secure credential storage
- Clear documentation on API key handling
- Regular security updates
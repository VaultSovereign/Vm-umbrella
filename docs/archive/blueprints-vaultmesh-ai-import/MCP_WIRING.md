# VaultMesh MCP Integration Guide

## Overview

This guide shows how to connect VaultMesh to Claude Code via the Model Context Protocol (MCP), enabling direct template execution and ledger querying from your Claude conversations.

## Prerequisites

- VaultMesh installed and built (`npm run build`)
- Claude Code installed
- API key configured (OpenRouter, OpenAI, or Ollama)

## Setup Steps

### 1. Configure Environment Variables

Ensure your API keys are available in your shell:

```bash
# Add to ~/.bashrc, ~/.zshrc, or ~/.profile
export OPENROUTER_API_KEY="sk-or-your-key-here"
export MODEL="meta-llama/llama-3.1-70b-instruct"
export REALITY_LEDGER_COMPACT=1
```

### 2. Create MCP Server Configuration

Create or update `~/.claude/mcp_servers.json`:

```json
{
  "mcpServers": {
    "vaultmesh": {
      "command": "env",
      "args": [
        "MODEL=meta-llama/llama-3.1-70b-instruct",
        "REALITY_LEDGER_COMPACT=1",
        "OPENROUTER_API_KEY=${OPENROUTER_API_KEY}",
        "node",
        "/absolute/path/to/your/forge/dist/mcp/vaultmesh-mcp-server.js"
      ]
    }
  }
}
```

**Important**: Replace `/absolute/path/to/your/forge/` with your actual project path.

### 3. Test MCP Connection

In Claude Code, run:
```
/mcp
```

You should see `vaultmesh` in the connected servers list.

### 4. Test MCP Tools

Try these commands in Claude Code:

```
Use the list_templates tool to show available VaultMesh templates
```

```
Use the run_template tool to execute tem-recon with target "example.org" and depth "shallow"
```

```
Use the ledger_query tool to show the last 3 template executions
```

## Available MCP Tools

### `list_templates`
Lists all available VaultMesh templates with descriptions.

**Parameters**: None

**Example**:
```
Please list all available VaultMesh templates
```

### `run_template`
Executes a VaultMesh template with specified parameters.

**Parameters**:
- `template` (required): Template ID (e.g., "tem-recon", "deck-fintech")
- `profile` (optional): Profile to use ("vault", "blue", "exec") - defaults to "vault"
- `args` (optional): Template arguments as object - defaults to {}
- `format` (optional): Output format ("json", "yaml", "markdown") - defaults to "markdown"

**Example**:
```
Run the deck-fintech template with brief "Dubai DORA compliance check" for founders audience
```

### `ledger_query`
Queries the VaultMesh Reality Ledger for audit records.

**Parameters**:
- `template` (optional): Filter by template ID
- `profile` (optional): Filter by profile
- `since` (optional): ISO 8601 timestamp to filter from
- `limit` (optional): Maximum records to return (default 10)
- `stats` (optional): Return statistics instead of events (default false)

**Examples**:
```
Query the ledger for the last 5 template executions
```

```
Show me ledger statistics
```

```
Query ledger for all tem-recon executions in the last day
```

### `render_report`
Generates compliance reports from ledger events.

**Parameters**:
- `template` (optional): Template ID for aggregate report
- `eventId` (optional): Specific event ID for single report

**Example**:
```
Generate a compliance report for all deck-fintech executions
```

## Troubleshooting

### MCP Server Not Listed
1. Check file path in `mcp_servers.json` is absolute and correct
2. Ensure VaultMesh is built: `npm run build`
3. Verify environment variables are exported
4. Restart Claude Code

### Template Execution Fails
1. Check API key is valid and has credits
2. Verify model name is correct for your provider
3. Check VaultMesh logs for error details
4. Ensure template exists: use `list_templates` first

### Ledger Issues
1. Check `reality_ledger/` directory exists
2. Verify write permissions
3. Check disk space

### Environment Variables Not Found
1. Make sure variables are exported in your shell profile
2. Restart terminal and Claude Code
3. Test with: `echo $OPENROUTER_API_KEY`

## Security Considerations

### API Key Safety
- ✅ Store keys in environment variables only
- ✅ Never commit keys to version control
- ✅ Use MCP environment variable substitution
- ❌ Never hardcode keys in MCP config files

### Template Safety
- All templates run with built-in guardrails
- Read-only operations by default
- Schema validation on all outputs
- Complete audit trail in Reality Ledger

### Network Security
- MCP server runs locally only
- No external network access required for core operation
- API calls only to configured LLM providers

## Advanced Usage

### Custom Profiles
Create custom profiles in `/profiles/` directory:

```yaml
# profiles/mycompany.yaml
voice: "MyCompany Compliance Officer - precise, regulatory-focused"
defaults:
  output_format: json
  footer: "- MyCompany Internal Use Only"
```

Use with: `run_template template="dora.ict_risk" profile="mycompany"`

### Template Development
Add custom templates in `/catalog/` subdirectories following the YAML schema. See existing templates for examples.

### Reality Ledger Integration
All template executions are automatically logged. Use programmatic access via CLI:

```bash
vm ledger query --template deck-fintech --limit 10
vm ledger verify <event-id>
```

## Support

- Architecture: `/docs/ARCHITECTURE.md`
- Schema Reference: `/docs/SCHEMAS.md`
- Pricing: `/docs/FINTECH_PRICING.md`
- Quick Start: `/docs/QUICKSTART.md`

**VaultMesh - Earth's Civilization Ledger**
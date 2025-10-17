# VaultMesh Quickstart Guide

## Installation & Setup

### 1. Install Dependencies

```bash
pnpm install
```

### 2. Configure Environment

```bash
cp .env.example .env
# Edit .env with your API keys:
```

#### Choose ONE provider

```env
# OpenRouter (recommended)
OPENROUTER_API_KEY=sk-or-...
MODEL=meta-llama/llama-3.1-70b-instruct

# OR OpenAI
# OPENAI_API_KEY=sk-...
# MODEL=gpt-4o-mini

# OR Local Ollama
# OLLAMA_HOST=http://localhost:11434
# MODEL=llama3.1:70b
```

### 3. Build

```bash
pnpm run build
```

## Quick Examples

### CLI Usage

#### Run a Template

```bash
# Reconnaissance
vm run tem-recon -p blue -a '{"target":"example.org","depth":"shallow"}'

# DORA Compliance Deck
vm run deck-fintech -a '{"brief":"Dubai DORA compliance check","audience":"founders"}'

# Guardrails Check
vm run tem-guardrails -p blue -a '{"agent":"Copilot","permissions_matrix":"./examples/iso27001.yaml"}'
```

#### Query Reality Ledger

```bash
# List recent events
vm ledger query --limit 5

# Filter by template
vm ledger query --template tem-recon --limit 3

# Verify an event
vm ledger verify a1b2c3d4-e5f6-7890-abcd-ef1234567890

# Show statistics
vm ledger stats
```

### CLI Diagnostics & Scaffolding

#### Run Health Checks

```bash
vm doctor
```

#### Scaffold a New Template

```bash
vm scaffold template tem.new_clause
```

### MCP Integration (Claude Code)

#### Setup MCP Server

Add the server entry to `~/.claude/mcp_servers.json`:

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
        "/absolute/path/to/forge/dist/mcp/vaultmesh-mcp-server.js"
      ]
    }
  }
}
```

Then in Claude Code, run `/mcp` to verify the connection.

#### Use MCP Tools

- `list_templates` - Show all available templates
- `run_template` - Execute template with parameters
- `ledger_query` - Query audit trail
- `render_report` - Generate compliance reports

## Templates Available

### DORA Compliance (Coming Soon)

- `dora.ict_risk` - ICT Risk Management Framework
- `dora.tprm` - Third-Party Risk Management
- `dora.incident` - Incident Reporting
- `dora.resilience` - Operational Resilience Testing

### Cybersecurity Audits (Coming Soon)

- `cyber.iso27001` - ISO 27001 Compliance
- `cyber.pci_dss` - PCI DSS Assessment
- `cyber.swift_csp` - SWIFT CSP Compliance

### Current Templates

- `tem-recon` - Passive reconnaissance
- `tem-guardrails` - Agent permission analysis
- `deck-fintech` - FinTech pitch decks
- `tem-vision` - Visual analysis (experimental)
- `tem-sonic` - Audio analysis (experimental)

## Safety & Compliance

### Built-in Guardrails

- **Read-only by default** - Templates cannot execute harmful actions
- **Schema validation** - All outputs validated against JSON schemas
- **Audit trail** - Every execution logged to Reality Ledger
- **Content addressing** - Cryptographic hashes for integrity

### Reality Ledger

Every template execution creates an immutable audit record:

- **Content-addressed IDs** - SHA-256 hashes
- **Timestamped entries** - ISO 8601 timestamps
- **Verifiable events** - Hash validation support
- **Replayable operations** - Full input/output capture

## Pilot Docker Runbook

Build and run the Forge container with a mounted ledger and outputs folder. Replace the API key with your own secret before running.

```bash
docker build -t vaultmesh/forge:1.0.0 .
docker run --rm \
  -e MODEL="meta-llama/llama-3.1-70b-instruct" \
  -e OPENROUTER_API_KEY="${OPENROUTER_API_KEY}" \
  -e REALITY_LEDGER_COMPACT=1 \
  -v "$PWD/outputs:/app/outputs" \
  -v "$PWD/reality_ledger:/app/reality_ledger" \
  vaultmesh/forge:1.0.0 \
  vm run --template dora.ict_risk_framework.v1 --args '{"org_name":"AcmeBank","critical_functions":["Payments"],"threat_scenarios":["DDoS"]}'
```

Artifacts will be written to `outputs/AcmeBank/...` and a signed receipt will be appended to `reality_ledger/events-*.jsonl`.

## One-Week Readiness Checklist

- [ ] MCP `list_templates` responds in under 200ms; invalid args return Zod validation errors.
- [ ] Reality Ledger tamper test fails verification; Ed25519 signatures verify when keys are configured.
- [ ] `dora.ict_risk_framework.v1` and `cyber.iso_27001.checker.v1` emit `report.md` and `controls_register.json` artifacts.
- [ ] CI passes type/lint/test/audit steps and uploads the SBOM artifact.
- [ ] Container image builds, Trivy scan reports no high/critical vulnerabilities, and the demo command completes successfully.
- [ ] A new engineer can follow this Quickstart end-to-end without additional context.

## Next Steps

1. **Run your first template**: `vm run tem-recon -a '{"target":"example.org"}'`
2. **Check the ledger**: `vm ledger query --limit 1`
3. **Connect to Claude Code**: Follow MCP integration steps
4. **Explore templates**: `vm list_templates` via MCP

## Getting Help

- Architecture: See `/docs/ARCHITECTURE.md`
- Schemas: See `/docs/SCHEMAS.md`
- Pricing: See `/docs/FINTECH_PRICING.md`
- MCP Setup: See `/docs/MCP_WIRING.md`

### VaultMesh - Earth's Civilization Ledger

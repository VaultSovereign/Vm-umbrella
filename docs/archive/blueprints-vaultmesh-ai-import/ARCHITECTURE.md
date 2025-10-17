# VaultMesh Architecture

## Overview

VaultMesh is a **sovereign prompt orchestration platform** designed as "Earth's Civilization Ledger" for financial services compliance and cybersecurity operations.

## Core Components

### 1. Dispatcher (`/dispatcher/`)
**Purpose**: Template execution engine with safety guardrails

- `router.ts` - Main execution router and template resolution
- `safety.ts` - Safety preflight checks and guardrails enforcement
- `expander.ts` - Template variable expansion (Handlebars-like)
- `ensureConforms.ts` - Schema validation and auto-repair
- `modelProvider.ts` - Multi-provider LLM integration (OpenAI, OpenRouter, Ollama)
- `types.ts` - TypeScript interfaces and types

### 2. Reality Ledger (`/reality_ledger/`)
**Purpose**: Immutable audit trail for all template executions

- `reality_ledger.py` - Core ledger operations and event storage
- `realityLedger.ts` - Node.js adapter for TypeScript integration
- `ledger.schema.json` - JSON Schema for event validation
- `events-YYYY-MM-DD.jsonl` - Daily sharded event logs
- `events-YYYY-MM-DD.idx` - Index files for deduplication

### 3. Template Catalog (`/catalog/`)
**Purpose**: Structured prompt templates with metadata

```
catalog/
├── tem/           # TEM (remembrance) templates
├── dora/          # DORA compliance templates
├── cyber/         # Cybersecurity audit templates
└── deck/          # Business presentation templates
```

### 4. CLI Interface (`/cli/`)
**Purpose**: Command-line interface for template execution

- `index.ts` - Main CLI entry point (target for `vm` command)
- `forge.ts` - Legacy forge interface

### 5. MCP Server (`/mcp/`)
**Purpose**: Model Context Protocol integration with Claude Code

- `vaultmesh-mcp-server.ts` - MCP server implementation
- Tools: `list_templates`, `run_template`, `ledger_query`

## Data Flow

```
1. User executes: vm run --template dora.ict_risk --profile @vault --args {...}
2. CLI validates inputs and calls dispatcher/router.ts
3. Router loads template from catalog/ and profile from profiles/
4. Safety preflight checks run (safety.ts)
5. Template expanded with variables (expander.ts)
6. LLM called via modelProvider.ts
7. Output validated against schema (ensureConforms.ts)
8. Event logged to Reality Ledger with hash
9. Result returned to user
```

## Security Model

### Template Safety
- **Guardrails**: Mandatory safety checks before LLM execution
- **Schema Validation**: Strict input/output validation with auto-repair
- **Sandboxing**: Templates cannot execute arbitrary code
- **Audit Trail**: Every execution logged immutably

### Secrets Management
- **Environment Variables**: All API keys in `.env` files only
- **No Hardcoding**: Zero secrets in code or configuration files
- **MCP Security**: Environment variable substitution in MCP configs

### Reality Ledger Integrity
- **Content Addressing**: SHA-256 hashes for all events
- **Optional Signatures**: Ed25519 signatures for verification
- **Immutability**: Append-only event logs
- **Deduplication**: Index-based duplicate prevention

## Extensibility

### Adding Templates
1. Create YAML template in appropriate `/catalog/` subdirectory
2. Define input schema and validation rules
3. Add output schema to `/schemas/output.schema.json`
4. Test with golden snapshots

### Adding Providers
1. Extend `modelProvider.ts` with new provider
2. Add environment variable configuration
3. Update `.env.example` with provider settings

### MCP Extensions
1. Add new tools to `vaultmesh-mcp-server.ts`
2. Update tool list and input schemas
3. Wire to existing dispatcher functions

## Performance Considerations

- **Caching**: Template and schema caching for repeated executions
- **Sharding**: Daily event log sharding for scalable storage
- **Streaming**: Large outputs can be streamed to reduce memory usage
- **Concurrency**: Async/await pattern throughout for non-blocking operations

## Visual Workbench (Planned)
The VaultMesh Visual Workbench introduces a sovereign, auditable UI that layers on top of the dispatcher and Reality Ledger.

- Reference architecture, security posture, and implementation roadmap are documented in `docs/WORKBENCH.md`.
- Workbench will integrate with existing guardrails and reuse dispatcher/ledger logic via the upcoming `@vaultmesh/ai-core` package.
- Status tracking and outstanding tasks are maintained in the Workbench document to keep the CLI and visual pathways aligned.

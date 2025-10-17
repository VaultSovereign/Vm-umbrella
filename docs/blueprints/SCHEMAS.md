# VaultMesh Schema Reference

## Overview

VaultMesh uses JSON Schema for strict validation of all inputs, outputs, and events.

## Core Schemas

### 1. Prompt Schema (`/schemas/prompt.schema.json`)

Validates template definition files (YAML):

```json
{
  "required": ["id", "version", "keyword", "purpose", "inputs", "prompt", "outputs"],
  "properties": {
    "id": {"type": "string"},
    "version": {"type": "string"},
    "keyword": {"type": "string"},
    "purpose": {"type": "string"},
    "inputs": {"type": "object"},
    "prompt": {
      "type": "object",
      "required": ["system", "user"]
    },
    "outputs": {
      "type": "object",
      "properties": {
        "schema_ref": {"type": "string"}
      }
    }
  }
}
```

### 2. Output Schema (`/schemas/output.schema.json`)

Validates template execution results:

#### DORA Templates
- `#/definitions/dora/ict_risk` - ICT Risk Management Framework
- `#/definitions/dora/tprm` - Third-Party Risk Management
- `#/definitions/dora/incident` - Incident Reporting
- `#/definitions/dora/resilience` - Operational Resilience Testing

#### Cybersecurity Templates
- `#/definitions/cyber/iso27001` - ISO 27001 Compliance
- `#/definitions/cyber/pci_dss` - PCI DSS Assessment
- `#/definitions/cyber/swift_csp` - SWIFT CSP Compliance
- `#/definitions/cyber/pci_dss_misconfiguration_checker` - PCI DSS Misconfiguration Checker

#### TEM Templates
- `#/definitions/tem/recon` - Reconnaissance
- `#/definitions/tem_advanced/vision` - Visual Analysis
- `#/definitions/tem_advanced/sonic` - Audio Analysis

### 3. Ledger Schema (`/reality_ledger/ledger.schema.json`)

Validates Reality Ledger events:

```json
{
  "required": ["id", "ts", "template", "profile", "input", "output", "hash"],
  "properties": {
    "id": {"type": "string", "pattern": "UUID v4"},
    "ts": {"type": "string", "format": "date-time"},
    "template": {"type": "string"},
    "profile": {"type": "string"},
    "input": {"type": "object"},
    "output": {"type": "object"},
    "hash": {"type": "string", "pattern": "SHA-256 hex"},
    "sig": {"type": "string", "pattern": "Ed25519 signature"}
  }
}
```

## Template Input Patterns

### Common Input Types

```yaml
inputs:
  # Required string
  org_name: {type: string, required: true}

  # Enum with default
  depth: {type: enum, values: [shallow, moderate, deep], default: moderate}

  # Array of strings
  critical_functions: {type: array, items: {type: string}}

  # Optional object
  metadata: {type: object, required: false}
```

### Output Format Control

All templates support:
```yaml
output_format: {type: enum, values: [json, yaml, markdown], default: json}
```

## Schema Validation Flow

1. **Template Load**: Validate template YAML against `prompt.schema.json`
2. **Input Validation**: Validate user inputs against template's input schema
3. **Output Validation**: Validate LLM output against referenced output schema
4. **Auto-Repair**: If validation fails, attempt single repair pass
5. **Event Logging**: Validate event against `ledger.schema.json` before storage

## Schema References

Templates reference output schemas using JSON Pointer syntax:

```yaml
outputs:
  schema_ref: "../schemas/output.schema.json#/definitions/dora/ict_risk"
```

## Extending Schemas

### Adding New Output Schema

1. Add definition to `/schemas/output.schema.json`:
```json
"definitions": {
  "my_category": {
    "my_template": {
      "type": "object",
      "required": ["summary", "confidence_scores"],
      "properties": {
        "summary": {"type": "string"},
        "confidence_scores": {"type": "object"}
      }
    }
  }
}
```

2. Reference in template:
```yaml
outputs:
  schema_ref: "../schemas/output.schema.json#/definitions/my_category/my_template"
```

### Schema Evolution

- **Backward Compatible**: Add optional fields only
- **Breaking Changes**: Increment schema version in path
- **Validation**: Test all existing templates after schema changes

## Common Patterns

### Confidence Scoring
All templates should include:
```json
"confidence_scores": {
  "type": "object",
  "properties": {
    "overall": {"type": "number", "minimum": 0, "maximum": 1},
    "per_section": {"type": "object"}
  }
}
```

### Error Handling
Failed validations return:
```json
{
  "error": "Schema validation failed",
  "validation_errors": [...],
  "attempted_repair": "..."
}
```

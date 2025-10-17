# Support & SLAs (Pilot)

**Channels**
- Email: support@vaultmesh.org (business hours, Mon–Fri)
- Security: security@vaultmesh.org (24×7 for critical)

**Targets (Pilot)**
- P1 (system down / data at risk): response 2h, update 4h
- P2 (degraded / failed run): response 8h, update 1d
- P3 (how‑to / feature): response 2d

**Escalation**
1. Support queue (email)
2. On‑call engineering for P1/P2
3. Product owner for prioritization

**Runbooks**
- **Workbench**: `/v1/api/health`, `/health/deep`, ledger verify
- **CLI**: `vm doctor --json --skip-provider`, `vm ledger verify <id>`
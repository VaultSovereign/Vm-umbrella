# VaultMesh Pilot Runbook - DIFC/Dublin One-Week Readiness

## Objective

Deploy VaultMesh in a financial services organization to demonstrate DORA readiness and compliance posture within 7 days.

## Pre-Pilot Requirements

### Technical Prerequisites
- [ ] Node.js 18+ installed
- [ ] API access to LLM provider (OpenRouter recommended)
- [ ] Network access for API calls
- [ ] 1GB+ available disk space
- [ ] Basic command line proficiency

### Organizational Prerequisites
- [ ] Executive sponsor identified
- [ ] Compliance officer engaged
- [ ] IT security team briefed
- [ ] Sample use cases defined (2-3 templates minimum)

## Phase 1: Foundation (Day 1)

### Setup & Installation
```bash
# 1. Clone and install
git clone <repo-url> vaultmesh
cd vaultmesh
npm install

# 2. Configure environment
cp .env.example .env
# Edit .env with API keys

# 3. Build and test
npm run build
node dist/cli/index.js --help
```

### Acceptance Criteria - Day 1
- [ ] VaultMesh builds without errors
- [ ] CLI responds to `--help`
- [ ] Environment variables configured
- [ ] Basic template execution works: `vm run tem-recon`

## Phase 2: Integration (Days 2-3)

### MCP Setup
```bash
# 1. Configure Claude Code integration
vim ~/.claude/mcp_servers.json
# Add VaultMesh server configuration

# 2. Test MCP connection
# In Claude Code: /mcp
```

### Reality Ledger Validation
```bash
# 1. Run test executions
vm run deck-fintech -a '{"brief":"test pilot","audience":"founders"}'
vm run tem-guardrails -a '{"agent":"test"}'

# 2. Verify ledger integrity
vm ledger stats
vm ledger query --limit 5
```

### Acceptance Criteria - Day 3
- [ ] MCP server connected in Claude Code
- [ ] Can execute templates via Claude Code
- [ ] Reality Ledger capturing all events
- [ ] Ledger verification working
- [ ] Hash integrity confirmed

## Phase 3: Business Validation (Days 4-5)

### Use Case Testing

**Use Case 1: DORA ICT Risk Assessment**
- [ ] Execute `dora.ict_risk` template (when available)
- [ ] Generate compliance report
- [ ] Review with compliance officer
- [ ] Validate against internal controls

**Use Case 2: Third-Party Risk Management**
- [ ] Execute `dora.tprm` template (when available)
- [ ] Test vendor assessment workflow
- [ ] Compare with existing TPRM process
- [ ] Validate completeness

**Use Case 3: Incident Response Preparation**
- [ ] Execute `dora.incident` template (when available)
- [ ] Generate incident reporting framework
- [ ] Review with security team
- [ ] Test reporting workflow

### Current Template Testing (v1.0)
```bash
# Test available templates
vm run tem-recon -a '{"target":"internal-test.local","depth":"shallow"}'
vm run deck-fintech -a '{"brief":"DORA compliance project","audience":"c-suite"}'
vm run tem-guardrails -a '{"agent":"Internal Copilot","permissions_matrix":"./examples/iso27001.yaml"}'
```

### Acceptance Criteria - Day 5
- [ ] 3 business use cases tested
- [ ] Compliance officer approval on output quality
- [ ] Security team approval on audit trail
- [ ] Templates produce business-ready outputs
- [ ] Confidence scores meet threshold (>0.7)

## Phase 4: Production Readiness (Days 6-7)

### Security Validation
```bash
# 1. Audit dependencies
npm audit --production

# 2. Validate secrets management
# Ensure no keys in code/config
grep -r "sk-" . --exclude-dir=node_modules || echo "No secrets found"

# 3. Test access controls
# Verify templates cannot execute harmful actions
```

### Performance Testing
```bash
# 1. Measure execution time
time vm run tem-recon -a '{"target":"example.org","depth":"moderate"}'

# 2. Concurrent execution test
for i in {1..5}; do
  vm run deck-fintech -a "{\"brief\":\"test-$i\",\"audience\":\"founders\"}" &
done
wait

# 3. Ledger performance
time vm ledger query --limit 100
```

### Documentation Review
- [ ] Architecture documentation complete
- [ ] Security policies documented
- [ ] Recovery procedures defined
- [ ] User training materials prepared

### Acceptance Criteria - Day 7
- [ ] Security review passed
- [ ] Performance benchmarks met (<3s P95)
- [ ] Documentation complete
- [ ] Rollback plan prepared
- [ ] Go-live approval obtained

## Success Criteria

### Technical Success
- [ ] Zero critical security vulnerabilities
- [ ] 100% template execution success rate
- [ ] Reality Ledger integrity verified
- [ ] MCP integration stable
- [ ] Performance targets met

### Business Success
- [ ] Compliance officer sign-off
- [ ] Security team approval
- [ ] Executive sponsor endorsement
- [ ] 3 validated use cases
- [ ] ROI projection completed

### Operational Success
- [ ] Support processes defined
- [ ] Monitoring configured
- [ ] Backup/recovery tested
- [ ] User training completed
- [ ] Change management approved

## Rollback Criteria

**Immediate Rollback Required If:**
- Critical security vulnerability discovered
- Data integrity compromised
- Regulatory compliance questioned
- Executive directive to halt

**Rollback Procedure:**
1. Stop all template executions
2. Preserve Reality Ledger for audit
3. Revert MCP configuration
4. Document lessons learned
5. Schedule post-mortem

## Risk Mitigation

### Technical Risks
- **API Rate Limits**: Configure multiple providers
- **Schema Validation Failures**: Enable auto-repair mode
- **Disk Space**: Configure log rotation
- **Network Issues**: Test offline mode capabilities

### Business Risks
- **Compliance Concerns**: Engage legal team early
- **User Adoption**: Provide comprehensive training
- **Integration Complexity**: Phase rollout by department
- **Change Resistance**: Demonstrate clear value

## Success Metrics

### Quantitative
- Template execution time: <3 seconds P95
- Ledger verification: 100% success rate
- MCP uptime: >99.9%
- User task completion: <5 minutes average

### Qualitative
- Compliance officer confidence: High
- Security team comfort: High
- User satisfaction: >8/10
- Executive endorsement: Strong

## Post-Pilot Actions

### If Successful
1. Schedule production deployment
2. Expand to additional use cases
3. Plan user training rollout
4. Define operational procedures
5. Create success case study

### If Partial Success
1. Address identified gaps
2. Extend pilot duration
3. Refine use cases
4. Additional stakeholder engagement
5. Risk mitigation planning

### If Unsuccessful
1. Document failure reasons
2. Preserve lessons learned
3. Consider alternative approaches
4. Stakeholder communication plan
5. Future evaluation timeline

---

**Pilot Contact**: VaultMesh Support Team
**Escalation**: Executive Sponsor
**Documentation**: All pilot activities logged to Reality Ledger

**VaultMesh - Earth's Civilization Ledger**
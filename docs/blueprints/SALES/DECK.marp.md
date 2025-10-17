---
marp: true
title: VaultMesh AI — Sovereign Compliance Automation
paginate: true
theme: default
footer: 'VaultMesh · Earth’s Civilization Ledger'
---

<!-- _class: lead -->

# VaultMesh AI  
## Sovereign Compliance Automation

**Earth’s Civilization Ledger**  
DORA‑grade compliance automation with immutable audit receipts  
**For:** CIO • CISO • Head of Compliance  
**CTA:** Pilot in 1 week • security@vaultmesh.org

::: notes
Set the tone: we automate high‑stakes compliance while preserving sovereignty.
Agenda: why VaultMesh, how it works, verifiable evidence, one‑week pilot path.
:::

---

## Problem — Compliance at War with Velocity

- Manual audits → weeks of effort, fragmented evidence  
- Expensive external assessments with low reusability  
- AI sprawl: secrets risk, unverifiable outputs, no audit trail  
- Regulators (e.g., DORA) demand **evidence**, not slides

::: notes
Emphasize cost, time, and repeatability pains.
Core crux: proofs must be verifiable and replayable, not anecdotal.
:::

---

## Solution — Sovereign, Verifiable Automation

- **Sovereign by design:** your infra; your keys, your data  
- **Security as a feature:** strict guardrails; no secrets in browser  
- **Reality Ledger:** immutable JSON receipts (hashes, optional signatures)  
- **Templates:** DORA ICT Risk, TPRM, secrets hygiene, container security

::: notes
We’re a platform (not a point tool): consistent guardrails and evidence.
Every action is ledgered—success **and** failure—for complete auditability.
:::

---

## How It Works — From Evidence to Signed Report

- **Inputs:** evidence paths, questionnaires, config  
- **Execution:** schema‑validated prompts under guardrails  
- **Streaming logs:** real‑time SSE to the Workbench  
- **Outputs:** structured report + ledger receipt (+ optional signature)

Browser (SPA) → BFF (OIDC/RBAC, SSE) → Core (gRPC)
↘ Reality Ledger (source of truth)

::: notes
Walk one run lifecycle. Outputs are machine‑readable and verifiable offline.
:::

---

## Templates & Mappings — What You Can Run Today

- **DORA ICT Risk** (policy/controls/evidence checks)  
- **TPRM (Third‑Party Risk)**: DDQ + evidence synthesis + acceptance logic  
- **Secrets Hygiene**: code/config leakage review  
- **Container/CI**: Dockerfile + pipeline hardening (advisory)  
- Framework alignment: NIST / ISO / OWASP (per template)

::: notes
Show that templates map to buyers’ control families.
Each run emits reviewer‑friendly artifacts (see ARTIFACTS.md).
:::

---

## Live Preview — Run → Stream → Verify

- Start `dora.tprm.v1` with evidence paths  
- Watch logs stream (SSE)  
- Open ledger event → verify hash/signature  
- Download JSON report for reviewers

::: notes
Narrate: real‑time visibility, deterministic outputs, zero “black box” steps.
Tie back to audit: every field in the report has provenance in the ledger.
:::

---

## ROI & Pricing — Illustrative Business Case

- Replace weeks of manual collation with repeatable runs  
- **Anchors:** Ops €299–€499/yr; DORA €7K–€24K/yr  
- **Bundles:** €30K–€300K/yr, by scope  
- Typical pilot: production‑quality report in 1 week

::: notes
Keep numbers illustrative. Emphasize repeatability and lower marginal cost.
Enterprise bundles = predictable spend + internalized knowledge.
:::

---

## Security & Trust — Built for High‑Stakes Environments

- No secrets in browser; provider keys only server‑side  
- OIDC + RBAC; deny‑by‑default guardrails  
- Reality Ledger: content‑addressed, optional signing  
- CI gates: secrets/code/container scans; nightly metrics

::: notes
This is **AI under controls** you can show auditors.
Point to CI artifacts and ARTIFACTS.md as the due‑diligence packet.
:::

---

## Implementation — One‑Week Pilot Plan

- **Day 1–2:** connect evidence, choose templates, dry run  
- **Day 3–4:** calibrate findings, finalize acceptance thresholds  
- **Day 5:** sign‑off run, ledger receipt, stakeholder readout  
- **Success:** zero critical gaps, repeatable runbook, documented ledger proof

::: notes
Clarify roles (your team vs ours), data boundaries, and exit artifacts.
Outcome: real report + auditable ledger trail.
:::

---

## Call to Action — Start Your Pilot

- Pick templates (DORA ICT Risk, TPRM)  
- Provide evidence paths & DDQ (if any)  
- Schedule kickoff (60 min)  
- **security@vaultmesh.org** • vaultmesh.org

::: notes
Reiterate outcomes and propose three pilot dates.
:::
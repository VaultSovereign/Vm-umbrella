# VaultMesh Sales Deck Outline (10 Slides)

---

## 1) Cover — VaultMesh AI: Sovereign Compliance Automation

**On slide**
*	Tagline: Earth’s Civilization Ledger
*	What we do: DORA‑grade compliance automation with immutable audit receipts
*	Who for: Financial services (CIO • CISO • Head of Compliance)
*	CTA: Pilot in 1 week • security@vaultmesh.org

**Visual**
*	Simple brand lockup + 1‑line value prop
*	(Optional) CI “forge‑prepush” badge + “Nightly Security” badge

**Speaker notes (≈45s)**
*	Set the tone: we automate high‑stakes compliance while preserving sovereignty.
*	Today: why VaultMesh, how it works, evidence you can trust, and a one‑week pilot path.

---

## 2) Problem — Compliance at War with Velocity

**On slide**
*	Manual audits → weeks of effort, fragmented evidence
*	Expensive external assessments with low reusability
*	AI sprawl risk: secrets, unverifiable outputs, no audit trail
*	Regulators (e.g., DORA) demand evidence, not slides

**Visual**
*	“As‑is” flow: people → spreadsheets → PDFs → findings (lots of icons/arrows)

**Speaker notes (≈60s)**
*	Emphasize cost, time, and repeatability pains.
*	The crux: proofs must be verifiable and replayable, not anecdotal.

---

## 3) Solution — Sovereign, Verifiable Automation

**On slide**
*	Sovereign by design: run it on your infra; your keys, your data
*	Security as a feature: strict guardrails; no secrets in browser
*	Reality Ledger: immutable JSON receipts (hashes, optional signatures)
*	Templates: DORA ICT Risk, TPRM, secrets hygiene, container security

**Visual**
*	Three‑pillar graphic (Sovereignty • Security • Verifiability) with Reality Ledger at the base

**Speaker notes (≈60s)**
*	Position VaultMesh as a platform (not a point tool): consistent guardrails, consistent evidence.
*	Every action is ledgered—success and failure—for complete auditability.

---

## 4) How It Works — From Evidence to Signed Report

**On slide**
*	Inputs: evidence paths, questionnaires, config
*	Execution: schema‑validated prompts under guardrails
*	Streaming logs: real‑time SSE to the Workbench
*	Outputs: structured report + ledger receipt (+ optional signature)

**Visual**
*	Simplified architecture: SPA → BFF → Core → Providers • Reality Ledger (as source of truth)

**Speaker notes (≈75s)**
*	Walk through a single run lifecycle.
*	Stress that outputs are machine‑readable and verifiable offline.

---

## 5) Templates & Mappings — What You Can Run Today

**On slide**
*	DORA ICT Risk (policy/controls/evidence checks)
*	TPRM (Third‑Party Risk): DDQ + evidence synthesis + acceptance logic
*	Secrets Hygiene: code/config leakage review
*	Container/CI: Dockerfile and pipeline hardening (advisory)
*	Framework alignment: NIST/ISO/OWASP (as applicable per template)

**Visual**
*	Template cards with 1‑line benefits + “mapped controls” badges

**Speaker notes (≈60s)**
*	Focus on regulated buyers: show that templates map to their control families.
*	Call out that each run emits artifacts reviewers can download (see ARTIFACTS.md).

---

## 6) Live Preview — Run → Stream → Verify

**On slide**
*	Start dora.tprm.v1 with evidence paths
*	Watch logs stream (SSE)
*	Open ledger event → verify hash/signature
*	Download JSON report for reviewers

**Visual**
*	Two screenshots: (a) Workbench console with logs, (b) Ledger event detail

**Speaker notes (≈90s)**
*	Narrate the experience: real‑time visibility, deterministic outputs, and zero “black box” steps.
*	Tie back to audit: every field in the report has provenance.

---

## 7) ROI & Pricing — Illustrative Business Case

**On slide**
*	Replace weeks of manual collation with repeatable runs
*	Pricing anchors: Ops templates €299–€499/yr; DORA templates €7K–€24K/yr
*	Bundles: €30K–€300K/yr depending on scope
*	Typical pilot: production‑quality report in 1 week

**Visual**
*	Simple table: “Manual vs VaultMesh” (effort, cycle time, reusability)

**Speaker notes (≈60s)**
*	Keep numbers illustrative (no promises). Emphasize repeatability and lower marginal cost per assessment.
*	For enterprise bundles, highlight predictable spend and internalization of knowledge.

---

## 8) Security & Trust — Designed for High‑Stakes Environments

**On slide**
*	No secrets in browser; egress keys resolved server‑side
*	RBAC & OIDC ready; deny‑by‑default guardrails
*	Reality Ledger: content‑addressed, optional signing
*	CI gates: secrets/code/container scans; nightly metrics

**Visual**
*	Shield icon + bullets; small diagram: browser ↛ providers (blocked), only BFF/Core

**Speaker notes (≈75s)**
*	This is not “AI at any cost.” It’s AI within controls you can show to auditors.
*	Mention CI artifacts and ARTIFACTS.md as your due‑diligence packet.

---

## 9) Implementation — One‑Week Pilot Plan

**On slide**
*	Day 1–2: connect evidence, choose templates, dry run
*	Day 3–4: calibrate findings, finalize acceptance thresholds
*	Day 5: sign‑off run, ledger receipt, stakeholder readout
*	Success criteria: zero critical gaps, repeatable runbook, documented ledger proof

**Visual**
*	Timeline with 3 milestones (Connect • Calibrate • Certify)

**Speaker notes (≈60s)**
*	Clarify roles (your team vs ours) and data boundary expectations.
*	Promise: buyer walks away with a real report + audit trail.

---

## 10) Call to Action — Start Your Pilot

**On slide**
*	Pick templates (DORA ICT Risk, TPRM)
*	Provide evidence paths & DDQ (if any)
*	Schedule pilot kickoff (60 min)
*	Contact: security@vaultmesh.org • vaultmesh.org

**Visual**
*	Clean CTA with QR/URL; short checklist

**Speaker notes (≈45s)**
*	Reiterate outcomes: verifiable report, ledger receipts, and a predictable ramp to production.
*	Invite questions; propose 3 pilot dates.

---

## Appendix (optional)
*	A1: Detailed Architecture (BFF, SSE, gRPC, Ledger)
*	A2: Control Mapping Examples (DORA → template checks)
*	A3: Evidence Artifacts (JSON snippets + how to verify)
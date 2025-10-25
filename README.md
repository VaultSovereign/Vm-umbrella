[![Shared Release CI](https://github.com/VaultSovereign/vm-umbrella/actions/workflows/shared-release.yml/badge.svg)](https://github.com/VaultSovereign/vm-umbrella/actions/workflows/shared-release.yml)

**Current CI Baseline:** `v0.1.0` — Rubedo Phase

# 🜔 vm-umbrella — VaultMesh Law & Governance

This repository is the **constitutional brain** of VaultMesh:
- Signs and seals releases (SHA3-256 + optional RFC-3161).
- Hosts governance docs & codex pointers.
- Coordinates multi-repo CI/CD policy.

**Start here:** see [`START_HERE.md`](./START_HERE.md)

## LawChain Outputs
- `UMBRELLA_SEAL.json` — canonical hash + timestamp of governance corpus
- GitHub Actions artifacts — CI proofs per commit/PR

## Repos (canonical leafs)
- Mesh (Rust core) → vm-mesh
- Forge (TypeScript workbench) → vm-forge
- Ops (prompts/guardrails/MCP tools) → vm-ops
- Infra DNS → vm-infra-dns
- Infra Servers → vm-infra-srv
- Meta (publishing) → vm-meta
- Shared CLI utils → vm-cmd

## Quick start
```bash
git clone <this-repo> vm-umbrella && cd vm-umbrella
make init      # installs pre-commit hooks
make bootstrap # adds submodules from REPO_MAP.md (SSH)
make status    # shows submodule SHAs, remotes, toolchains
```

## Principles
- No history churn. This umbrella only references leaf repos.
- Minimal duplication. Docs/code live in their canonical leafs.
- Standards everywhere. Shared linters, CI, submodule hygiene.

## Related / External
- vaultmesh-ai — GTM blueprints & marketing collateral
  Source: https://github.com/VaultSovereign/vaultmesh-ai
  Concepts borrowed: release CI, security checks, one-pager docs.

## Blueprints
See docs/blueprints/INDEX.md for imported GTM materials.

## API Bootstrap (GitHub)
Use the provided scripts to create and configure repos via GitHub API.

Requirements: export GITHUB_TOKEN with repo/workflow (and admin:org for org-wide changes).

Examples:

- Create the umbrella repo under your org (public by default):
  make gh:create-umbrella ORG=VaultSovereign REPO=vm-umbrella VIS=public

- Configure Actions on the umbrella repo (allow all actions, write perms):
  make gh:configure-umbrella ORG=VaultSovereign REPO=vm-umbrella

- Push this local repo upstream:
  make gh:push-umbrella ORG=VaultSovereign REPO=vm-umbrella

- Wire a leaf project to reuse the umbrella workflow:
  make gh:wire-leaf ORG=VaultSovereign LEAF=vm-forge UMBRELLA=vm-umbrella BRANCH=main

- Wire common leaves (vm-forge, vm-ops, vm-mesh, vm-infra-dns, vm-infra-srv, vm-meta):
  make gh:wire-all ORG=VaultSovereign UMBRELLA=vm-umbrella BRANCH=main

- (Org admins) Set org-wide Actions defaults:
  bash scripts/gh_configure_org_actions.sh VaultSovereign

## Related Repos
- vaultmesh-ai (blueprint + GTM collateral): https://github.com/VaultSovereign/vaultmesh-ai
  - We keep it separate. We borrow useful concepts (CI, Pages, artifact docs) into this umbrella via templates.

## Borrowed Concepts (from vaultmesh-ai)
- CI gates templates (lint/test/build across JS/TS, Python, Rust)
- GitHub Pages workflow for docs publishing
- Release workflow skeleton (semver tags + artifacts)
- Nightly security checks (dependency audit, basic scanners)
- ARTIFACTS.md pattern to explain CI outputs

See `templates/workflows/*.yml` and `docs/ARTIFACTS.md`. Use `scripts/adopt_templates.sh <submodule-dir>` to copy into a leaf repo.

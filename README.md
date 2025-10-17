# vm-umbrella — VaultMesh Master Umbrella

This repo is a pure coordinator. It pins canonical leaf projects as submodules under a single workspace.

Why vm-? Neutral naming, clean convergence for multiple families without “old” labels or history rewrites.

## Repos (canonical leafs)
- Mesh (Rust core) → vaultmesh-mesh (or VaultMesh; switchable)
- Forge (TypeScript workbench) → forge
- Ops (prompts/guardrails/MCP tools) → ops
- Infra DNS → infra-dns
- Infra Servers → infra-servers
- Meta (publishing) → meta
- Shared CLI utils → cmd

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

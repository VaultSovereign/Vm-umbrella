# 🜄 START HERE — vm-umbrella (Law & Governance)

## What this is
The **constitutional layer** of VaultMesh: CI/CD policy, governance docs, codex pointers, and cryptographic proofs of release.

## How it fits
- **Upstream:** none (root of law)
- **Downstream:** vm-spawn (deploy), vm-codex (doctrine), vm-mesh (runtime)

## Quick commands
```bash
make seal        # hash governance corpus → UMBRELLA_SEAL.json
make verify      # recompute & check seal
make anchor      # optional: RFC-3161 timestamp; push proof to artifacts
```

## Repos in orbit

| Layer      | Repository       | Role                                  |
|------------|------------------|---------------------------------------|
| Doctrine   | vm-codex         | Canonical codices (Salt & Sulfur, Governance) |
| Deployment | vm-spawn         | Epoch/Genesis jobs, charts            |
| Network    | vm-mesh          | Federation, CRDT, Ψ-field             |
| Portal     | vaultmesh-site   | Public docs & dashboards              |

**Mantra:** Proof is sacred. Intelligence serves truth. Evolution is measured.

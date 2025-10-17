# VaultMesh - Pre-Push Forge Checklist (Full Repo)

> Run from repo root. All steps are mandatory unless marked optional.
> Fast mode: set `FORGE_FAST=1` to skip heavy scans.

## A. Grounding And Hygiene

- [ ] Git status clean (no stray changes)

  ```bash
  git update-index -q --refresh && git diff --quiet && git diff --cached --quiet
  ```

- [ ] Node and Python toolchains present

  ```bash
  node -v && pnpm -v && python3 --version
  ```

## B. Build Integrity

- [ ] Install dependencies (lockfile respected)

  ```bash
  pnpm install --frozen-lockfile
  ```

- [ ] Typecheck, lint, format

  ```bash
  pnpm run typecheck
  pnpm run lint
  pnpm run format
  ```

- [ ] Unit tests (with coverage)

  ```bash
  pnpm test
  ```

## C. Forge Health

- [ ] Build

  ```bash
  pnpm run build
  ```

- [ ] VM doctor (env and ledger basics)

  ```bash
  node dist/cli/index.js doctor
  ```
  Note: set `FORGE_SKIP_DOCTOR=1` to bypass this check when provider credentials are not configured.

## D. Security Gates (Full Repo, No Exclusions)

- [ ] Secrets gate (hard fail on critical)

  ```bash
  ts-node scripts/pre_scan/secrets_scan.ts > /tmp/pre_secrets.json
  ts-node scripts/pre_scan/collect_changed_files.ts > /tmp/pre_changed.json
  node dist/cli/index.js run \
    cyber-secrets-audit \
    --args "$(jq -nc '{repo_context:"prepush", files_index:(.files), findings_raw:(input), changed_only:(.changed_only)}' /tmp/pre_changed.json /tmp/pre_secrets.json)" \
    | tee /tmp/secrets_out.json
  test "$(jq '.result.summary.critical // 0' /tmp/secrets_out.json)" -eq 0
  ```

- [ ] Code security review (fail on high)

  ```bash
  node dist/cli/index.js run \
    cyber-code-security-reviewer \
    --args "$(jq -nc '{repo_context:"prepush", diffs_or_files:(.files), prescan:{secrets: input}}' /tmp/pre_changed.json /tmp/pre_secrets.json)" \
    | tee /tmp/review_out.json
  test "$(jq '.result.summary.high // 0' /tmp/review_out.json)" -eq 0
  ```
  Note: set `FORGE_SKIP_REMOTE_SCANS=1` when provider credentials (OPENAI_API_KEY, OPENROUTER_API_KEY, or OLLAMA_HOST) are unavailable.

## E. Supply Chain And Container (Optional In Fast Mode)

- [ ] SBOM generated

  ```bash
  pnpm run sbom
  ```

- [ ] Container advisory scan

  ```bash
  ts-node scripts/pre_scan/docker_scan.ts > /tmp/pre_docker.json
  node dist/cli/index.js run cyber-container-security-scanner \
    --args @/tmp/pre_docker.json > /tmp/container_out.json
  ```
  Note: set `FORGE_SKIP_REMOTE_SCANS=1` to skip when provider credentials are not available.

## F. Compliance Snapshot (Advisory)

- [ ] Compliance gaps JSON generated

  ```bash
  jq -nc '{ current_controls: { ci:{ tests:true, secrets_gate:true }, ledger:{ hashing:"sha256", signature:"ed25519?" } }, target_frameworks:["NIST 800-53","OWASP ASVS"] }' \
    > /tmp/gaps.json
  node dist/cli/index.js run cyber-compliance-gap-analyzer \
    --args @/tmp/gaps.json > /tmp/gaps_out.json
  ```
  Note: set `FORGE_SKIP_REMOTE_SCANS=1` to skip when provider credentials are not available.

## G. Artifacts (Commit Or Archive)

- [ ] Save artifacts

  ```bash
  mkdir -p artifacts/prepush
  cp -f /tmp/*_out.json artifacts/prepush/ 2>/dev/null || true
  cp -f sbom.json artifacts/prepush/ 2>/dev/null || true
  ```

---

### Pass Criteria

- Secrets audit: critical = 0
- Code security review: high = 0
- Build, tests, typecheck, lint all succeed
- Optional container and compliance steps may warn but are skipped when `FORGE_FAST=1`

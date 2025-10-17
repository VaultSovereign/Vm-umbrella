#!/usr/bin/env bash
set -euo pipefail

# Collect logs for failed GitHub Actions runs across repos
# - Uses gh API if authenticated (best), falls back to curl for public repos
# - Downloads run logs (ZIP) for runs with conclusion in {failure, timed_out, action_required, cancelled}
#
# Usage:
#   ./scripts/gh_collect_failed_logs.sh \
#     --owner VaultSovereign \
#     --repos vm-umbrella,vm-forge,vm-ops \
#     --limit 20 \
#     --out logs/actions

OWNER=""
REPOS=(vm-umbrella)
LIMIT=20
OUT_DIR="logs/actions"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --owner) OWNER="$2"; shift 2;;
    --repos) IFS=',' read -r -a REPOS <<< "$2"; shift 2;;
    --limit) LIMIT="$2"; shift 2;;
    --out) OUT_DIR="$2"; shift 2;;
    --help|-h)
      echo "Usage: $0 --owner <ORG|USER> [--repos a,b,c] [--limit N] [--out dir]"; exit 0;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

if [[ -z "$OWNER" ]]; then
  echo "--owner is required (e.g., VaultSovereign)" >&2; exit 2
fi

mkdir -p "$OUT_DIR"

has_gh=0; gh --version >/dev/null 2>&1 && has_gh=1 || true
authed=0; if [[ $has_gh -eq 1 ]] && gh auth status >/dev/null 2>&1; then authed=1; fi

echo "Owner: $OWNER | Limit: $LIMIT | Out: $OUT_DIR | gh: $has_gh authed: $authed"

fail_set='failure|timed_out|action_required|cancelled'

for r in "${REPOS[@]}"; do
  echo "=== $OWNER/$r ==="
  runs_json=""
  if [[ $authed -eq 1 ]]; then
    runs_json=$(gh api -X GET "repos/$OWNER/$r/actions/runs?per_page=$LIMIT" 2>/dev/null || echo '')
  else
    runs_json=$(curl -s "https://api.github.com/repos/$OWNER/$r/actions/runs?per_page=$LIMIT" || echo '')
  fi
  if [[ -z "$runs_json" ]] || echo "$runs_json" | grep -q '"status":\s*"404"'; then
    echo "(no runs or no access)"; continue
  fi
  # Extract failing run IDs and metadata
  ids=( $(printf '%s' "$runs_json" | jq -r \
    --arg re "$fail_set" \
    '.workflow_runs[] | select((.conclusion // "") | test($re)) | .id') )
  if [[ ${#ids[@]} -eq 0 ]]; then
    echo "No failing runs in last $LIMIT."; continue
  fi
  echo "Failing runs: ${#ids[@]}"
  for id in "${ids[@]}"; do
    dest="$OUT_DIR/$OWNER-$r-run-$id-logs.zip"
    # Download logs as ZIP
    if [[ $authed -eq 1 ]]; then
      gh api -H "Accept: application/zip" -X GET "repos/$OWNER/$r/actions/runs/$id/logs" -o "$dest" || echo "(failed to download logs for $id)"
    else
      curl -L -s -H "Accept: application/zip" -o "$dest" "https://api.github.com/repos/$OWNER/$r/actions/runs/$id/logs" || echo "(failed to download logs for $id)"
    fi
    if [[ -s "$dest" ]]; then
      echo "→ saved: $dest"
    else
      rm -f "$dest" 2>/dev/null || true
      echo "(no log data for $id)"
    fi
  done
done

echo "Done. Logs (if any) under: $OUT_DIR"

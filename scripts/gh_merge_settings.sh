#!/usr/bin/env bash
set -euo pipefail

# Audit and optionally configure merge-related settings for repos.
# Uses GitHub REST API with $GITHUB_TOKEN.
#
# Usage:
#   GITHUB_TOKEN=... ./scripts/gh_merge_settings.sh --owner VaultSovereign --repos vm-forge,vm-ops --audit
#   GITHUB_TOKEN=... ./scripts/gh_merge_settings.sh --owner VaultSovereign --repos vm-mesh --apply
#
# Applies (when --apply):
#   - allow_auto_merge: true
#   - delete_branch_on_merge: true
#   - merge strategies: allow_squash_merge=true, allow_merge_commit=false, allow_rebase_merge=true

OWNER=""
REPOS=(vm-forge vm-ops vm-mesh vm-infra-dns vm-infra-srv vm-meta vm-umbrella)
DEFAULT_BRANCH="main"
MODE="audit" # or apply

while [[ $# -gt 0 ]]; do
  case "$1" in
    --owner) OWNER="$2"; shift 2 ;;
    --repos) IFS=',' read -r -a REPOS <<< "$2"; shift 2 ;;
    --branch) DEFAULT_BRANCH="$2"; shift 2 ;;
    --apply) MODE="apply"; shift ;;
    --audit) MODE="audit"; shift ;;
    --help|-h)
      echo "Usage: $0 --owner <ORG|USER> [--repos a,b,c] [--branch main] [--apply|--audit]"; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "GITHUB_TOKEN is required in env" >&2; exit 2
fi
if [[ -z "$OWNER" ]]; then
  echo "--owner is required (e.g., VaultSovereign)" >&2; exit 2
fi

API="https://api.github.com"
HDR=( -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" )

echo "Owner: $OWNER"; echo "Repos: ${REPOS[*]}"; echo "Mode: $MODE"; echo

for r in "${REPOS[@]}"; do
  echo "=== $OWNER/$r ==="
  # Repo settings
  curl -sS "${API}/repos/${OWNER}/${r}" "${HDR[@]}" \
    | jq '{
        name:.name,
        private:.private,
        default_branch:.default_branch,
        allow_auto_merge:.allow_auto_merge,
        delete_branch_on_merge:.delete_branch_on_merge,
        allow_squash_merge:.allow_squash_merge,
        allow_merge_commit:.allow_merge_commit,
        allow_rebase_merge:.allow_rebase_merge
      }'

  # Branch protection (best-effort)
  curl -sS "${API}/repos/${OWNER}/${r}/branches/${DEFAULT_BRANCH}/protection" "${HDR[@]}" \
    | jq '{required_status_checks:(.required_status_checks.contexts // []), enforce_admins, required_pull_request_reviews:(.required_pull_request_reviews // null)}' 2>/dev/null || echo "(no branch protection info)"

  if [[ "$MODE" = "apply" ]]; then
    echo "Applying merge settings…"
    payload=$(jq -n '{allow_auto_merge:true, delete_branch_on_merge:true, allow_squash_merge:true, allow_merge_commit:false, allow_rebase_merge:true}')
    curl -sS -X PATCH "${API}/repos/${OWNER}/${r}" "${HDR[@]}" -d "$payload" >/dev/null || echo "(failed to patch settings)"
    echo "✓ applied"
  fi
  echo
done

echo "Done."

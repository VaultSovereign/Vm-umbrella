#!/usr/bin/env bash
set -euo pipefail

# VaultMesh CI lattice audit/fix helper
# - Audits Actions/Workflow permissions, branch protection checks, and recent runs
# - Optionally applies standard settings to enable reusable workflows from vm-umbrella
#
# Requirements:
#   - GitHub CLI (gh) authenticated: `gh auth login`
#   - jq (for output formatting)
#
# Usage examples:
#   ./scripts/gh_audit_and_fix.sh --owner VaultSovereign \
#     --repos vm-forge,vm-ops,vm-mesh,vm-infra-dns,vm-infra-srv,vm-meta,vm-umbrella
#
#   # Apply fixes (enable reuse + write perms + branch checks)
#   ./scripts/gh_audit_and_fix.sh --owner VaultSovereign --fix \
#     --repos vm-forge,vm-ops,vm-mesh,vm-infra-dns,vm-infra-srv,vm-meta,vm-umbrella
#
#   # Include security check in branch protection
#   ./scripts/gh_audit_and_fix.sh --owner VaultSovereign --fix --with-security \
#     --repos vm-forge,vm-ops

OWNER=""
REPOS=(vm-forge vm-ops vm-mesh vm-infra-dns vm-infra-srv vm-meta vm-umbrella)
BRANCH="main"
WITH_SECURITY=0
DO_FIX=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --owner) OWNER="$2"; shift 2;;
    --repos) IFS=',' read -r -a REPOS <<< "$2"; shift 2;;
    --branch) BRANCH="$2"; shift 2;;
    --with-security) WITH_SECURITY=1; shift;;
    --fix) DO_FIX=1; shift;;
    --help|-h)
      echo "Usage: $0 --owner <ORG|USER> [--repos a,b,c] [--branch main] [--with-security] [--fix]";
      exit 0;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

if [[ -z "$OWNER" ]]; then
  echo "--owner is required (e.g., --owner VaultSovereign)" >&2; exit 2
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "gh CLI is not authenticated. Run: gh auth login" >&2; exit 2
fi

echo "Owner: $OWNER"
echo "Repos: ${REPOS[*]}"
echo "Branch: $BRANCH  | with-security: $WITH_SECURITY  | fix: $DO_FIX"
echo

audit_repo() {
  local repo="$1"
  echo "=== $OWNER/$repo ==="
  echo "- Actions perms:"
  gh api "repos/$OWNER/$repo/actions/permissions" \
    --jq '{enabled:.enabled, allowed:.allowed_actions}' || echo "(no access)"

  echo "- Workflow perms:"
  gh api "repos/$OWNER/$repo/actions/permissions/workflow" \
    --jq '{can_approve:.can_approve_pull_request_reviews, default:.default_workflow_permissions}' || echo "(no access)"

  echo "- Latest workflow runs:"
  gh run list -R "$OWNER/$repo" -L 3 --json databaseId,name,conclusion,headBranch,url 2>/dev/null \
    | jq -r '.[] | "\(.name)  \(.conclusion)  \(.headBranch)  \(.url)"' || echo "(no runs)"

  echo "- Branch protection ($BRANCH):"
  gh api "repos/$OWNER/$repo/branches/$BRANCH/protection" 2>/dev/null \
    --jq '{enforce_admins, contexts:(.required_status_checks.contexts // [])}' || echo "No protection"
  echo
}

fix_repo() {
  local repo="$1"
  echo ">>> Fixing $OWNER/$repo"

  # Allow all actions (incl. reuse)
  gh api -X PUT "repos/$OWNER/$repo/actions/permissions" \
    -f enabled=true -f allowed_actions=all >/dev/null

  # Workflow permissions: write
  gh api -X PUT "repos/$OWNER/$repo/actions/permissions/workflow" \
    -f default_workflow_permissions=write \
    -f can_approve_pull_request_reviews=true >/dev/null

  # Branch protection with required checks
  local args=(
    -X PUT "repos/$OWNER/$repo/branches/$BRANCH/protection"
    -H "Accept: application/vnd.github+json"
    -f required_status_checks.strict=true
    -f required_status_checks.contexts[]="reuse-shared-release"
    -f required_status_checks.contexts[]="reuse-shared-lint"
    -F enforce_admins=true
    -F required_pull_request_reviews.dismiss_stale_reviews=true
    -F restrictions=null
  )
  if [[ $WITH_SECURITY -eq 1 ]]; then
    args+=( -f required_status_checks.contexts[]="reuse-shared-security" )
  fi
  gh api "${args[@]}" >/dev/null || true

  echo "✓ $repo configured"
}

echo "--- AUDIT BEFORE ---"
for r in "${REPOS[@]}"; do audit_repo "$r"; done

if [[ $DO_FIX -eq 1 ]]; then
  echo "--- APPLYING FIXES ---"
  for r in "${REPOS[@]}"; do fix_repo "$r"; done
  echo
  echo "--- AUDIT AFTER ---"
  for r in "${REPOS[@]}"; do audit_repo "$r"; done
fi

echo "Done."

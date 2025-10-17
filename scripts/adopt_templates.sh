#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <submodule-dir> [--dry-run]" >&2
  exit 2
fi

TARGET="$1"; shift || true
DRY=0; [ "${1:-}" = "--dry-run" ] && DRY=1

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TPL_DIR="$ROOT/templates/workflows"
DEST="$ROOT/$TARGET/.github/workflows"

if [ ! -d "$ROOT/$TARGET" ]; then
  echo "Target not found: $TARGET (expected under $ROOT)" >&2
  exit 1
fi

echo "Adopting workflow templates into $TARGET (.github/workflows)"
echo "Templates: $TPL_DIR"
echo "Dest     : $DEST"

[ $DRY -eq 1 ] || mkdir -p "$DEST"
for f in "$TPL_DIR"/*.yml; do
  base="$(basename "$f")"
  echo "• copy $base"
  if [ $DRY -eq 0 ]; then
    cp "$f" "$DEST/$base"
  fi
done

echo "Done. Review and tweak repo-specific steps as needed."


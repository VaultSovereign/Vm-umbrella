#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

if [ ! -d .git ]; then
  echo "• initializing git repo in $root"
  git init >/dev/null
fi

# Parse REPO_MAP.md lines that look like: "- vm-name => ssh-url"
lines=()
while IFS= read -r line; do
  lines+=("$line")
done < <(awk '/^\-/ && $3=="=>" {print $2" "$4}' "$root/REPO_MAP.md")

if [ ${#lines[@]} -eq 0 ]; then
  echo "No entries found in REPO_MAP.md"; exit 1
fi

for line in "${lines[@]}"; do
  name="$(awk '{print $1}' <<< "$line")"
  url="$(awk '{print $2}' <<< "$line")"
  path="$name"

  if [ -d "$root/$path/.git" ]; then
    echo "• submodule exists: $path"
    continue
  fi

  echo "• adding submodule: $path  ->  $url"
  git submodule add --force "$url" "$path" || true
done

echo "• pin shared cmd usage (if present)"
if [ -d "$root/vm-forge" ]; then
  pushd "$root/vm-forge" >/dev/null
  if [ ! -f .gitmodules ] || ! grep -q 'tools/cmd' .gitmodules; then
    cmd_url=$(awk '/^\-\s*vm-cmd/ && $3=="=>" {print $4}' "$root/REPO_MAP.md" | head -n1)
    if [ -n "$cmd_url" ]; then
      echo "[vm] forge: creating .gitmodules for tools/cmd"
      printf "[submodule \"tools/cmd\"]\n\tpath = tools/cmd\n\turl = %s\n" "$cmd_url" > .gitmodules
    fi
  fi
  git submodule sync --recursive || true
  git submodule update --init --recursive || true
  popd >/dev/null
fi

# Ensure vm-ops also has tools/cmd if referenced
if [ -d "$root/vm-ops" ]; then
  pushd "$root/vm-ops" >/dev/null
  if [ -d tools ] && git ls-files -s tools 2>/dev/null | grep -q '\stools/cmd$'; then
    if [ ! -f .gitmodules ] || ! grep -q 'tools/cmd' .gitmodules; then
      cmd_url=$(awk '/^\-\s*vm-cmd/ && $3=="=>" {print $4}' "$root/REPO_MAP.md" | head -n1)
      if [ -n "$cmd_url" ]; then
        echo "[vm] ops: creating .gitmodules for tools/cmd"
        printf "[submodule \"tools/cmd\"]\n\tpath = tools/cmd\n\turl = %s\n\tbranch = main\n" "$cmd_url" > .gitmodules
      fi
    fi
  fi
  git submodule sync --recursive || true
  git submodule update --init --recursive || true
  popd >/dev/null
fi

echo "• syncing and initializing recursively"
git submodule sync --recursive || true
git submodule update --init --recursive || true

echo "• done"

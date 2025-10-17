#!/usr/bin/env bash
set -euo pipefail

echo "== vm umbrella status =="
echo "model: gpt-5 (reasoning-high)"
echo "repo : $(basename "$(git rev-parse --show-toplevel)")"
echo

echo "== toolchains =="
echo -n "rust   : "; (rustc --version 2>/dev/null || echo "n/a")
echo -n "node   : "; (node -v 2>/dev/null || echo "n/a")
echo -n "pnpm   : "; (pnpm -v 2>/dev/null || echo "n/a")
echo -n "python : "; (python3 --version 2>/dev/null || python --version 2>/dev/null || echo "n/a")
echo

echo "== submodules (top) =="
git submodule status || true
echo
echo "== submodules (recursive remotes) =="
git submodule foreach --recursive 'echo "$name -> $(git remote get-url origin 2>/dev/null)"'


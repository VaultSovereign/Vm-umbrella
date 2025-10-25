#!/usr/bin/env bash
set -euo pipefail
SEAL="${1:-UMBRELLA_SEAL.json}"
OUT="UMBRELLA_SEAL.tsr"
if ! command -v openssl >/dev/null; then
  echo "openssl not found; skipping RFC-3161"; exit 0
fi
ROOT=$(jq -r .root_sha3_256 "$SEAL" 2>/dev/null || python3 - <<'PY'
import json,sys; print(json.load(open(sys.argv[1]))["root_sha3_256"])
PY
"$SEAL")
echo -n "$ROOT" | xxd -r -p > seal.bin
openssl ts -query -sha256 -data seal.bin -cert -no_nonce -out seal.tsq
if [[ -n "${TSA_URL:-}" ]]; then
  curl -sS -H "Content-Type: application/timestamp-query" --data-binary @seal.tsq "$TSA_URL" > "$OUT" || true
  file "$OUT" || true
else
  echo "TSA_URL not set; generated TSQ only."
fi

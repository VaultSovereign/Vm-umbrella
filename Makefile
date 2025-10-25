# 🜄 VaultMesh Umbrella Governance Makefile

PY?=python3
SEAL_OUT?=UMBRELLA_SEAL.json
GOV_DIRS?=LICENSE.sovereign SECURITY.md README.md START_HERE.md

.PHONY: seal verify anchor

seal:
	$(PY) scripts/seal_corpus.py --out $(SEAL_OUT) $(GOV_DIRS)

verify:
	$(PY) scripts/seal_corpus.py --verify $(SEAL_OUT) $(GOV_DIRS)

anchor:
	bash scripts/anchor_rfc3161.sh $(SEAL_OUT)

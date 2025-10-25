SHELL := /bin/bash

.PHONY: init bootstrap status foreach pull verify

init:
	@echo "• installing pre-commit hooks (if available)"
	@command -v pre-commit >/dev/null 2>&1 && pre-commit install || true
	@echo "• done"

bootstrap:
	@bash scripts/bootstrap_submodules.sh

status:
	@bash scripts/status.sh

pull:
	@git submodule foreach --recursive 'git fetch --tags --prune && (git pull --ff-only || true)'

foreach:
	@cmd='$(filter-out $@,$(MAKECMDGOALS))'; \
	git submodule foreach --recursive "$$cmd"

verify:
	@echo "• submodule pointers:" && git submodule status --recursive || true
	@echo "• remotes:" && git submodule foreach --recursive 'git remote -v'

# --- GitHub API automation ---
.PHONY: gh-create-umbrella gh-configure-umbrella gh-wire-leaf gh-wire-all gh-push-umbrella

# Usage: make gh-create-umbrella ORG=VaultSovereign REPO=vm-umbrella VIS=public
gh-create-umbrella:
	@[ -n "$$GITHUB_TOKEN" ] || { echo "GITHUB_TOKEN is required" >&2; exit 2; }
	@[ -n "$(ORG)" ] || { echo "ORG required (e.g., ORG=VaultSovereign)" >&2; exit 2; }
	@[ -n "$(REPO)" ] || { echo "REPO required (e.g., REPO=vm-umbrella)" >&2; exit 2; }
	@bash scripts/gh_bootstrap_repo.sh "$(ORG)" "$(REPO)" "$(if $(VIS),$(VIS),public)"

# Usage: make gh-configure-umbrella ORG=VaultSovereign REPO=vm-umbrella
gh-configure-umbrella:
	@[ -n "$$GITHUB_TOKEN" ] || { echo "GITHUB_TOKEN is required" >&2; exit 2; }
	@[ -n "$(ORG)" ] || { echo "ORG required" >&2; exit 2; }
	@[ -n "$(REPO)" ] || { echo "REPO required" >&2; exit 2; }
	@bash scripts/gh_configure_repo.sh "$(ORG)" "$(REPO)"

# Usage: make gh-wire-leaf ORG=VaultSovereign LEAF=vm-forge UMBRELLA=vm-umbrella BRANCH=main
gh-wire-leaf:
	@[ -n "$$GITHUB_TOKEN" ] || { echo "GITHUB_TOKEN is required" >&2; exit 2; }
	@[ -n "$(ORG)" ] || { echo "ORG required" >&2; exit 2; }
	@[ -n "$(LEAF)" ] || { echo "LEAF required (e.g., LEAF=forge)" >&2; exit 2; }
	@bash scripts/gh_add_reuse_workflow.sh "$(ORG)" "$(LEAF)" "$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella)" "$(if $(BRANCH),$(BRANCH),main)"

# Wire common leaves quickly
gh-wire-all:
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=vm-forge UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=vm-ops UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=vm-mesh UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=vm-infra-dns UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=vm-infra-srv UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=vm-meta UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)

# Usage: make gh-push-umbrella ORG=VaultSovereign REPO=vm-umbrella
gh-push-umbrella:
	@[ -n "$(ORG)" ] || { echo "ORG required" >&2; exit 2; }
	@[ -n "$(REPO)" ] || { echo "REPO required" >&2; exit 2; }
	@cd . && echo "Pushing current repo to git@github.com:$(ORG)/$(REPO).git"
	@cd . && git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Run from vm-umbrella dir" >&2; exit 2; }
	@git remote get-url origin >/dev/null 2>&1 || git remote add origin git@github.com:$(ORG)/$(REPO).git
	@git push -u origin main

.PHONY: prune-branches prune-branches-dry-run
# Prune merged branches across the constellation (with backup tags)
prune-branches:
	@for r in vm-forge vm-ops vm-mesh vm-infra-dns vm-infra-srv vm-meta vm-umbrella; do \
	  echo "== Pruning $$r (with backup tags)…"; \
	  bash scripts/gh_prune_merged_branches.sh --repo VaultSovereign/$$r --backup; \
	  echo; \
	done

# Preview deletion candidates without changes
prune-branches-dry-run:
	@for r in vm-forge vm-ops vm-mesh vm-infra-dns vm-infra-srv vm-meta vm-umbrella; do \
	  echo "== Preview $$r (dry-run)…"; \
	  bash scripts/gh_prune_merged_branches.sh --repo VaultSovereign/$$r --dry-run; \
	  echo; \
	done

.PHONY: ci-status
ci-status:
	@for repo in vm-forge vm-ops vm-mesh vm-infra-dns vm-infra-srv vm-meta; do \
	  echo "== $$repo =="; \
	  gh run list -R VaultSovereign/$$repo -L 1 --json status,name,conclusion,url || true; \
	  echo; \
	done

# --- Remote auditing + rewrite to SSH host alias ---
.PHONY: remotes-audit fix-remotes ssh-config-ensure

# Default SSH host alias (as in ~/.ssh/config)
HOST_ALIAS ?= github.com-vault
IDENTITY ?= $(HOME)/.ssh/id_rsa_vaultsovereign

remotes-audit:
	@echo "• auditing remotes in umbrella and leaves";
	@for d in . vm-*; do \
	  if [ -e "$$d/.git" ]; then \
	    echo "== $$d =="; \
	    git -C "$$d" remote -v || true; \
	    echo; \
	  fi; \
	done

fix-remotes:
	@echo "• rewriting remotes to use SSH host alias: $(HOST_ALIAS)";
	@for d in . vm-*; do \
	  if [ -e "$$d/.git" ]; then \
	    cur=$$(git -C "$$d" remote get-url origin 2>/dev/null || true); \
	    if [ -z "$$cur" ]; then echo "(skip $$d: no origin)"; continue; fi; \
	    new=""; \
	    if [[ "$$cur" =~ ^git@([^:]+):(.*)$$ ]]; then \
	      new="git@$(HOST_ALIAS):$${BASH_REMATCH[2]}"; \
	    elif [[ "$$cur" =~ ^ssh://git@([^/]+)/(.+)$$ ]]; then \
	      new="ssh://git@$(HOST_ALIAS)/$${BASH_REMATCH[2]}"; \
	    elif [[ "$$cur" =~ ^https://github.com/(.+)$$ ]]; then \
	      new="git@$(HOST_ALIAS):$${BASH_REMATCH[1]}"; \
	    fi; \
	    if [ -n "$$new" ] && [ "$$new" != "$$cur" ]; then \
	      echo "== $$d =="; \
	      echo "  $$cur"; \
	      echo "→ $$new"; \
	      git -C "$$d" remote set-url origin "$$new"; \
	    else \
	      echo "(ok $$d: no change)"; \
	    fi; \
	  fi; \
	done

ssh-config-ensure:
	@mkdir -p $(HOME)/.ssh && chmod 700 $(HOME)/.ssh
	@touch $(HOME)/.ssh/config && chmod 600 $(HOME)/.ssh/config
	@if ! grep -q '^Host $(HOST_ALIAS)$$' $(HOME)/.ssh/config; then \
	  echo "Adding Host $(HOST_ALIAS) to ~/.ssh/config"; \
	  { \
	    echo 'Host $(HOST_ALIAS)'; \
	    echo '  HostName github.com'; \
	    echo '  User git'; \
	    echo '  IdentityFile $(IDENTITY)'; \
	    echo '  IdentitiesOnly yes'; \
	  } >> $(HOME)/.ssh/config; \
	else \
	  echo "Host $(HOST_ALIAS) already present in ~/.ssh/config"; \
	fi

# --- LawChain governance sealing ---
PY?=python3
SEAL_OUT?=UMBRELLA_SEAL.json
GOV_DIRS?=docs/ blueprints/ policies/ codex/ LICENSE* SECURITY.md README.md

.PHONY: seal seal-verify anchor

seal:
	$(PY) scripts/seal_corpus.py --out $(SEAL_OUT) $(GOV_DIRS)

seal-verify:
	$(PY) scripts/seal_corpus.py --verify $(SEAL_OUT) $(GOV_DIRS)

anchor:
	bash scripts/anchor_rfc3161.sh $(SEAL_OUT)

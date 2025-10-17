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

# Usage: make gh-wire-leaf ORG=VaultSovereign LEAF=forge UMBRELLA=vm-umbrella BRANCH=main
gh-wire-leaf:
	@[ -n "$$GITHUB_TOKEN" ] || { echo "GITHUB_TOKEN is required" >&2; exit 2; }
	@[ -n "$(ORG)" ] || { echo "ORG required" >&2; exit 2; }
	@[ -n "$(LEAF)" ] || { echo "LEAF required (e.g., LEAF=forge)" >&2; exit 2; }
	@bash scripts/gh_add_reuse_workflow.sh "$(ORG)" "$(LEAF)" "$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella)" "$(if $(BRANCH),$(BRANCH),main)"

# Wire common leaves quickly
gh-wire-all:
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=forge UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=ops UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=vaultmesh-mesh UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=infra-dns UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=infra-servers UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)
	@$(MAKE) gh-wire-leaf ORG=$(ORG) LEAF=meta UMBRELLA=$(if $(UMBRELLA),$(UMBRELLA),vm-umbrella) BRANCH=$(if $(BRANCH),$(BRANCH),main)

# Usage: make gh-push-umbrella ORG=VaultSovereign REPO=vm-umbrella
gh-push-umbrella:
	@[ -n "$(ORG)" ] || { echo "ORG required" >&2; exit 2; }
	@[ -n "$(REPO)" ] || { echo "REPO required" >&2; exit 2; }
	@cd . && echo "Pushing current repo to git@github.com:$(ORG)/$(REPO).git"
	@cd . && git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Run from vm-umbrella dir" >&2; exit 2; }
	@git remote get-url origin >/dev/null 2>&1 || git remote add origin git@github.com:$(ORG)/$(REPO).git
	@git push -u origin main

.PHONY: ci-status
ci-status:
	@for repo in forge ops vaultmesh-mesh infra-dns infra-servers meta; do \
	  echo "== $$repo =="; \
	  gh run list -R VaultSovereign/$$repo -L 1 --json status,name,conclusion,url || true; \
	  echo; \
	done

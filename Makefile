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


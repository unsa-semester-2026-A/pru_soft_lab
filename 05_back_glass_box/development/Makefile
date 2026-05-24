.PHONY: install
install:
	uv sync
	bash scripts/install-hooks.sh

.PHONY: run
run:
	uv run finance

.PHONY: check
check:
	bash .githooks/pre-push

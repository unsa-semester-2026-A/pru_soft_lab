.PHONY: install
install:
	uv sync
	uv run python scripts/install_hooks.py

.PHONY: run
run:
	uv run python -m finance

.PHONY: format
format:
	uv run ruff format .

.PHONY: lint
lint:
	uv run ruff check --fix .

.PHONY: typecheck
typecheck:
	uv run pyright

.PHONY: test
test:
	uv run pytest

.PHONY: check
check:
	uv run ruff format --check .
	uv run ruff check .
	uv run pyright
	uv run pytest

## Setup

1. Sync dependencies:
```bash
uv sync
```

2. **Mandatory: Install Git Hooks**
To ensure code quality, you must install the project's Git hooks:
```bash
bash scripts/install-hooks.sh
```

## Scripts

- To run the app:

```bash
uv sync
uv run finance
```

- validation before submit 

```bash
#!/bin/sh
uv run ruff format .

uv run ruff check --fix .

uv run pyright

uv run pytest
```

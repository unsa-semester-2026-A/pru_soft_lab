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

# Glass Box - Finance Tracking

A minimal personal finance tracker focusing on local execution and hexagonal architecture.

## Setup & Workflow

We use `make` as our primary command runner to simplify the workflow. 

### 1. Initial Setup (Mandatory)

To install dependencies and configure the Git hooks (works on Windows/Linux/macOS):
```bash
make install
```

### 2. Running the Application

To run the main application:
```bash
make run
```

### 3. Development Commands

During development, you can use the following commands to ensure your code is clean and correct:

- **Format code:** `make format`
- **Lint code (auto-fix):** `make lint`
- **Type checking:** `make typecheck`
- **Run tests:** `make test`

### 4. Pre-Submit Validation

To run all checks exactly as they will be run by the `pre-push` git hook:
```bash
make check
```

## Structure

- `finance/core`: Hexagon core containing domain and ports.
- `finance/adapters`: Outside world implementations.
- `finance/config`: Dependency injection and bootstrap.

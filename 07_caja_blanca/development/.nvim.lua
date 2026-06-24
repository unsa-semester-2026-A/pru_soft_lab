local root_markers = { 'pyproject.toml', '.git' }
local root_dir = vim.fs.root(0, root_markers)

-- Identificamos la ruta exacta del intérprete que 'uv' creó en .venv
local python_path = root_dir and (root_dir .. "/.venv/bin/python") or "python"

vim.lsp.config.pyright = {
  -- Usamos 'uv run' para invocar el langserver directamente desde tus dev-dependencies
  cmd = { 'uv', 'run', 'pyright-langserver', '--stdio' },
  root_markers = root_markers,
  settings = {
    python = {
      pythonPath = python_path
    }
  }
}
vim.lsp.enable('pyright')

vim.lsp.config.ruff = {
  -- Invocamos el servidor LSP nativo de Ruff a través de uv
  cmd = { 'uv', 'run', 'ruff', 'server' },
  root_markers = root_markers,
}
vim.lsp.enable('ruff')

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function(args)
    vim.lsp.buf.format({
      bufnr = args.buf,
      name = "ruff"
    })
  end,
})

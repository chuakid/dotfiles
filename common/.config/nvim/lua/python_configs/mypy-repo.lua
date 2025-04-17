vim.lsp.enable 'pyright'
require('lint').linters_by_ft.python = { 'mypy', 'flake8' }
-- set up auto formatting with ruff
require('conform').formatters_by_ft = {
  python = {
    -- To fix auto-fixable lint errors.
    'ruff_fix',
    -- To run the Ruff formatter.
    'ruff_format',
    -- To organize the imports.
    'ruff_organize_imports',
  },
}

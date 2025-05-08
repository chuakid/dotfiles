-- repos using ruff for linting and organizing imports and pyright for other things
vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
      typeCheckingMode = 'standard',
    },
  },
})

vim.lsp.enable 'ruff'
require('lint').linters_by_ft.python = { 'mypy' }
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

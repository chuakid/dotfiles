-- repos using ruff for linting and organizing imports and pyright for other things
vim.lsp.config('pyright', {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      },
    },
  },
})

vim.lsp.enable 'ruff_lsp'
vim.lsp.enable 'pyright'
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

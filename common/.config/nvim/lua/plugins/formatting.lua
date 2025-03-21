return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    format_on_save = { lsp_fallback = true, async = false },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'first' },
      typescript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'first' },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'first' },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'first' },
      css = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'first' },
      html = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'first' },
      go = { 'gofmt' },
    },
  },
}

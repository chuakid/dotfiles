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
      -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
      -- typescript = { 'prettierd', 'prettier', stop_after_first = true },
      -- javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      -- typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      -- css = { 'prettierd', 'prettier', stop_after_first = true },
      -- html = { 'prettierd', 'prettier', stop_after_first = true },
      go = { 'gofmt' },
      nix = { 'nixfmt' },
      json = { 'jq' },
    },
  },
}

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
      css = { 'biome', 'biome-check' },
      javascript = { 'biome', 'biome-check' },
      javascriptreact = { 'biome', 'biome-check' },
      typescript = { 'biome', 'biome-check' },
      typescriptreact = { 'biome', 'biome-check' },
      html = { 'biome', 'biome-check' },
      go = { 'gofmt' },
      nix = { 'nixfmt' },
      json = { 'jq' },
    },
  },
}

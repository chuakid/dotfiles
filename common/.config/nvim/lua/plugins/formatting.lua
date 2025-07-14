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
      css = { 'biome', 'biome-organize-imports' },
      javascript = { 'biome', 'biome-organize-imports' },
      javascriptreact = { 'biome', 'biome-organize-imports' },
      typescript = { 'biome', 'biome-organize-imports' },
      typescriptreact = { 'biome', 'biome-organize-imports' },
      html = { 'biome', 'biome-organize-imports' },
      go = { 'gofmt' },
      nix = { 'nixfmt' },
      json = { 'jq' },
    },
  },
}

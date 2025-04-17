return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      local servers = {
        gopls = {},
        pyright = {},
        ruff = {
          autostart = false,
        },
        ts_ls = {},
        eslint = {
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'EslintFixAll',
            })
          end,
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        cssls = {},
        tailwindcss = {},
        nil_ls = {},
        astro = {},
      }
      vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover { border = 'rounded' }
      end)

      local ensure_installed = vim.tbl_deep_extend('force', vim.tbl_keys(servers), {
        'stylua',
        'golangci-lint',
        'flake8',
      })

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }
      require('mason-lspconfig').setup {}

      for server, config in pairs(servers) do
        vim.lsp.enable(server)
        vim.lsp.config(server, config)
      end
    end,
  },
}

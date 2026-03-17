return {
  -- ============================================================
  -- AI / Completion
  -- ============================================================
  { -- Autocompletion
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'super-tab' },
      snippets = { preset = 'luasnip' },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
          },
        },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
      },
      signature = { enabled = true },
    },
  },

  -- ============================================================
  -- LSP
  -- ============================================================
  { -- Lua LSP for Neovim config/runtime/plugins
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
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
        basedpyright = {},
        ts_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        cssls = {},
        tailwindcss = {},
        nil_ls = {}, -- nix
        astro = {},
        jsonls = {},
        html = {},
        dockerls = {},
        taplo = {}, -- toml
        biome = {},
        tinymist = {}, -- typst
        rust_analyzer = {},
        ansiblels = {},
        jdtls = {},
      }

      vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover { border = 'rounded' }
      end)

      local ensure_installed = { 'stylua' }
      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
        table.insert(ensure_installed, server)
      end

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {}
    end,
  },

  -- ============================================================
  -- Treesitter
  -- ============================================================
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    opts = {},
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = { max_lines = 4 },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },

  -- ============================================================
  -- Formatting & Linting
  -- ============================================================
  { -- Autoformat
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
        java = { 'google-java-format' },
      },
    },
  },
  { -- Linting (most linting is done by LSP)
    'mfussenegger/nvim-lint',
    dependencies = { 'neovim/nvim-lspconfig' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        go = { 'golangcilint' },
      }
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },

  -- ============================================================
  -- UI
  -- ============================================================
  { -- Collection of small independent plugins
    'nvim-mini/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects (va), yinq, ci')
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (saiw), sd', sr)')
      require('mini.surround').setup()
      vim.keymap.set({ 'n', 'x' }, 's', '<Nop>') -- unbind s so surround works

      require('mini.statusline').setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      require('mini.statusline').section_location = function()
        return '%2l:%-2v'
      end

      require('mini.pairs').setup()

      require('mini.hipatterns').setup {
        highlighters = {
          fixme = { pattern = '%f[%w]()FIXME.*:', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK.*:', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO.*:', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE.*:', group = 'MiniHipatternsNote' },
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      }

      require('mini.sessions').setup { autoread = true }

      local MiniMap = require 'mini.map'
      MiniMap.setup {
        integrations = { MiniMap.gen_integration.diagnostic() },
        symbols = { encode = MiniMap.gen_encode_symbols.dot '4x2' },
        window = { show_integration_count = false },
      }
      vim.keymap.set('n', '<leader>mf', function()
        require('mini.map').toggle_focus()
      end, { desc = 'Toggle Minimap Focus' })
      vim.keymap.set('n', '<leader>mt', function()
        require('mini.map').toggle()
      end, { desc = 'Toggle Minimap' })

      require('mini.notify').setup()
    end,
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
      {
        '\\',
        function()
          require('snacks.explorer').open()
        end,
        desc = 'Open explorer',
      },
      -- picker
      {
        '<leader><leader>',
        function()
          require('snacks.picker').smart { multi = { 'buffers', 'files' } }
        end,
        desc = 'Smart search',
      },
      {
        'gd',
        function()
          require('snacks.picker').lsp_definitions()
        end,
        desc = '[G]oto [D]efinitions',
      },
      {
        'grr',
        function()
          require('snacks.picker').lsp_references()
        end,
        desc = '[G]oto [R]eferences',
      },
      {
        'gri',
        function()
          require('snacks.picker').lsp_implementations()
        end,
        desc = '[G]oto [I]mplementations',
      },
      {
        'gO',
        function()
          require('snacks.picker').lsp_symbols()
        end,
        desc = 'Search lsp_symbols',
      },
      {
        '<leader>sp',
        function()
          require('snacks.picker').pickers()
        end,
        desc = 'Search all pickers',
      },
      {
        '<leader>sg',
        function()
          require('snacks.picker').grep()
        end,
        desc = '[S]earch [G]rep',
      },
      {
        '<leader>sw',
        function()
          require('snacks.picker').lsp_workspace_symbols()
        end,
        desc = '[S]earch [W]orkspace',
      },
      {
        '<leader>sf',
        function()
          require('snacks.picker').lines()
        end,
        desc = '[S]earch [F]ile',
      },
      {
        '<leader>sd',
        function()
          require('snacks.picker').diagnostics()
        end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sj',
        function()
          require('snacks.picker').jumps()
        end,
        desc = '[S]earch [J]umplist',
      },
      {
        '<leader>q',
        function()
          require('snacks.picker').diagnostics_buffer()
        end,
        desc = 'Diagnostics in current buffer',
      },
      -- lazygit
      {
        '<leader>lg',
        function()
          require('snacks.lazygit').open()
        end,
      },
    },
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      input = { enabled = true },
      picker = {
        enabled = true,
        hidden = true,
        win = {
          input = {
            keys = {
              ['<C-h>'] = 'toggle_hidden',
              ['<C-i>'] = 'toggle_ignored',
            },
          },
        },
        sources = {
          explorer = {
            auto_close = true,
            ignored = true,
          },
        },
      },
      image = { enabled = true },
      lazygit = { enabled = true },
      indent = { enabled = true },
      words = { enabled = true },
      rename = { enabled = true },
    },
  },
  { -- Useful plugin to show you pending keybinds
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      preset = 'helix',
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>' },
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    'fei6409/log-highlight.nvim',
    opts = {},
  },
  {
    'sphamba/smear-cursor.nvim',
    opts = {},
  },

  -- ============================================================
  -- Git
  -- ============================================================
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 200 },
    },
    keys = {
      {
        '<leader>hr',
        function()
          require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end,
      },
    },
  },

  -- ============================================================
  -- Editing Tools
  -- ============================================================
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local mc = require 'multicursor-nvim'
      mc.setup()
      local set = vim.keymap.set

      set({ 'n', 'x' }, '<c-d>', function()
        mc.matchAddCursor(1)
      end, { desc = 'Add cursor' })

      set('n', '<c-leftmouse>', mc.handleMouse)
      set('n', '<c-leftdrag>', mc.handleMouseDrag)
      set('n', '<c-leftrelease>', mc.handleMouseRelease)

      mc.addKeymapLayer(function(layerSet)
        layerSet('n', '<esc>', function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
  },
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    config = function()
      vim.keymap.set('n', '<A-Left>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<A-Down>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<A-Up>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<A-Right>', require('smart-splits').resize_right)
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
      vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
    end,
  },
  { -- Docstring generation
    'danymat/neogen',
    config = true,
    opts = {
      languages = {
        python = { template = {} },
      },
    },
    keys = {
      {
        '<leader>d',
        function()
          require('neogen').generate()
        end,
      },
    },
  },
  { -- Search and replace
    'nvim-pack/nvim-spectre',
    keys = {
      {
        '<leader>sx',
        function()
          require('spectre').toggle()
        end,
        desc = 'Toggle spectre',
      },
    },
    opts = {},
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'mfussenegger/nvim-ansible',
  },
}

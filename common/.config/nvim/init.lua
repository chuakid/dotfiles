-- ╔══════════════════════════════════════════════════════════════╗
-- ║                      Leader & Globals                       ║
-- ╚══════════════════════════════════════════════════════════════╝

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                      Editor Options                         ║
-- ╚══════════════════════════════════════════════════════════════╝

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false -- already shown by lualine
vim.opt.undofile = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250 -- faster swap writes and CursorHold triggers
vim.opt.confirm = true -- prompt to save instead of failing on :q with changes
vim.opt.exrc = true -- load per-project .nvim.lua

-- Splits open in the more natural direction
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Sync clipboard after UI loads to avoid slowing startup
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                      Visual Settings                        ║
-- ╚══════════════════════════════════════════════════════════════╝

vim.opt.guicursor = {
  'n-v-c:block-blinkwait700-blinkon400-blinkoff250',
  'i-ci:ver25-blinkwait700-blinkon400-blinkoff250',
  'r-cr-o:hor20-blinkwait700-blinkon400-blinkoff250',
}

vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- Visible whitespace
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Live preview of :s substitutions
vim.opt.inccommand = 'split'

-- Hide cmdline; temporarily show it during macro recording
vim.opt.cmdheight = 0
vim.cmd [[autocmd RecordingEnter * set cmdheight=1]]
vim.cmd [[autocmd RecordingLeave * set cmdheight=0]]

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                         Search                              ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Case-insensitive unless the query contains uppercase or \C
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                       Diagnostics                           ║
-- ╚══════════════════════════════════════════════════════════════╝

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
  },
  update_in_insert = true,
}

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                        Keymaps                              ║
-- ╚══════════════════════════════════════════════════════════════╝

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show error' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { desc = 'Rename symbol' })

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                      Autocommands                           ║
-- ╚══════════════════════════════════════════════════════════════╝

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                 Plugin Manager (lazy.nvim)                  ║
-- ╚══════════════════════════════════════════════════════════════╝

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                         Plugins                             ║
-- ╚══════════════════════════════════════════════════════════════╝

require('lazy').setup({

  -- ── Theme ──────────────────────────────────────────────────────
  { -- Pastel colorscheme with transparent background support
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    opts = {
      transparent_background = true,
      styles = { functions = { 'italic' } },
      auto_integrations = true,
    },
  },

  -- ── Completion & Snippets ──────────────────────────────────────
  { -- Fast, Rust-based completion engine with fuzzy matching
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      { -- Snippet engine with VSCode snippet format support
        'L3MON4D3/LuaSnip',
        dependencies = {
          { -- Pre-built snippet collection for most languages
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
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      signature = { enabled = true },
    },
  },

  -- ── LSP ────────────────────────────────────────────────────────
  {
    -- Provides Lua LSP completions for Neovim's API when editing config
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { -- LSP configs with Mason for auto-installing servers and tools
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} }, -- portable LSP/tool installer
      'williamboman/mason-lspconfig.nvim', -- bridges mason and lspconfig
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- auto-installs tools on startup
      'saghen/blink.cmp',
    },
    config = function()
      local servers = {
        gopls = {},
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true, -- ruff handles imports instead
              typeCheckingMode = 'standard',
            },
          },
        },
        ruff = {},
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

  -- ── Treesitter ─────────────────────────────────────────────────
  { -- Incremental parsing for syntax highlighting, indentation, and folds
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    opts = {},
  },
  { -- Shows the function/class you're inside at the top of the window
    'nvim-treesitter/nvim-treesitter-context',
    opts = { max_lines = 4 },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  { -- Auto-close and rename HTML/JSX tags
    'windwp/nvim-ts-autotag',
    opts = {},
  },

  -- ── Formatting & Linting ───────────────────────────────────────
  { -- Format on save with per-filetype formatter configuration
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
        desc = 'Format buffer',
      },
    },
    opts = {
      format_on_save = { lsp_fallback = true, async = false },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
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
  {
    -- Most linting is handled by LSP; this covers gaps like golangci-lint
    'mfussenegger/nvim-lint',
    dependencies = { 'neovim/nvim-lspconfig' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        go = { 'golangcilint' },
      }
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('lint', { clear = true }),
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },

  -- ── UI ─────────────────────────────────────────────────────────
  { -- Collection of small independent plugins (textobjects, surround, pairs, etc.)
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 } -- extended a/i textobjects (e.g. va), ci')
      require('mini.surround').setup() -- add/delete/replace surroundings (sa, sd, sr)
      vim.keymap.set({ 'n', 'x' }, 's', '<Nop>') -- free up 's' for mini.surround

      require('mini.pairs').setup() -- auto-close brackets/quotes

      require('mini.hipatterns').setup { -- inline hex color previews (e.g. #ff0000)
        highlighters = {
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      }

      require('mini.sessions').setup { autoread = true } -- auto-restore last session per directory

      local MiniMap = require 'mini.map' -- code minimap with diagnostic overlay
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

      require('mini.notify').setup({
        lsp_progress = { enable = false },
      })
    end,
  },
  { -- Swiss-army-knife: file explorer, fuzzy picker, lazygit, dashboard, and more
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
      -- Picker keymaps
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
        desc = 'Goto definitions',
      },
      {
        'grr',
        function()
          require('snacks.picker').lsp_references()
        end,
        desc = 'Goto references',
      },
      {
        'gri',
        function()
          require('snacks.picker').lsp_implementations()
        end,
        desc = 'Goto implementations',
      },
      {
        'gO',
        function()
          require('snacks.picker').lsp_symbols()
        end,
        desc = 'Search symbols',
      },
      {
        '<leader>sp',
        function()
          require('snacks.picker').pickers()
        end,
        desc = 'Search pickers',
      },
      {
        '<leader>sg',
        function()
          require('snacks.picker').grep()
        end,
        desc = 'Search grep',
      },
      {
        '<leader>sw',
        function()
          require('snacks.picker').lsp_workspace_symbols()
        end,
        desc = 'Search workspace',
      },
      {
        '<leader>sf',
        function()
          require('snacks.picker').lines()
        end,
        desc = 'Search file',
      },
      {
        '<leader>sd',
        function()
          require('snacks.picker').diagnostics()
        end,
        desc = 'Search diagnostics',
      },
      {
        '<leader>sj',
        function()
          require('snacks.picker').jumps()
        end,
        desc = 'Search jumplist',
      },
      {
        '<leader>q',
        function()
          require('snacks.picker').diagnostics_buffer()
        end,
        desc = 'Buffer diagnostics',
      },
      {
        '<leader>lg',
        function()
          require('snacks.lazygit').open()
        end,
        desc = 'Lazygit',
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
          explorer = { auto_close = true, ignored = true },
        },
      },
      image = { enabled = true },
      lazygit = { enabled = true },
      indent = { enabled = true },
      words = { enabled = true },
      rename = { enabled = true },
    },
  },
  { -- Shows available keybindings in a popup as you type
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
  { -- Statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup()
    end,
  },
  { -- Renders markdown with headings, code blocks, and links in-buffer
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  { 'fei6409/log-highlight.nvim', opts = {} }, -- syntax highlighting for log files
  { 'sphamba/smear-cursor.nvim', opts = {} }, -- animated cursor trail

  -- ── Git ────────────────────────────────────────────────────────
  { -- Inline git blame, hunk staging/reset, and sign column diff markers
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

  -- ── Editing ────────────────────────────────────────────────────
  { -- VSCode/Sublime-style multiple cursors (Ctrl-d to add)
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local mc = require 'multicursor-nvim'
      mc.setup()

      vim.keymap.set({ 'n', 'x' }, '<c-d>', function()
        mc.matchAddCursor(1)
      end, { desc = 'Add cursor' })
      vim.keymap.set('n', '<c-leftmouse>', mc.handleMouse)
      vim.keymap.set('n', '<c-leftdrag>', mc.handleMouseDrag)
      vim.keymap.set('n', '<c-leftrelease>', mc.handleMouseRelease)

      -- Esc clears cursors, or re-enables them if they were disabled
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
  { -- Navigate and resize splits seamlessly (works across tmux panes too)
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    config = function()
      local ss = require 'smart-splits'
      vim.keymap.set('n', '<A-Left>', ss.resize_left)
      vim.keymap.set('n', '<A-Down>', ss.resize_down)
      vim.keymap.set('n', '<A-Up>', ss.resize_up)
      vim.keymap.set('n', '<A-Right>', ss.resize_right)
      vim.keymap.set('n', '<C-h>', ss.move_cursor_left)
      vim.keymap.set('n', '<C-j>', ss.move_cursor_down)
      vim.keymap.set('n', '<C-k>', ss.move_cursor_up)
      vim.keymap.set('n', '<C-l>', ss.move_cursor_right)
      vim.keymap.set('n', '<C-\\>', ss.move_cursor_previous)
    end,
  },
  { -- Generate language-appropriate docstrings/annotations
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
        desc = 'Generate docstring',
      },
    },
  },
  { -- Project-wide search and replace with live preview
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
  { 'mfussenegger/nvim-ansible' }, -- filetype detection and syntax for Ansible YAML
}, {
  ui = {
    -- Fallback icons for terminals without Nerd Font
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                    Post-Plugin Setup                         ║
-- ╚══════════════════════════════════════════════════════════════╝

vim.cmd.colorscheme 'catppuccin-mocha'

-- Built-in experimental message UI (Neovim 0.11+)
require('vim._core.ui2').enable {
  enable = true,
  msg = {
    targets = 'cmd',
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.5, timeout = 4000 },
    pager = { height = 1 },
  },
}

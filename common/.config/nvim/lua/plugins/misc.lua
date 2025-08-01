return {
  {
    'fei6409/log-highlight.nvim',
    opts = {},
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
  {
    'rmagatti/goto-preview',
    dependencies = 'rmagatti/logger.nvim',
    event = 'BufEnter',
    config = {
      default_mappings = true,
    },
  },
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    config = function()
      vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
      -- moving between splits
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
      vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
    end,
  },
  --- docstring generation
  {
    'danymat/neogen',
    config = true,
    opts = {
      languages = {
        python = {
          template = {
            -- annotation_convention = 'reST',
          },
        },
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
  --- git integration
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 200,
      },
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
  --- search and replace
  {
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
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
}

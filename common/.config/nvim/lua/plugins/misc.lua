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
  -- {
  --   'sphamba/smear-cursor.nvim',
  --   opts = {
  --     -- Smear cursor when switching buffers or windows.
  --     smear_between_buffers = true,
  --
  --     -- Draw the smear in buffer space instead of screen space when scrolling
  --     scroll_buffer_space = true,
  --
  --     -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
  --     -- Smears will blend better on all backgrounds.
  --     legacy_computing_symbols_support = true,
  --
  --     smear_insert_mode = false,
  --
  --     smear_time_interval = 7,
  --     damping = 1,
  --   },
  -- },
}

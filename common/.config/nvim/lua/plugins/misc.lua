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
    'sphamba/smear-cursor.nvim',
    opts = {
      -- Smear cursor when switching buffers or windows.
      smear_between_buffers = true,

      -- Draw the smear in buffer space instead of screen space when scrolling
      scroll_buffer_space = true,

      -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
      -- Smears will blend better on all backgrounds.
      legacy_computing_symbols_support = true,

      smear_insert_mode = false,

      smear_time_interval = 7,
    },
  },
}

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
}

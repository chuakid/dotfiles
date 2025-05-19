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
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
    },
  },
}

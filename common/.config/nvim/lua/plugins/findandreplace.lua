return {
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
}

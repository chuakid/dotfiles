return {
  {
    'github/copilot.vim',
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('codecompanion').setup {
        strategies = {
          chat = {
            adapter = 'githubmodels',
          },
          inline = {
            adapter = 'githubmodels',
          },
        },
      }
      vim.keymap.set({ 'n', 'v' }, '<Leader>cca', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
      vim.keymap.set({ 'n', 'v' }, '<Leader>ct', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
      vim.keymap.set('v', '<leader>ca', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })
    end,
  },
}

return { -- Fuzzy Finder (files, lsp, etc)
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = { 'telescope' }, -- telescope preset
  keys = {
    {
      '<leader><leader>',
      function()
        require('fzf-lua').files()
      end,
      desc = 'Search all files',
    },
    {
      '<leader>sr',
      function()
        require('fzf-lua').lsp_references()
      end,
      desc = '[S]earch [R]eferences',
    },
    {
      '<leader>sg',
      function()
        require('fzf-lua').live_grep_native()
      end,
      desc = '[S]earch [G]rep',
    },
    {
      '<leader>sf',
      function()
        require('fzf-lua').grep_curbuf {
          winopts = {
            preview = {
              hidden = true,
            },
          },
        }
      end,
      desc = '[S]earch [F]ile',
    },
  },
}

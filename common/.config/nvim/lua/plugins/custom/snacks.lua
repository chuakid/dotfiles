return {
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
        require('snacks.picker').smart {
          multi = { 'buffers', 'files' },
        }
      end,
      desc = 'Search all files',
    },
    {
      'gd',
      function()
        require('snacks.picker').lsp_definitions()
      end,
      desc = '[G]oto [D]efinitions',
    },
    {
      'gr',
      function()
        require('snacks.picker').lsp_references()
      end,
      desc = '[G]oto [R]eferences',
    },
    {
      'gi',
      function()
        require('snacks.picker').lsp_implementations()
      end,
      desc = '[G]oto [I]mplementations',
    },
    {
      '<leader>sg',
      function()
        require('snacks.picker').grep()
      end,
      desc = '[S]earch [G]rep',
    },
    {
      '<leader>sf',
      function()
        require('snacks.picker').lines()
      end,
      desc = '[S]earch [F]ile',
    },
    {
      '<leader>sh',
      function()
        require('snacks.picker').help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sj',
      function()
        require('snacks.picker').jumps()
      end,
      desc = '[S]earch [J]umps',
    },
    {
      '<leader>sk',
      function()
        require('snacks.picker').keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sr',
      function()
        require('snacks.picker').recent()
      end,
      desc = '[S]earch [R]ecents',
    },
    {
      '<leader>sd',
      function()
        require('snacks.picker').diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
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
    bigfile = { enabled = true }, -- disable some features when file too big
    dashboard = { enabled = true }, -- dashboard
    explorer = { enabled = true }, -- file browser
    input = { enabled = true }, -- nicer command input
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
    }, -- file picker
    image = { enabled = true },
    lazygit = { enabled = true },
    indent = { enabled = true },
  },
}

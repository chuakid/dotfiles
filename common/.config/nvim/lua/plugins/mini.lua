-- Collection of various small independent plugins/modules
-- https://github.com/echasnovski/mini.nvim
return {
  'echasnovski/mini.nvim',
  -- https://lazy.folke.io/spec/lazy_loading
  -- keys is set so need to explicitly not lazy load it
  lazy = false,
  keys = {
    {
      'n',
      '<Leader>mf',
      function()
        require('mini.map').toggle_focus()
      end,
      desc = 'Toggle Minimap Focus',
    },
    {
      'n',
      '<Leader>mt',
      function()
        require('mini.map').toggle()
      end,
      { desc = 'Toggle Minimap' },
    },
  },
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    -- unbind s so surround works
    vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

    require('mini.statusline').setup { use_icons = vim.g.have_nerd_font }
    ---@diagnostic disable-next-line: duplicate-set-field
    require('mini.statusline').section_location = function()
      return '%2l:%-2v'
    end
    require('mini.pairs').setup()
    require('mini.hipatterns').setup {
      highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = '%f[%w]()FIXME.*:', group = 'MiniHipatternsFixme' },
        hack = { pattern = '%f[%w]()HACK.*:', group = 'MiniHipatternsHack' },
        todo = { pattern = '%f[%w]()TODO.*:', group = 'MiniHipatternsTodo' },
        note = { pattern = '%f[%w]()NOTE.*:', group = 'MiniHipatternsNote' },
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      },
    }
    require('mini.sessions').setup { autoread = true }

    local MiniMap = require 'mini.map'
    MiniMap.setup { integrations = {
      MiniMap.gen_integration.gitsigns(),
      MiniMap.gen_integration.diagnostic(),
    } }

    require('mini.notify').setup()
  end,
}

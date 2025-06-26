return {
  'danymat/neogen',
  config = true,
  opts = {
    languages = {
      python = {
        template = {
          annotation_convention = 'reST',
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
}

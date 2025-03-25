return {
  -- most linting is done by LSP
  { -- Linting
    'mfussenegger/nvim-lint',
    dependencies = {
      'neovim/nvim-lspconfig',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        python = { 'flake8' },
        go = { 'golangcilint' },
      }
      -- HACK: temp fix until
      -- https://github.com/mfussenegger/nvim-lint/pull/761 is merged
      lint.linters.golangcilint.args = {
        'run',
        '--output.json.path=stdout',
        '--issues-exit-code=0',
        '--show-stats=false',
        function()
          return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
        end,
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}

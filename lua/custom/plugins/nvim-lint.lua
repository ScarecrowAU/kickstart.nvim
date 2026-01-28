return {
  {
    'mfussenegger/nvim-lint',
    event = {
      'BufReadPre',
      'BufNewFile',
    },
    config = function()
      local lint = require 'lint'

      local js_linters = { 'oxlint', 'eslint_d', 'eslint' }

      lint.linters_by_ft = {
        javascript = js_linters,
        typescript = js_linters,
        javascriptreact = js_linters,
        typescriptreact = js_linters,
        svelte = js_linters,
        kotlin = { 'ktlint' },
        terraform = { 'tflint' },
        ruby = { 'standardrb' },
        go = { 'golangcilint' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint(nil, { ignore_errors = true })
        end,
      })

      vim.keymap.set('n', '<leader>ll', function()
        lint.try_lint(nil, { ignore_errors = true })
      end, { desc = 'Trigger linting for current file' })
    end,
  },
}

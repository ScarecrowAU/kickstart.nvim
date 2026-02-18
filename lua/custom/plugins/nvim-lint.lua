return {
  {
    'mfussenegger/nvim-lint',
    event = {
      'BufReadPre',
      'BufNewFile',
    },
    config = function()
      local lint = require 'lint'
      local utils = require 'custom.utils'

      local js_filetypes = {
        javascript = true,
        typescript = true,
        javascriptreact = true,
        typescriptreact = true,
        svelte = true,
      }

      lint.linters_by_ft = {
        kotlin = { 'ktlint' },
        terraform = { 'tflint' },
        ruby = { 'standardrb' },
        go = { 'golangcilint' },
      }

      local function run_lint()
        local ft = vim.bo.filetype
        if js_filetypes[ft] then
          local buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:h')
          if utils.has_oxc_config(buf_dir) then
            lint.try_lint({ 'oxlint' }, { ignore_errors = true })
          elseif vim.fn.executable('eslint_d') == 1 then
            lint.try_lint({ 'eslint_d' }, { ignore_errors = true })
          else
            lint.try_lint({ 'eslint' }, { ignore_errors = true })
          end
        else
          lint.try_lint(nil, { ignore_errors = true })
        end
      end

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = run_lint,
      })

      vim.keymap.set('n', '<leader>ll', run_lint, { desc = 'Trigger linting for current file' })
    end,
  },
}

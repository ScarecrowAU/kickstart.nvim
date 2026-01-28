return {
  {
    'mfussenegger/nvim-lint',
    event = {
      'BufReadPre',
      'BufNewFile',
    },
    config = function()
      local lint = require 'lint'
      
      -- Check if biome is available
      local has_biome = vim.fn.executable('biome') == 1
      
      -- Build linters list based on what's available
      local js_linters = {}
      if has_biome then
        table.insert(js_linters, 'biomejs')
      else
        -- Check for eslint variants
        if vim.fn.executable('eslint_d') == 1 then
          table.insert(js_linters, 'eslint_d')
        elseif vim.fn.executable('eslint') == 1 then
          table.insert(js_linters, 'eslint')
        end
        -- Add oxlint if available
        if vim.fn.executable('oxlint') == 1 then
          table.insert(js_linters, 'oxlint')
        end
      end

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
          lint.try_lint()
        end,
      })

      vim.keymap.set('n', '<leader>ll', function()
        lint.try_lint()
      end, { desc = 'Trigger linting for current file' })
    end,
  },
}

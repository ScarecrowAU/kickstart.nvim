return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-plenary',
      'nvim-neotest/neotest-vim-test',
      'nvim-neotest/neotest-jest',
      { 'vim-test/vim-test', lazy = false },
    },
    config = function()
      local neotest = require 'neotest'
      neotest.setup {
        discovery = {
          enabled = false,
        },
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
          },
          require 'neotest-plenary',
          require 'neotest-vim-test' {
            ignore_file_types = { 'python', 'vim', 'lua' },
          },
          require 'neotest-jest' {
            env = {
              JEST_FOCUSED = 'true',
            },
            cwd = function(path) return vim.fn.getcwd() end,
          },
        },
      }

      vim.keymap.set('n', '<leader>tn', function() neotest.run.run() end, { desc = '[T]est [N]earest' })
      vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand '%') end, { desc = '[T]est [F]ile' })
      vim.keymap.set('n', '<leader>tp', function() neotest.output_panel.toggle() end, { desc = '[T]est Output [P]anel' })
      vim.keymap.set('n', '<leader>to', function() neotest.output.open() end, { desc = '[T]est Output [P]anel' })
      vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end, { desc = '[T]est [S]ummary' })
    end,
  },
}

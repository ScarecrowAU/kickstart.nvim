return {
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local refactoring = require 'refactoring'
      local telescope = require 'telescope'
      refactoring.setup {
        prompt_func_return_type = {
          go = true,
          cpp = true,
          c = true,
          java = true,
        },
        prompt_func_param_type = {
          go = true,
          cpp = true,
          c = true,
          java = true,
        },
        printf_statements = {},
        print_var_statements = {},
        show_success_message = false,
      }

      vim.keymap.set({ 'n', 'x' }, '<leader>rr', function() telescope.extensions.refactoring.refactors() end, { desc = 'Refactor' })
      vim.keymap.set('x', '<leader>re', function() refactoring.refactor 'Extract Function' end, { desc = 'Extract Function' })
      vim.keymap.set('x', '<leader>rf', function() refactoring.refactor 'Extract Function To File' end, { desc = 'Extract Function To File' })
      vim.keymap.set('x', '<leader>rv', function() refactoring.refactor 'Extract Variable' end, { desc = 'Extract Variable' })
      vim.keymap.set('n', '<leader>rI', function() refactoring.refactor 'Inline Function' end, { desc = 'Inline Function' })
      vim.keymap.set({ 'n', 'x' }, '<leader>ri', function() refactoring.refactor 'Inline Variable' end, { desc = 'Inline Variable' })
      vim.keymap.set('n', '<leader>rb', function() refactoring.refactor 'Extract Block' end, { desc = 'Extract Block' })

      vim.keymap.set('n', '<leader>rbf', function() refactoring.refactor 'Extract Block To File' end, { desc = 'Extract Block To File' })
    end,
  },
}

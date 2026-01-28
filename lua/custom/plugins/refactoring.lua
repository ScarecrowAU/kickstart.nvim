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
        -- prompt for return type
        prompt_func_return_type = {
          go = true,
          cpp = true,
          c = true,
          java = true,
        },
        -- prompt for function parameters
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

      -- prompt for a refactor to apply when the remap is triggered
      -- Note that not all refactor support both normal and visual mode
      vim.keymap.set({ 'n', 'x' }, '<leader>rr', function() telescope.extensions.refactoring.refactors() end, { desc = 'Refactor' })

      vim.keymap.set('x', '<leader>re', function() refactoring.refactor 'Extract Function' end, { desc = 'Extract Function' })

      -- Extract function supports only visual mode
      vim.keymap.set('x', '<leader>rf', function() refactoring.refactor 'Extract Function To File' end, { desc = 'Extract Function To File' })

      -- Extract variable supports only visual mode
      vim.keymap.set('x', '<leader>rv', function() refactoring.refactor 'Extract Variable' end, { desc = 'Extract Variable' })

      -- Inline func supports only normal
      vim.keymap.set('n', '<leader>rI', function() refactoring.refactor 'Inline Function' end, { desc = 'Inline Function' })

      -- Inline var supports both normal and visual mode
      vim.keymap.set({ 'n', 'x' }, '<leader>ri', function() refactoring.refactor 'Inline Variable' end, { desc = 'Inline Variable' })

      -- Extract block supports only normal mode
      vim.keymap.set('n', '<leader>rb', function() refactoring.refactor 'Extract Block' end, { desc = 'Extract Block' })

      vim.keymap.set('n', '<leader>rbf', function() refactoring.refactor 'Extract Block To File' end, { desc = 'Extract Block To File' })
    end,
  },
}

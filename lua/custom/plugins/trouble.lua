return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below

      mode = 'workspace_diagnostics',
    },

    config = function()
      local trouble = require 'trouble'
      trouble.setup {
        mode = 'workspace_diagnostics',
      }

      -- Lua
      vim.keymap.set('n', '<leader>xx', function() trouble.toggle() end, { desc = 'Trouble: Toggle' })
      vim.keymap.set('n', '<leader>xw', function() trouble.toggle 'workspace_diagnostics' end, { desc = 'Trouble: Workspace Diagnostics' })
      vim.keymap.set('n', '<leader>xd', function() trouble.toggle 'document_diagnostics' end, { desc = 'Trouble: Document Diagnostics' })
      vim.keymap.set('n', '<leader>xq', function() trouble.toggle 'quickfix' end, { desc = 'Trouble: Quickfix' })
      vim.keymap.set('n', '<leader>xl', function() trouble.toggle 'loclist' end, { desc = 'Trouble: Loclist' })
      vim.keymap.set('n', 'gR', function() trouble.toggle 'lsp_references' end, { desc = 'Trouble: LSP References' })

      vim.keymap.set('n', '<leader>dt', trouble.toggle, { desc = '[D]iagnostic View [T]oggle' })
    end,
  },
}

return {
  {
    'natecraddock/workspaces.nvim',
    path = vim.fn.stdpath 'data' .. '/workspaces',
    cd_type = 'local',
    sort = true,
    mru_sort = true,
    auto_open = false,
    notify_info = true,

    config = function()
      local workspaces = require 'workspaces'
      workspaces.setup()

      vim.keymap.set('n', '<leader>wsa', workspaces.add, { desc = 'Add workspace' })
      vim.keymap.set('n', '<leader>wso', workspaces.open, { desc = 'Open workspace' })
      vim.keymap.set('n', '<leader>wsr', workspaces.remove, { desc = 'Remove workspace' })
    end,
  },
}

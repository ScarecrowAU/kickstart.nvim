return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 5000,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { '<leader>un', function() require('snacks').notifier.hide() end, desc = 'Dismiss all notifications' },
      { '<leader>bd', function() require('snacks').bufdelete() end, desc = 'Delete buffer' },
      { '<leader>gg', function() require('snacks').lazygit() end, desc = 'Lazygit' },
      { '<leader>gb', function() require('snacks').git.blame_line() end, desc = 'Git blame line' },
      { '<leader>gB', function() require('snacks').gitbrowse() end, desc = 'Git browse' },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          require('snacks').toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
          require('snacks').toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
          require('snacks').toggle.diagnostics():map '<leader>ud'
        end,
      })
    end,
  },
}

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    scope = {
      show_start = true,
      show_end = false,
    },
  },
  config = function(_, opts)
    local hooks = require 'ibl.hooks'
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#333333' })
      vim.api.nvim_set_hl(0, 'IblScope', { fg = '#2C5282' })
    end)
    require('ibl').setup(opts)
  end,
}

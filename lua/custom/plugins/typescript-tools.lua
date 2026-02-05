return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'neovim/nvim-lspconfig' },
    },
    config = function()
      require('typescript-tools').setup {
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = 'change',
          expose_as_code_action = { 'all' },
          tsserver_plugins = {
            'styled-components',
          },
          tsserver_locale = 'en',
        },
      }
    end,
  },
}

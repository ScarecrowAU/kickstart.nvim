return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        pyright = {},
        ts_ls = {},
        jsonls = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                ['https://json.schemastore.org/github-action.json'] = '.github/action.{yml,yaml}',
                ['https://json.schemastore.org/prettierrc.json'] = '.prettierrc.{yml,yaml}',
                ['https://json.schemastore.org/docker-compose.json'] = 'docker-compose.{yml,yaml}',
              },
            },
          },
        },
        dockerls = {},
        docker_compose_language_service = {},
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = {
                command = 'clippy',
              },
            },
          },
        },
        taplo = {},
        bashls = {},
      }

      for name, server in pairs(servers) do
        local server_capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        server_capabilities.offsetEncoding = { 'utf-16', 'utf-8' }

        server.capabilities = server_capabilities
        server.offset_encoding = 'utf-16'

        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },
}

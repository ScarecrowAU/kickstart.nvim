return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local conform = require 'conform'

      local js_formatters = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true }
      local json_formatters = { 'prettierd', 'prettier', 'jq', stop_after_first = true }
      local markdown_formatters = { 'prettierd', 'prettier', stop_after_first = true }
      local graphql_formatters = { 'prettierd', 'prettier', stop_after_first = true }
      local css_formatters = { 'prettierd', 'prettier', stop_after_first = true }
      local terraform_formatters = { 'tofu_fmt', 'terraform_fmt', stop_after_first = true }

      conform.setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          svelte = js_formatters,
          javascript = js_formatters,
          typescript = js_formatters,
          javascriptreact = js_formatters,
          typescriptreact = js_formatters,
          go = { 'gofmt' },
          json = json_formatters,
          graphql = graphql_formatters,
          java = { 'google-java-format' },
          kotlin = { 'ktlint' },
          ruby = { 'standardrb' },
          markdown = markdown_formatters,
          erb = { 'htmlbeautifier' },
          html = { 'htmlbeautifier' },
          bash = { 'beautysh' },
          proto = { 'buf' },
          rust = { 'rustfmt' },
          yaml = { 'yamlfix' },
          toml = { 'taplo' },
          css = css_formatters,
          scss = css_formatters,
          terraform = terraform_formatters,
        },
      }

      vim.keymap.set(
        { 'n', 'v' },
        '<leader>fb',
        function()
          require('conform').format {
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
          }
        end,
        { desc = '[F]ormat [B]uffer' }
      )

      vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function(args)
          require('conform').format {
            bufnr = args.buf,
            lsp_fallback = true,
          }
        end,
      })
    end,
  },
}

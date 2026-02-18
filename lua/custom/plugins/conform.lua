return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local conform = require 'conform'
      local utils = require 'custom.utils'

      local function js_formatters(bufnr)
        local buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:h')
        if utils.has_prettier_config(buf_dir) then
          return { 'prettierd', 'prettier', stop_after_first = true }
        end
        if utils.has_oxc_config(buf_dir) then
          return { 'oxfmt' }
        end
        return { 'prettierd', 'prettier', stop_after_first = true }
      end

      local function json_formatters(bufnr)
        local buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:h')
        if utils.has_prettier_config(buf_dir) then
          return { 'prettierd', 'prettier', stop_after_first = true }
        end
        return { 'prettierd', 'prettier', 'jq', stop_after_first = true }
      end

      local prettier_formatters = { 'prettierd', 'prettier', stop_after_first = true }
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
          graphql = prettier_formatters,
          java = { 'google-java-format' },
          kotlin = { 'ktlint' },
          ruby = { 'standardrb' },
          markdown = prettier_formatters,
          erb = { 'htmlbeautifier' },
          html = { 'htmlbeautifier' },
          bash = { 'beautysh' },
          proto = { 'buf' },
          rust = { 'rustfmt' },
          yaml = { 'yamlfix' },
          toml = { 'taplo' },
          css = prettier_formatters,
          scss = prettier_formatters,
          terraform = terraform_formatters,
          python = { 'ruff_format', 'ruff_organize_imports' },
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

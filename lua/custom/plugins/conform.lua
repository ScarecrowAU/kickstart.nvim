return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local conform = require 'conform'

      local function get_formatters_with_prettier_check(normal_order, prettier_only)
        return function(bufnr)
          local buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:h')

          local prettier_configs = {
            '.prettierrc',
            '.prettierrc.json',
            '.prettierrc.js',
            '.prettierrc.cjs',
            '.prettierrc.mjs',
            '.prettierrc.yaml',
            '.prettierrc.yml',
            '.prettierrc.toml',
            'prettier.config.js',
            'prettier.config.cjs',
            'prettier.config.mjs',
          }

          local current_dir = buf_dir
          while current_dir ~= '/' do
            for _, config in ipairs(prettier_configs) do
              if vim.fn.filereadable(current_dir .. '/' .. config) == 1 then
                return prettier_only
              end
            end

            local package_json = current_dir .. '/package.json'
            if vim.fn.filereadable(package_json) == 1 then
              local content = vim.fn.readfile(package_json)
              local json_str = table.concat(content, '\n')
              if json_str:match '"prettier"' then
                return prettier_only
              end
            end

            current_dir = vim.fn.fnamemodify(current_dir, ':h')
          end

          return normal_order
        end
      end

      local js_formatters = get_formatters_with_prettier_check(
        { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
        { 'prettierd', 'prettier', stop_after_first = true }
      )
      local json_formatters = get_formatters_with_prettier_check(
        { 'prettierd', 'prettier', 'jq', stop_after_first = true },
        { 'prettierd', 'prettier', stop_after_first = true }
      )
      local markdown_formatters = get_formatters_with_prettier_check(
        { 'prettierd', 'prettier', stop_after_first = true },
        { 'prettierd', 'prettier', stop_after_first = true }
      )
      local graphql_formatters = { 'prettierd', 'prettier', stop_after_first = true }
      local css_formatters = get_formatters_with_prettier_check(
        { 'prettierd', 'prettier', stop_after_first = true },
        { 'prettierd', 'prettier', stop_after_first = true }
      )
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

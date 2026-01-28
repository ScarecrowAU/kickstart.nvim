return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local conform = require 'conform'
      
      -- Check if biome is available
      local has_biome = vim.fn.executable('biome') == 1
      
      -- Build formatters list based on what's available
      local js_formatters = has_biome and { 'biome' } or { 'prettierd', 'prettier', stop_after_first = true }
      
      conform.setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          svelte = js_formatters,
          javascript = js_formatters,
          typescript = js_formatters,
          javascriptreact = js_formatters,
          typescriptreact = js_formatters,
          go = { 'gofmt' },
          json = has_biome and { 'biome' } or { 'prettierd', 'prettier', 'jq', stop_after_first = true },
          graphql = { 'prettierd', 'prettier', stop_after_first = true },
          java = { 'google-java-format' },
          kotlin = { 'ktlint' },
          ruby = { 'standardrb' },
          markdown = { 'prettierd', 'prettier', stop_after_first = true },
          erb = { 'htmlbeautifier' },
          html = { 'htmlbeautifier' },
          bash = { 'beautysh' },
          proto = { 'buf' },
          rust = { 'rustfmt' },
          yaml = { 'yamlfix' },
          toml = { 'taplo' },
          css = { 'prettierd', 'prettier', stop_after_first = true },
          scss = { 'prettierd', 'prettier', stop_after_first = true },
          terraform = { 'tofu_fmt', 'terraform_fmt', stop_after_first = true },
        },

        vim.keymap.set({ 'n', 'v' }, '<leader>fb', function()
          require('conform').format {
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
          }
        end, { desc = '[F]ormat [B]uffer' }),

        vim.api.nvim_create_autocmd('BufWritePre', {
          callback = function(args)
            require('conform').format { bufnr = args.buf }
          end,
        }),
      }
    end,
  },
}

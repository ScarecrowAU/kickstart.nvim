return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
    },
    config = function()
      local telescope = require 'telescope'
      local themes = require 'telescope.themes'
      local builtin = require 'telescope.builtin'

      telescope.setup {
        pickers = {
          find_files = {
            hidden = true,
          },
          buffers = {
            sort_lastused = true,
          },
          grep_string = {
            additional_args = { '--hidden' },
            glob_pattern = { '!node_modules', '!.git', '!dist', '!pnpm-lock.yaml' },
          },
          live_grep = {
            additional_args = { '--hidden' },
            glob_pattern = { '!node_modules', '!.git', '!dist', '!pnpm-lock.yaml' },
          },
        },
        ignore_patterns = { 'node_modules', 'dist', '.git/' },
        extensions = {
          ['ui-select'] = {
            themes.get_dropdown(),
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
              },
            },
          },
        },
      }

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      pcall(telescope.load_extension, 'live_grep_args')
    end,
  },
}

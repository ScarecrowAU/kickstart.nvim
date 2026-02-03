return {
  { -- Fuzzy Finder (files, lsp, etc)
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

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gi', builtin.lsp_implementations, { desc = '[G]oto [I]mplementations' })

      vim.keymap.set(
        'n',
        '<leader>/',
        function()
          builtin.current_buffer_fuzzy_find(themes.get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        { desc = '[/] Fuzzily search in current buffer' }
      )

      vim.keymap.set(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        { desc = '[S]earch [/] in Open Files' }
      )

      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

      -- Live grep with args (supports advanced ripgrep syntax)
      vim.keymap.set('n', '<leader>fg', function() telescope.extensions.live_grep_args.live_grep_args() end, { desc = '[F]ind [G]rep with args' })

      -- Open the telescope file browser with <leader>ff
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find [F]iles' })
      vim.keymap.set(
        'n',
        '<leader>fa',
        function() builtin.find_files { hidden = true, ignore_patterns = {}, glob_pattern = {}, no_ignore = true } end,
        { desc = '[F]ind [A]ll Files' }
      )

      vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = '[B]uffers' })
      vim.keymap.set('n', '<leader>bo', builtin.oldfiles, { desc = '[B]rowse [O]ld Files' })
    end,
  },
}

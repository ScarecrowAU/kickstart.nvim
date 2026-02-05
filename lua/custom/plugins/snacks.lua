return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      local explorer_keys = {
        ['<esc>'] = '',
        ['q'] = '',
        ['<C-b>'] = function()
          vim.cmd 'wincmd p'
        end,
        -- File modification keybinds (matching nvim-tree)
        ['a'] = 'explorer_add',
        ['d'] = 'explorer_del',
        ['r'] = 'explorer_rename',
        ['c'] = 'explorer_copy',
        ['x'] = 'explorer_move',
        ['p'] = 'explorer_paste',
        ['y'] = 'explorer_yank',
      }

      local snacks = require('snacks')
      snacks.setup({
      bigfile = { enabled = true },
      notifier = {
        enabled = false,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      animate = { enabled = true },
      dashboard = { enabled = true },
      dim = { enabled = true },
      explorer = { enabled = true },
      indent = {
        enabled = true,
        char = '│',
        scope = {
          enabled = true,
          char = '┃',
          underline = false,
          hl = 'SnacksIndentScope',
        },
      },
      input = { enabled = true },
      keymap = { enabled = true },
      rename = { enabled = true },
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ['<PageUp>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              ['<PageDown>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            },
          },
        },
        sources = {
          explorer = {
            win = {
              input = { keys = explorer_keys },
              list = { keys = explorer_keys },
              preview = { keys = explorer_keys },
            },
          },
        },
      },
      scratch = { enabled = true },
      scroll = { enabled = true },
      terminal = { enabled = true },
      zen = { enabled = true },
      })

      -- Set up diagnostic keybindings after Snacks is loaded
      local function go_to_next_error()
        vim.diagnostic.jump { count = 1, float = true }
      end
      local function go_to_prev_error()
        vim.diagnostic.jump { count = -1, float = true }
      end

      require('snacks').keymap.set('n', '<leader>dr', vim.diagnostic.reset, { desc = '[D]iagnostic [R]eset' })
      require('snacks').keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
      require('snacks').keymap.set('n', '<leader>en', go_to_next_error, { desc = 'Show diagnostic [E]rror [N]ext' })
      require('snacks').keymap.set('n', '<leader>ep', go_to_prev_error, { desc = 'Show diagnostic [E]rror [P]revious' })
      require('snacks').keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
      require('snacks').keymap.set('n', '[d', go_to_prev_error, { desc = 'Go to previous [D]iagnostic message' })
      require('snacks').keymap.set('n', ']d', go_to_next_error, { desc = 'Go to next [D]iagnostic message' })
      require('snacks').keymap.set('n', 'e', go_to_next_error, { desc = 'Go to next [E]rror' })
      require('snacks').keymap.set('n', 'E', go_to_prev_error, { desc = 'Go to previous [E]rror' })

      require('snacks').keymap.set('n', 'K', vim.lsp.buf.hover, {
        lsp = { method = 'textDocument/hover' },
        desc = 'Hover Documentation',
      })
      require('snacks').keymap.set('n', '<F2>', vim.lsp.buf.rename, {
        lsp = { method = 'textDocument/rename' },
        desc = '[R]e[n]ame',
      })

      local function setup_indent_colors()
        vim.api.nvim_set_hl(0, 'SnacksIndentScope', { fg = '#00D7FF', bold = true })
      end

      setup_indent_colors()
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = setup_indent_colors,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
          snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
          snacks.toggle.diagnostics():map '<leader>ud'
          snacks.toggle.dim():map '<leader>uD'
          snacks.toggle.zen():map '<leader>uz'
          snacks.toggle.scroll():map '<leader>uS'
        end,
      })
    end,
    keys = {
      { '<leader>un', function() require('snacks').notifier.hide() end, desc = 'Dismiss all notifications' },
      { '<leader>bd', function() require('snacks').bufdelete() end, desc = 'Delete buffer' },
      { '<leader>lg', function() require('snacks').lazygit() end, desc = 'Lazygit' },
      { '<leader>gb', function() require('snacks').git.blame_line() end, desc = 'Git blame line' },
      { '<leader>gB', function() require('snacks').gitbrowse() end, desc = 'Git browse' },
      { '<leader>tt', function() require('snacks').terminal() end, desc = 'Toggle terminal', mode = 'n' },
      { '<M-t>', function() require('snacks').terminal() end, desc = 'Toggle terminal', mode = { 'n', 't' } },
      { '<A-t>', function() require('snacks').terminal() end, desc = 'Toggle terminal', mode = { 'n', 't' } },
      { '<C-/>', function() require('snacks').terminal() end, desc = 'Toggle terminal', mode = { 'n', 't' } },
      { '<C-`>', function() require('snacks').terminal() end, desc = 'Toggle terminal', mode = { 'n', 't' } },
      { '<leader>ns', function() require('snacks').scratch() end, desc = 'New scratch buffer' },
      { '<leader>nS', function() require('snacks').scratch.select() end, desc = 'Select scratch buffer' },
      { '<leader>z', function() require('snacks').zen() end, desc = 'Toggle zen mode' },
      { '<leader>Z', function() require('snacks').zen.zoom() end, desc = 'Zoom window' },
      { '<leader>h', function() require('snacks').dashboard() end, desc = 'Dashboard' },
      { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
      { '<leader>fa', function() Snacks.picker.files({ hidden = true, no_ignore = true }) end, desc = '[F]ind [A]ll Files' },
      { '<leader>fg', function() Snacks.picker.grep() end, desc = '[F]ind [G]rep' },
      { '<leader>sw', function() Snacks.picker.grep_word() end, desc = '[S]earch current [W]ord' },
      { '<leader>f/', function() Snacks.picker.grep_buffers() end, desc = '[F]ind [/] in Open Files' },
      { '<leader><leader>', function() Snacks.picker.buffers() end, desc = 'Find existing buffers' },
      { '<leader>bb', function() Snacks.picker.buffers() end, desc = '[B]uffers' },
      { '<leader>s.', function() Snacks.picker.recent() end, desc = '[S]earch Recent Files' },
      { '<leader>bo', function() Snacks.picker.recent() end, desc = '[B]rowse [O]ld Files' },
      { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp' },
      { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[S]earch [K]eymaps' },
      { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
      { '<leader>/', function() Snacks.picker.lines() end, desc = '[/] Fuzzily search in current buffer' },
      { '<leader>sn', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = '[S]earch [N]eovim files' },
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = '[G]oto [D]efinition' },
      { 'gr', function() Snacks.picker.lsp_references() end, desc = '[G]oto [R]eferences' },
      { 'gi', function() Snacks.picker.lsp_implementations() end, desc = '[G]oto [I]mplementations' },
      {
        '<C-b>',
        function()
          local current_buf = vim.api.nvim_get_current_buf()
          local current_ft = vim.bo[current_buf].filetype

          local explorer_win = nil
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft:match '^snacks' then
              explorer_win = win
              break
            end
          end

          if current_ft:match '^snacks' then
            vim.cmd 'wincmd p'
          elseif explorer_win then
            vim.api.nvim_set_current_win(explorer_win)
          else
            require('snacks').explorer()
          end
        end,
        desc = 'Toggle explorer',
      },
      {
        '<leader>kb',
        function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft:match '^snacks' then
              vim.api.nvim_win_close(win, false)
              return
            end
          end
          require('snacks').explorer()
        end,
        desc = 'Toggle explorer',
      },
      init = function()
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'FileType' }, {
          callback = function(event)
            local ft = vim.bo[event.buf].filetype
            local bufname = vim.api.nvim_buf_get_name(event.buf)
            if ft == 'snacks_explorer' or bufname:match 'snacks://explorer' then
              vim.defer_fn(function()
                if vim.api.nvim_buf_is_valid(event.buf) then
                  vim.keymap.set('n', '<C-b>', function()
                    vim.cmd 'wincmd p'
                  end, { buffer = event.buf, noremap = true, nowait = true, silent = true, desc = 'Go back to code' })

                  vim.keymap.set('n', '<Esc>', function() end, { buffer = event.buf, noremap = true, nowait = true, silent = true })
                  vim.keymap.set('n', 'q', function() end, { buffer = event.buf, noremap = true, nowait = true, silent = true })
                end
              end, 500)
            end
          end,
        })
      end,
    },
  },
}

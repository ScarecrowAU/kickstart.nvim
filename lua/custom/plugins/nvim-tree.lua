return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local nvimTree = require 'nvim-tree'
      local api = require 'nvim-tree.api'

      nvimTree.setup {
        disable_netrw = true,
        hijack_netrw = true,
        diagnostics = {
          enable = false, -- Disabled to avoid sign errors
        },
        update_focused_file = {
          enable = true,
          update_cwd = false,
        },
        system_open = {
          cmd = nil,
          args = {},
        },
        view = {
          width = 35,
          side = 'left',
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
          custom = { '^.git$', 'node_modules', '\\.cache', '\\.next', '\\.DS_Store', 'next-env.d.ts' },
        },
      }

      -- Mark nvim-tree window as fixed width
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'NvimTree',
        callback = function() vim.opt_local.winfixwidth = true end,
      })

      -- Smart focus: open/focus tree, or go back to last buffer if already focused
      local function smart_tree_focus()
        local current_buf = vim.api.nvim_get_current_buf()
        local current_ft = vim.bo[current_buf].filetype

        if current_ft == 'NvimTree' then
          -- Already in tree, go back to last buffer
          vim.cmd 'wincmd p'
        else
          -- Open tree if closed, or focus it if open
          api.tree.focus()
        end
      end

      vim.keymap.set('n', '<C-b>', smart_tree_focus, { noremap = true, silent = true, desc = 'Focus/unfocus file tree' })
      vim.keymap.set('n', '<leader>kb', '<CMD>NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'Toggle file tree' })
    end,
  },
}

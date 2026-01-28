vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

return {
  {
    'folke/persistence.nvim',
    event = 'VimEnter',
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath 'data' .. '/sessions/'),
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
    },
    config = function(_, opts)
      require('persistence').setup(opts)

      -- Auto-restore session when opening Neovim in a directory
      local function restore_session()
        -- Only load the session if nvim was started with no arguments
        if vim.fn.argc() == 0 then
          vim.defer_fn(function()
            require('persistence').load()

            -- Check if nvim-tree window exists but is empty, and reopen it
            vim.defer_fn(function()
              local current_win = vim.api.nvim_get_current_win()
              local tree_win = nil

              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.bo[buf].filetype
                if ft == 'NvimTree' then
                  tree_win = win
                  -- Close the empty tree window and reopen properly
                  vim.api.nvim_win_close(win, true)
                  vim.cmd 'NvimTreeOpen'
                  break
                end
              end

              -- If we reopened the tree and we weren't focused on it, restore focus
              if tree_win and current_win ~= tree_win then vim.api.nvim_set_current_win(current_win) end
            end, 50)
          end, 100)
        end
      end

      -- Try to restore immediately if we're already past VimEnter
      if vim.v.vim_did_enter == 1 then
        restore_session()
      else
        vim.api.nvim_create_autocmd('VimEnter', {
          callback = restore_session,
          once = true,
        })
      end
    end,
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = '[Q]uit [S]ession Restore' },
      { '<leader>ql', function() require('persistence').load { last = true } end, desc = '[Q]uit [L]ast Session' },
      { '<leader>qd', function() require('persistence').stop() end, desc = "[Q]uit [D]on't Save Session" },
      {
        '<leader>qq',
        function()
          require('persistence').save()
          vim.cmd 'qall'
        end,
        desc = '[Q]uit and save session',
      },
      {
        '<leader>qQ',
        function()
          require('persistence').stop()
          vim.cmd 'qall'
        end,
        desc = '[Q]uit without updating session',
      },
    },
  },
}

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

      local function restore_session()
        if vim.fn.argc() == 0 then
          vim.defer_fn(function()
            require('persistence').load()

            vim.defer_fn(function()
              local current_win = vim.api.nvim_get_current_win()
              local explorer_win = nil
              local was_in_explorer = false

              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.bo[buf].filetype
                if ft:match '^snacks' then
                  explorer_win = win
                  was_in_explorer = (current_win == win)
                  vim.api.nvim_win_close(win, true)
                  require('snacks').explorer()
                  break
                end
              end

              if explorer_win then
                vim.defer_fn(function()
                  for _, win in ipairs(vim.api.nvim_list_wins()) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    local ft = vim.bo[buf].filetype
                    if not ft:match '^snacks' then
                      vim.api.nvim_set_current_win(win)
                      break
                    end
                  end
                end, 10)
              end
            end, 50)
          end, 100)
        end
      end

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

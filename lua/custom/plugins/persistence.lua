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
          vim.schedule(function()
            pcall(require('persistence').load)

            vim.schedule(function()
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == 'NvimTree' then
                  if #vim.api.nvim_list_wins() > 1 then
                    vim.api.nvim_win_close(win, true)
                  end
                  break
                end
              end

              require('nvim-tree.api').tree.open()

              -- Focus an editor window
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype ~= 'NvimTree' then
                  vim.api.nvim_set_current_win(win)
                  break
                end
              end
            end)
          end)
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

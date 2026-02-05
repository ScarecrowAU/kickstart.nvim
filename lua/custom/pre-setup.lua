-- Wrap vim.notify to handle fast event contexts
-- This prevents errors when plugins call vim.notify during fast events
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  -- Use pcall to catch fast event errors and schedule the notification
  local ok, err = pcall(original_notify, msg, level, opts)
  if not ok and err:match("E5560") then
    -- If we're in a fast event context, schedule for later
    vim.schedule(function()
      original_notify(msg, level, opts)
    end)
  end
end

vim.g.have_nerd_font = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.api.nvim_create_user_command('CopyPathToFile', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
vim.api.nvim_create_user_command('CopyPathToDir', function()
  local path = vim.fn.expand '%:p:h'
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

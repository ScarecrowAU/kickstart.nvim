-- Commands to be configured before plugin imports
vim.g.have_nerd_font = true

vim.opt.relativenumber = true

-- Set tab width
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

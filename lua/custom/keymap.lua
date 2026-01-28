local function go_to_next_error() vim.diagnostic.jump { count = 1, float = true } end

local function go_to_prev_error() vim.diagnostic.jump { count = -1, float = true } end

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dr', vim.diagnostic.reset, { desc = '[D]iagnostic [R]eset' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>en', go_to_next_error, { desc = 'Show diagnostic [E]rror [N]ext' })
vim.keymap.set('n', '<leader>ep', go_to_prev_error, { desc = 'Show diagnostic [E]rror [P]revious' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '[d', go_to_prev_error, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', go_to_next_error, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', 'e', go_to_next_error, { desc = 'Go to next [E]rror' })
vim.keymap.set('n', 'E', go_to_prev_error, { desc = 'Go to previous [E]rror' })

-- Window management - Arrow keys
vim.keymap.set('n', '<C-Down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- Disabled <C-Left>/<C-Right> to allow word navigation via ghostty
-- vim.keymap.set('n', '<C-Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-Up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window management - hjkl (same as init.lua for consistency)
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })

-- Smart window cycling that skips special buffers like nvim-tree
local function smart_window_cycle()
  local current_win = vim.api.nvim_get_current_win()
  vim.cmd 'wincmd w'
  local new_win = vim.api.nvim_get_current_win()
  local filetype = vim.bo.filetype

  -- If we landed on nvim-tree or other special filetypes, cycle again
  local skip_filetypes = { 'NvimTree', 'neo-tree', 'undotree', 'diff' }
  if vim.tbl_contains(skip_filetypes, filetype) and current_win ~= new_win then vim.cmd 'wincmd w' end
end

vim.keymap.set('n', '<C-w>w', smart_window_cycle, { desc = 'Cycle windows (skip special buffers)' })
vim.keymap.set('n', '<C-w><C-w>', smart_window_cycle, { desc = 'Cycle windows (skip special buffers)' })

vim.keymap.set('n', '<leader>wd', '<cmd>close<CR>', { desc = '[W]indow [D]elete' })
vim.keymap.set('n', '<leader>ws', '<cmd>split<CR>', { desc = '[W]indow [S]plit Horizontal' })
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = '[W]indow Split [V]ertical' })

-- Buffer management
vim.keymap.set('n', '<leader>bc', '<cmd>enew<CR>', { desc = '[B]uffer [C]reate' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>bn', '<cmd>bn<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', '<cmd>bp<CR>', { desc = '[B]uffer [P]revious' })
vim.keymap.set('n', '<leader>bq', '<cmd>bd<CR>', { desc = '[B]uffer [Q]uit' })
vim.keymap.set('n', '<leader>nn', '<cmd>enew<CR>', { desc = '[N]ew Buffer' })

-- Alt+Shift+C to force delete buffer (like Bdelete but ignores unsaved changes)
vim.keymap.set('n', '<A-C>', '<cmd>Bdelete!<CR>', { desc = 'Force delete buffer' })
vim.keymap.set('n', '<M-C>', '<cmd>Bdelete!<CR>', { desc = 'Force delete buffer' })
vim.keymap.set('n', '<Esc>C', '<cmd>Bdelete!<CR>', { desc = 'Force delete buffer' })

-- Quit
-- <leader>qq is handled by persistence.nvim for session save + quit
vim.keymap.set('n', '<leader>wq', '<cmd>wq<CR>', { desc = '[W]rite and [Q]uit' })
vim.keymap.set('n', '<leader>ww', '<cmd>w<CR>', { desc = '[W]rite' })

-- Command results
vim.keymap.set('n', '<leader>cc', '<cmd>cclose<CR>', { desc = '[C]ommand Results [C]lose' })
vim.keymap.set('n', '<leader>co', '<cmd>copen<CR>', { desc = '[C]ommand Results [O]pen' })

-- Opens a popup that displays documentation about the word under your cursor
--  See `:help K` for why this keymap.
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })

-- General keymaps
vim.keymap.set('n', '<A-Down>', ':m .+1<CR>==', { desc = 'Move line [D]own' })
vim.keymap.set('n', '<A-Up>', ':m .-2<CR>==', { desc = 'Move line [U]p' })

-- Move cursor by viewport height
local function move_viewport_down()
  local height = vim.api.nvim_win_get_height(0)
  vim.cmd('normal! ' .. height .. 'j')
end

local function move_viewport_up()
  local height = vim.api.nvim_win_get_height(0)
  vim.cmd('normal! ' .. height .. 'k')
end

vim.keymap.set('n', '<S-Down>', move_viewport_down, { desc = 'Move cursor down by viewport height' })
vim.keymap.set('n', '<S-Up>', move_viewport_up, { desc = 'Move cursor up by viewport height' })
vim.keymap.set('v', '<S-Down>', move_viewport_down, { desc = 'Move cursor down by viewport height' })
vim.keymap.set('v', '<S-Up>', move_viewport_up, { desc = 'Move cursor up by viewport height' })

-- Jump list navigation (try multiple key codes for Mac compatibility)
vim.keymap.set('n', '<A-Left>', '<C-o>', { desc = 'Jump to previous location' })
vim.keymap.set('n', '<A-Right>', '<C-i>', { desc = 'Jump to next location' })
vim.keymap.set('n', '<M-Left>', '<C-o>', { desc = 'Jump to previous location' })
vim.keymap.set('n', '<M-Right>', '<C-i>', { desc = 'Jump to next location' })
-- Escape sequences that some Mac terminals send for Option+Arrow
vim.keymap.set('n', '<Esc>b', '<C-o>', { desc = 'Jump to previous location' })
vim.keymap.set('n', '<Esc>f', '<C-i>', { desc = 'Jump to next location' })
vim.keymap.set('n', 'U', '<cmd>redo<CR>', { desc = 'Redo' })
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move line [D]own' })
vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move line [U]p' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent and reselect' })
vim.keymap.set('v', '<', '<gv', { desc = 'Dedent and reselect' })
vim.keymap.set({ 'n', 'v' }, ';', ':')
vim.keymap.set({ 'n', 'v' }, '<M-y>', '<C-y>', { desc = 'Accept current completion' })

vim.keymap.set('n', '<leader>fd', '<cmd>CopyPathToDir<CR>', { desc = 'Copy Current [F]ile [D]irectory' })
vim.keymap.set('n', '<leader>fp', '<cmd>CopyPathToFile<CR>', { desc = 'Copy Current [F]ile [P]ath' })

-- LSP keymaps
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<CR>', { desc = '[L]anguage Server [R]estart' })

-- Disable C-e/C-y scrolling since Karabiner sends these for Ctrl+Arrow keys
vim.keymap.set('n', '<C-e>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<C-y>', '<Nop>', { noremap = true })
vim.keymap.set('i', '<C-e>', '<Nop>', { noremap = true })
vim.keymap.set('i', '<C-y>', '<Nop>', { noremap = true })

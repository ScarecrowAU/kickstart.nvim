return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/nvim-treesitter/runtime')

      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}

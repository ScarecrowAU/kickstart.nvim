return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Add runtime subdirectory to runtimepath for query files
      vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/nvim-treesitter/runtime')
      
      -- Enable treesitter highlighting for all filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}

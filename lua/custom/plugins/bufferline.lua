return {
  {
    'akinsho/bufferline.nvim',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'moll/vim-bbye',
    },
    opts = {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)

      local map = vim.keymap.set

      map('n', '<A-,>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
      map('n', '<A-.>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
      map('n', '<A-<>', '<cmd>BufferLineMovePrev<cr>', { desc = 'Move buffer left' })
      map('n', '<A->>', '<cmd>BufferLineMoveNext<cr>', { desc = 'Move buffer right' })

      map('n', '<A-1>', '<cmd>BufferLineGoToBuffer 1<cr>', { desc = 'Go to buffer 1' })
      map('n', '<A-2>', '<cmd>BufferLineGoToBuffer 2<cr>', { desc = 'Go to buffer 2' })
      map('n', '<A-3>', '<cmd>BufferLineGoToBuffer 3<cr>', { desc = 'Go to buffer 3' })
      map('n', '<A-4>', '<cmd>BufferLineGoToBuffer 4<cr>', { desc = 'Go to buffer 4' })
      map('n', '<A-5>', '<cmd>BufferLineGoToBuffer 5<cr>', { desc = 'Go to buffer 5' })
      map('n', '<A-6>', '<cmd>BufferLineGoToBuffer 6<cr>', { desc = 'Go to buffer 6' })
      map('n', '<A-7>', '<cmd>BufferLineGoToBuffer 7<cr>', { desc = 'Go to buffer 7' })
      map('n', '<A-8>', '<cmd>BufferLineGoToBuffer 8<cr>', { desc = 'Go to buffer 8' })
      map('n', '<A-9>', '<cmd>BufferLineGoToBuffer 9<cr>', { desc = 'Go to buffer 9' })
      map('n', '<A-0>', '<cmd>BufferLineGoToLast<cr>', { desc = 'Last buffer' })

      map('n', '<A-p>', '<cmd>BufferLineTogglePin<cr>', { desc = 'Toggle pin' })
      map('n', '<A-c>', '<cmd>Bdelete<cr>', { desc = 'Delete buffer' })
      map('n', '<C-p>', '<cmd>BufferLinePick<cr>', { desc = 'Pick buffer' })
      map('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Close other buffers' })
      map('n', '<leader>br', '<cmd>BufferLineCloseRight<cr>', { desc = 'Close buffers to right' })
      map('n', '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', { desc = 'Close buffers to left' })
    end,
  },
}

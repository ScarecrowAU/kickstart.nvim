return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('codecompanion').setup {
      interactions = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
      adapters = {
        http = {
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
              schema = {
                model = {
                  default = 'claude-sonnet-4.5',
                },
              },
            })
          end,
          ollama = function()
            return require('codecompanion.adapters').extend('ollama', {
              schema = {
                model = {
                  default = 'qwen3-coder:30b',
                },
              },
            })
          end,
        },
        -- TODO: Copilot ACP adapter not yet supported by codecompanion
        -- acp = {
        --   copilot_cli = function()
        --     return require('codecompanion.adapters').extend('copilot', {
        --       name = 'copilot_cli',
        --       commands = {
        --         default = {
        --           'copilot',
        --           '--acp',
        --           '--allow-all-tools',
        --         },
        --       },
        --       defaults = {
        --         model = 'claude-sonnet-4.5',
        --       },
        --     })
        --   end,
        -- },
      },
      display = {
        chat = {
          window = {
            layout = 'vertical',
          },
        },
      },
    }

    -- Keymaps
    vim.keymap.set('n', '<leader>cc', '<cmd>CodeCompanionChat<cr>', { desc = '[C]ode [C]ompanion Chat' })
    vim.keymap.set('v', '<leader>cc', '<cmd>CodeCompanionChat<cr>', { desc = '[C]ode [C]ompanion Chat' })
    vim.keymap.set('n', '<leader>ca', '<cmd>CodeCompanionActions<cr>', { desc = '[C]ode [C]ompanion [A]ctions' })
    vim.keymap.set('v', '<leader>ca', '<cmd>CodeCompanionActions<cr>', { desc = '[C]ode [C]ompanion [A]ctions' })
    vim.keymap.set('n', '<leader>ct', '<cmd>CodeCompanionChat Toggle<cr>', { desc = '[C]ode [C]ompanion [T]oggle' })
    vim.keymap.set('v', '<leader>ca', '<cmd>CodeCompanionChat Add<cr>', { desc = '[C]ode [C]ompanion [A]dd' })

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd [[cab cc CodeCompanion]]
  end,
}

return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-plenary',
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
    },
    config = function()
      -- Helper function to check if Jest is configured in the project
      local function has_jest_config()
        local jest_files = vim.fs.find({
          'jest.config.js',
          'jest.config.ts',
          'jest.config.mjs',
          'jest.config.cjs',
          'jest.config.json',
        }, { upward = true, type = 'file' })

        if #jest_files > 0 then return true end

        -- Check if package.json has jest configuration
        local package_json = vim.fs.find('package.json', { upward = true, type = 'file' })[1]
        if package_json then
          local ok, content = pcall(vim.fn.readfile, package_json)
          if ok then
            local json_str = table.concat(content, '\n')
            if json_str:match '"jest"' then return true end
          end
        end

        return false
      end

      -- Build adapters list dynamically
      local adapters = {
        require 'neotest-python' {
          dap = { justMyCode = false },
        },
        require 'neotest-plenary',
        require 'neotest-vitest',
        require 'custom.packages.neotest-cypress',
      }

      -- Only add Jest adapter if Jest is configured in the project
      if has_jest_config() then
        table.insert(
          adapters,
          require 'neotest-jest' {
            jestCommand = 'npm test --',
            env = { CI = true },
            cwd = function(path)
              local file_dir = vim.fn.fnamemodify(path, ':p:h')
              local root = vim.fs.find('package.json', {
                path = file_dir,
                upward = true,
                type = 'file',
              })[1]
              return root and vim.fs.dirname(root) or vim.fn.getcwd()
            end,
          }
        )
      end

      require('neotest').setup {
        adapters = adapters,
      }

      local neotest = require 'neotest'
      vim.keymap.set('n', '<leader>tn', function() neotest.run.run() end, { desc = '[T]est [N]earest' })
      vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand '%') end, { desc = '[T]est [F]ile' })
      vim.keymap.set('n', '<leader>tp', function() neotest.output_panel.toggle() end, { desc = '[T]est Output [P]anel' })
      vim.keymap.set('n', '<leader>to', function() neotest.output.open() end, { desc = '[T]est [O]utput' })
      vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end, { desc = '[T]est [S]ummary' })

      -- Cypress interactive keybindings (Snacks.terminal — not replaceable by neotest)
      local cypress_adapter = require 'custom.packages.neotest-cypress'

      vim.keymap.set('n', '<leader>tco', function()
        local current_file = vim.fn.expand '%:p'
        local root = cypress_adapter.root(vim.fn.fnamemodify(current_file, ':h'))
        if not root then return vim.notify('No cypress.config found', vim.log.levels.WARN) end
        Snacks.terminal('pnpm run cy:open', { cwd = root })
      end, { desc = '[T]est [C]ypress [O]pen (component)' })

      vim.keymap.set('n', '<leader>tce', function()
        local current_file = vim.fn.expand '%:p'
        local root = cypress_adapter.root(vim.fn.fnamemodify(current_file, ':h'))
        if not root then return vim.notify('No cypress.config found', vim.log.levels.WARN) end
        Snacks.terminal('pnpm run cy:open --e2e', { cwd = root })
      end, { desc = '[T]est [C]ypress [E]2e open' })
    end,
  },
}

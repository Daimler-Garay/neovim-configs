return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },

    {
      '<leader>dm',
      function()
        require('dap-python').test_method()
      end,
      desc = 'Debug: pytest method',
    },
    {
      '<leader>dc',
      function()
        require('dap-python').test_class()
      end,
      desc = 'Debug: pytest class',
    },
    {
      '<leader>ds',
      function()
        require('dap-python').debug_selection()
      end,
      desc = 'Debug: selection',
    },
  },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
        'codelldb',
        'python',
      },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }
    require('nvim-dap-virtual-text').setup()

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    require('dap-go').setup {
      delve = { detached = vim.fn.has 'win32' == 0 },
    }

    local function python_path()
      for _, v in ipairs { '.venv', 'venv', '.env' } do
        local exe = (vim.fn.has 'win32' == 1) and (v .. '\\Scripts\\python.exe') or (v .. '/bin/python')
        if vim.fn.executable(exe) == 1 then
          return exe
        end
      end
      if vim.fn.executable 'python3' == 1 then
        return 'python3'
      end
      return 'python'
    end

    require('dap-python').setup(python_path())

    local dap_py = require 'dap-python'
    dap_py.test_runner = 'pytest'
    dap_py.setup_args = { '--log-cli-level=INFO' }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        justMyCode = true,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Module: run -m <module>',
        module = function()
          return vim.fn.input 'Module to run (e.g. package.module): '
        end,
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        justMyCode = true,
      },
      {
        type = 'python',
        request = 'attach',
        name = 'Attach to process',
        processId = require('dap.utils').pick_process,
        justMyCode = false,
      },
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'python',
      callback = function()
        dap.listeners.after.event_initialized['dapui_python_autopen'] = function()
          dapui.open()
        end
      end,
    })
  end,
}

vim.g.rustaceanvim = function()
  -- Update this path
  local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = extension_path .. 'lldb/lib/liblldb'
  local this_os = vim.uv.os_uname().sysname

  -- The path is different on Windows
  if this_os:find 'Windows' then
    codelldb_path = extension_path .. 'adapter\\codelldb.exe'
    liblldb_path = extension_path .. 'lldb\\bin\\liblldb.dll'
  else
    -- The liblldb extension is .so for Linux and .dylib for MacOS
    liblldb_path = liblldb_path .. (this_os == 'Linux' and '.so' or '.dylib')
  end

  local cfg = require 'rustaceanvim.config'
  return {
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
  }
end

return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  ft = 'rust',
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set('n', '<leader>cq', function()
        vim.cmd.RustLsp 'codeAction'
      end, { desc = 'Code Action', buffer = bufnr })
      vim.keymap.set('n', '<leader>dr', function()
        vim.cmd.RustLsp 'debuggables'
      end, { desc = 'Rust Debuggables', buffer = bufnr })
    end,
  },
  ['rust-analyzer'] = {
    cargo = {
      allFeatures = true,
      loadOutDirsFromCheck = true,
      buildScripts = {
        enable = true,
      },
    },
    diagnostics = {
      enable = diagnostics == 'rust-analyzer',
    },
    procMacro = {
      enable = true,
      ignored = {
        ['async-trait'] = { 'async_trait' },
        ['napi-dereive'] = { 'napi' },
        ['async-recursion'] = { 'async_recursion' },
      },
    },
    files = {
      excludeDirs = {
        '.direnv',
        '.git',
        '.github',
        '.gitlab',
        'bin',
        'node_modules',
        'target',
        'venv',
        '.venv',
      },
    },
  },
}

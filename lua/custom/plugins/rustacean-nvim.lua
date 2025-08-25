return {
  'mrcjkb/rustaceanvim',
  version = '^4', -- keep in sync with stable
  ft = { 'rust' },
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          local keymap = vim.keymap.set
          local opts = { buffer = bufnr, silent = true, noremap = true }

          keymap('n', 'K', vim.lsp.buf.hover, opts)
          keymap('n', 'gd', vim.lsp.buf.definition, opts)
          keymap('n', 'gr', vim.lsp.buf.references, opts)
          keymap('n', '<leader>rn', vim.lsp.buf.rename, opts)
          keymap('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          keymap('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
        default_settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
          },
        },
      },
      tools = {
        hover_actions = { auto_focus = true },
      },
    }
  end,
}

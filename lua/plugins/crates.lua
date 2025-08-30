return {
  'saecki/crates.nvim',
  tag = 'stable',
  config = function()
    local ct = require 'crates'
    require('crates').setup {
      popup = {
        autofocus = true,
      },
      lsp = {
        enabled = true,
        on_attach = function(client, bufnr) end,
        actions = true,
        completion = true,
        hover = true,
      },
      completion = {
        crates = {
          enabled = true,
          max_results = 8,
          min_chars = 3,
        },
      },
    }
    -- Keymaps
    vim.keymap.set('n', '<leader>cu', ct.update_crate, { desc = 'Update crate under cursor' })
    vim.keymap.set('n', '<leader>ca', ct.update_all_crates, { desc = 'Update all crates' })
    vim.keymap.set('n', '<leader>cv', ct.show_versions_popup, { desc = 'Show crate versions' })
    vim.keymap.set('n', '<leader>cf', ct.show_features_popup, { desc = 'Show crate features' })
    vim.keymap.set('n', '<leader>cd', ct.show_dependencies_popup, { desc = 'Show crate dependencies' })
  end,
}

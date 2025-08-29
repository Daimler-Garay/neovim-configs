return {
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Setup mini.ai
      require('mini.ai').setup { n_lines = 50 }
      -- Setup mini.surround
      require('mini.surround').setup()
      -- Setup mini.animate
      -- Setup mini.misc
      require('mini.misc').setup {}

      -- Automatically sync terminal background
      -- This runs the function as soon as Neovim loads the plugin/config
      vim.schedule(function()
        MiniMisc.setup_termbg_sync()
      end)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

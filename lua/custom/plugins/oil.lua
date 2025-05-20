return {
  'stevearc/oil.nvim',
  ---@module 'oil',
  ---@type oil.SetupOpts
  keys = {
    { '\\', '<cmd>Oil --float<CR>', desc = 'Oil reveal', silent = true },
  },
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
}

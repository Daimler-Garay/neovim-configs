return {
  'stevearc/oil.nvim',
  win_options = {
    signcolumn = 'yes:2',
  },
  keys = {
    { '\\', '<cmd>Oil --float<CR>', desc = 'Oil reveal', silent = true },
  },
  opts = {
    default_file_explorer = true,
    columns = {
      'icon',
    },
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ['q'] = function()
        vim.api.nvim_win_close(0, true)
      end,
    },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
}

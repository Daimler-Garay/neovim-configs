return {
  'vieitesss/miniharp.nvim',
  opts = {
    autoload = true,
    autosave = true,
    show_on_autoload = false,
  },
  config = function()
    local harp = require 'miniharp'
    vim.keymap.set('n', '<leader>m', harp.toggle_file, { desc = 'miniharp: toggle file mark' })
    vim.keymap.set('n', '<leader>n', harp.next, { desc = 'miniharp: next file mark' })
    vim.keymap.set('n', '<leader>p', harp.prev, { desc = 'miniharp: previous file mark' })
    vim.keymap.set('n', '<leader>l', harp.show_list, { desc = 'miniharp: list file marks' })
  end,
}

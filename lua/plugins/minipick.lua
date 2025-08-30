return {
  'echasnovski/mini.pick',
  version = false, -- or use a release tag
  keys = {
    {
      '<leader>sf',
      function()
        MiniPick.builtin.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sg',
      function()
        MiniPick.builtin.grep_live()
      end,
      desc = '[S]earch [G]rep',
    },
    {
      '<leader>sb',
      function()
        MiniPick.builtin.buffers()
      end,
      desc = '[S]earch [B]uffers',
    },
    {
      '<leader>sh',
      function()
        MiniPick.builtin.help()
      end,
      desc = '[S]earch [H]elp',
    },
  },
  config = function()
    require('mini.pick').setup()
  end,
}

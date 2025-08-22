return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '~/vaults/notes',
        opts = function()
          local vault = vim.fn.expand '~/vaults/notes'
          return {
            workspaces = {
              { name = 'notes', path = vault },
            },
            notes_subdir = 'zettel',
            daily_notes = {
              folder = 'daily',
              date_format = '%Y-%m-%d',
            },
            templates = {
              folder = 'templates',
              date_format = '%Y-%m-%d',
              time_format = '%H:%M',
            },
            disable_frontmatter = false,
          }
        end,
        keys = {
          { '<leader>on', '<cmd>ObsidianNew<cr>', desc = 'Obsidian: New note' },
          { '<leader>oq', '<cmd>ObsidianQuickSwitch<cr>', desc = 'Obsidian: Quick switch' },
          { '<leader>os', '<cmd>ObsidianSearch<cr>', desc = 'Obsidian: Search in vault' },
          { '<leader>ob', '<cmd>ObsidianBacklinks<cr>', desc = 'Obsidian: Backlinks' },
          { '<leader>od', '<cmd>ObsidianToday<cr>', desc = 'Obsidian: Today (daily)' },
        },
      },
    },
  },
}

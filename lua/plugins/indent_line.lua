return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '|',
      },
      scope = {
        show_start = false,
        show_end = false,
        show_exact_scope = false,
      },
      -- Instead of excluding many, we explicitly include indent-reliant ones
      exclude = {
        filetypes = {}, -- keep empty, we’ll control via hooks
      },
    },
    config = function(_, opts)
      local indent_filetypes = {
        'python',
        'yaml',
      }

      require('ibl').setup(opts)

      -- Disable by default, enable only for chosen filetypes
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(event)
          if vim.tbl_contains(indent_filetypes, event.match) then
            require('ibl').setup_buffer(0, opts)
          else
            -- disable for others
            require('ibl').setup_buffer(0, { enabled = false })
          end
        end,
      })
    end,
  },
}

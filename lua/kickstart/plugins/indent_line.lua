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
      exclude = {
        filetypes = {},
      },
    },
    config = function(_, opts)
      local indent_filetypes = {
        'python',
        'yaml',
        'nim',
        'make',
      }

      require('ibl').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(event)
          if vim.tbl_contains(indent_filetypes, event.match) then
            require('ibl').setup_buffer(0, opts)
          else
            require('ibl').setup_buffer(0, { enabled = false })
          end
        end,
      })
    end,
  },
}

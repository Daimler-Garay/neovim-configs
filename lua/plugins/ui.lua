-- LSP Widget
require("fidget").setup()

-- QOL
require("plugins.lualine")
require("lsp-endhints").setup()

-- Treesitter
require("nvim-treesitter").install({ "rust", "python", "typescript", "lua" })

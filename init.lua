-- Pre-plugin Configs
require("plugins.rustaceanvim")

-- Plugins ---------------------------------------------------------------------

local plugins = {
	-- Core
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },

	-- Syntax / editing
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/windwp/nvim-autopairs" },

	-- UI/UX
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/chrisgrieser/nvim-lsp-endhints" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },

	-- Tooling
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },

	-- Language-specific
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/saecki/crates.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },

	-- Completion
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },

	-- Theme
	{ src = "https://github.com/ribru17/bamboo.nvim" },
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },

	{ src = "https://github.com/nvim-lua/plenary.nvim" },

	-- Debugger
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
	{ src = "https://github.com/mfussenegger/nvim-dap-python" },

	-- neotest
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/nvim-neotest/neotest" },
	{ src = "https://github.com/nvim-neotest/neotest-python" },
}

vim.pack.add(plugins)

-- Boot / basics ----------------------------------------------------------------

require("core.options")
require("core.keymaps")
require("core.autocmd")

-- Tooling ----------------------------------------------------------------------
require("plugins.tools")

require("plugins.coding")

-- UI / navigation --------------------------------------------------------------

require("plugins.ui")

-- Debugger + Testing -----------------------------------------------------------

require("plugins.debug")
require("plugins.neotest")

-- mini.nvim --------------------------------------------------------------------

require("plugins.mini")

-- Completion -------------------------------------------------------------------

require("plugins.completion")

-- LSP ----------------------------------------------------------------------------

vim.lsp.enable({
	"lua_ls",
	"rust_analyzer",
	"tinymist",
	"pyright",
	"ts_ls",
	"yamlls",
	"jsonls",
	"ruff",
})

-- Theme -------------------------------------------------------------------------

require("plugins.theme")

-- Snippets ----------------------------------------------------------------------

require("plugins.snippets")

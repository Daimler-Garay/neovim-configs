-- ORGANIZED BY AI

-- Plugins ---------------------------------------------------------------------

local plugins = {
	-- Core
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },

	-- Syntax / editing
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/abecodes/tabout.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },

	-- UX
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },

	-- Tooling
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },

	-- Language-specific
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/saecki/crates.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },

	-- Completion
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },

	-- Theme
	{ src = "https://github.com/projekt0n/github-nvim-theme" },

	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
}

vim.pack.add(plugins)

-- Boot / basics ----------------------------------------------------------------

require("core.options")
require("core.keymaps")
require("plugins.debug")

-- Treesitter -------------------------------------------------------------------

require("nvim-treesitter").install({ "rust", "python" })

-- Tooling ----------------------------------------------------------------------

require("mason").setup()

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		typescript = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		html = { "prettier" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- UI / navigation --------------------------------------------------------------

require("fidget").setup()
require("tabout").setup()
require("nvim-autopairs").setup()

require("oil").setup({
	view_options = { show_hidden = true },
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = { "icon" },
})

-- Rust -------------------------------------------------------------------------

require("crates").setup({
	lsp = {
		enabled = true,
		actions = true,
		completion = true,
		hover = true,
	},
	completion = {
		crates = {
			enabled = true,
			max_results = 8,
			min_chars = 3,
		},
	},
})

-- mini.nvim --------------------------------------------------------------------

require("mini.surround").setup({})
require("mini.extra").setup({})
require("mini.pick").setup({})

-- Completion -------------------------------------------------------------------

require("blink.cmp").setup({
	snippets = { preset = "luasnip" },
	signature = { enabled = true },
	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "normal",
	},
	completion = {
		menu = {
			scrolloff = 1,
			scrollbar = false,
			draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
					{ "kind" },
					{ "source_name" },
				},
			},
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
		},
		documentation = {
			window = {
				scrollbar = false,
				border = "rounded",
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
			},
			auto_show = false,
			auto_show_delay_ms = 500,
		},
		list = {
			max_items = 50,
			selection = { preselect = false, auto_insert = true },
		},
	},
})

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

require("github-theme").setup({
	options = { transparent = true },
})

vim.cmd.colorscheme("github_dark_high_contrast")
vim.cmd("hi statusline guibg=NONE")

-- Snippets ----------------------------------------------------------------------

local function get_snippet_path()
	local sysname = vim.loop.os_uname().sysname
	if sysname == "Windows_NT" then
		return vim.fn.expand("~/AppData/Local/nvim/snippets/")
	end
	return vim.fn.expand("~/.config/nvim/snippets/")
end

require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = get_snippet_path() })

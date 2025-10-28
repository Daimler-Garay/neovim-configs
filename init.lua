vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "http://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/saecki/crates.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/projekt0n/github-nvim-theme" },
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
	{ src = "https://github.com/nvim-neotest/neotest" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
	{ src = "https://github.com/nvim-neotest/neotest-python" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-mini/mini.extra", version = vim.version.range("*") },
})

require("core.options")
require("core.keymaps")
require("mason").setup()
require("oil").setup({
	view_options = { show_hidden = true },
	lsp_file_methods = { enbaled = true, timeout_ms = 1000, autosave_changes = true },
	columns = { "permissions", "icon" },
	float = { max_width = 0.7, max_height = 0.6, border = "rounded" },
})
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
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff" },
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
require("nvim-treesitter.config").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})
require("neotest").setup({
	adapters = {
		require("neotest-python"),
		require("rustaceanvim.neotest"),
	},
})
require("mini.extra").setup({})
require("mini.pick").setup({})
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
		},
		documentation = {
			window = {
				scrollbar = false,
			},
			auto_show = false,
			auto_show_delay_ms = 500,
		},
		list = {
			max_items = 70,
			selection = { preselect = false, auto_insert = true },
		},
	},
})

-- lsp
vim.lsp.enable({ "lua_ls", "rust_analyzer", "tinymist", "pylsp", "ts_ls", "yamlls", "jsonls" })

-- theme
vim.cmd.colorscheme("github_dark_high_contrast")
vim.cmd(":hi statusline guibg=NONE")

-- snippets
local sysname = vim.loop.os_uname().sysname
local snippet_path

if sysname == "Windows_NT" then
	snippet_path = vim.fn.expand("~/AppData/Local/nvim/snippets/")
else
	snippet_path = vim.fn.expand("~/.config/nvim/snippets/")
end
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = snippet_path })

vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/projekt0n/github-nvim-theme" },
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
	{ src = "https://github.com/nvim-neotest/neotest" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
	{ src = "https://github.com/fredrikaverpil/neotest-golang" },
	{ src = "https://github.com/nvim-neotest/neotest-python" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
})

require("mason").setup()
require("oil").setup({ view_options = { show_hidden = true } })
require("core.options")
require("core.keymaps")
require("dap-go").setup()
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff" },
		go = { "goimports" },
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
		require("neotest-golang")({
			version = vim.version.range("*"),
		}),
		require("neotest-python"),
	},
})
local win_config = function()
	local height = math.floor(0.618 * vim.o.lines)
	local width = math.floor(0.618 * vim.o.columns)
	return {
		anchor = "NW",
		height = height,
		width = width,
		row = math.floor(0.5 * (vim.o.lines - height)),
		col = math.floor(0.5 * (vim.o.columns - width)),
	}
end
require("mini.pick").setup({
	window = { config = win_config },
	source = {
		files = function()
			return require("mini.pick").default_source.files({
				command = {
					"fd",
					"--type",
					"f",
					"--hidden",
					"--exclude",
					"venv",
					"--exclude",
					".venv",
					"--exclude",
					"node_modules",
				},
			})
		end,
	},
})
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
	},
})

-- lsp
vim.lsp.enable({ "lua_ls", "tinymist", "pylsp", "ts_ls", "gopls" })

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

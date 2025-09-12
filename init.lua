vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/kepano/flexoki-neovim" },
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
	{ src = "https://github.com/saecki/crates.nvim" },
	{ src = "https://github.com/nvim-neotest/neotest" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
	{ src = "https://github.com/fredrikaverpil/neotest-golang" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
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
		rust = { "rustfmt", lsp_format = "fallback" },
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
		require("rustaceanvim.neotest"),
	},
})
require("crates").setup({
	lsp = {
		enabled = true,
		on_attach = function(client, bufnr) end,
		actions = true,
		completion = true,
		hover = true,
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

-- lsp
vim.lsp.enable({ "lua_ls", "tinymist", "pylsp", "ts_ls", "gopls" })

-- theme
vim.cmd.colorscheme("flexoki-dark")
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

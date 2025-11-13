vim.pack.add({
	{ src = "https://github.com//j-hui/fidget.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "master" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/saecki/crates.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/projekt0n/github-nvim-theme" },
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/nvim-mini/mini.extra", version = vim.version.range("*") },
	{ src = "https://github.com/nvim-mini/mini.surround", version = vim.version.range("*") },
	{ src = "https://github.com/abecodes/tabout.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
})

require("core.options")
require("core.keymaps")
require("mason").setup()
require("fidget").setup()
require("tabout").setup()
require("nvim-autopairs").setup()
require("oil").setup({
	view_options = { show_hidden = true },
	lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
	columns = { "icon" },
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

require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "python", "rust", "typescript" },
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	indent = { enable = true },
	textobjects = {
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["[f"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["]f"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[F"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		select = {
			enable = true,

			lookahead = true,

			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
			},
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "<c-v>", -- blockwise
			},
			include_surrounding_whitespace = true,
		},
	},
})
require("mini.surround").setup({})
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
require("github-theme").setup({
	options = {
		transparent = true,
	},
})
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

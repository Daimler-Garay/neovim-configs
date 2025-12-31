require("tabout").setup()
require("nvim-autopairs").setup()
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
require("inc_rename").setup({
	cmd_name = "Rename",
})

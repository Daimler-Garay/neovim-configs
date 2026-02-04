-- Mason
require("mason").setup()

-- Rust
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

-- File Picker
require("oil").setup({
	view_options = { show_hidden = true },
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
	},
	columns = { "icon" },
})

require("diffview").setup({})
require("gitsigns").setup({})
require("outline").setup({})

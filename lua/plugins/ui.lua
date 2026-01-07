-- LSP Widget
require("fidget").setup()

-- QOL
require("lsp-endhints").setup()
require("trouble").setup({
	modes = {
		test = {
			mode = "diagnostics",
			preview = {
				type = "split",
				relative = "win",
				position = "right",
				size = 0.3,
			},
		},
	},
})

-- Lualine
local trouble = require("trouble")

local symbols = trouble.statusline({
	mode = "lsp_document_symbols",
	groups = {},
	title = false,
	filter = { range = true },
	format = "{kind_icon}{symbol.name:Normal}",
	hl_group = "lualine_c_normal",
})

local opts = {
	sections = {
		lualine_c = {
			{
				symbols.get,
				cond = symbols.has,
			},
		},
	},
}

require("lualine").setup(opts)

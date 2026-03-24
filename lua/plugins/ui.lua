-- LSP Widget
require("fidget").setup()

-- QOL

-- Markdown
require("render-markdown").setup({
	completions = { blink = { enabled = true } },
})

-- Lualine

require("lualine").setup()

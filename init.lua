vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.lsp.enable({ "lua_ls", "pylsp", "ruff", "rust_analyzer" })

require("core.options")

require("core.keymaps")

require("core.lazy-bootstrap")

require("core.lazy-plugins")

local function set_statusline_transparent()
	for _, grp in ipairs({ "StatusLine", "StatusLineNC" }) do
		pcall(vim.api.nvim_set_hl, 0, grp, { bg = "none" })
	end
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
	callback = set_statusline_transparent,
})

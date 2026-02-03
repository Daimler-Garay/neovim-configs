local function get_snippet_path()
	local sysname = vim.loop.os_uname().sysname
	if sysname == "Windows_NT" then
		return vim.fn.expand("~/AppData/Local/nvim/snippets/")
	end
	return vim.fn.expand("~/.config/nvim/snippets/")
end

require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_vscode").lazy_load({})
require("luasnip.loaders.from_lua").lazy_load({ paths = get_snippet_path() })

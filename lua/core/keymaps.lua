vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("t", "<Esc><Esc>", "<C-\\><C-n>")
map("n", "<C-h>", "<C-w><C-h>")
map("n", "<C-l>", "<C-w><C-l>")
map("n", "<C-j>", "<C-w><C-j>")
map("n", "<C-k>", "<C-w><C-k>")
map("n", "<leader>w", ":update<CR>")
map("n", "<leader>q", ":quit<CR>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")
map("v", "J", ":m '>+1<CR>gv=gv") -- move blocks of code easily (Up)
map("v", "K", ":m '<-2<CR>gv=gv") -- move blocks of code easily (Down)

-- Flash

map({ "n", "x", "o" }, "zk", function()
	require("flash").jump()
end)

map({ "n", "x", "o" }, "Zk", function()
	require("flash").treesitter()
end)

-- Snippets
local ls = require("luasnip")
map("i", "<C-e>", function()
	ls.expand_or_jump(1)
end, { silent = true })
map({ "i", "s" }, "<C-J>", function()
	ls.jump(1)
end, { silent = true })
map({ "i", "s" }, "<C-K>", function()
	ls.jump(-1)
end, { silent = true })

-- Oil
map("n", "\\", "<cmd>Oil --float<cr>")

-- Lazygit
map("n", "<leader>lg", "<cmd>LazyGit<cr>")

-- Minipick
map("n", "<leader>sf", function()
	require("mini.pick").builtin.files()
end)
map("n", "<leader>sg", function()
	require("mini.pick").builtin.grep_live()
end)

map("n", "<leader>sb", function()
	require("mini.pick").builtin.buffers()
end)

map("n", "<leader>sd", function()
	require("mini.extra").pickers.diagnostic({ scope = "current" })
end)

-- Tmux Navigation
local nvim_tmux_nav = require("nvim-tmux-navigation")
map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)

-- Auto Commands
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- dont auto comment on new line
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local lap = function(keys, func)
			map("n", keys, func)
		end

		lap("gl", vim.diagnostic.open_float)
		lap("K", vim.lsp.buf.hover)
		lap("gs", vim.lsp.buf.signature_help)
		lap("gD", vim.lsp.buf.declaration)
		lap("<leader>la", vim.lsp.buf.code_action)
		lap("<leader>ff", vim.lsp.buf.format)
		lap("<leader>Wa", vim.lsp.buf.add_workspace_folder)
		lap("<leader>Wr", vim.lsp.buf.remove_workspace_folder)
		lap("<leader>Wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end)
		lap("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>")

		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})

-- manage plugins
local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

vim.keymap.set("n", "<leader>pc", pack_clean)

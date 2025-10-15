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

-- Tmux Navigation
local nvim_tmux_nav = require("nvim-tmux-navigation")
map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)

-- Dap
local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
	expand_lines = true,
	controls = { enabled = false },
	floating = { border = "rounded" },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▸", texthl = "DiagnosticInfo", linehl = "Visual", numhl = "" })

map("n", "<leader>du", function()
	dapui.toggle()
end, { noremap = true, silent = true })

map({ "n", "v" }, "<leader>dw", function()
	dapui.eval(nil, { enter = true })
end, { noremap = true, silent = true })

map({ "n", "v" }, "Q", function()
	dapui.eval()
end, { noremap = true, silent = true })

map("n", "<leader>dB", function()
	dap.set_breakpoiont(vim.fn.input("Breakpoint condition: "))
end)

map("n", "<leader>db", function()
	dap.toggle_breakpoint()
end)

map("n", "<leader>dc", function()
	dap.continue()
end)

map("n", "<leader>di", function()
	dap.step_into()
end)

map("n", "<leader>do", function()
	dap.step_out()
end)

map("n", "<leadeer>dO", function()
	dap.step_over()
end)

map("n", "<leader>dr", function()
	dap.repl.toggle()
end)

-- Auto Commands
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
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

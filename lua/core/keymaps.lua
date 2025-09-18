vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>q", vim.diagnostic.setloclist)
map("t", "<Esc><Esc>", "<C-\\><C-n>")
map("n", "<C-h>", "<C-w><C-h>")
map("n", "<C-l>", "<C-w><C-l>")
map("n", "<C-j>", "<C-w><C-j>")
map("n", "<C-k>", "<C-w><C-k>")
map("n", "<leader>ff", vim.lsp.buf.format)
map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")

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

dapui.setup()

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

map("n", "<F5>", function()
	dap.continue()
end, { desc = "DAP Continue/Start" })
map("n", "<F9>", function()
	dap.toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })
map("n", "<leader>B", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "DAP Conditional BP" })
map("n", "<F10>", function()
	dap.step_over()
end, { desc = "DAP Step Over" })
map("n", "<F11>", function()
	dap.step_into()
end, { desc = "DAP Step Into" })
map("n", "<S-F11>", function()
	dap.step_out()
end, { desc = "DAP Step Out" })
map("n", "<leader>du", function()
	dapui.toggle({})
end, { desc = "DAP UI Toggle" })
map("n", "<leader>de", function()
	dapui.eval()
end, { desc = "DAP Eval (hover expr)" })

-- Rustaceanvim
vim.g.rustaceanvim = {
	server = {
		on_attach = function(client, bufnr)
			local map = vim.keymap.set
			map("n", "K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, { silent = true, buffer = bufnr })
			map("n", "<leader>a", function()
				vim.cmd.RustLsp("codeAction")
			end, { silent = true, buffer = bufnr })
		end,
	},
}

-- Auto Commands
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/completion") then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}
			for i = 32, 126 do
				table.insert(chars, string.char(i))
			end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

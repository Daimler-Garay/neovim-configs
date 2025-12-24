-- Plugins
vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
})

-- =========================
-- Core DAP (UI + keymaps)
-- =========================
local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
	expand_lines = true,
	controls = { enabled = false },
	floating = { border = "rounded" },
})

require("nvim-dap-virtual-text").setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_disconnected["dapui_config"] = function()
	dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▸", texthl = "DiagnosticInfo", linehl = "Visual", numhl = "" })

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>du", function()
	dapui.toggle()
end, opts)
map({ "n", "v" }, "<leader>dw", function()
	dapui.eval(nil, { enter = true })
end, opts)

-- Prefer not to override "Q"; keep it namespaced
map({ "n", "v" }, "<leader>de", function()
	dapui.eval()
end, opts)

map("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, opts)

map("n", "<leader>db", function()
	dap.toggle_breakpoint()
end, opts)
map("n", "<leader>dc", function()
	dap.continue()
end, opts)
map("n", "<leader>di", function()
	dap.step_into()
end, opts)
map("n", "<leader>do", function()
	dap.step_out()
end, opts)
map("n", "<leader>dn", function()
	dap.step_over()
end, opts)
map("n", "<leader>dr", function()
	dap.repl.toggle()
end, opts)
map("n", "<leader>dq", function()
	dap.terminate()
end, opts)

-- =========================================
-- Rust: let rustaceanvim handle Rust DAP
-- =========================================
vim.g.rustaceanvim = {
	tools = {},
	server = {
		on_attach = function(_, bufnr)
			map("n", "<leader>rr", "<cmd>RustLsp runnables<cr>", vim.tbl_extend("force", opts, { buffer = bufnr }))
			map("n", "<leader>rd", "<cmd>RustLsp debuggables<cr>", vim.tbl_extend("force", opts, { buffer = bufnr }))
		end,
		default_settings = {
			["rust-analyzer"] = {},
		},
		dap = {
			adapter = require("rustaceanvim.config").get_codelldb_adapter("codelldb", "/usr/lib/liblldb.so"),
		},
	},
}

-- =========================================
-- Python: debugpy adapter + configurations
-- =========================================

dap.adapters.python = function(cb, _)
	cb({
		type = "executable",
		command = "python",
		args = { "-m", "debugpy.adapter" },
	})
end

dap.configurations.python = {
	{
		name = "Python: file",
		type = "python",
		request = "launch",
		program = "${file}",
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
		justMyCode = true,
	},
	{
		name = "Python: module",
		type = "python",
		request = "launch",
		module = function()
			return vim.fn.input("Module (e.g. pkg.module): ")
		end,
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
		justMyCode = true,
	},
	{
		name = "Python: attach (localhost:5678)",
		type = "python",
		request = "attach",
		connect = { host = "127.0.0.1", port = 5678 },
		justMyCode = true,
	},
}

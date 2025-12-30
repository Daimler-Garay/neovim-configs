-- Plugins
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },

	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },

	-- neotest
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/nvim-neotest/neotest" },
	{ src = "https://github.com/nvim-neotest/neotest-python" },
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

-- =========================
-- neotest (keymaps + setup)
-- =========================
local neotest = require("neotest")

local adapters = {
	require("neotest-python")({
		runner = "pytest",
		python = ".venv/bin/python",
	}),
	require("rustaceanvim.neotest"),
}

neotest.setup({
	adapters = adapters,
})

-- Namespaced under <leader>t*
map("n", "<leader>tt", function()
	neotest.run.run()
end, opts) -- nearest
map("n", "<leader>tT", function()
	neotest.run.run(vim.fn.expand("%"))
end, opts) -- file
map("n", "<leader>td", function()
	neotest.run.run({ strategy = "dap" })
end, opts) -- debug nearest via dap
map("n", "<leader>ts", function()
	neotest.summary.toggle()
end, opts)
map("n", "<leader>to", function()
	neotest.output.open({ enter = true, auto_close = true })
end, opts)
map("n", "<leader>tO", function()
	neotest.output_panel.toggle()
end, opts)
map("n", "<leader>tS", function()
	neotest.run.stop()
end, opts)

-- =========================================
-- Rust: debugpy adapter + configurations
-- =========================================
dap.adapters.codelldb = {
	type = "executable",
	command = "/home/dgaray/.vscode-server-insiders/extensions/vadimcn.vscode-lldb-1.12.0/adapter/codelldb",
}

dap.configurations.rust = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
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

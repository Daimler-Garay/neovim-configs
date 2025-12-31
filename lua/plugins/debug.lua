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
-- Rust: codelldb adapter + configurations
-- =========================================

-- moved to /lua/plugins/rustacean.nvim

-- =========================================
-- Python: debugpy adapter + configurations
-- =========================================
require("dap-python").setup("uv")

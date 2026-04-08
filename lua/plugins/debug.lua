local dap = require("dap")
local dapview = require("dap-view")

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▸", texthl = "DiagnosticInfo", linehl = "Visual", numhl = "" })

-- Keymaps

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>dt", function()
	dapview.DapViewToggle()
end)
map("n", "<leader>dw", function()
	dapview.DapViewWatch()
end)

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

-- =========================
-- neotest (keymaps + setup)
-- =========================
local neotest = require("neotest")
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

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

-- Keymaps
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

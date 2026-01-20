local bufnr = vim.api.nvim_get_current_buf()
local map = vim.keymap.set
local sets = { silent = true, buffer = bufnr }

map("n", "<leader>rr", function()
	vim.cmd.RustLsp("runnables")
end, sets)
map("n", "<leader>rd", function()
	vim.cmd.RustLsp("debuggables")
end, sets)
map("n", "<space>a", "<Plug>RustHoverAction", sets)
map("n", "<leader>rj", function()
	vim.cmd.RustLsp("relatedDiagnostics")
end, sets)
map("n", "<leader>rp", function()
	vim.cmd.RustLsp({ "renderDiagnostic", "current" })
end, sets)
map("n", "K", function()
	vim.cmd.RustLsp({ "hover", "actions" })
end, sets)
map("n", "<leader>la", function()
	vim.cmd.RustLsp("codeAction")
end, sets)
map({ "n" }, "<leader>n", function()
	local cur = vim.fn.expand("%")
	local num = cur:sub(-4, -4)
	local next = cur:sub(1, -5) .. (num + 1) .. ".rs"
	if vim.fn.filereadable(next) == 1 then
		vim.cmd("bd")
		vim.cmd("edit " .. next)
	else
		print("All problems solved for this topic.")
	end
end)

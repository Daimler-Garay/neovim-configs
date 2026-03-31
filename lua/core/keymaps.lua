-- Leaders ---------------------------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymap helper ----------------------------------------------------------------

local map = vim.keymap.set
local function n(lhs, rhs, opts)
	map("n", lhs, rhs, opts)
end
local function v(lhs, rhs, opts)
	map("v", lhs, rhs, opts)
end
local function t(lhs, rhs, opts)
	map("t", lhs, rhs, opts)
end
local function nxol(lhs, rhs, opts)
	map({ "n", "x", "o" }, lhs, rhs, opts)
end

-- QOL --------------------------------------------------------------------------
n("<Esc>", "<cmd>nohlsearch<CR>")
t("<Esc><Esc>", "<C-\\><C-n>")
n("<leader>o", "<cmd>Outline!<CR>")

-- LSP --------------------------------------------------------------------------

-- Leaders ---------------------------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymap helper ----------------------------------------------------------------

local map = vim.keymap.set
local function n(lhs, rhs, opts)
	map("n", lhs, rhs, opts)
end
local function v(lhs, rhs, opts)
	map("v", lhs, rhs, opts)
end
local function t(lhs, rhs, opts)
	map("t", lhs, rhs, opts)
end
local function nxol(lhs, rhs, opts)
	map({ "n", "x", "o" }, lhs, rhs, opts)
end

-- QOL --------------------------------------------------------------------------
n("<Esc>", "<cmd>nohlsearch<CR>")
t("<Esc><Esc>", "<C-\\><C-n>")
n("<leader>o", "<cmd>Outline!<CR>")

-- LSP --------------------------------------------------------------------------

-- Save / quit
n("<leader>w", "<cmd>update<CR>")
n("<leader>q", "<cmd>quit<CR>")

-- Keep cursor centered while scrolling
for _, key in ipairs({ "<C-d>", "<C-u>", "<C-f>", "<C-b>" }) do
	n(key, key .. "zz")
end

-- Move selected lines up/down
v("J", ":m '>+1<CR>gv=gv") -- down
v("K", ":m '<-2<CR>gv=gv") -- up

-- Plugin mappings --------------------------------------------------------------

-- Crates
local crates = require("crates")
n("<leader>ct", crates.toggle, { silent = true })
n("<leader>cf", crates.show_features_popup, { silent = true })

-- Snippets (LuaSnip)
do
	local ls = require("luasnip")
	map("i", "<C-e>", function()
		ls.expand_or_jump(1)
	end, { silent = true })
	map({ "i", "s" }, "<C-j>", function()
		ls.jump(1)
	end, { silent = true })
	map({ "i", "s" }, "<C-k>", function()
		ls.jump(-1)
	end, { silent = true })
end

-- Oil
n("\\", "<cmd>Oil<CR>")

-- Lazygit
n("<leader>lg", "<cmd>LazyGit<CR>")

-- mini.pick / mini.extra
-- n("<leader>f", function()
-- 	require("mini.pick").builtin.files()
-- end)
-- n("<leader>sg", function()
-- 	require("mini.pick").builtin.grep_live()
-- end)
-- n("<leader>sb", function()
-- 	require("mini.pick").builtin.buffers()
-- end)

-- Tmux Navigation (overrides <C-h/j/k/l>) -------------------------------------

-- do
-- 	local tmux = require("nvim-tmux-navigation")
-- 	n("<C-h>", tmux.NvimTmuxNavigateLeft)
-- 	n("<C-j>", tmux.NvimTmuxNavigateDown)
-- 	n("<C-k>", tmux.NvimTmuxNavigateUp)
-- 	n("<C-l>", tmux.NvimTmuxNavigateRight)
-- end

-- Managed plugins: clean unused ------------------------------------------------

local function pack_clean()
	local unused = {}

	for _, plugin in ipairs(vim.pack.get()) do
		local is_managed = plugin.spec and type(plugin.spec.src) == "string" and plugin.spec.src ~= ""
		if is_managed and not plugin.active then
			table.insert(unused, plugin.spec.name)
		end
	end

	if #unused == 0 then
		print("No unused managed plugins.")
		return
	end

	print("Unused managed plugins:")
	for _, name in ipairs(unused) do
		print("  - " .. name)
	end

	if vim.fn.confirm("Remove these plugins from disk?", "&Yes\n&No", 2) == 1 then
		vim.pack.del(unused)
	end
end

-- Window navigation (overridden later by tmux-nav if enabled)
n("<C-h>", "<C-w><C-h>")
n("<C-j>", "<C-w><C-j>")
n("<C-k>", "<C-w><C-k>")
n("<C-l>", "<C-w><C-l>")

-- Save / quit
n("<leader>w", "<cmd>update<CR>")
n("<leader>q", "<cmd>quit<CR>")

-- Keep cursor centered while scrolling
for _, key in ipairs({ "<C-d>", "<C-u>", "<C-f>", "<C-b>" }) do
	n(key, key .. "zz")
end

-- Move selected lines up/down
v("J", ":m '>+1<CR>gv=gv") -- down
v("K", ":m '<-2<CR>gv=gv") -- up

-- Plugin mappings --------------------------------------------------------------

-- Crates
local crates = require("crates")
n("<leader>ct", crates.toggle, { silent = true })
n("<leader>cf", crates.show_features_popup, { silent = true })

-- Snippets (LuaSnip)
do
	local ls = require("luasnip")
	map("i", "<C-e>", function()
		ls.expand_or_jump(1)
	end, { silent = true })
	map({ "i", "s" }, "<C-j>", function()
		ls.jump(1)
	end, { silent = true })
	map({ "i", "s" }, "<C-k>", function()
		ls.jump(-1)
	end, { silent = true })
end

-- Oil
n("\\", "<cmd>Oil<CR>")

-- Lazygit
n("<leader>lg", "<cmd>LazyGit<CR>")

-- snacks picker
n("<leader>f", function()
	require("snacks").picker.files()
end)
n("<leader>sG", function()
	require("snacks").picker.lines()
end)
n("<leader>sg", function()
	require("snacks").picker.grep()
end)
n("<leader>sb", function()
	require("snacks").picker.buffers()
end)

n("gd", function()
	require("snacks").picker.lsp_definitions()
end)
n("gD", function()
	require("snacks").picker.lsp_declarations()
end)
n("gr", function()
	require("snacks").picker.lsp_references()
end)
n("gI", function()
	require("snacks").picker.lsp_implementations()
end)
n("gy", function()
	require("snacks").picker.lsp_type_definitions()
end)
n("gai", function()
	require("snacks").picker.lsp_incoming_calls()
end)
n("gao", function()
	require("snacks").picker.lsp_outgoing_calls()
end)
n("<leader>ss", function()
	require("snacks").picker.lsp_symbols()
end)
n("<leader>sS", function()
	require("snacks").picker.lsp_workspace_symbols()
end)

-- -- Tmux Navigation (overrides <C-h/j/k/l>) -------------------------------------
--
-- do
-- 	local tmux = require("nvim-tmux-navigation")
-- 	n("<C-h>", tmux.NvimTmuxNavigateLeft)
-- 	n("<C-j>", tmux.NvimTmuxNavigateDown)
-- 	n("<C-k>", tmux.NvimTmuxNavigateUp)
-- 	n("<C-l>", tmux.NvimTmuxNavigateRight)
-- end

-- Managed plugins: clean unused ------------------------------------------------

local function pack_clean()
	local unused = {}

	for _, plugin in ipairs(vim.pack.get()) do
		local is_managed = plugin.spec and type(plugin.spec.src) == "string" and plugin.spec.src ~= ""
		if is_managed and not plugin.active then
			table.insert(unused, plugin.spec.name)
		end
	end

	if #unused == 0 then
		print("No unused managed plugins.")
		return
	end

	print("Unused managed plugins:")
	for _, name in ipairs(unused) do
		print("  - " .. name)
	end

	if vim.fn.confirm("Remove these plugins from disk?", "&Yes\n&No", 2) == 1 then
		vim.pack.del(unused)
	end
end

n("<leader>pc", pack_clean)

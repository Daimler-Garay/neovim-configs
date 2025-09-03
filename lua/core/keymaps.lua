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

-- Flash
map({ "n", "x", "o" }, "<leader>f", function()
    require("flash").jump()
end)

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
map("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
map("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)


-- Auto Commands
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

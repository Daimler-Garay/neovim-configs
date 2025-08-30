vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.o.sidescrolloff = 8
vim.opt.confirm = true
vim.o.swapfile = false
vim.o.conceallevel = 1
vim.o.wrap = false
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.opt.termguicolors = true -- True color support
vim.opt.timeoutlen = 500 -- Mapped sequence timeout
vim.opt.ttimeoutlen = 0 -- Faster escape key response
vim.opt.lazyredraw = true -- Don’t redraw while executing macros
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.completeopt = { 'menuone', 'noselect' } -- Better completion
vim.opt.pumheight = 10 -- Popup menu height

--- Autosave file when leaving insert mode
local autosave_filetypes = {
  typescript = true,
  javascript = true,
  typescriptreact = true,
  javascriptreact = true,
  html = true,
  css = true,
  scss = true,
  json = true,
  vue = true,
}

vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged', 'TextChangedI' }, {
  callback = function()
    local ft = vim.bo.filetype
    if autosave_filetypes[ft] and vim.bo.modifiable and not vim.bo.readonly then
      vim.cmd 'silent! write'
    end
  end,
})

-- vim: ts=2 sts=2 sw=2 et

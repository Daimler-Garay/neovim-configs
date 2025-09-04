vim.pack.add({
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/chomosuke/typst-preview.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/folke/flash.nvim" },
    { src = "https://github.com/kdheepak/lazygit.nvim" },
    { src = "https://github.com/kepano/flexoki-neovim" },
    { src = "https://github.com/alexghergh/nvim-tmux-navigation" },
})


require("mason").setup()
require("oil").setup({ view_options = { show_hidden = true } })
require("core.options")
require("core.keymaps")
require("nvim-treesitter.config").setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
})

local win_config = function()
    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.618 * vim.o.columns)
    return {
        anchor = 'NW',
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
    }
end
require("mini.pick").setup({
    window = { config = win_config },
    source = {
        files = function()
            return require("mini.pick").default_source.files({
                command = {
                    "fd", "--type", "f", "--hidden",
                    "--exclude", "venv",
                    "--exclude", ".venv",
                    "--exclude", "node_modules",
                },
            })
        end,
    },
})

-- lsp
vim.lsp.enable({ "lua_ls", "tinymist", "rust_analyzer", "pylsp", "ts_ls" })

-- theme
vim.cmd.colorscheme("flexoki-dark")
vim.cmd(":hi statusline guibg=NONE")

-- snippets
local sysname = vim.loop.os_uname().sysname
local snippet_path

if sysname == "Windows_NT" then
    snippet_path = vim.fn.expand("~/AppData/Local/nvim/snippets/")
else
    snippet_path = vim.fn.expand("~/.config/nvim/snippets/")
end
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = snippet_path })

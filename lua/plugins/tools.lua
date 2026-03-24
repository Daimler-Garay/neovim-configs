-- Mason
require("mason").setup()

-- Rust
require("crates").setup({
	lsp = {
		enabled = true,
		actions = true,
		completion = true,
		hover = true,
	},
	completion = {
		crates = {
			enabled = true,
			max_results = 8,
			min_chars = 3,
		},
	},
})

-- File Picker
require("oil").setup({
	view_options = { show_hidden = true },
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
	},
	columns = { "icon" },
})

require("diffview").setup({})
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>hs", gitsigns.stage_hunk)
		map("n", "<leader>hr", gitsigns.reset_hunk)

		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("n", "<leader>hS", gitsigns.stage_buffer)
		map("n", "<leader>hR", gitsigns.reset_buffer)
		map("n", "<leader>hp", gitsigns.preview_hunk)
		map("n", "<leader>hi", gitsigns.preview_hunk_inline)

		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end)

		map("n", "<leader>hd", gitsigns.diffthis)

		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end)

		map("n", "<leader>hQ", function()
			gitsigns.setqflist("all")
		end)
		map("n", "<leader>hq", gitsigns.setqflist)

		-- Toggles
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
		map("n", "<leader>tw", gitsigns.toggle_word_diff)

		-- Text object
		map({ "o", "x" }, "ih", gitsigns.select_hunk)
	end,
})
require("outline").setup({
	symbol_folding = {
		markers = { "🞂", "🞃" },
	},
	symbols = {
		icons = {
			File = { icon = "🗈", hl = "Identifier" }, -- '󰈔'
			Module = { icon = "▣", hl = "Include" }, -- '󰆧'
			Namespace = { icon = "{}", hl = "Include" }, -- '󰅪'
			Package = { icon = "📦", hl = "Include" }, -- '󰏗'
			Property = { icon = "⛬", hl = "Identifier" }, -- ''
			Field = { icon = "⬧", hl = "Identifier" }, -- '󰆨'
			Interface = { icon = "⚙", hl = "Type" }, -- '󰜰'
			Variable = { icon = "α", hl = "Constant" }, -- ''
			Constant = { icon = "💎", hl = "Constant" }, -- ''
			Array = { icon = "[]", hl = "Constant" }, -- '󰅪'
			Key = { icon = "🗝", hl = "Type" }, -- '🔐'
			Null = { icon = "∅", hl = "Type" }, -- 'NULL'
			Component = { icon = "⟨⟩", hl = "Function" }, -- '󰅴'
			Fragment = { icon = "❲❳", hl = "Constant" }, -- '󰅴'
			TypeAlias = { icon = "🏷", hl = "Type" }, -- ' '
			Parameter = { icon = "⟨T⟩", hl = "Identifier" }, -- ' '
			StaticMethod = { icon = "🧊", hl = "Function" }, -- ' '
		},
	},
})

require("livepreview.config").set({
	port = 5501,
	browser = "default",
	dynamic_root = false,
	sync_scroll = true,
	picker = "",
	address = "127.0.0.1",
})

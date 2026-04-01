require("blink.cmp").setup({
	sources = {
		default = { "lsp", "easy-dotnet", "path", "snippets" },
		providers = {
			["easy-dotnet"] = {
				name = "easy-dotnet",
				enabled = true,
				module = "easy-dotnet.completion.blink",
				score_offset = 10000,
				async = true,
			},
		},
	},
	snippets = { preset = "luasnip" },
	signature = { enabled = true },
	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "normal",
	},
	completion = {
		menu = {
			scrolloff = 1,
			scrollbar = false,
			draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
					{ "kind" },
					{ "source_name" },
				},
			},
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
		},
		documentation = {
			window = {
				scrollbar = false,
				border = "rounded",
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
			},
			auto_show = false,
			auto_show_delay_ms = 500,
		},
		list = {
			max_items = 50,
			selection = { preselect = false, auto_insert = true },
		},
	},
	cmdline = {
		keymap = { preset = "inherit" },
		completion = { menu = { auto_show = true } },
	},
})

vim.g.rustaceanvim = {
	server = {
		default_settings = {
			["rust-analyzer"] = {
				inlayHints = {
					chainingHints = { enable = true },
					closingBraceHints = { enable = true, minLines = 25 },
					parameterHints = { enable = true },
					typeHints = { enable = true },
				},
			},
		},
	},
}

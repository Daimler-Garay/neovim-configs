local mason_root = vim.fn.stdpath("data") .. "/mason"
local codelldb_root = mason_root .. "/packages/codelldb/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

vim.g.rustaceanvim = {
	tools = {
		float_win_config = {
			auto_focus = true,
			open_split = "vertical",
		},
	},
	server = {
		default_settings = {
			["rust_analyzer"] = {
				inlayHints = {
					chainingHints = { enable = true },
					closingBraceHints = { enable = true, minLines = 25 },
					parameterHints = { enable = true },
					typeHints = { enable = true },
				},
			},
		},
	},
	dap = {
		adapter = {
			type = "server",
			host = "127.0.0.1",
			port = "${port}",
			executable = {
				command = codelldb_path,
				args = { "--liblldb", liblldb_path, "--port", "${port}" },
			},
		},
	},
}

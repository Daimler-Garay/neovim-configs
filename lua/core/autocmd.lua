-- Autocommands -----------------------------------------------------------------

-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "rs", "py", "lua" },
	callback = function(args)
		vim.treesitter.start(args.buf)
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Don't auto-comment new lines
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- LSP Attach

local function client_supports_method(client, method, bufnr)
	if vim.fn.has("nvim-0.11") == 1 then
		return client:supports_method(method, bufnr)
	end
	return client.supports_method(method, { bufnr = bufnr })
end

-- Only set map if there isn't already a buffer-local map for {mode,lhs}
local function buf_map_if_free(bufnr, mode, lhs, rhs, opts)
	opts = opts or {}
	opts.buffer = bufnr
	opts.silent = opts.silent ~= false

	-- maparg() returns info about the effective map; `buffer == 1` means buffer-local
	local existing = vim.fn.maparg(lhs, mode, false, true)
	if existing and existing.buffer == 1 then
		return
	end

	vim.keymap.set(mode, lhs, rhs, opts)
end

local lsp_attach_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_attach_group,
	callback = function(event)
		local bufnr = event.buf
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		-- mappings: do not clobber ftplugin buffer-local maps
		buf_map_if_free(bufnr, "n", "gl", vim.diagnostic.open_float)
		buf_map_if_free(bufnr, "n", "K", vim.lsp.buf.hover)
		buf_map_if_free(bufnr, "n", "gs", vim.lsp.buf.signature_help)
		buf_map_if_free(bufnr, "n", "gD", vim.lsp.buf.declaration)

		buf_map_if_free(bufnr, "n", "<leader>la", vim.lsp.buf.code_action)
		buf_map_if_free(bufnr, "n", "<leader>ff", vim.lsp.buf.format)

		buf_map_if_free(bufnr, "n", "<leader>v", function()
			vim.cmd.vsplit()
			vim.lsp.buf.definition()
		end)

		-- highlights (optional): only if supported
		if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
			local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = bufnr,
				group = hl_group,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = bufnr,
				group = hl_group,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = false }),
				callback = function(detach_event)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = hl_group, buffer = detach_event.buf })
				end,
			})
		end
	end,
})

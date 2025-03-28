vim.lsp.enable("basedpyright")
vim.lsp.enable("lua_ls")
vim.lsp.enable("marko")
vim.lsp.enable("omnisharp")
vim.lsp.enable("ruff")
vim.lsp.enable("sourcekit")
vim.lsp.enable("ts_ls")
vim.lsp.enable("zls")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- See Snacks.picker for picker-related LSP functions

    map("<leader>rn", vim.lsp.buf.rename, "LSP: [R]e[n]ame")
    map("<leader>fm", vim.lsp.buf.format, "LSP: [F]or[m]at")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<leader>d", vim.diagnostic.open_float, "[D]iagnostic popup")


    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    --[[ local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end ]]
  end,
})

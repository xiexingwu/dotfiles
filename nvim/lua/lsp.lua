vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  },
  root_markers = { '.git' },
})

vim.lsp.enable("basedpyright")
vim.lsp.enable("lua_ls")
vim.lsp.enable("marko")
vim.lsp.enable("omnisharp")
vim.lsp.enable("ruff")
vim.lsp.enable("rust-analyzer")
vim.lsp.enable("sourcekit")
vim.lsp.enable("tinymist")
vim.lsp.enable("ts_ls")
vim.lsp.enable("zls")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client.name == "tinymist" then
      local main = client.root_dir .. "/main.typ"
      client:exec_cmd({
          title = 'tinymist.pinMain',
          command = 'tinymist.pinMain',
          arguments = { main }
        },
        client.handlers
      )
    end
    -- -- Capabilities
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- -- folding
    -- capabilities.textDocument.foldingRange = {
    --   dynamicRegistration = false,
    --   lineFoldingOnly = true
    -- }
    -- client.capabilities = capabilities

    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

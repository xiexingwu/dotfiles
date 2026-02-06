-- vim.api.nvim_create_autocmd({
--   "BufNewFile",
--   "BufRead",
--   "BufEnter",
-- }, {
--   pattern = "*.sh,*.sh.tmpl",
--   callback = function()
--     if vim.fn.search("{{.\\+}}", "nw") ~= 0 then
--       local buf = vim.api.nvim_get_current_buf()
--       vim.api.nvim_set_option_value("filetype", "sh", {buf = buf})
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({
--   "BufNewFile",
--   "BufRead",
--   "BufEnter",
-- }, {
--   pattern = "*.marko",
--   callback = function()
--     if vim.fn.search("{{.\\+}}", "nw") ~= 0 then
--       local buf = vim.api.nvim_get_current_buf()
--       vim.api.nvim_set_option_value("filetype", "marko", {buf = buf})
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({
--   "BufNewFile",
--   "BufRead",
--   "BufEnter",
-- }, {
--   pattern = "Brewfile,Brewfile.tmpl",
--   callback = function()
--     if vim.fn.search("{{.\\+}}", "nw") ~= 0 then
--       local buf = vim.api.nvim_get_current_buf()
--       vim.api.nvim_set_option_value("filetype", "ruby", {buf = buf})
--     end
--   end,
-- })

vim.filetype.add({
  extension = {
    marko = 'marko', -- missing Treesitter grammar for marko but there's github linguist: https://github.com/marko-js/marko-tmbundle
  },
  pattern = {
    ['Brewfile.*'] = 'Brewfile',
  },
})

-- Ghostty scrollback history
vim.filetype.add({
  pattern = {
    -- [os.getenv('TMPDIR') .. '.*/history.txt'] = function(path, bufnr, ext)  -- not matching for some reason?
    [".*/history.txt"] = function(path, bufnr, ext)
      return 'scrollback'
    end,
    [".*/screen.txt"] = function(path, bufnr, ext)
      return 'scrollback'
    end,
  }
})

vim.api.nvim_create_autocmd( "FileType" , {
  pattern = 'scrollback',
  callback = function()
    vim.cmd("norm G")
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ziggy', {}),
  pattern = 'ziggy',
  callback = function()
    vim.lsp.start {
      name = 'Ziggy LSP',
      cmd = { 'ziggy', 'lsp' },
      root_dir = vim.loop.cwd(),
      flags = { exit_timeout = 1000 },
    }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ziggy_schema', {}),
  pattern = 'ziggy_schema',
  callback = function()
    vim.lsp.start {
      name = 'Ziggy LSP',
      cmd = { 'ziggy', 'lsp', '--schema' },
      root_dir = vim.loop.cwd(),
      flags = { exit_timeout = 1000 },
    }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('superhtml', {}),
  pattern = 'superhtml',
  callback = function()
    vim.lsp.start {
      name = 'SuperHTML LSP',
      cmd = { 'superhtml', 'lsp' },
      root_dir = vim.loop.cwd(),
      flags = { exit_timeout = 1000 },
    }
  end,
})

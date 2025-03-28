local root_files = {
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
  -- mxie added as temp workaround:
  'init.lua',
  '.git',
}

local config = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_marker = root_files,
    -- root_dir = function(fname)
    --   local root = util.root_pattern(unpack(root_files))(fname)
    --   if root and root ~= vim.env.HOME then
    --     return root
    --   end
    --   local root_lua = util.root_pattern 'lua/'(fname) or ''
    --   local root_git = vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]) or ''
    --   if root_lua == '' and root_git == '' then
    --     return
    --   end
    --   return #root_lua >= #root_git and root_lua or root_git
    -- end,
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
  }


return config

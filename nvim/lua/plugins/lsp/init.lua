local function lua()
  vim.lsp.config('lua_ls', {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
            path ~= vim.fn.stdpath('config')
            and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using (most
          -- likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Tell the language server how to find Lua modules same way as Neovim
          -- (see `:h lua-module-load`)
          path = {
            'lua/?.lua',
            'lua/?/init.lua',
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME
            -- Depending on the usage, you might want to add additional paths
            -- here.
            -- '${3rd}/luv/library'
            -- '${3rd}/busted/library'
          }
          -- Or pull in all of 'runtimepath'.
          -- NOTE: this is a lot slower and will cause issues when working on
          -- your own configuration.
          -- See https://github.com/neovim/nvim-lspconfig/issues/3189
          -- library = {
          --   vim.api.nvim_get_runtime_file('', true),
          -- }
        }
      })
    end,
    settings = {
      Lua = {}
    }
  })
  vim.lsp.enable('lua_ls')
end

local function ts()
  -- TypeScript 7 (brew `typescript`) dropped tsserver, which ts_ls needs; use its native LSP instead
  vim.lsp.config('tsgo', {
    cmd = { 'tsc', '--lsp', '--stdio' },
  })
  vim.lsp.enable('tsgo')
end

local function zig()
  vim.lsp.config('zls', {
    cmd = { vim.env.HOME .. '/.zvm/bin/zls' },
    filetypes = { 'zig' },
    root_markers = { 'build.zig' },
    settings = {
      zls = {
        zig_exe_path = vim.env.HOME .. '/.zvm/bin/zig',
      },
    },
  })
  vim.lsp.enable('zls')
end

return {
  'neovim/nvim-lspconfig',
  config = function()
    -- brew's binary is `kotlin-lsp`; lspconfig defaults to `intellij-server`
    vim.lsp.config('kotlin_lsp', { cmd = { 'kotlin-lsp', '--stdio' } })

    vim.lsp.enable({
      'bashls',
      'basedpyright',
      'kotlin_lsp',
      'marko-js',
      'rust_analyzer',
      'sourcekit',
    })
    lua()
    ts()
    zig()
  end
}

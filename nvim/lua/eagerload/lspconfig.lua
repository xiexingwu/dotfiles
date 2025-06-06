function lua()
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

function rust()
  -- vim.lsp.config('rust_analyzer', {
  --   settings = {
  --     ['rust-analyzer'] = {
  --       diagnostics = {
  --         enable = false,
  --       }
  --     }
  --   }
  -- })
  vim.lsp.enable('rust_analyzer')
end

function ts()
  vim.lsp.enable('ts_ls')
end

function zig()
  vim.lsp.enable("zls")
end

return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require("lspconfig")

    vim.lsp.enable("bashls")
    lua()
    -- Markdown
    vim.lsp.enable('marksman')
    -- Marko
    vim.lsp.enable("marko-js")
    -- Python
    vim.lsp.enable("ruff")
    rust()
    ts()
    zig()
  end
}

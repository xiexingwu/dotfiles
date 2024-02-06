local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "regex",

    "toml",
    "yaml",
    "json",

    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",

    "c",
    "zig",

    "python",
    "sql",

    "markdown",
    "markdown_inline",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    -- python
    "autoflake",

    "sqlfmt",

    "zls",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M

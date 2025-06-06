return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter-context",
  },
  event = "VeryLazy",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all"
      ensure_installed = {
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "c",
        "lua",
        "rust",
        "jsdoc",
        "bash",
        "jinja",
        "sql",
        "regex",
        "bash",
        "latex",
        "markdown",
        "markdown_inline",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
      auto_install = true,

      indent = {
        enable = true,
      },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,
        additional_vim_regex_highlighting = false
      },
    })

    local context = require("treesitter-context")
    context.setup({
      enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor",          -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20,     -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    })

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    parser_config.templ = {
      install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
      },
    }

    vim.treesitter.language.register("templ", "templ")

    vim.treesitter.language.register("tsx", "marko")

    vim.treesitter.language.register("jinja", "sql")

    parser_config.ziggy = {
      install_info = {
        url = 'https://github.com/kristoff-it/ziggy',
        includes = { 'tree-sitter-ziggy/src' },
        files = { 'tree-sitter-ziggy/src/parser.c' },
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'ziggy',
    }

    parser_config.ziggy_schema = {
      install_info = {
        url = 'https://github.com/kristoff-it/ziggy',
        files = { 'tree-sitter-ziggy-schema/src/parser.c' },
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'ziggy-schema',
    }

    parser_config.supermd = {
      install_info = {
        url = 'https://github.com/kristoff-it/supermd',
        includes = { 'tree-sitter/supermd/src' },
        files = {
          'tree-sitter/supermd/src/parser.c',
          'tree-sitter/supermd/src/scanner.c'
        },
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'supermd',
    }

    parser_config.supermd_inline = {
      install_info = {
        url = 'https://github.com/kristoff-it/supermd',
        includes = { 'tree-sitter/supermd-inline/src' },
        files = {
          'tree-sitter/supermd-inline/src/parser.c',
          'tree-sitter/supermd-inline/src/scanner.c'
        },
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'supermd_inline',
    }

    parser_config.superhtml = {
      install_info = {
        url = 'https://github.com/kristoff-it/superhtml',
        includes = { 'tree-sitter-superhtml/src' },
        files = {
          'tree-sitter-superhtml/src/parser.c',
          'tree-sitter-superhtml/src/scanner.c'
        },
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'superhtml',
    }

    vim.filetype.add {
      extension = {
        smd = 'supermd',
        shtml = 'superhtml',
        ziggy = 'ziggy',
        ['ziggy-schema'] = 'ziggy_schema',
      },
    }
  end,
}

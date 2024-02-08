local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "stevearc/conform.nvim",
    --  for users those who want auto-save conform + lazyloading!
    -- event = "BufWritePre"
    config = function()
      require "custom.configs.conform"
    end,
  },
  { "ggandor/leap.nvim", dependencies = { "tpope/vim-repeat" } },
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/projects", "~/downloads", "/" },
      }
    end,
  },
  {
    "PedramNavid/dbtpal",
    config = function()
      local dbt = require "dbtpal"
      dbt.setup {
        -- Path to the dbt executable
        path_to_dbt = "dbt",

        -- Path to the dbt project, if blank, will auto-detect
        -- using currently open buffer for all sql,yml, and md files
        path_to_dbt_project = "",

        -- Path to dbt profiles directory
        path_to_dbt_profiles_dir = vim.fn.expand "~/.dbt",

        -- Search for ref/source files in macros and models folders
        extended_path_search = true,

        -- Prevent modifying sql files in target/(compiled|run) folders
        protect_compiled_files = true,
      }

      -- Setup key mappings

      vim.keymap.set("n", "<leader>drf", dbt.run)
      vim.keymap.set("n", "<leader>drp", dbt.run_all)
      vim.keymap.set("n", "<leader>dtf", dbt.test)
      vim.keymap.set("n", "<leader>dm", require("dbtpal.telescope").dbt_picker)

      -- Enable Telescope Extension
      require("telescope").load_extension "dbtpal"
    end,
    requires = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope.nvim" } },
  },

  -- to make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins

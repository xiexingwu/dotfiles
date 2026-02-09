return {
  {
    'dmtrKovalenko/fff.nvim',
    build = function()
      -- this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      debug = {
        enabled = true,   -- we expect your collaboration at least during the beta
        show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
      },
      title = 'fff.nvim',
      layout = {
        prompt_position = 'top',
      },
    },
    keys = {
      {
        "ff", -- try it if you didn't it is a banger keybinding for a picker
        function() require('fff').find_files() end,
        desc = 'FFFind files',
      }
    }
  },

  {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    event = "UIEnter",
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    lazy = true,
    opts = {},
  },

}

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    }
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      labels = "fjdkslghrueiwotyaqpvncmx",
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      -- { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      -- { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  {
    "FluxxField/smart-motion.nvim",
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      flow_state_timeout_ms = 1000,
      disable_dim_background = true,
      presets = {
        -- words = true,
        -- search = true, -- s, f, F, t, T, ;, ,, gs
        -- delete = true,       -- d, dt, dT, rdw, rdl
        -- yank = true,        -- y, yt, yT, ryw, ryl
        -- change = true,      -- c, ct, cT
        -- paste = true,       -- p, P
        -- treesitter = true,  -- ]], [[, ]c, [c, ]b, [b, daa, caa, yaa, dfn, cfn, yfn, saa
        -- diagnostics = true, -- ]d, [d, ]e, [e
        -- git = true,         -- ]g, [g
        -- quickfix = true,    -- ]q, [q, ]l, [l
        -- marks = true,       -- g', gm
        -- misc = true,        -- . g. g0 g1-g9 gp gP gA-gZ gmd gmy (repeat, history, pins, global pins)
      },
    },
  },

  {
    "zk-org/zk-nvim",
    config = function()
      local zk = require("zk")

      zk.setup({
        -- Can be "telescope", "fzf", "fzf_lua", "minipick", "snacks_picker",
        -- or select" (`vim.ui.select`).
        picker = "snacks_picker",
        lsp = {
          -- `config` is passed to `vim.lsp.start(config)`
          config = {
            name = "zk",
            cmd = { "zk", "lsp" },
            filetypes = { "markdown" },
            -- on_attach = ...
            -- etc, see `:h vim.lsp.start()`
          },

          -- automatically attach buffers in a zk notebook that match the given filetypes
          auto_attach = {
            enabled = true,
          },
        },
      })

      local opts = { noremap = true, silent = false }

      vim.api.nvim_set_keymap("n", "<leader>zkn", "<Cmd>ZkNew { title = vim.ui.input('Title: ') }<CR>", opts)
      vim.api.nvim_set_keymap("n", "<leader>zkl", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
    end,
  }
}

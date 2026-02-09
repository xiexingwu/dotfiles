return {
  -- Marks
  {
    "TheNoeTrevino/haunt.nvim",
    opts = {},
    config = function()
      local haunt = require("haunt.api")
      local haunt_picker = require("haunt.picker")
      vim.keymap.set("n", "<leader>mm", haunt.annotate, { desc = "[H]aunt: [A]nnotate" })
      vim.keymap.set("n", "<leader>md", haunt.delete, { desc = "[H]aunt: [D]elete Annotation" })
      vim.keymap.set("n", "<leader>mc", haunt.clear_all, { desc = "[H]aunt: [C]lear All Annotations" })
      vim.keymap.set("n", "<leader>mt", haunt.toggle_all_lines, { desc = "[H]aunt: [T]oggle" })
      vim.keymap.set("n", "<leader>mq", haunt.to_quickfix, { desc = "[H]aunt: To [Q]uickfix" })
      vim.keymap.set("n", "<leader>mQ", function() haunt.to_quickfix({ current_buffer = true }) end,
        { desc = "[H]aunt: To [Q]uickfix (current buf)" })
      vim.keymap.set("n", "<leader>mp", haunt_picker.show, { desc = "[H]aunt: [P]ick" })
    end
  },

  -- Session
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
  },


  -- Motions
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      labels = "fjdkslghrueiwotyaqpvncmx",
    },
    -- stylua: ignore
    keys = {
      { "<C-CR>",   mode = { "n" }, function() require("flash").jump() end,       desc = "Flash" },
      { "<C-S-CR>", mode = { "n" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
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
        delete = {
          d = false,
          dt = false,
          dT = false,
        },
        yank = {
          y = false,
          yt = false,
          yT = false,
        },
        -- change = true,      -- c, ct, cT
        -- paste = true,       -- p, P
        -- treesitter = true,  -- ]], [[, ]c, [c, ]b, [b, daa, caa, yaa, dfn, cfn, yfn, saa
        -- diagnostics = true, -- ]d, [d, ]e, [e
        -- git = true,         -- ]g, [g
        -- quickfix = true,    -- ]q, [q, ]l, [l
        -- marks = true,       -- g', gm
        misc = {
          ['g.'] = false,
          g0 = false,
          -- g1 = false,
          -- g2 = false,
          -- g3 = false,
          g4 = false,
          g5 = false,
          g6 = false,
          g7 = false,
          g8 = false,
          g9 = false,

          -- gA = false,
          -- gB = false,
          -- gC = false,
          gD = false,
          gE = false,
          gF = false,
          gG = false,
          gH = false,
          gI = false,
          gJ = false,
          gK = false,
          gL = false,
          gM = false,
          gN = false,
          gO = false,
          gP = false,
          gQ = false,
          gR = false,
          gS = false,
          gT = false,
          gU = false, -- Upper case
          gV = false,
          gW = false,
          gX = false,
          gY = false,
          gZ = false,

          gp = false,

          gTd = false,
          gTe = false,
          gTf = false,
          gTg = false,
          gQd = false,
          gQe = false,
          gQf = false,
          gQg = false,

          gmd = false,
          gmy = false,
        },
      },
    },
  },


  -- CLI integrations
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

      vim.api.nvim_set_keymap("n", "<leader>zn", "<Cmd>ZkNew { title = vim.ui.input('Title: ') }<CR>",
        { desc = "ZK: [N]ew", noremap = true, silent = false })
      vim.api.nvim_set_keymap("n", "<leader>zl", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
        { desc = "ZK: [L]ist", noremap = true, silent = false })
    end,
  }
}

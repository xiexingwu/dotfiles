return {
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
}

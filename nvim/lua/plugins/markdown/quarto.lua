local config = {
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "markdown" },
    config = function()
      local quarto = require("quarto")
      quarto.setup({
        lspFeatures = {
          languages = { "python", "rust", "lua" },
          chunks = "all", -- 'curly' or 'all'
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
          },
          completion = {
            enabled = true,
          },
        },
        keymap = {
          hover = "H",
          definition = "gd",
          rename = "<leader>rn",
          references = "gr",
          format = "<leader>gf",
        },
        codeRunner = {
          enabled = true,
          -- ft_runners = {
          --   bash = "slime",
          -- },
          default_method = "molten",
        },
      })

      vim.keymap.set("n", "<localleader>QP", quarto.quartoPreview,
        { desc = "Preview the Quarto document", silent = true, noremap = true })
    end,
  },
  {
    "GCBallesteros/jupytext.nvim",
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },
}

return {};

return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  lazy = true,
  config = function()
    -- Lua
    local actions = require("diffview.actions")

    require("diffview").setup({
      view = {
        merge_tool = {
          layout = "diff3_mixed"
        }
      },
      file_panel = {
        listing_style = "list",   -- One of 'list' or 'tree'
      }
    })

    vim.keymap.set("n", "<leader>dv", "<cmd>DiffviewOpen -uno -- :!tmp<CR>", {desc = "[D]iff[V]iew: Open"})
    vim.keymap.set("n", "<leader>dV", "<cmd>DiffviewClose<CR>", {desc = "[D]iff[V]iew: Close"})
  end,
}

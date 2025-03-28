return {
  "rcarriga/nvim-notify",
  dependencies = { "nvim-telescope/telescope.nvim" },
  event = "VeryLazy",
  config = function()
    local notify = require('notify')
    notify.setup({
      fps = 60,
      stages = "static",
      timeout = 1500,
      max_height = 3,
      render = "wrapped-compact",
    })
    vim.notify = notify

    local telescope = require("telescope")
    telescope.load_extension("notify")
    vim.keymap.set("n", "<leader>mm", function() telescope.extensions.notify.notify() end,
      { desc = "[M]essages (Telescope)" })
  end
}

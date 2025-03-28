return {
  "ibhagwan/fzf-lua",
  lazy = true,
  event = "UIEnter",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({
      winopts = {
        preview = {
          layout = "vertical",
          vertical = "up",
        }
      },
      fzf_opts = {
        -- ["--layout"] = "reverse-list",
      },
    })

    local fzflua = require("fzf-lua");
    -- using telescope
    -- vim.keymap.set("n", "<C-P>", fzflua.files, { desc = "File finder (fzf)", silent = true })
    -- vim.keymap.set("n", "<C-A-P>", function() fzflua.files({ resume=true }) end, { desc = "File finder (fzf)", silent = true })
  end,
}

return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release.
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      "folke/snacks.nvim",
      optional = true,
      opts = {
        -- Enhances `ask()`.
        input = {},
        -- Enhances `select()`.
        picker = {
          actions = {
            opencode_send = function(...) return require('opencode').snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
              },
            },
          },
        },
        -- Enables the `snacks` provider.
        terminal = {},
      }
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any; goto definition on the type or field for details.
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end,
      { desc = "OpenCode: [A]sk" })
    vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end,
      { desc = "OpenCode: [S]elect" })
    vim.keymap.set({ "n", "t" }, "<leader>oo", function() require("opencode").toggle() end,
      { desc = "OpenCode: [O]pen/Close" })

    vim.keymap.set({ "n", "x" }, "<leader>ov", function() return require("opencode").operator("@this ") end,
      { desc = "OpenCode: Add [V]isual", expr = true })
    vim.keymap.set("n", "<leader>ol", function() return require("opencode").operator("@this ") .. "_" end,
      { desc = "OpenCode: Add [L]ine", expr = true })

    -- vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
    --   { desc = "Scroll opencode up" })
    -- vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end,
    --   { desc = "Scroll opencode down" })
  end,
}

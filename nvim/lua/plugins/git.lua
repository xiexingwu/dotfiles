return {
  -- Visual tree
  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },

  -- VSCode-style diffs, history, merge conflicts
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>dd", "<Cmd>CodeDiff<CR>",                desc = "[D]iff working tree" },
      { "<leader>ds", "<Cmd>CodeDiff --staged<CR>",       desc = "[D]iff [S]taged" },
      { "<leader>dm", "<Cmd>CodeDiff main...HEAD<CR>",    desc = "[D]iff vs [M]ain (merge-base)" },
      { "<leader>df", "<Cmd>CodeDiff file HEAD<CR>",      desc = "[D]iff [F]ile vs HEAD" },
      { "<leader>dh", "<Cmd>CodeDiff history %<CR>",      desc = "[D]iff file [H]istory" },
      { "<leader>dh", ":CodeDiff history<CR>", mode = "x", desc = "[D]iff line [H]istory" },
      { "<leader>dH", "<Cmd>CodeDiff history<CR>",        desc = "[D]iff repo [H]istory" },
      {
        "<leader>dp",
        function()
          vim.ui.input({ prompt = "PR number: " }, function(pr)
            if pr and pr ~= "" then vim.cmd("CodeDiff pr " .. pr) end
          end)
        end,
        desc = "[D]iff [P]R",
      },
    },
    opts = {
      diff = { compute_moves = true },
      explorer = { width = 30 },
      history = { width = 40 },
    },
  },

  -- Fugitive
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gb", "<Cmd>G blame<CR>", { desc = "[G]it [B]lame (fugitive)" })
    end
  },
}

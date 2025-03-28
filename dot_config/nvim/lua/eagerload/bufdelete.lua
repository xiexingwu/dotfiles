local config = {
  'famiu/bufdelete.nvim',
  keys = {
    { "<leader>db", "<Cmd>Bwipeout<CR>", desc = "[D]elete [B]uffer (BWipeout)" },
    { "<C-B>",      "<Cmd>Bwipeout<CR>", desc = "[D]elete [B]uffer (BWipeout)" }
  },
}
-- return config
return {}

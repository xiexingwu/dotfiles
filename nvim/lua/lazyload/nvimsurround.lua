return
{
  "kylechui/nvim-surround",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      -- Configuration here, or leave empty to use defaults
      keymaps = {
        -- insert = "<C-g>s",
        -- insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "ySS", -- not sure what this does. shadow with cur_line
        normal_cur_line = "ySS",
        visual = "as",
        visual_line = "ass",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
    })
  end
}

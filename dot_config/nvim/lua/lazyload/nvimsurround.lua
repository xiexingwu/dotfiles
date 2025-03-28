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
        normal = "gs",
        normal_cur = "gss",
        normal_line = "gSS", -- not sure what this does. shadow with cur_line
        normal_cur_line = "gSS",
        visual = "gs",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
    })
  end
}

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      -- transparent_background = false,
      show_end_of_buffer = true,
      dim_inactive = {
        enabled = true,   -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      default_integrations = true,
      integrations = {
        blink_cmp = true,
        cmp = true,
        diffview = true,
        flash = true,
        gitsigns = true,
        grug_far = true,
        notify = false,
        nvim_surround = true,
        treesitter = true,
        treesitter_context = true,
        ufo = true,
        which_key = true,
      }
    })
    vim.cmd.colorscheme("catppuccin")
  end
}

return {
  -- Markdown rendering (kitty graphics for images/mermaid; icons via mini.icons)
  {
    "delphinus/md-render.nvim",
    version = "*",
    ft = "markdown",
    cmd = "MdRender",
    -- stylua: ignore
    keys = {
      { "<leader>ms", function() require("md-render").preview.split({ mods = { vertical = true, split = "belowright" } }) end,       desc = "Markdown: [S]plit" },
      { "<leader>mm", "<Plug>(md-render-toggle)",      desc = "Markdown: toggle in place" },
      { "<leader>mf", "<Plug>(md-render-preview)",     desc = "Markdown: [F]loat" },
      { "<leader>mt", "<Plug>(md-render-preview-tab)", desc = "Markdown: [T]ab" },
      { "<leader>ma", "<Plug>(md-render-auto)",        desc = "Markdown: [A]uto (render outside insert)" },
      { "<leader>mp", "<Cmd>MdRender pager<CR>",       desc = "Markdown: [P]ager" },
    },
  },
}

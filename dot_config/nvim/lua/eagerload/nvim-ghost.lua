return {
  "subnut/nvim-ghost.nvim",
  config = function()
    local au_id = vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", {clear = true})

    vim.api.nvim_create_autocmd("User", {
      pattern = {"*github.com", "*reddit.com"},
      command = "setfiletype markdown",
      group = au_id,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = {"console.cloud.google.com/bigquery"},
      command = "setfiletype sql",
      group = au_id,
    })
  end,
}

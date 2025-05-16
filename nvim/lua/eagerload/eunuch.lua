function rename_file_with_input()
  vim.ui.input(
    { prompt = "Enter new path for file: " },
    function(new_name)
      if new_name ~= nil and new_name ~= "" then
        vim.cmd("Move " .. new_name)
      else
        return
      end
    end)
end

return {
  "tpope/vim-eunuch",
  config = function()
    vim.keymap.set("n", "<leader>mv", rename_file_with_input, { desc = "[M]o[v]e / rename (vim-eunuch)" }) -- need input for filename
    -- vim.keymap.set("n", "<leader>rm", "<Cmd>Remove<CR>", {desc = "[R]e[m]ove / delete (vim-eunuch)"})
  end
}

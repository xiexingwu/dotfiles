return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gc", "<Cmd>Git commit<CR>")
        vim.keymap.set("n", "<leader>gd", "<Cmd>Gvdiffsplit<CR>")
    end
}

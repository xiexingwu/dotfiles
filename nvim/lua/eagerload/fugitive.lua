return {
    "tpope/vim-fugitive",
    config = function()
        -- vim.keymap.set("n", "<leader>gg", "<Cmd>G<CR>", {desc = "[G] (fugitive)"})
        -- vim.keymap.set("n", "<leader>gl", "<Cmd>G log<CR>", {desc = "[G] [L]og (fugitive)"})
        -- vim.keymap.set("n", "<leader>gf", "<Cmd>G fetch<CR>", {desc = "[G]it [F]etch (fugitive)"})
    -- vim.keymap.set("n", "<leader>gcc", "<Cmd>G commit<CR>", {desc = "[G]it [C]ommit (fugitive)"})
        vim.keymap.set("n", "<leader>gb", "<Cmd>G blame<CR>", {desc = "[G]it [B]lame (fugitive)"})

        vim.keymap.set("n", "<leader>gcp", ":G cherry-pick ", {desc = "[G]it [C]herry-[P]ick (fugitive)"})
        vim.keymap.set("n", "<leader>gm", ":G merge ", {desc = "[G]it [M]erge (fugitive)"})
        vim.keymap.set("n", "<leader>gr", ":G rebase ", {desc = "[G]it [R]ebase (fugitive)"})
    end
}

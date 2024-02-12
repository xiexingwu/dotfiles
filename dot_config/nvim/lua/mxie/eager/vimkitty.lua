return {
	"knubie/vim-kitty-navigator",
	lazy = false,
	config = function()
		vim.g.kitty_navigator_no_mappings = 1

		vim.keymap.set("n", "<c-w>h", "<cmd>KittyNavigateLeft<cr>", { noremap = true, silent = true })
		vim.keymap.set("n", "<c-w>j", "<cmd>KittyNavigateDown<cr>", { noremap = true, silent = true })
		vim.keymap.set("n", "<c-w>k", "<cmd>KittyNavigateUp<cr>", { noremap = true, silent = true })
		vim.keymap.set("n", "<c-w>l", "<cmd>KittyNavigateRight<cr>", { noremap = true, silent = true })

        os.execute("cp -n ~/.local/share/nvim/lazy/vim-kitty-navigator/*.py ~/.config/kitty/")
	end,
}

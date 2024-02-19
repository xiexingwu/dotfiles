return {
	"ibhagwan/fzf-lua",
	lazy = true,
	event = "UIEnter",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- calling `setup` is optional for customization
		require("fzf-lua").setup({
            winopts = {
                preview = {
                    layout = "vertical",
                    vertical = "up",
                }
            },
			fzf_opts = {
				-- ["--layout"] = "reverse-list",
			},
		})
		vim.keymap.set("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
		vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
	end,
}

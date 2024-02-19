return {
	"jiaoshijie/undotree",
	dependencies = "nvim-lua/plenary.nvim",
    lazy = true,
    event = "UIEnter",
	config = function()
		require("undotree").setup({
			window = {
				winblend = 0,
			},
		})
		vim.keymap.set("n", "<leader>u", require("undotree").toggle, { noremap = true, silent = true })
	end,
	keys = { -- load the plugin only when using it's keybinding:
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	},
}

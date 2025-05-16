return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    lazy = true,
	config = function()
		require("trouble").setup({
			icons = false,
		})
	end,
}

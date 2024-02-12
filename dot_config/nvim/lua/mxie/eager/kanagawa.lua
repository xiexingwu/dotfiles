return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000, -- load colorscheme ASAP
	config = function()
		require("kanagawa").load("dragon")
	end,
}

return {
	"nvim-lualine/lualine.nvim",
	requires = { "kyazdani42/nvim-web-devicons", opt = true },
	lazy = false,
	opts = {
		theme = "auto",
	},
	config = function()
		require("lualine").setup({
			sections = {
				lualine_x = {
					{
						--[[ require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
						color = { fg = "#ff9e64" }, ]]
					},
				},
			},
		})
	end,
}

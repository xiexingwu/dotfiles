return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {},
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>fm",
			function()
				require("conform").format()
			end,
			mode = "",
			desc = "Format (conform)",
		},
	},
	config = function()
		local conform = require("conform")
		conform.setup({
			-- Conform will run multiple formatters sequentially
			-- lang = { fmt1, fmt2 }
			-- Use a sub-list to run only the first available formatter
			-- lang = { {fmt1, fmt2} }
			formatters_by_ft = {
				lua = { "stylua" },
				python = { { "black", "flake8" } },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				sql = { "sqlfluff" },
                templ = { "templ" }
			},
		})
	end,
}

require("mxie.set")
require("mxie.remap")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	spec = {
		{ import = "mxie.lazy", lazy = true },
		{ import = "mxie.eager" },
	},
}

local opts = {
	defaults = {
		lazy = true,
	},
	change_detection = {
		notify = false,
	},
	install = {
		colorscheme = { "kanagawa-dragon" },
	},
}

require("lazy").setup(plugins, opts)
vim.keymap.set("n", "<leader>L", ":Lazy<CR>")

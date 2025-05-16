print("Loading root init.lua")
-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local group_cdpwd = vim.api.nvim_create_augroup("group_cdpwd", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = group_cdpwd,
  pattern = "*",
  callback = function()
    vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
  end,
})


require("set")
require("keys")
require("filetype")

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
		{ import = "eagerload" },
    { import = "lazyload", lazy = true },
	},
}

local opts = {
	change_detection = {
		notify = true,
	},
}

require("lazy").setup(plugins, opts)
vim.keymap.set("n", "<leader>L", ":Lazy<CR>")

-- require("lsp") -- replaced by nvim-lspconfig

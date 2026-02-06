vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.title = true

vim.g.markdown_recommended_style = 0
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.linebreak = true -- for when wrap is turned on manually

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.o.winborder = "single"

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- fold
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"
vim.opt.cursorline = true

vim.opt.conceallevel = 0
vim.opt.fillchars:append { diff = "╱" }

vim.cmd.colorscheme('retrobox')

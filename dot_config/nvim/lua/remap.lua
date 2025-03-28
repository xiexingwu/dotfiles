vim.g.mapleader = " "
vim.g.maplocalleader = ";"
-- visual mode move line up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Editing
vim.keymap.set("n", "<BS>", "diw")
vim.keymap.set("n", "J", "mzJ`z") -- Join but keep cursor position

-- Scrolling
-- vim.keymap.set("n", "<leader>j", "5<C-E>")  -- use zz,zt,zb etc.
-- vim.keymap.set("n", "<leader>k", "5<C-Y>")
vim.keymap.set("n", "<C-D>", "<C-d>zz") -- scroll and centre cursor
vim.keymap.set("n", "<C-U>", "<C-u>zz")
-- vim.keymap.set("n", "{", "6k")
-- vim.keymap.set("n", "}", "6j")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>sb", ":set scrollbind<CR>", { desc = "[S]croll[b]ind On" })
vim.keymap.set("n", "<leader>sB", ":set scrollbind!<CR>", { desc = "[S]croll[b]ind Off!" })

-- P but keep register
-- vim.keymap.set("v", "<leader>p", [["_dPgv]])

-- yank to system copy/paste
vim.keymap.set("v", "<T-C>", [["+y]])
vim.keymap.set("v", "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>y", [[mzV"+yzz]])

-- windows/tabs
vim.keymap.set("n", "<C-q>", vim.cmd.quit, { desc = "Quit window" })
vim.keymap.set("n", "<leader>bo", ":%bd|e#<CR>", { desc = "Keep This [B]uffer [O]nly"})

-- misc
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-S-;>", "q:")
vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("n", "\\", "<C-^>", { desc = "Alternate file" })

vim.keymap.set("n", "<leader>l", "<cmd>noh<CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<leader>w", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })

vim.keymap.set('n', '<space>K', vim.diagnostic.open_float)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- plugins
vim.keymap.set("n", "<C-W>r", "<nop>") -- smart-splits resize mode

-- reload init.lua
vim.keymap.set("n", "<leader>rr", "<cmd>source" .. vim.api.nvim_eval("$MYVIMRC") .. "<CR>", { desc = "[R]eload config" })

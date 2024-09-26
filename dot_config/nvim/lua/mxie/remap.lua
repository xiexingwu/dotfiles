vim.g.mapleader = " "
vim.g.maplocalleader = ","
-- visual mode move line up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Editing
vim.keymap.set("n", "<BS>", "diw")
vim.keymap.set("n", "J", "mzJ`z") -- Join but keep cursor position

-- move and centre cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- P but keep register
vim.keymap.set("v", "<leader>p", [["_dPgv]])

-- yank to system copy/paste
vim.keymap.set("v", "<T-c>", [["+y]])
vim.keymap.set("v", "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>y", [[mzV"+yzz]])

-- misc
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "q:", "<nop>") -- use :<C-f> instead
vim.keymap.set("n", "<A-w>", "<cmd>bd<CR>", { desc = "Close buffer" })

vim.keymap.set("n", "<leader>l", "<cmd>noh<CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<leader>w", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>K', vim.diagnostic.open_float)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- plugins
vim.keymap.set("n", "<C-w>r", "<nop>") -- smart-splits resize mode
vim.keymap.set("n", "<leader>FML", "<cmd>CellularAutomaton make_it_rain<CR>")

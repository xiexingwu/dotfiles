vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- Editing
vim.keymap.set("n", "J", "mzJ`z") -- Join but keep cursor position
-- Add empty lines before and after cursor line
vim.keymap.set('n', ']O', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
vim.keymap.set('n', ']o', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")

-- Scrolling
vim.keymap.set("n", "<C-D>", "<C-d>zz") -- scroll and centre cursor
vim.keymap.set("n", "<C-U>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>tsb", ":set scrollbind!<CR>", { desc = "[T]oggle [S]croll[b]ind" })

-- yank to system copy/paste
vim.keymap.set("v", "<T-C>", [["+y]])
vim.keymap.set("v", "<leader>y", [["+y]], { desc = '[Y]ank to Pasteboard' })
-- vim.keymap.set("n", "<leader>y", [[mzV"+yzz]])
-- vim.keymap.set("n", "<leader>y%", [[<cmd>let @+=@%<CR>]])

-- buffers/windows/tabs
vim.keymap.set("n", "<C-q>", vim.cmd.quit, { desc = "Quit window" })
vim.keymap.set("n", "<leader>bo", ":%bd|e#<CR>", { desc = "Keep This [B]uffer [O]nly" })
vim.keymap.set("n", "<Tab>", "gt", { desc = "Next Tab" })
vim.keymap.set("n", "<S-Tab>", "gT", { desc = "Alternate Tab" })
vim.keymap.set("n", "<C-W>\\", "<C-W>^", { desc = "Split [Alternate]" })
vim.keymap.set("n", "<C-W>gt", "<C-W>T", { desc = "Split -> [T]ab" })
vim.keymap.del("n", "<C-W><C-D>");

-- Terminal
vim.keymap.set("t", "<C-\\><C-\\>", "<C-\\><C-N>", {desc = "Terminal Escape"})

-- Folds
vim.keymap.set("n", "zo", "zO", { desc = "Fold [O]pen (recursive)" })
vim.keymap.set("n", "zc", "zC", { desc = "Fold [C]lose (recursive)" })

-- misc
vim.keymap.set("n", "Q", "<nop>") -- use @@
vim.keymap.set("n", "<leader>;", "q:", { desc = "Cmdline window" })
vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("n", "\\", "<C-^>", { desc = "Alternate file" })

vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<CR>", { desc = "[T]oggle [W]rap" })

-- reload init.lua
vim.keymap.set("n", "<leader>R", "<cmd>source" .. vim.api.nvim_eval("$MYVIMRC") .. "<CR>", { desc = "[R]eload config" })

-- LSP See Snacks.picker for picker-related LSP functions
vim.keymap.set('n', '<space>ld', vim.diagnostic.open_float, { desc = "LSP [D]iagnostic (Popup)" })
vim.keymap.set("n", "<space>ll", vim.diagnostic.setloclist, { desc = "LSP diagnostic [L]oclist" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP [R]ename" })

-- term/multiplexer integration
local nav = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function navigate(dir)
  return function()
    -- First change nvim window
    local win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(dir)

    -- Then try to change zellij pane
    local pane = vim.env.ZELLIJ
    local pane_dir = nav[dir]
    local action = "move-focus"
    -- if pane_dir == "Left" or pane_dir == "Right" then
    --   action = "move-focus-or-tab"
    -- end
    if pane and win == vim.api.nvim_get_current_win() then
      vim.system(
        { "zellij", "action", action, pane_dir },
        { text = true },
        function(p)
          if p.code ~= 0 then
            vim.notify(
              "Failed to move to pane " .. pane_dir .. "\n" .. p.stderr,
              vim.log.levels.ERROR,
              { title = "Zellij" }
            )
          end
        end)
    end
  end
end

-- Move to window using the movement keys
for key, dir in pairs(nav) do
  vim.keymap.set("n", "<C-" .. key .. ">", navigate(key), { desc = "smart-split: " .. dir })
end

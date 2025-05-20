vim.g.mapleader = " "
vim.g.maplocalleader = ";"

vim.keymap.set("n", "<leader>qq", ":qa")
vim.keymap.set("n", "<leader>ww", ":wa")
-- visual mode move line up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

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
vim.keymap.set("v", "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>y", [[mzV"+yzz]])

-- buffers/windows/tabs
vim.keymap.set("n", "<C-q>", vim.cmd.quit, { desc = "Quit window" })
vim.keymap.set("n", "<leader>bo", ":%bd|e#<CR>", { desc = "Keep This [B]uffer [O]nly" })
vim.keymap.set("n", "<C-i>", "<Tab>", { desc = "Jumplist" }) -- gets overwrriten if Tab is remapped
vim.keymap.set("n", "<Tab>", "gt", { desc = "Next Tab" })
vim.keymap.set("n", "<S-Tab>", "<C-Tab>", { desc = "Alternate Tab" })

-- misc
vim.keymap.set("n", "Q", "<nop>") -- use @@
vim.keymap.set("n", "<leader>;", "q:", { desc = "Open Command-line window" })
vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("n", "\\", "<C-^>", { desc = "Alternate file" })

vim.keymap.set("n", "<leader>l", "<cmd>noh<CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<leader>dm", "<cmd>delm!<CR>", { desc = "[D]elete [M]arks" })
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<CR>", { desc = "[T]oggle [W]rap" })

vim.keymap.set('n', '<space>K', vim.diagnostic.open_float)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- reload init.lua
vim.keymap.set("n", "<leader>rr", "<cmd>source" .. vim.api.nvim_eval("$MYVIMRC") .. "<CR>", { desc = "[R]eload config" })
-- See Snacks.picker for picker-related LSP functions
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame" })
vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, { desc = "LSP: [F]or[m]at" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "[D]iagnostic popup" })

-- wezterm integration
local nav = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function navigate(dir)
  return function()
    print("triggered " .. dir)
    -- First change nvim window
    local win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(dir)

    -- Then try to change wezterm pane
    local pane = vim.env.WEZTERM_PANE
    local pane_dir = nav[dir]
    if pane and win == vim.api.nvim_get_current_win() then
      vim.system(
        { "wezterm", "cli", "activate-pane-direction", pane_dir },
        { text = true },
        function(p)
          if p.code ~= 0 then
            vim.notify(
              "Failed to move to pane " .. pane_dir .. "\n" .. p.stderr,
              vim.log.levels.ERROR,
              { title = "Wezterm" }
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
vim.keymap.set("n", "<S-H>", function() vim.cmd.wincmd("h") end, { desc = "smart-split: Left" })
vim.keymap.set("n", "<S-L>", function() vim.cmd.wincmd("l") end, { desc = "smart-split: Right" })

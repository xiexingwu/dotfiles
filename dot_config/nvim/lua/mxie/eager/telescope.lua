return
{
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
        require("telescope").load_extension("fzf")
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>h', builtin.keymaps, {desc = "ALL Keymaps"})
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = "Telescope"})
        vim.keymap.set('n', '<leader>fc', builtin.commands, {desc = "Command history (Telescope)"})
        vim.keymap.set('n', '<leader>of', builtin.oldfiles, {desc = "Old files (Telescope)"})
        vim.keymap.set('n', '<leader>rg', builtin.live_grep, {desc = "rgrep (Telescope)"})
        vim.keymap.set('n', '<leader>b',
            function()
                builtin.buffers({
                    ignore_current_buffer = true,
                    sort_mru = true,
                })
            end,
            {}
        )
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = "Help tags (Telescope)"})
    end
}

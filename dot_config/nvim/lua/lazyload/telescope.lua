local config =  {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- "kkharji/sqlite.lua",
    -- "nvim-telescope/telescope-smart-history.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  lazy = true,
  event = "VeryLazy",
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    function reenter_to_normal_mode(prompt_bufnr)
      -- local picker = actions.state.get_current_picker(prompt_bufnr)
      actions.close(prompt_bufnr)
      builtin.resume({ initial_mode = 'normal' })
    end

    function toggle_gitignore(prompt_bufnr)
      require("notify").notify("toggle .gitignore not implemented")
      -- local picker = actions.state.get_current_picker(prompt_bufnr)
      -- actions.close(prompt_bufnr)
      -- builtin.resume({ initial_mode = 'normal' })
    end

    -- setup
    telescope.setup({
      extensions = {
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        }
      },
      defaults = {
        scroll_stragetgy = 'limit',
        dynamic_preview_title = true,
        path_display = {
          truncate = 3,
          -- smart = {},
          -- shorten = { len = 1, exclude = { 1, -1 } }
        },
        results_title = false,
        history = {
          -- path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
          limit = 10,
        },
        mappings = {
          i = {
            ["<Esc>"] = actions.close,
            ["<C-c>"] = reenter_to_normal_mode,
            ["<C-g>"] = toggle_gitignore,
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
          },
        },
      },
      pickers = {
        find_files = {
          theme = "ivy",
        },
        keymaps = { theme = "ivy" },
        commands = { theme = "ivy" },
        oldfiles = { theme = "ivy" },
        live_grep = { theme = "ivy", additional_args = { "--multiline" } },
        buffers = {
          theme = "ivy",
          initial_mode = 'normal',
          ignore_current_buffer = true,
          sort_mru = true,
        },
      },
    })
    telescope.load_extension("fzf")
    -- telescope.load_extension("smart_history")

    vim.keymap.set("n", "<C-P>", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>rg", builtin.live_grep, { desc = "rgrep (Telescope)" })
    vim.keymap.set("n", "<leader>of", builtin.oldfiles, { desc = "[O]pen old [F]iles (Telescope)" })
    vim.keymap.set("n", "<leader>ob", builtin.buffers, { desc = "[O]pen [B]uffers (Telescope)" })
    vim.keymap.set("n", "<leader>oc", builtin.commands, { desc = "[O]pen [C]ommand History (Telescope)" })
    vim.keymap.set("n", "<leader>hh", builtin.help_tags, { desc = "[H]elp tags (Telescope)" })
    vim.keymap.set("n", "<leader>hm", builtin.keymaps, { desc = "All [K]eymaps (Telescope)" })
  end,
}

-- return config
return {}

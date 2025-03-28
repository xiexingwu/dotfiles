---@class snacks.picker.Config
---@field multi? (string|snacks.picker.Config)[]
---@field source? string source name and config to use
---@field pattern? string|fun(picker:snacks.Picker):string pattern used to filter items by the matcher
---@field search? string|fun(picker:snacks.Picker):string search string used by finders
---@field cwd? string current working directory
---@field live? boolean when true, typing will trigger live searches
---@field limit? number when set, the finder will stop after finding this number of items. useful for live searches
---@field ui_select? boolean set `vim.ui.select` to a snacks picker
--- Source definition
---@field items? snacks.picker.finder.Item[] items to show instead of using a finder
---@field format? string|snacks.picker.format|string format function or preset
---@field finder? string|snacks.picker.finder|snacks.picker.finder.multi finder function or preset
---@field preview? snacks.picker.preview|string preview function or preset
---@field matcher? snacks.picker.matcher.Config|{} matcher config
---@field sort? snacks.picker.sort|snacks.picker.sort.Config sort function or config
---@field transform? string|snacks.picker.transform transform/filter function
--- UI
---@field win? snacks.picker.win.Config
---@field layout? snacks.picker.layout.Config|string|{}|fun(source:string):(snacks.picker.layout.Config|string)
---@field icons? snacks.picker.icons
---@field prompt? string prompt text / icon
---@field title? string defaults to a capitalized source name
---@field auto_close? boolean automatically close the picker when focusing another window (defaults to true)
---@field show_empty? boolean show the picker even when there are no items
---@field focus? "input"|"list" where to focus when the picker is opened (defaults to "input")
---@field enter? boolean enter the picker when opening it
---@field toggles? table<string, string|false|snacks.picker.toggle>
--- Preset options
---@field previewers? snacks.picker.previewers.Config|{}
---@field formatters? snacks.picker.formatters.Config|{}
---@field sources? snacks.picker.sources.Config|{}|table<string, snacks.picker.Config|{}>
---@field layouts? table<string, snacks.picker.layout.Config>
--- Actions
---@field actions? table<string, snacks.picker.Action.spec> actions used by keymaps
---@field confirm? snacks.picker.Action.spec shortcut for confirm action
---@field auto_confirm? boolean automatically confirm if there is only one item
---@field main? snacks.picker.main.Config main editor window config
---@field on_change? fun(picker:snacks.Picker, item?:snacks.picker.Item) called when the cursor changes
---@field on_show? fun(picker:snacks.Picker) called when the picker is shown
---@field on_close? fun(picker:snacks.Picker) called when the picker is closed
---@field jump? snacks.picker.jump.Config|{}
--- Other
---@field config? fun(opts:snacks.picker.Config):snacks.picker.Config? custom config function
---@field db? snacks.picker.db.Config|{}
---@field debug? snacks.picker.debug|{}
local picker_config = {
  prompt = " ",
  sources = {},
  focus = "input",
  layout = {
    cycle = true,
    --- Use the default layout or vertical if the window is too narrow
    preset = function()
      return vim.o.columns >= 120 and "default" or "vertical"
    end,
  },
  ---@class snacks.picker.matcher.Config
  matcher = {
    fuzzy = true,          -- use fuzzy matching
    smartcase = true,      -- use smartcase
    ignorecase = true,     -- use ignorecase
    sort_empty = false,    -- sort results when the search string is empty
    filename_bonus = true, -- give bonus for matching file names (last part of the path)
    file_pos = true,       -- support patterns like `file:line:col` and `file:line`
    -- the bonusses below, possibly require string concatenation and path normalization,
    -- so this can have a performance impact for large lists and increase memory usage
    cwd_bonus = true,      -- give bonus for matching files in the cwd
    frecency = true,       -- frecency bonus
    history_bonus = false, -- give more weight to chronological order
  },
  sort = {
    -- default sort is by score, text length and index
    fields = { "score:desc", "#text", "idx" },
  },
  ui_select = true, -- replace `vim.ui.select` with the snacks picker
  ---@class snacks.picker.formatters.Config
  formatters = {
    text = {
      ft = nil, ---@type string? filetype for highlighting
    },
    file = {
      filename_first = false, -- display filename before the file path
      truncate = 40,          -- truncate the file path to (roughly) this length
      filename_only = false,  -- only show the filename
      icon_width = 2,         -- width of the icon (in characters)
      git_status_hl = true,   -- use the git status highlight group for the filename
    },
    selected = {
      show_always = false, -- only show the selected column when there are multiple selections
      unselected = true,   -- use the unselected icon for unselected items
    },
    severity = {
      icons = true,  -- show severity icons
      level = false, -- show severity level
      ---@type "left"|"right"
      pos = "left",  -- position of the diagnostics
    },
  },
  ---@class snacks.picker.previewers.Config
  previewers = {
    diff = {
      builtin = true,    -- use Neovim for previewing diffs (true) or use an external tool (false)
      cmd = { "delta" }, -- example to show a diff with delta
    },
    git = {
      builtin = true, -- use Neovim for previewing git output (true) or use git (false)
      args = {},      -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
    },
    file = {
      max_size = 1024 * 1024, -- 1MB
      max_line_length = 500,  -- max line length
      ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
    },
    man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
  },
  ---@class snacks.picker.jump.Config
  jump = {
    jumplist = true,   -- save the current position in the jumplist
    tagstack = false,  -- save the current position in the tagstack
    reuse_win = false, -- reuse an existing window if the buffer is already open
    close = true,      -- close the picker when jumping/editing to a location (defaults to true)
    match = false,     -- jump to the first match position. (useful for `lines`)
  },
  toggles = {
    follow = "f",
    hidden = "h",
    ignored = "i",
    modified = "m",
    regex = { icon = "R", value = false },
  },
  win = {
    -- input window
    input = {
      keys = {
        -- to close the picker on ESC instead of going to normal mode,
        -- add the following keymap to your config
        -- ["<Esc>"] = { "close", mode = { "n", "i" } },
        ["q"] = "close",
        ["<Esc>"] = "cancel",
        ["<C-c>"] = { "cancel", mode = "i" },
        ["<CR>"] = { "confirm", mode = { "n", "i" } },
        ["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
        ["<c-t>"] = { "tab", mode = { "n", "i" } },
        ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
        ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },

        ["<Down>"] = { "list_down", mode = { "i", "n" } },
        ["<Up>"] = { "list_up", mode = { "i", "n" } },
        ["j"] = "list_down",
        ["k"] = "list_up",
        ["<c-j>"] = { "list_down", mode = { "i", "n" } },
        ["<c-k>"] = { "list_up", mode = { "i", "n" } },
        ["<c-n>"] = { "list_down", mode = { "i", "n" } },
        ["<c-p>"] = { "list_up", mode = { "i", "n" } },
        ["G"] = "list_bottom",
        ["gg"] = "list_top",

        ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
        ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
        ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
        ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },

        ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
        ["<C-Up>"] = { "history_back", mode = { "i", "n" } },

        ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },

        -- ["<a-d>"] = { "inspect", mode = { "n", "i" } },
        -- ["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
        -- ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
        ["<a-i>"] = { { "toggle_ignored", "toggle_hidden" }, mode = { "i", "n" } },
        ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
        ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
        ["<a-w>"] = { "cycle_win", mode = { "i", "n" } },

        ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },

        ["<c-a>"] = { "select_all", mode = { "n", "i" } },
        ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
        ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
        ["<c-q>"] = { "qflist", mode = { "i", "n" } },
        ["<c-l>"] = { "loclist", mode = { "i", "n" } },

        -- ["<c-r>#"] = { "insert_alt", mode = "i" },
        -- ["<c-r>%"] = { "insert_filename", mode = "i" },
        ["<c-r><c-a>"] = { "insert_cWORD", mode = "i" },
        ["<c-r><c-f>"] = { "insert_file", mode = "i" },
        ["<c-r><c-l>"] = { "insert_line", mode = "i" },
        ["<c-r><c-p>"] = { "insert_file_full", mode = "i" },
        ["<c-r><c-w>"] = { "insert_cword", mode = "i" },

        -- ["<c-w>H"] = "layout_left",
        ["<c-w>J"] = "layout_bottom",
        ["<c-w>K"] = "layout_top",
        -- ["<c-w>L"] = "layout_right",

        ["?"] = "toggle_help_input",
      },
      b = {
        minipairs_disable = true,
      },
    },
  },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@class snacks.Config
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    explorer = { enabled = true },
    image = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = picker_config,
    quickfile = { enabled = true },
    scope = { enabled = true },
    -- scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },

  keys = {
    -- Common Pickers
    { "<C-p>",            function() Snacks.picker.smart() end,                                                        desc = "Picker: Smart" },
    { "<leader><leader>", function() Snacks.picker.resume() end,                                                       desc = "Picker: Resume" },
    { "<leader>,",        function() Snacks.picker.buffers() end,                                                      desc = "Picker: Buffers" },
    { "<leader>/",        function() Snacks.picker.grep() end,                                                         desc = "Picker: Search" },
    { "<leader>?",        function() Snacks.picker.grep_buffers() end,                                                 desc = "Picker: Search Buffers" },
    { "<leader>:",        function() Snacks.picker.command_history() end,                                              desc = "Picker: Command History" },
    { "<leader>N",        function() Snacks.picker.notifications() end,                                                desc = "Picker: Notifications" },
    { "<leader>e",        function() Snacks.explorer() end,                                                            desc = "Picker: [E]xplorer" },
    { '<leader>"',        function() Snacks.picker.registers() end,                                                    desc = "Picker: Registers" },
    { "<leader>`",        function() Snacks.picker.marks() end,                                                        desc = "Picker: Marks" },

    -- Pick
    { "<leader>pb",       function() Snacks.picker.buffers() end,                                                      desc = "[P]ick [B]uffers" },
    { "<leader>pf",       function() Snacks.picker.files() end,                                                        desc = "[P]ick [F]iles" },
    { "<leader>pg",       function() Snacks.picker.git_files() end,                                                    desc = "[P]ick [G]it Files" },
    { "<leader>pp",       function() Snacks.picker.projects({ recent = false, dev = { "~/src/", "~/src/ddr/" } }) end, desc = "[P] [P]rojects" },
    { "<leader>pr",       function() Snacks.picker.recent() end,                                                       desc = "[P]ick [R]ecent" },
    -- { "<leader>pc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },

    -- Git
    { "<leader>gB",       function() Snacks.picker.git_branches() end,                                                 desc = "[G]it [B]ranches" },
    { "<leader>gl",       function() Snacks.picker.git_log() end,                                                      desc = "[G]it [L]og" },
    { "<leader>gL",       function() Snacks.picker.git_log_line() end,                                                 desc = "[G]it Log ([L]ine)" },
    { "<leader>gs",       function() Snacks.picker.git_status() end,                                                   desc = "[G]it [S]tatus" },
    { "<leader>gS",       function() Snacks.picker.git_stash() end,                                                    desc = "[G]it [S]tash" },
    { "<leader>gd",       function() Snacks.picker.git_diff() end,                                                     desc = "[G]it [D]iff (Hunks)" },
    { "<leader>gf",       function() Snacks.picker.git_log_file() end,                                                 desc = "[G]it Log ([F]ile)" },

    -- Search
    { "<leader>sb",       function() Snacks.picker.lines() end,                                                        desc = "[S]earch [B]uffer" },
    { "<leader>sw",       function() Snacks.picker.grep_word() end,                                                    desc = "[S]earch [W]ord (or visual)",    mode = { "n", "x" } },
    { '<leader>s/',       function() Snacks.picker.search_history() end,                                               desc = "[S]earch Search History" },
    { "<leader>sd",       function() Snacks.picker.diagnostics_buffer() end,                                           desc = "[S]earch [D]iagnostics (Buffer)" },
    { "<leader>sD",       function() Snacks.picker.diagnostics() end,                                                  desc = "[S]earch [D]iagnostics (All)" },
    { "<leader>sl",       function() Snacks.picker.loclist() end,                                                      desc = "Location List" },
    -- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq",       function() Snacks.picker.qflist() end,                                                       desc = "Quickfix List" },
    { "<leader>su",       function() Snacks.picker.undo() end,                                                         desc = "Undo History" },

    { "<leader>si",       function() Snacks.picker.icons() end,                                                        desc = "Icons" },

    -- Nvim meta
    { "<leader>ha",       function() Snacks.picker.autocmds() end,                                                     desc = "[H]elp: Autocmds" },
    { "<leader>hc",       function() Snacks.picker.commands() end,                                                     desc = "[H]elp: Commands" },
    { "<leader>hh",       function() Snacks.picker.help() end,                                                         desc = "[H]elp: [H]elp topics" },
    { "<leader>hH",       function() Snacks.picker.highlights() end,                                                   desc = "[H]elp: [H]ighlights" },
    { "<leader>hk",       function() Snacks.picker.keymaps() end,                                                      desc = "[H]elp: [K]eymaps" },
    { "<leader>hm",       function() Snacks.picker.man() end,                                                          desc = "[H]elp: [M]an Pages" },
    { "<leader>hC",       function() Snacks.picker.colorschemes() end,                                                 desc = "[H]elp [C]olorschemes" },

    -- LSP
    { "gd",               function() Snacks.picker.lsp_definitions() end,                                              desc = "[G]oto [D]efinition" },
    { "gD",               function() Snacks.picker.lsp_declarations() end,                                             desc = "[G]oto [D]eclaration" },
    { "gr",               function() Snacks.picker.lsp_references() end,                                               nowait = true,                           desc = "[G]oto [R]eferences" },
    { "gI",               function() Snacks.picker.lsp_implementations() end,                                          desc = "[G]oto [I]mplementation" },
    { "gy",               function() Snacks.picker.lsp_type_definitions() end,                                         desc = "[G]oto T[y]pe Definition" },
    { "<leader>ss",       function() Snacks.picker.lsp_symbols() end,                                                  desc = "LSP Symbols" },
    { "<leader>sS",       function() Snacks.picker.lsp_workspace_symbols() end,                                        desc = "LSP Workspace Symbols" },

    -- Other
    { "<C-B>",            function() Snacks.bufdelete() end,                                                           desc = "Delete Buffer" },
    { "<leader>rf",       function() Snacks.rename.rename_file() end,                                                  desc = "[R]ename [F]ile" },
    { "<c-/>",            function() Snacks.terminal() end,                                                            desc = "Toggle Terminal" },

    { "]]",               function() Snacks.words.jump(vim.v.count1) end,                                              desc = "Next Reference",                 mode = { "n", "t" } },
    { "[[",               function() Snacks.words.jump(-vim.v.count1) end,                                             desc = "Prev Reference",                 mode = { "n", "t" } },

  }
}

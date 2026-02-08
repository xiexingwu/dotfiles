local currentDir = debug.getinfo(1).source:match("@?(.*/)") or ""
package.path = package.path .. ";" .. currentDir .. "?.lua"
local picker_config = require("picker")
local image_config = require("image")
local dashboard_config = require("dashboard")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@class snacks.Config
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = dashboard_config,
    explorer = { enabled = true },
    -- image = image_config,
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = picker_config,
    quickfile = { enabled = true },
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
    { "<leader>u",        function() Snacks.picker.undo() end,                                                         desc = "Undo History" },

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
    { "gD",               function() vim.cmd(":tab split | lua vim.lsp.buf.definition()") end,                         desc = "[G]oto [D]efiniion (new tab)" },
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

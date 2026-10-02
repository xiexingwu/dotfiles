-- Debugging. Zig (and C/C++) via Xcode's lldb-dap.
-- Stepping keys (<leader>D c/n/i/o/r) form a mini.clue submode: keep tapping, <Esc> to leave.

local function zig_build_exe()
  local res = vim.system({ "zig", "build" }, { text = true }):wait()
  if res.code ~= 0 then
    vim.notify("zig build failed:\n" .. res.stderr, vim.log.levels.ERROR)
    return require("dap").ABORT
  end
  local exes = vim.fn.glob("zig-out/bin/*", false, true)
  if #exes == 0 then
    vim.notify("no executables in zig-out/bin", vim.log.levels.ERROR)
    return require("dap").ABORT
  end
  if #exes == 1 then return exes[1] end
  return require("dap.ui").pick_one(exes, "Executable: ", function(p) return vim.fn.fnamemodify(p, ":t") end)
      or require("dap").ABORT
end

local function zig_build_test()
  local out = "zig-out/dap/" .. vim.fn.expand("%:t:r") .. "-test"
  vim.fn.mkdir(vim.fn.fnamemodify(out, ":h"), "p")
  local res = vim.system({ "zig", "test", vim.fn.expand("%"), "--test-no-exec", "-femit-bin=" .. out }, { text = true })
      :wait()
  if res.code ~= 0 then
    vim.notify("zig test build failed:\n" .. res.stderr, vim.log.levels.ERROR)
    return require("dap").ABORT
  end
  return out
end

local function prompt_args()
  local input = vim.fn.input("Args: ")
  return vim.split(input, " ", { trimempty = true })
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        version = "1.*",
        opts = {
          auto_toggle = true,
          virtual_text = { enabled = true },
        },
      },
    },
    keys = {
      { "<leader>Db", function() require("dap").toggle_breakpoint() end,                                    desc = "[B]reakpoint toggle" },
      { "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,            desc = "[B]reakpoint (conditional)" },
      { "<leader>Dc", function() require("dap").continue() end,                                             desc = "[C]ontinue / start" },
      { "<leader>Dn", function() require("dap").step_over() end,                                            desc = "Step over ([N]ext)" },
      { "<leader>Di", function() require("dap").step_into() end,                                            desc = "Step [I]nto" },
      { "<leader>Do", function() require("dap").step_out() end,                                             desc = "Step [O]ut" },
      { "<leader>Dr", function() require("dap").run_to_cursor() end,                                        desc = "[R]un to cursor" },
      { "<leader>Dl", function() require("dap").run_last() end,                                             desc = "Run [L]ast" },
      { "<leader>Dq", function() require("dap").terminate() end,                                            desc = "[Q]uit session" },
      { "<leader>Dv", "<Cmd>DapViewToggle<CR>",                                                             desc = "[V]iew toggle" },
      { "<leader>Dw", "<Cmd>DapViewWatch<CR>",                                                              desc = "[W]atch expression", mode = { "n", "x" } },
      { "<leader>Dk", function() require("dap.ui.widgets").hover() end,                                     desc = "Hover value ([K])" },
    },
    config = function()
      local dap = require("dap")

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "Visual" })

      local lldb_dap = vim.trim(vim.system({ "xcrun", "-f", "lldb-dap" }, { text = true }):wait().stdout or "")
      dap.adapters.lldb = { type = "executable", command = lldb_dap, name = "lldb" }

      local base = { type = "lldb", request = "launch", cwd = "${workspaceFolder}", stopOnEntry = false }
      dap.configurations.zig = {
        vim.tbl_extend("force", base, { name = "zig build → launch", program = zig_build_exe }),
        vim.tbl_extend("force", base, { name = "zig build → launch (args)", program = zig_build_exe, args = prompt_args }),
        vim.tbl_extend("force", base, { name = "zig test current file", program = zig_build_test }),
      }
      dap.configurations.c = {
        vim.tbl_extend("force", base, {
          name = "Launch executable",
          program = function() return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file") end,
        }),
      }
      dap.configurations.cpp = dap.configurations.c
    end,
  },
}

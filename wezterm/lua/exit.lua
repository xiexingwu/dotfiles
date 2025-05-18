local wezterm = require("wezterm") --[[@as Wezterm]]
local act = wezterm.action
local G = wezterm.GLOBAL

wezterm.on('update-status',
  ---This callback quits the wezterm-gui if it's last pane
  ---Each wezterm-gui instance has its own PID and contains its own wezterm.GLOBAL
  ---WARNING: This breaks the default SwitchToWorkspace action since changing to a
  --- new workspace will just quit the application. New windows are nonetheless opened
  --- and will likely cause wezterm to crash.
  --- Workaround: set GLOBAL.unique_workspace to nil before calling SwitchToWorkspace.
  function(win, pane)
    local ws_new = win:active_workspace()
    local ws_old = G.unique_workspace

    if not ws_old then
      wezterm.log_info("Setting unique_workspace:", ws_new)
      G.unique_workspace = ws_new
      return
    end

    if ws_new ~= ws_old then
      if ws_new == G.startup_workspace then
        wezterm.log_info("Returned to startup_workspace:", ws_new)
        G.unique_workspace = ws_new
      else
        wezterm.log_info("Workspace change", ws_old, "->", ws_new, "(startup: ", G.startup_workspace,
          ") expected to QuitApplication.")
        win:perform_action(act.QuitApplication, pane)
      end
    end
  end
)

return {
  apply_to_config = function(config)
  end
}

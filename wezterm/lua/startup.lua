local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

wezterm.on("gui-attached", function(domain)
  local workspace = mux.get_active_workspace()
  if workspace == "scratch" then
    for _, window in ipairs(mux.all_windows()) do
      local gwin = window:gui_window()
      gwin:perform_action(act.SetWindowLevel "AlwaysOnTop", gwin:active_pane())
    end
  end
end)

return {
  apply_to_config = function(config)
    config.default_workspace = "work"
  end
}

local wezterm = require("wezterm")
local mux = wezterm.mux

-- Window name
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  local zoomed = ""
  if tab.active_pane.is_zoomed then
    zoomed = "[Z] "
  end

  local index = ""
  if #tabs > 1 then
    index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
  end

  -- Workspace
  local ws = mux.get_active_workspace():gsub("^%l", string.upper)
  return ws .. " | " .. zoomed .. index .. tab.active_pane.title
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = pane.title
  if pane.domain_name then
    title = title .. ' - (' .. pane.domain_name .. ')'
  end
  return title
end)

function apply_to_config(config)
  config.color_scheme = "catppuccin-mocha"
  config.force_reverse_video_cursor = true
  -- config.font = wezterm.font("MesloLGM Nerd Font Mono")
  config.font = wezterm.font("JetBrains Mono")
  config.font_size = 14

  config.command_palette_font_size = 14
end

return {
  apply_to_config = apply_to_config
}

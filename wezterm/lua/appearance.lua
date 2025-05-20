local wezterm = require("wezterm") --[[@as Wezterm]]
local mux = wezterm.mux
local act = wezterm.action

local color_scheme = "catppuccin-mocha"
local palette = wezterm.color.get_builtin_schemes()[color_scheme]

local tab_bright = wezterm.color.parse(palette.cursor_bg)
local tab_text_bright = palette.background
local tab_dark = wezterm.color.parse(palette.selection_bg)
local tab_text_dark = palette.cursor_bg

local tabline_dark = wezterm.color.parse(palette.ansi[1]):darken(0.2)

-- Util
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- Tab & Window name
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local zoom = pane.is_zoomed and "[Z]" or ""
  local pane_title = pane.title
  local tab_index
  for _, t in ipairs(tabs) do
    if t.tab_id == tab.tab_id then
      tab_index = t.tab_index + 1
      break
    end
  end

  if pane_title:find("Nvim") then
    pane_title = " " .. pane_title
  elseif pane_title:find("zsh") or pane_title:find("bash") then
    pane_title = " " .. pane_title
  end

  local title = zoom .. (tab_index .. ".") .. pane_title

  -- return title
  return {
    -- LEFT
    { Background = { Color = tab.is_active and tab_index == 1 and tabline_dark or tab_dark } },
    { Foreground = { Color = tab.is_active and tab_bright or tab_dark } },
    { Text = SOLID_LEFT_ARROW },
    -- TEXT
    { Background = { Color = tab.is_active and tab_bright or tab_dark } },
    { Foreground = { Color = tab.is_active and tab_text_bright or tab_text_dark } },
    { Text = wezterm.truncate_right(title, max_width - 2) },
    -- RIGHT
    { Background = { Color = tab_index == #tabs and tabline_dark or tab_dark } },
    { Foreground = { Color = tab.is_active and tab_bright or tab_dark } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

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

-- Scratch
local scratch = "_scratch" -- Keep this consistent with Hammerspoon
wezterm.on("gui-attached", function(domain)
  local workspace = mux.get_active_workspace()
  wezterm.GLOBAL.startup_workspace = workspace
  -- if workspace ~= scratch then return nil end

  for _, window in ipairs(mux.all_windows()) do
    local gwin = window:gui_window()
    if gwin ~= nil then
      if workspace ~= scratch then gwin:set_config_overrides({ window_decorations = "INTEGRATED_BUTTONS" }) end
      gwin:perform_action(act.SetWindowLevel "AlwaysOnTop", gwin:active_pane())
    end
  end
end)

---Handles situations where another window attaches to an existing workspace and a TWM resizs it,
---causing existing window to have insensible inner size.
wezterm.on('update-status', function(win, pane)
  if not win:is_focused() then return end

  local dims = win:get_dimensions()
  win:set_inner_size(dims.pixel_width, dims.pixel_height)
end)

return {
  apply_to_config = function(config)
    config.color_scheme = color_scheme
    config.force_reverse_video_cursor = true
    -- config.font = wezterm.font("MesloLGM Nerd Font Mono")
    config.font = wezterm.font("JetBrains Mono")
    config.font_size = 14

    config.initial_rows = 30
    config.initial_cols = 120

    config.enable_scroll_bar = true
    config.command_palette_font_size = 14
  end
}

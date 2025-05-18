local wezterm = require("wezterm") --[[@as Wezterm]]

local color_scheme = "catppuccin-mocha"
local palette = wezterm.color.get_builtin_schemes()[color_scheme]

local tab_bright = wezterm.color.parse(palette.cursor_bg)
local tab_text_bright = palette.background
local tab_dark = wezterm.color.parse(palette.selection_bg)
local tab_text_dark = palette.cursor_bg

local tabline_text = palette.cursor_fg
local tabline_bright = wezterm.color.parse(palette.ansi[8]):darken(0.3)
local tabline_dark = wezterm.color.parse(palette.ansi[1]):darken(0.2)

local tabline_colors = wezterm.color.gradient({
  colors = {
    tabline_bright,
    tabline_dark,
  }
}, 4)

-- Util
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

function tabPush(elements, color, color_next, text, first, last)
  if (first or "") ~= "" then
    table.insert(elements, { Foreground = { Color = color } })
    color = color_next
    table.insert(elements, { Background = { Color = color } })
    table.insert(elements, { Text = first })
  end

  table.insert(elements, { Foreground = { Color = tabline_text } })
  table.insert(elements, { Background = { Color = color } })
  table.insert(elements, { Text = ' ' .. text .. ' ' })

  if (last or "") ~= "" then
    color = color_next
    table.insert(elements, { Foreground = { Color = color } })
    table.insert(elements, { Text = last })
  end
  return elements
end

wezterm.on("update-status", function(win, pane)
  -- Left
  local mode = win:active_key_table() or "INSERT"
  mode = mode:gsub("_mode", ""):upper()
  local workspace = win:active_workspace():upper()
  local left_texts = { mode, workspace }

  -- Right
  local cwd = ""
  if not pcall(function() pane:get_current_working_dir() end) then
    cwd = pane:get_current_working_dir()
    cwd = cwd and cwd.file_path or ""
  end
  pane:get_current_working_dir()
  local pid = wezterm.procinfo.pid()
  local win_id = win:window_id()
  local pane_id = pane:pane_id()
  local right_texts = { cwd, "PID: " .. pid, "Win/Pane: " .. win_id .. "/" .. pane_id }
  local hasLeader = win:leader_is_active()
  if hasLeader then table.insert(right_texts, 1, "LEADER") end

  -- Generate components to feed into status
  -- Colors are computed such that the inner-most colors are the darkest
  local left_components = {}
  for i, text in ipairs(left_texts) do
    local i_color = #tabline_colors - (#left_texts - i)
    if i == 1 then
      left_components = tabPush(left_components, tabline_colors[i_color], tabline_colors[i_color + 1], text)
    else
      left_components = tabPush(left_components, tabline_colors[i_color - 1], tabline_colors[i_color], text,
        SOLID_RIGHT_ARROW)
    end
  end

  local right_components = {}
  for i, text in ipairs(right_texts) do
    local i_color = #tabline_colors - i + 1
    if i ~= #right_texts then
      right_components = tabPush(right_components, tabline_colors[i_color], tabline_colors[i_color - 1], text, nil,
        SOLID_LEFT_ARROW)
    else
      right_components = tabPush(right_components, tabline_colors[i_color], tabline_colors[i_color - 1], text)
    end
  end
  win:set_left_status(wezterm.format(left_components))
  win:set_right_status(wezterm.format(right_components))
end)


return {
  apply_to_config = function(config)
    config.use_fancy_tab_bar = false
    config.tab_max_width = 32
    config.colors = {
      tab_bar = {
        background = tabline_dark,

        active_tab = {
          bg_color = tab_bright,
          fg_color = tab_text_bright,
          intensity = "Bold", -- Half/Normal/Bold
          underline = "None", -- None/Single/Double
        },

        inactive_tab = {
          bg_color = tab_dark,
          fg_color = tab_text_dark,
          intensity = "Half",
        },

        inactive_tab_hover = {
          bg_color = tab_dark:darken(0.3),
          fg_color = tab_text_dark,
          italic = true,
        },

        new_tab = {
          bg_color = tab_dark:darken(0.3),
          fg_color = tab_text_dark,
          intensity = "Bold", -- Half/Normal/Bold
        },

        new_tab_hover = {
          bg_color = tab_bright,
          fg_color = tab_text_bright,
          intensity = "Bold", -- Half/Normal/Bold
        },
      },
    }
  end
}

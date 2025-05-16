local wezterm = require("wezterm") --[[@as Wezterm]]
local module = {}
local act = wezterm.action

local utils = {}
---Checks whether A contains B
---@param a any
---@param b any
---@return boolean
function utils.contains(a, b)
  for _, e in pairs(a) do
    if e == b then return true end
  end
  return false
end

---Detach the surface it is the last one. Otherwise close.
---@param win any
---@param pane any
---@param surface "tab"|"pane" what the function is trying to close
function detach_if_last_else_close(win, pane, surface)
  local isLastTab = #win:mux_window():tabs() == 1
  local tab = win:active_tab()
  local isLastPane = #tab:panes() == 1
  if surface == "tab" then
    if isLastTab then
      win:perform_action(act.DetachDomain "CurrentPaneDomain", pane)
    else
      win:perform_action(act.CloseCurrentTab({ confirm = true }), pane)
    end
    return
  elseif surface == "pane" then
    if isLastTab and isLastPane then
      win:perform_action(act.DetachDomain "CurrentPaneDomain", pane)
    else
      win:perform_action(act.CloseCurrentPane({ confirm = true }), pane)
    end
    return
  end

  -- fallback is close current tab
  win:perform_action(act.CloseCurrentTab({ confirm = true }), pane)
end

function module.apply_to_config(config)
  config.disable_default_key_bindings = true

  config.leader = { key = ";", mods = "CTRL", timeout_milliseconds = 1000 }

  config.keys = {
    -- Passthrough Cmd+C to other applications
    {
      mods = "CMD",
      key = "c",
      action = wezterm.action_callback(function(win, pane)
        if pane:is_alt_screen_active() then
          win:perform_action(act.SendKey({ key = "c", mods = "CMD" }), pane)
        else
          win:perform_action(act.CompleteSelection("ClipboardAndPrimarySelection"), pane)
        end
      end)
    },
    { mods = "CMD",    key = "v",      action = act.PasteFrom("Clipboard") },

    { mods = "LEADER", key = "p",      action = act.ActivateCommandPalette },
    { mods = "LEADER", key = "E",      action = act.CharSelect }, -- [E]moji

    { mods = "CMD",    key = "k",      action = act.ClearScrollback("ScrollbackAndViewport") },

    -- Modes
    { mods = "LEADER", key = "Escape", action = act.ActivateCopyMode },
    { mods = "LEADER", key = "Enter",  action = act.QuickSelect },
    { mods = "CMD",    key = "f",      action = act.Search({ CaseInSensitiveString = '' }) },
    { mods = "LEADER", key = "a",      action = act.AttachDomain "unix", },
    { mods = "LEADER", key = "d",      action = act.DetachDomain "CurrentPaneDomain", },
    {
      mods = "CMD",
      key = "q",
      action = act.Confirmation {
        message = "Quit WezTerm?",
        action = wezterm.action_callback(function(window, pane) window:perform_action(act.QuitApplication, pane) end),
        cancel = wezterm.action_callback(function() end),
      },
    },
    {
      mods = "CMD",
      key = "w",
      action = wezterm.action_callback(function(win, pane)
        detach_if_last_else_close(win, pane, "tab")
      end)
    },
    {
      mods = "OPT",
      key = "w",
      action = wezterm.action_callback(function(win, pane)
        detach_if_last_else_close(win, pane, "pane")
      end)
    },

    { mods = "CMD",        key = "n",          action = act.SpawnWindow },
    { mods = "CMD",        key = "t",          action = act.SpawnTab("CurrentPaneDomain") },

    { mods = "CTRL",       key = "Tab",        action = act.ActivateTabRelative(1) },
    { mods = "CTRL|SHIFT", key = "Tab",        action = act.ActivateTabRelative(-1) },

    { mods = "LEADER",     key = "v",          action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { mods = "LEADER",     key = "s",          action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- Resize/activate panes (vanilla)
    { mods = "LEADER",     key = "r",          action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
    { mods = "CTRL",       key = "Enter",      action = act.TogglePaneZoomState },

    -- Switch between work/personal workspaces
    -- { mods = "LEADER",     key = "1",          action = action.SwitchToWorkspace({ name = "work" }) },
    -- { mods = "LEADER",     key = "2",          action = action.SwitchToWorkspace({ name = "personal" }) },

    -- Disable minimise & hide
    { mods = "CMD",        key = "m",          action = act.Nop },
    { mods = "CMD",        key = "h",          action = act.Nop },

    -- Jump word
    { mods = "OPT",        key = "LeftArrow",  action = act.SendKey({ key = "b", mods = "ALT", }) },
    { mods = "OPT",        key = "RightArrow", action = act.SendKey({ key = "f", mods = "ALT" }) },
    -- { mods = "OPT",        key = "LeftArrow",  action = action.SendKey { mods = "CTRL", key = "LeftArrow" }, },
    -- { mods = "OPT",        key = "RightArrow", action = action.SendKey { mods = "CTRL", key = "RightArrow" }, },
    { mods = "CMD",        key = "LeftArrow",  action = act.SendString "\x01", }, -- Home
    { mods = "CMD",        key = "RightArrow", action = act.SendString "\x05", }, -- End


    -- Font size
    { mods = "CMD",        key = "=",          action = act.IncreaseFontSize },
    { mods = "CMD",        key = "-",          action = act.DecreaseFontSize },
    { mods = "CMD",        key = "0",          action = act.ResetFontSize },

    -- Scroll
    { mods = nil,          key = "PageUp",     action = act.ScrollByPage(-0.5) },
    { mods = nil,          key = "PageDown",   action = act.ScrollByPage(0.5) },

    {
      mods = 'CMD|SHIFT',
      key = 'N',
      action = act.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Enter name for new workspace' },
        },
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(act.SwitchToWorkspace { name = line, }, pane)
          end
        end),
      },
    },
    { mods = "CTRL|SHIFT", key = "L", action = wezterm.action.ShowDebugOverlay },

  }


  config.key_tables = {
    wez_mode = {

      { key = "Escape", action = "ClearKeyTableStack" },
    },
    resize_pane = {
      { key = "h", action = act.AdjustPaneSize({ "Left", 3 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 3 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 3 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 3 }) },
      {
        key = "0",
        ---Balance panes at the top-level (e.g. try to model as a matrix)
        action = wezterm.action_callback(function(win, pane)
          local panes = win:active_tab():panes_with_info()
          -- Get distinct tops/lefts
          local lefts = {}
          local tops = {}
          for _, pane in pairs(panes) do
            if not utils.contains(tops, pane.top) then table.insert(tops, pane.top) end
            if not utils.contains(lefts, pane.left) then table.insert(lefts, pane.left) end
          end

          local n_width = 1
          local n_height = 1
          for _, top in pairs(tops) do
            local count = 0
            for _, pane in pairs(panes) do
              if pane.top == top then count = count + 1 end
            end
            if count > n_width then n_width = count end
          end
          for _, left in pairs(lefts) do
            local count = 0
            for _, pane in pairs(panes) do
              if pane.left == left then count = count + 1 end
            end
            if count > n_height then n_height = count end
          end

          -- Compute
          local width = win:get_dimensions().pixel_width / n_width
          local height = win:get_dimensions().pixel_height / n_height

          -- Resize
          -- win:perform_action(act.AdjustPaneSize({ "Right", 3}), pane)

          win:perform_action(act.ClearKeyTableStack, pane)
        end)
      },

      { key = "Escape", action = "ClearKeyTableStack" },
    },

    -- Configure Search mode
    search_mode = {
      { mods = nil,    key = "Enter",    action = act.Multiple { { CopyMode = "AcceptPattern" }, { CopyMode = "ClearSelectionMode" } }, },
      { mods = nil,    key = "Escape",   action = act.Multiple { { CopyMode = "ClearPattern" }, { CopyMode = "AcceptPattern" }, { CopyMode = "ClearSelectionMode" } }, },

      { mods = "CTRL", key = "r",        action = act.CopyMode "CycleMatchType" },
      { mods = "CTRL", key = "u",        action = act.CopyMode "ClearPattern" },

      { mods = "CTRL", key = "n",        action = act.CopyMode "NextMatch" },
      { mods = "CTRL", key = "p",        action = act.CopyMode "PriorMatch" },

      { mods = nil,    key = "PageUp",   action = act.CopyMode "PriorMatchPage", },
      { mods = nil,    key = "PageDown", action = act.CopyMode "NextMatchPage", },
      -- { mods = nil,     key = "UpArrow",   action = action.CopyMode "PriorMatch" },
      -- { mods = nil,     key = "DownArrow", action = action.CopyMode "NextMatch" },
    },

    -- Configure Copy mode
    copy_mode = {
      -- Select mode
      -- { mods = "CMD",        key = "f",          action = action.Search({ CaseInSensitiveString = '' }) },
      { mods = nil,     key = "/",        action = act.Multiple { { CopyMode = "ClearPattern" }, { Search = { CaseInSensitiveString = '' } } }, },
      -- { mods = nil,     key = "/",        action = action.Multiple { { CopyMode = "ClearPattern" }, { CopyMode = "EditPattern" } }, },
      { mods = "CTRL",  key = "c",        action = act.CopyMode "Close" },
      { mods = nil,     key = "i",        action = act.CopyMode "Close" },
      { mods = nil,     key = 'y',        action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' }, }, },
      -- { mods = nil,  key = ":",        action = action.ActivateCommandPalette }, -- Use Multiple -> ActivateCommandPalette + CopyMode Close?

      { mods = nil,     key = "v",        action = act.CopyMode { SetSelectionMode = "Cell" }, },
      { mods = "SHIFT", key = "V",        action = act.CopyMode { SetSelectionMode = "Line" }, },
      { mods = "CTRL",  key = "v",        action = act.CopyMode { SetSelectionMode = "Block" }, },
      { mods = nil,     key = "Escape",   action = act.CopyMode "ClearSelectionMode", },

      { mods = nil,     key = "o",        action = act.CopyMode "MoveToSelectionOtherEnd", },
      { mods = "SHIFT", key = "O",        action = act.CopyMode "MoveToSelectionOtherEndHoriz", },

      -- Search
      { mods = nil,     key = "?",        action = act.CopyMode "CycleMatchType" },
      -- { mods = "SHIFT", key = "F",        action = action.CopyMode { JumpBackward = { prev_char = false } }, }, -- undocumented
      -- { mods = "SHIFT", key = "T",        action = action.CopyMode { JumpBackward = { prev_char = true } }, },
      { mods = nil,     key = "n",        action = act.Multiple { { CopyMode = "NextMatch" }, { CopyMode = "ClearSelectionMode" } }, },
      { mods = "SHIFT", key = "N",        action = act.Multiple { { CopyMode = "PriorMatch" }, { CopyMode = "ClearSelectionMode" } }, },

      -- Navigation
      { mods = nil,     key = "h",        action = act.CopyMode "MoveLeft" },
      { mods = nil,     key = "j",        action = act.CopyMode "MoveDown" },
      { mods = nil,     key = "k",        action = act.CopyMode "MoveUp" },
      { mods = nil,     key = "l",        action = act.CopyMode "MoveRight" },

      { mods = nil,     key = "e",        action = act.CopyMode "MoveForwardWordEnd", },
      { mods = nil,     key = 'w',        action = act.CopyMode 'MoveForwardWord' },
      { mods = nil,     key = "b",        action = act.CopyMode "MoveBackwardWord" },

      { mods = "SHIFT", key = "$",        action = act.CopyMode "MoveToEndOfLineContent", },
      { mods = nil,     key = "0",        action = act.CopyMode "MoveToStartOfLine" },
      { mods = nil,     key = "_",        action = act.CopyMode "MoveToStartOfLineContent" },
      { mods = nil,     key = "Enter",    action = act.Multiple { { CopyMode = "MoveDown" }, { CopyMode = "MoveToStartOfLineContent" } }, },
      { mods = nil,     key = "-",        action = act.Multiple { { CopyMode = "MoveUp" }, { CopyMode = "MoveToStartOfLineContent" } }, },

      { mods = "CTRL",  key = 'd',        action = act.CopyMode { MoveByPage = 0.5 }, },
      { mods = "CTRL",  key = "u",        action = act.CopyMode { MoveByPage = -0.5 }, },
      { mods = nil,     key = 'PageUp',   action = act.CopyMode 'PageUp' },
      { mods = nil,     key = 'PageDown', action = act.CopyMode 'PageDown' },
      { mods = nil,     key = "g",        action = act.CopyMode "MoveToScrollbackTop", },
      { mods = "SHIFT", key = "G",        action = act.CopyMode "MoveToScrollbackBottom", },

      -- misc
      { mods = "SHIFT", key = "H",        action = act.CopyMode "MoveToViewportTop", },
      { mods = "SHIFT", key = "L",        action = act.CopyMode "MoveToViewportBottom", },
      { mods = "SHIFT", key = "Z",        action = act.CopyMode "MoveToViewportMiddle", },
    },
  }

  function isNvim(pane)
    -- local isAltPane = pane:is_alt_screen_active() -- doesn't work when muxing
    -- wezterm.log_info("isAltPane?", isAltPane)
    local title = pane:get_title()
    local isNvim = string.find(title, "vim")
    return isNvim
  end

  -- -- Do wezterm/nvim integration
  -- ---@param dir "Right" | "Left" | "Up" | "Down"
  -- function activate_pane(dir)
  --   return wezterm.action_callback(function(window, pane)
  --     local key = pane_nav[dir]
  --     if isNvim(pane) then
  --       wezterm.log_info('passing through keys:' .. pane_nav_mods .. key)
  --       window:perform_action(act.SendKey({ key = key, mods = pane_nav_mods }), pane)
  --     else
  --       wezterm.log_info('changing dir:' .. key)
  --       window:perform_action(act.ActivatePaneDirection(dir), pane)
  --     end
  --   end)
  -- end

  pane_nav = {
    h = "Left",
    j = "Down",
    k = "Up",
    l = "Right",
  }

  pane_nav_mods = "CTRL"
  for key, dir in pairs(pane_nav) do
    local event_name = "x-smartsplit-" .. key
    wezterm.log_info('Defining activate_pane for key:', pane_nav_mods, dir, pane_nav[dir])
    -- table.insert(config.keys, { key = key, mods = pane_nav_mods, action = activate_pane(dir) })
    table.insert(config.keys, { key = key, mods = pane_nav_mods, action = act.EmitEvent(event_name) })
    -- table.insert(config.keys, { key = key, mods = pane_nav_mods, action = act.ActivatePaneDirection(dir) })
    wezterm.on(event_name, function(window, pane)
      if isNvim(pane) then
        wezterm.log_info('passing through keys:' .. pane_nav_mods .. key)
        window:perform_action(act.SendKey({ key = key, mods = pane_nav_mods }), pane)
      else
        wezterm.log_info('changing direction:' .. dir)
        window:perform_action(act.ActivatePaneDirection(dir), pane)
      end
    end)
  end
end

return module

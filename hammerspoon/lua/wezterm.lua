function spawnWezterm(workspace)
  local args = " --class org.wezfurlong.wezterm." .. workspace .. " --workspace " .. workspace .. " --domain unix"
  if workspace == "scratch" then
    args = args .. " --position main:0,0"
  end
  -- local command = "wezterm connect --workspace " .. workspace .. " unix zsh -i & detach"
  local command = "wezterm start" .. args .. " --attach zsh -i & detach"
  io.popen(os.getenv("SHELL") .. [[ -l -i -c "]] .. command .. [["]])
  -- hs.execute(os.getenv("SHELL") .. [[ -l -i -c "]] .. command .. [["]])
  focusWezterm(workspace)
end

function focusWezterm(workspace)
  -- find window
  local terms = table.pack(hs.application.find("wezterm"))
  local win
  for _, term in ipairs(terms) do
    local windows = table.pack(term:findWindow(workspace))
    if #windows > 0 then
      win = windows[1]
      break
    end
  end
  if win == nil then return end

  -- do the focus
  if workspace == "scratch" then
    local app = win:application()
    -- Toggle scratch primary/minimised
    if win:isVisible() then
      app:hide()
    elseif win:application():isHidden() then
      app:unhide()
      win:centerOnScreen('0,0')
      win:focus()
    end
    -- -- minimize/maximize
    -- if win:isVisible() then
    --   win:application():hide()
    -- elseif win:isMinimized()then
    --   win:unminimize()
    --   win:centerOnScreen('0,0')
    --   win:focus()
    -- end
  else
    win:focus()
  end
  return true
end

function summonWezterm(workspace)
  local terms = table.pack(hs.application.find("wezterm"))
  if #terms == 0 then
    -- No Wezterm instances
    spawnWezterm(workspace)
  else
    local found = focusWezterm(workspace)
    if not found then
      -- No windows to focus
      spawnWezterm(workspace)
    end
  end
end

hs.hotkey.bind({ "alt" }, "1", function() summonWezterm("work") end)
hs.hotkey.bind({ "alt" }, "2", function() summonWezterm("pers") end)
hs.hotkey.bind({ "alt" }, "`", function() summonWezterm("scratch") end)

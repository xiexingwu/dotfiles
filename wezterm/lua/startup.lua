local wezterm = require("wezterm") --[[@as Wezterm]]

---Clean out old logs
wezterm.on("gui-attached", function(domain)
  local log_dir = (os.getenv("XDG_RUNTIME_DIR") or os.getenv("HOME") .. "/.local/share") .. "/wezterm"
  local f = io.popen("find " .. log_dir .. " -maxdepth 1 -mtime +1 -print | xargs rm -v")
  local output = f:read("*a")
  f:close()
  wezterm.log_info("Cleaning log dir:", output)
end)

return {
  apply_to_config = function(config)
  end
}

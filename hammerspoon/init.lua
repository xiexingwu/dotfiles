-- Run the folloiwng to set the config location
--  defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

-- CLI
require("hs.ipc").cliInstall()
require("hs.ipc").cliSaveHistory(true)

require("lua/wezterm")
require("lua/keys")


-- Reload config
hs.loadSpoon("ReloadConfiguration")
hs.loadSpoon("EmmyLua")
table.insert(spoon.ReloadConfiguration.watch_paths, hs.configdir .. '/lua')
spoon.ReloadConfiguration:start()

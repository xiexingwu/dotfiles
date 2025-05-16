--- === ReloadConfiguration ===
---
--- Adds a hotkey to reload the hammerspoon configuration, and a pathwatcher to automatically reload on changes.
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/ReloadConfiguration.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/ReloadConfiguration.spoon.zip)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "ReloadConfiguration"
obj.version = "1.0"
obj.author = "Jon Lorusso <jonlorusso@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"


--- ReloadConfiguration.watch_paths
--- Variable
--- List of directories to watch for changes, defaults to hs.configdir
obj.watch_paths = { hs.configdir }

--- ReloadConfiguration:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for ReloadConfiguration
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---   * reloadConfiguration - This will cause the configuration to be reloaded
function obj:bindHotkeys(mapping)
  local def = { reloadConfiguration = hs.fnutils.partial(hs.reload, self) }
  hs.spoons.bindHotkeysToSpec(def, mapping)
end

--- ReloadConfiguration:start()
--- Method
--- Start ReloadConfiguration
---
--- Parameters:
---  * recurse bool
function obj:start(recurse)
  if recurse == nil then recurse = false end

  self.watchers = {}
  for _, dir in pairs(self.watch_paths) do
    if recurse then
      for _, fileOrDir in pairs(hs.fs.fileListForPath(dir, { subdirs = true })) do
        -- bug: only returns files, not directories
        if hs.fs.attributes(fileOrDir).mode == "directory" then
          print("watching " .. fileOrDir)
          self.watchers[dir] = hs.pathwatcher.new(fileOrDir, hs.reload):start()
        end
      end
    else
      self.watchers[dir] = hs.pathwatcher.new(dir, hs.reload):start()
    end
  end
  return self
end

return obj

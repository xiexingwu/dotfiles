-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux
print(mux.all_domains())
print(mux.all_windows())
-- Start Config
local config = wezterm.config_builder()
require("keys").apply_to_config(config) -- Overwrites all keys
require("statusline").apply_to_config(config)
require("scrollback").apply_to_config(config)

-- Misc Configs
config.color_scheme = "kanagawabones"

config.font = wezterm.font("JetBrains Mono")
config.font_size = 18

-- Startup
wezterm.on("gui-startup", function(cmd)
	-- `wezterm start -- arg1 arg2 ...`
	local args = {}
	if cmd then
		args = cmd.args
	end

	-- Setup Work
	local tab, pane, window = mux.spawn_window({
		workspace = "work",
		cwd = wezterm.home_dir .. "/src/cloudlake-dbt",
		args = args,
	})

	-- Setup Personal
	local tab, pane, window = mux.spawn_window({
		workspace = "personal",
		cwd = wezterm.home_dir,
	})
	-- local pane_bot = pane:split({
	-- 	direction = "Bottom",
	-- 	size = 0.2,
	-- 	cwd = wezterm.home_dir,
	-- })

	-- Activate work
	mux.set_active_workspace("work")
end)

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
    local ws = mux.get_active_workspace():gsub("^%l", string.upper) .. " | "
	return ws .. zoomed .. index .. tab.active_pane.title
end)

-- and finally, return the configuration to wezterm
return config

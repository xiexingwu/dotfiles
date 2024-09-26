local wezterm = require("wezterm")
local module = {}
local action = wezterm.action

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local function split_nav(resize_or_move, key)
	return {
		key = key,
        -- Move is <C-hjkl>
        -- Resize is in key table
		mods = (resize_or_move == "resize" and { "" } or { "CTRL" })[1],
		action = wezterm.action_callback(function(win, pane)
            -- nvim not currently configured for resize
			if is_vim(pane) and resize_or_move == "move" then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

function module.apply_to_config(config)
	config.leader = { key = ";", mods = "CTRL", timeout_milliseconds = 1000 }
	config.keys = {
		-- Passthrough Cmd+C to other applications
		{
			key = "c",
			mods = "META",
			action = wezterm.action_callback(function(window, pane)
				if pane:is_alt_screen_active() then
					window:perform_action(wezterm.action.SendKey({ key = "c", mods = "META" }), pane)
				else
					window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
				end
			end),
		},
		-- Split panes
		{
			key = "v",
			mods = "LEADER",
			action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "s",
			mods = "LEADER",
			action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},

		-- Resize/activate panes (vanilla)
		{
			key = "r",
			mods = "LEADER",
			action = action.ActivateKeyTable({
				name = "resize_pane",
				one_shot = false,
			}),
		},
		-- { key = "h", mods = "LEADER", action = action.ActivatePaneDirection("Left") },
		-- { key = "l", mods = "LEADER", action = action.ActivatePaneDirection("Right") },
		-- { key = "k", mods = "LEADER", action = action.ActivatePaneDirection("Up") },
		-- { key = "j", mods = "LEADER", action = action.ActivatePaneDirection("Down") },

		-- Resize/activate panes (smart-splits.nvim)
		split_nav("move", "h"),
		split_nav("move", "j"),
		split_nav("move", "k"),
		split_nav("move", "l"),
        
		-- Switch between work/personal workspaces
		{
			key = "w",
			mods = "LEADER",
			action = action.SwitchToWorkspace({
				name = "work",
			}),
		},
		{
			key = "p",
			mods = "LEADER",
			action = action.SwitchToWorkspace({
				name = "personal",
			}),
		},

		-- Turn off default CMD-m actions
		-- be potentially recognized and handled by the tab
		{
			key = "m",
			mods = "CMD",
			action = action.DisableDefaultAssignment,
		},
		{
			key = "h",
			mods = "CMD",
			action = action.DisableDefaultAssignment,
		},

		-- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
		{
			key = "LeftArrow",
			mods = "OPT",
			action = action.SendKey({
				key = "b",
				mods = "ALT",
			}),
		},
		{
			key = "RightArrow",
			mods = "OPT",
			action = action.SendKey({ key = "f", mods = "ALT" }),
		},
	}

	config.key_tables = {
		resize_pane = {
			split_nav("resize", "h"),
			split_nav("resize", "j"),
			split_nav("resize", "k"),
			split_nav("resize", "l"),
			-- { key = "h", action = action.AdjustPaneSize({ "Left", 1 }) },
			-- { key = "l", action = action.AdjustPaneSize({ "Right", 1 }) },
			-- { key = "k", action = action.AdjustPaneSize({ "Up", 1 }) },
			-- { key = "j", action = action.AdjustPaneSize({ "Down", 1 }) },

			-- Cancel the mode by pressing escape
			{ key = "Escape", action = "ClearKeyTableStack" },
		},
	}
end

return module

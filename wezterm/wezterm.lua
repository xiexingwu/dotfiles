local wezterm = require("wezterm") --[[@as Wezterm]]

local config = wezterm.config_builder()
require("lua/startup").apply_to_config(config)
require("lua/exit").apply_to_config(config)
require("lua/appearance").apply_to_config(config)
require("lua/keys").apply_to_config(config)    -- Overwrites all keys
require("lua/tabline").apply_to_config(config) -- Overwrites all keys
-- require("lua/scrollback").apply_to_config(config)

config.unix_domains = { { name = 'unix', }, }
config.default_gui_startup_args = { 'connect', 'unix' }

config.exit_behavior = "CloseOnCleanExit"
config.clean_exit_codes = { 1 }
config.selection_word_boundary = " \t\n{}[]()\"'`.,;:"
config.switch_to_last_active_tab_when_closing_tab = true
config.window_close_confirmation = "NeverPrompt" -- Default "AlwaysPrompt"

---- set terminfo via this shell script:
--    tempfile=$(mktemp) \
--    && curl -o $tempfile https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo \
--    && tic -x -o ~/.terminfo $tempfile \
--    && rm $tempfile
config.term = 'wezterm'

return config

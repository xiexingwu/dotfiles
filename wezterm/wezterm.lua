local wezterm = require("wezterm")

local config = wezterm.config_builder()
require("lua/startup").apply_to_config(config)
require("lua/appearance").apply_to_config(config)
require("lua/keys").apply_to_config(config) -- Overwrites all keys
-- require("lua/tabline").apply_to_config(config)
require("lua/scrollback").apply_to_config(config)

config.unix_domains = {
  { name = 'unix', },
}

config.selection_word_boundary = " \t\n{}[]()\"'`.,;:"
config.switch_to_last_active_tab_when_closing_tab = true
-- set terminfo via this shell script:
--    tempfile=$(mktemp) \
--    && curl -o $tempfile https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo \
--    && tic -x -o ~/.terminfo $tempfile \
--    && rm $tempfile
config.term = 'wezterm'
return config

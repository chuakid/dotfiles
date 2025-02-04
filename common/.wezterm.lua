-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.color_scheme = 'Catppuccin Macchiato'
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true 

return config


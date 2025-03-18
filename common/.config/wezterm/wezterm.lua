local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- styling
config.color_scheme = "Catppuccin Macchiato"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {
	left = 5,
	right = "1cell",
	top = 0,
	bottom = 0,
}
config.inactive_pane_hsb = {
	brightness = 0.5,
}
config.enable_scroll_bar = true
config.max_fps = 165
config.window_background_opacity = 0.9

-- keys
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		key = "v",
		mods = "LEADER",
		action = act.SplitVertical,
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.SplitHorizontal,
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "[",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowTabNavigator,
	},
	-- alt + hjkl to move between panes
	{
		key = "h",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	-- Make CTRL-Right, Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
	{
		key = "LeftArrow",
		mods = "CTRL",
		action = wezterm.action({ SendString = "\x1bb" }),
	},
	-- Make CTRL-Right, Option-Right equivalent to Alt-f; forward-word
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action({ SendString = "\x1bf" }),
	},
	{
		key = "RightArrow",
		mods = "CTRL",
		action = wezterm.action({ SendString = "\x1bf" }),
	},
}
return config

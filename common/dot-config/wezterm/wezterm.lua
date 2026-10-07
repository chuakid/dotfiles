local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- styling
config.color_scheme = "Catppuccin Mocha"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {
	left = 5,
	right = "1cell",
	top = 0,
	bottom = 0,
}
config.inactive_pane_hsb = {
	brightness = 0.8,
}
config.enable_scroll_bar = true
config.max_fps = 165
config.window_background_opacity = 0.98
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 1000
config.hide_tab_bar_if_only_one_tab = true

-- keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		key = '"',
		mods = "LEADER|SHIFT",
		action = act.SplitPane({ direction = "Down" }),
	},
	{
		key = "%",
		mods = "LEADER|SHIFT",
		action = act.SplitPane({ direction = "Right" }),
	},
	{
		key = "q",
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
	-- alt + left right to move between words
	{
		key = "LeftArrow",
		mods = "OPT",
		action = act.SendKey({
			key = "b",
			mods = "ALT",
		}),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},
	{
		key = "s",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
}

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	-- directional keys to use in order of: left, down, up, right
	direction_keys = {
		move = { "h", "j", "k", "l" },
		resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	},
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

-- remove ligatures
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- Set the default_prog to fish or fall back to the system's default
-- config.default_prog = { "sh", "-c", "if command -v fish >/dev/null 2>&1; then exec fish; else exec $SHELL; fi" }
--
config.unix_domains = {
	{
		name = "unix",
	},
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
config.default_gui_startup_args = { "connect", "unix" }

return config

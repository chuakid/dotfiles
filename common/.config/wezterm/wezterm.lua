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
config.hide_tab_bar_if_only_one_tab = true
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 1000

-- keys
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		key = "s",
		mods = "LEADER",
		action = act.SplitVertical,
	},
	{
		key = "v",
		mods = "LEADER",
		action = act.SplitHorizontal,
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
}

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

local function cmd_exists(name)
	local f = io.open(name, "r")
	if f then
		f:close()
		return true
	else
		return false
	end
end

-- Define the order of shells you prefer
local shells = {
	{ wezterm.home_dir .. "/.nix-profile/bin/fish", "-l" },
	{ "/bin/fish", "-l" },
	{ "/bin/zsh", "-l" },
	{ "/bin/bash", "-l" },
}

-- Find the first available shell in the list
local found_shell = nil
for _, shell_pair in ipairs(shells) do
	wezterm.log_error(shell_pair[1])
	if cmd_exists(shell_pair[1]) then
		found_shell = shell_pair
		break
	end
end

-- Set the default_prog to the first available shell,
-- or fall back to the system's default
if found_shell then
	config.default_prog = found_shell
end

return config

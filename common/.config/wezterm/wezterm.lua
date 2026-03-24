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

-- resurrect

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.state_manager.periodic_save({
	interval_seconds = 60,
	save_tabs = true,
	save_windows = true,
	save_workspaces = true,
})
wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)
-- periodic_save writes state JSONs but not the current_state pointer that resurrect_on_gui_startup reads
wezterm.on("resurrect.state_manager.periodic_save.finished", function()
	resurrect.state_manager.write_current_state(wezterm.mux.get_active_workspace(), "workspace")
end)

-- keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical,
	},
	{
		key = "|",
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

wezterm.on("augment-command-palette", function(_, _)
	local workspace_state = resurrect.workspace_state
	return {
		{
			brief = "Window | Workspace: Save Workspaces",
			icon = "cod_save",
			action = wezterm.action_callback(function(_, _, _)
				resurrect.state_manager.save_state(workspace_state.get_workspace_state())
				resurrect.state_manager.write_current_state(wezterm.mux.get_active_workspace(), "workspace")
			end),
		},
		{
			brief = "Window | Workspace: Rename Workspace",
			icon = "md_briefcase_edit",
			action = wezterm.action.PromptInputLine({
				description = "Enter new name for workspace",
				action = wezterm.action_callback(function(_, _, line)
					if line then
						wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
						resurrect.state_manager.save_state(workspace_state.get_workspace_state())
					end
				end),
			}),
		},
		{
			brief = "Window | Delete Workspace",
			action = wezterm.action_callback(function(win, pane)
				resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
					resurrect.state_manager.delete_state(id)
				end, {
					title = "Delete State",
					description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
					fuzzy_description = "Search State to Delete: ",
					is_fuzzy = true,
				})
			end),
		},
	}
end)

-- Set the default_prog to fish or fall back to the system's default
config.default_prog = { "sh", "-c", "if command -v fish >/dev/null 2>&1; then exec fish; else exec $SHELL; fi" }

return config

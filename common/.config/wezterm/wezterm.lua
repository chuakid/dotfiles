local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- styling
config.color_scheme = 'Catppuccin Macchiato'
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
}

-- keys
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 2000}
config.keys = {
    {
        key = '-',
        mods = 'LEADER',
        action = act.SplitVertical,
    },
    {
        key = '|',
        mods = 'LEADER|SHIFT',
        action = act.SplitHorizontal,
    },
    {
        key = 't',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain',
    }, 
    {
        key = 'x',
        mods = 'LEADER',
        action = act.CloseCurrentPane { confirm = true },
    },
    {
        key = '[',
        mods = 'LEADER',
        action = act.ActivateCopyMode
    },
    {
        key = 'w',
        mods = 'LEADER',
        action = act.ShowTabNavigator 
    }
}


return config


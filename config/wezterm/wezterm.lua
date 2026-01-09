local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

config.font = wezterm.font_with_fallback({
	"Hack Nerd Font Mono",
	"HackGen Console NF",
})
config.font_size = 15

config.color_scheme = "Tokyo Night"
-- config.color_scheme = "iTerm2 Default"
config.window_background_opacity = 0.7
config.colors = {
	background = "#000000",
}

config.keys = {
	{
		key = "Space",
		mods = "SHIFT",
		action = wezterm.action.QuickSelect,
	},
}

return config

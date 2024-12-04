local wezterm = require("wezterm")

local config = wezterm.config_builder()

local mux = wezterm.mux
wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

config.color_scheme = "Gruvbox Dark (Gogh)"
config.enable_tab_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.font = wezterm.font("JetBrains Mono")
-- disable ligatures
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

return config

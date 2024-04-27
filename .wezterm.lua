-- Pull in the wezterm API
local wezterm = require 'wezterm'



-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.default_domain = 'WSL:Ubuntu'

config.font = wezterm.font('JetBrains Mono', { weight = 'Medium', italic = true })
config.font_size = 13.0
-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night'
config.window_background_opacity = 0.9

config.enable_tab_bar = false
return config

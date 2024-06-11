-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font('JetBrains Mono', { weight = 'Medium', italic = true })
config.font_size = 15.0
-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.98
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
-- config.use_fancy_tab_bar = true
return config

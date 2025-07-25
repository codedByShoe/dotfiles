-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox         = require("wibox")
-- Theme handling library
local beautiful     = require("beautiful")
local dpi           = require("beautiful.xresources").apply_dpi
-- Notification library
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local weather_widget = require("wttr-widget.weather")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err)
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/gruvbox/theme.lua")

naughty.config.defaults.border_width = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 16
naughty.config.defaults.padding = 16
naughty.config.defaults.shape = gears.shape.rounded_rect
naughty.config.defaults.bg = "#282828"
naughty.config.defaults.fg = "#ebdbb2"

naughty.config.presets.low = {
	fg = beautiful.fg_normal,
	bg = beautiful.bg_normal,
	border_width = 0,
	timeout = 5,
}

naughty.config.presets.normal = {
	fg = beautiful.fg_normal,
	bg = beautiful.bg_normal,
	border_width = 2,
	timeout = 6,
}

naughty.config.presets.critical = {
	fg = beautiful.fg_normal,
	bg = beautiful.bg_normal,
	border_color = beautiful.bg_urgent,
	border_width = 2,
	timeout = 12, -- sticky
}


-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
browser = "brave-browser"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	-- awful.layout.suit.tile.left,
	-- awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	-- awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
}
-- }}}
--
-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
	{ "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
	{ "manual",      terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart",     awesome.restart },
	{ "quit",        function() awesome.quit() end },
}

mymainmenu = awful.menu({
	items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal }
	}
})

mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})

local function style(widget)
	return wibox.container.margin(
		wibox.container.background(widget, beautiful.bg_focus, gears.shape.rounded_rect),
		3, 3, 2, 2
	)
end

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


-- {{{ Wibar
-- create calendar widget
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
local cw = calendar_widget({
	placement = 'top_right',
	start_sunday = true,
	radius = 4,
	-- with customized next/previous (see table above)
	previous_month_button = 1,
	next_month_button = 3,
})
mytextclock:connect_signal("button::press",
	function(_, _, _, button)
		if button == 1 then cw.toggle() end
	end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.

	s.mylayoutbox = awful.widget.layoutbox(s)

	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function() awful.layout.inc(1) end),
		awful.button({}, 3, function() awful.layout.inc(-1) end),
		awful.button({}, 4, function() awful.layout.inc(1) end),
		awful.button({}, 5, function() awful.layout.inc(-1) end)))
	-- Create a taglist widget
	s.mylayoutbox = wibox.widget {
		awful.widget.layoutbox(s),
		margins = 4,
		widget = wibox.container.margin,
	}


	s.mytaglist = awful.widget.taglist {
		screen          = s,
		filter          = awful.widget.taglist.filter.all,
		buttons         = taglist_buttons,
		widget_template = {
			{
				{
					id     = 'text_role',
					widget = wibox.widget.textbox,
				},
				left = 10,
				right = 10,
				top = 4,
				bottom = 4,
				widget = wibox.container.margin,
			},
			id     = 'background_role',
			widget = wibox.container.background,
		},
	}


	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		height = 45,
		maximum_width = s.geometry.width,
		max_widget_size = 500,
		y = 2,
		ontop = true,
		visible = true,
		type = "dock", -- keeps it from covering windows
		bg = "#00000000",
	})

	-- Add widgets to the wibox
	s.mywibox:setup {
		layout = wibox.layout.align.horizontal,
		wibox.container.margin(style(wibox.widget { -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
			spacing = 20,
			s.mylayoutbox
		}), 10, 0, 10, 0),
		wibox.container.margin(wibox.container.place(style(), "center"), 0, 0, 10, 0),
		wibox.container.margin(style(wibox.widget { -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			-- wibox.widget.systray(),
			-- volume_widget({
			-- 	widget_type = "arc",
			-- 	arc_thickness = 1,
			-- 	toggle_cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle",
			-- 	pactl = true
			-- }),
			wibox.container.margin(ram_widget(), 10, 0, 0, 0),
			cpu_widget(),
			brightness_widget {
				type = 'icon_and_text',
				program = 'brightnessctl',
				step = 2,
			},
			batteryarc_widget({
				show_current_level = true,
				arc_thickness = 1,
			}),
			weather_widget({
				location = "31.22,-85.39",
				units = "u",
				lang = "en"
			}),
			mytextclock,
			spacing = 20,
			wibox.container.margin(logout_menu_widget({
				onlock = function()
					awful.spawn.with_shell("betterlockscreen -l")
				end
			}), 0, 10, 0, 0),
		}), 0, 10, 10, 0),
	}
end)
-- }}}


local function set_wallpaper(path)
	awful.spawn.with_shell("feh --bg-fill '" .. path .. "'")
end

local wallpaper_dir = os.getenv("HOME") .. "/Wallpaper"
local wallpapers = {}

for file in io.popen('ls "' .. wallpaper_dir .. '"'):lines() do
	if file:match("%.jpg$") or file:match("%.png$") then
		table.insert(wallpapers, wallpaper_dir .. "/" .. file)
	end
end

gears.timer.delayed_call(function()
	local wallpaper = wallpapers[math.random(#wallpapers)]
	set_wallpaper(wallpaper)
end)


-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({}, 3, function() mymainmenu:toggle() end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
	awful.key({ modkey, }, "s", hotkeys_popup.show_help,
		{ description = "show help", group = "awesome" }),
	awful.key({ modkey, }, "Left", awful.tag.viewprev,
		{ description = "view previous", group = "tag" }),
	awful.key({ modkey, }, "Right", awful.tag.viewnext,
		{ description = "view next", group = "tag" }),
	-- awful.key({ modkey, "Shift" }, "6", awful.tag.history.restore,
	-- 	{ description = "go back", group = "tag" }),

	awful.key({ modkey, }, "j",
		function()
			awful.client.focus.byidx(1)
		end,
		{ description = "focus next by index", group = "client" }
	),
	awful.key({ modkey, }, "k",
		function()
			awful.client.focus.byidx(-1)
		end,
		{ description = "focus previous by index", group = "client" }
	),
	awful.key({ modkey }, "w", function()
		local wallpaper = wallpapers[math.random(#wallpapers)]
		set_wallpaper(wallpaper)
	end, { description = "random wallpaper", group = "custom" }), -- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
		{ description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
		{ description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
		{ description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
		{ description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }),
	awful.key({ modkey, }, "Tab",
		function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{ description = "go back", group = "client" }),

	-- Standard program
	awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
		{ description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart,
		{ description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit,
		{ description = "quit awesome", group = "awesome" }),
	awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
		{ description = "increase master width factor", group = "layout" }),
	awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
		{ description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
		{ description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
		{ description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
		{ description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
		{ description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey, }, ";", function() awful.layout.inc(1) end,
		{ description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, ";", function() awful.layout.inc(-1) end,
		{ description = "select previous", group = "layout" }),

	awful.key({ modkey, "Control" }, "n",
		function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal(
					"request::activate", "key.unminimize", { raise = true }
				)
			end
		end,
		{ description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ modkey }, "space", function() awful.spawn("rofi -show run") end,
		{ description = "run rofi", group = "launcher" }),

	-- Browser
	awful.key({ modkey }, "b", function() awful.spawn(browser) end,
		{ description = "Brave", group = "applications" }),

	-- Menubar
	awful.key({ modkey }, "p", function() menubar.show() end,
		{ description = "show the menubar", group = "launcher" }),
	awful.key({}, "XF86MonBrightnessUp", function() brightness_widget:inc() end,
		{ description = "increase brightness", group = "system" }),
	awful.key({}, "XF86MonBrightnessDown", function() brightness_widget:dec() end,
		{ description = "decrease brightness", group = "system" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false)
	end),
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false)
	end),
	awful.key({}, "XF86AudioMute", function()
		awful.util.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
	end),
	-- Media Keys
	awful.key({}, "XF86AudioPlay", function()
		awful.util.spawn("playerctl play-pause", false)
	end),
	awful.key({}, "XF86AudioNext", function()
		awful.util.spawn("playerctl next", false)
	end),
	awful.key({}, "XF86AudioPrev", function()
		awful.util.spawn("playerctl previous", false)
	end),
	awful.key({ modkey }, "Escape", function()
		awful.spawn("betterlockscreen -l")
	end)

)

clientkeys = gears.table.join(
	awful.key({ modkey, }, "f",
		function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{ description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey }, "q", function(c) c:kill() end,
		{ description = "close", group = "client" }),
	awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }),
	awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
		{ description = "move to master", group = "client" }),
	awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
		{ description = "move to screen", group = "client" }),
	awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
		{ description = "toggle keep on top", group = "client" }),
	awful.key({ modkey, }, "n",
		function(c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end,
		{ description = "minimize", group = "client" }),
	awful.key({ modkey, }, "m",
		function(c)
			c.maximized = not c.maximized
			c:raise()
		end,
		{ description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Control" }, "m",
		function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end,
		{ description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m",
		function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end,
		{ description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{ description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{ description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{ description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{ description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_radius = beautiful.border_radius,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen
		}
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer" },

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			}
		},
		properties = { floating = true }
	},

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = { type = { "normal", "dialog" }
		},
		properties = { titlebars_enabled = false }
	},

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup
	    and not c.size_hints.user_position
	    and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup {
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout  = wibox.layout.fixed.horizontal
		},
		{ -- Middle
			{ -- Title
				align  = "center",
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons,
			layout  = wibox.layout.flex.horizontal
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal
	}
end)


beautiful.useless_gap = 8
beautiful.gap_single_client = true

client.connect_signal("manage", function(c)
	c.shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, 10)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- Auto start
awful.spawn.with_shell("picom")
awful.spawn.with_shell("setxkbmap -option ctrl:nocaps")

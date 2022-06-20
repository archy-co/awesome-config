-- awesome_mode: api-level=4:screen=on If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

apps = {
   terminal = "alacritty",
   editor = "nvim",
   launcher = "rofi -location 8 -no-steal-focus -modi drun -show drun -theme ~/.config/rofi/rofi.rasi",
   browser = "firefox",
   lock = "i3lock",
   screenshot = "gnome-screenshot --interactive",
   filebrowser = "nautilus",
   schedule = "zathura '~/schedule.pdf'",
}

local run_on_start_up = {
   "picom --experimental-backends",
   "killall conky; sleep 1; ~/blood-and-milk/Application.sh",
   "viber",
   -- "redshift",
   -- "unclutter",
   "xset s on",
   "xset s 1800 1",
   "xss-lock -n ~/.config/awesome/transfer-sleep-lock-generic-delay.sh",
   "setxkbmap -layout us,ua,ca -option grp:alt_shift_toggle",
   "batsignal -w 20 -c 11 -d 5 -b"
}

-- Run all the apps listed in run_on_start_up
for _, app in ipairs(run_on_start_up) do
   local findme = app
   local firstspace = app:find(" ")
   if firstspace then
      findme = app:sub(0, firstspace - 1)
   end
   -- pipe commands to bash to allow command to be shell agnostic
   awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
end



-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "blind/arrow/themeSciFi.lua")

-- This is used later as the default terminal and editor to run.
terminal = "awesome"
editor = "nvim"
editor_cmd = apps.terminal .. " -e " .. apps.editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
awesome_menu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", apps.terminal .. " -e man awesome" },
   { "edit config", editor .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

system_menu = {
   { "poweroff", function()
       awful.spawn.easy_async_with_shell("poweroff", function() end)
   end },
   { "reboot", function()
       awful.spawn.easy_async_with_shell("reboot", function() end)
   end }
}

main_menu = awful.menu({ items = {  { "awesome", awesome_menu, beautiful.awesome_icon },
                                    { "system", system_menu },
                                    { "terminal", apps.terminal },
                                    { "rofi", apps.launcher}
                                  }
                        })

awesome_launcher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = main_menu })

-- awesome_launcher:connect_signal("mouse::enter", function() main_menu:toggle() end)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.floating,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        -- awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier,
        awful.layout.suit.corner.nw,
    })
end)
-- }}}


-- {{{ Wallpaper
--wallpaper_image = "~/.config/awesome/images/wallpaper.jpg"
--screen.connect_signal("request::wallpaper", function(s)
    --awful.wallpaper {
        --screen = s,
        --widget = {
            --{
                --image     = wallpaper_image,
                --upscale   = true,
                --downscale = true,
                --widget    = wibox.widget.imagebox,
            --},
            --valign = "center",
            --halign = "center",
            --tiled  = false,
            --widget = wibox.container.tile,
        --}
    --}
--end)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
keyboard_layout = awful.widget.keyboardlayout()

local capslock = require("capslock")
globalkeys = awful.util.table.join( capslock.key )

-- Create a textclock widget
text_clock = wibox.widget.textclock()

local volume_widget = require('widgets.volume-widget.volume')
local batteryarc_widget = require('widgets.batteryarc-widget.batteryarc')
local battery_widget = require("widgets.battery-widget.battery-widget")
local cpu_widget = require("widgets.cpu-widget.cpu-widget")
local net_widgets = require("widgets.net_widgets")

net_wireless = net_widgets.wireless({interface="wlan0"})

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.prompt_box = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.layout_box = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    -- Create a taglist widget
    s.tag_list = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }


    -- Create a tasklist widget
    s.task_list = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        }
    }

    -- Create the wibox
    s.wibox_wibar = awful.wibar {
        position = "top",
        screen   = s,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                awesome_launcher,
                s.tag_list,
                s.prompt_box,
            },
            s.task_list, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                battery_widget {
                   ac_prefix = "  AC ",
                   battery_prefix = "  Bat ",
                   widget_font = "Deja Vu Sans Mono 9",
                },
                batteryarc_widget{
                   show_current_level = true,
                   arc_thickness = 2,
                },
                volume_widget{
                   widget_type = "arc",
                },
                net_wireless,
                capslock,
                keyboard_layout,
                wibox.widget.systray(),
                text_clock,
                s.layout_box,
            },
        }
    }
end)
-- }}}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () main_menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})
-- }}}

-- {{{ Key bindings
require('keys')
-- }}}

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    awful.titlebar(c).widget = {
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
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal
    }
end)
-- }}}


local ruled = require("ruled")

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)


-- {{{ Rules
require('rules')
-- }}}

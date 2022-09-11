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

local dpi = beautiful.xresources.apply_dpi

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
   screenshot = "gnome-screenshot",
   screenshot_interactive = "gnome-screenshot --interactive",
   filebrowser = "nautilus",
   schedule = "zathura '~/schedule.pdf'",
   bluetooth_manager = "blueman-manager"
}

local run_on_start_up = {
   "picom --experimental-backends",
   -- "killall conky; sleep 1; ~/blood-and-milk/Application.sh",
   "viber",
   -- "killall xgifwallpaper; sleep 1; xgifwallpaper Pictures/wallpapers/WindowsXPBoot.gif --scale FILL -d 7",
   "feh --bg-fill ~/Pictures/wallpapers/eclipse.jpg",
   -- "redshift",
   -- "unclutter",
   "xset s on",
   "xset s 1800 1",
   "xss-lock -n ~/.config/awesome/transfer-sleep-lock-generic-delay.sh",
   "setxkbmap -layout us,ua,ca -option grp:alt_shift_toggle",
   "batsignal -w 20 -c 11 -d 5 -b",
   "blueman-applet"
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
terminal = "alacritty"
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
local awesome_menu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", apps.terminal .. " -e man awesome" },
   { "edit config", editor .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local system_menu = {
   { "poweroff", function()
       awful.spawn.easy_async_with_shell("poweroff", function() end)
   end },
   { "reboot", function()
       awful.spawn.easy_async_with_shell("reboot", function() end)
   end }
}

local main_menu = awful.menu({ items = {  { "awesome", awesome_menu, beautiful.awesome_icon },
                                    { "system", system_menu },
                                    { "terminal", apps.terminal },
                                    { "rofi", apps.launcher}
                                  }
                        })

local awesome_launcher = awful.widget.launcher({ image = beautiful.awesome_icon,
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
-- -- Either
gears.wallpaper.maximized("~/Pictures/wallpapers/eclipse.jpg")
-- gears.wallpaper.maximized(gears.filesystem.get_configuration_dir() .. "/wallpaper/mirage.png")
-- -- Or
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
text_clock = wibox.widget.textclock(" %a %d %b | %T", 5)

local volume_widget = require('widgets.volume-widget.volume')
local batteryarc_widget = require('widgets.batteryarc-widget.batteryarc')
local battery_widget = require("widgets.battery-widget.battery-widget")
local cpu_widget = require("widgets.cpu-widget.cpu-widget")
local net_widgets = require("widgets.net_widgets")

net_wireless = net_widgets.wireless({interface="wlan0"})

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

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
        },

        layout   = {
            spacing = 1,
            layout  = wibox.layout.flex.horizontal
        },

        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 5,
                right = 5,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create the wibox
    s.wibox_wibar = awful.wibar {
        position = "top",
        bg = "#090B0C",
        screen   = s,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.container.margin(s.prompt_box, dpi(60), dpi(0), dpi(0), dpi(0)),
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
                wibox.container.margin(text_clock, dpi(0), dpi(5), dpi(0), dpi(0)),
                -- s.layout_box,
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





-- Import components
require("widgets.volume-adjust")

local left_panel = require("widgets.left-panel")

local icon_dir = gears.filesystem.get_configuration_dir() .. "images/icons/tags/"

awful.screen.connect_for_each_screen(function(s)
    for i = 1, 7, 1 do
        awful.tag.add(i, {
            icon = icon_dir .. i .. ".png",
            icon_only = true,
            layout = awful.layout.suit.tile,
            screen = s,
            selected = i == 1
        })
    end

    -- Only add the left panel on the primary screen
    if s.index == 1 then
        left_panel.create(s)
    end
end)

-- set initally selected tag to be active
local initial_tag = awful.screen.focused().selected_tag
awful.tag.seticon(icon_dir .. initial_tag.name .. ".png", initial_tag)

-- updates tag icons
local function update_tag_icons()
    -- get a list of all tags
    local atags = awful.screen.focused().tags

    -- update each tag icon
    for i, t in ipairs(atags) do
        -- don't update active tag icon
        if t == awful.screen.focused().selected_tag then
            goto continue
        end
        -- if the tag has clients use busy icon
        for _ in pairs(t:clients()) do
            awful.tag.seticon(icon_dir .. t.name .. ".png", t)
            goto continue
        end
        -- if the tag has no clients use regular inactive icon
        awful.tag.seticon(icon_dir .. t.name .. "-inactive.png", t)

        ::continue::
    end
end

-- Update tag icons when tag is switched
tag.connect_signal("property::selected", function(t)
    -- set newly selected tag icon as active
    awful.tag.seticon(icon_dir .. t.name .. ".png", t)
    update_tag_icons()
end)

-- Update tag icons when a client is moved to a new tag
tag.connect_signal("tagged", function(c)
    update_tag_icons()
end)






local freedesktop = require("freedesktop")

awful.util.mymainmenu = freedesktop.menu.build {
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
}

-- Hide the menu when the mouse leaves it
--[[
awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function()
    if not awful.util.mymainmenu.active_child or
       (awful.util.mymainmenu.wibox ~= mouse.current_wibox and
       awful.util.mymainmenu.active_child.wibox ~= mouse.current_wibox) then
        awful.util.mymainmenu:hide()
    else
        awful.util.mymainmenu.active_child.wibox:connect_signal("mouse::leave",
        function()
            if awful.util.mymainmenu.wibox ~= mouse.current_wibox then
                awful.util.mymainmenu:hide()
            end
        end)
    end
end)
--]]



-- {{{ Rules
require('rules')
-- }}}

local beautiful = require("beautiful")
local awful = require("awful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local dpi = beautiful.xresources.apply_dpi
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local capslock = require("capslock")


-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, altkey    }, "s", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey, altkey    }, "w", function () main_menu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, altkey    }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey }, "x",
            function ()
                awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().prompt_box.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            {description = "lua execute prompt", group = "awesome"}),

    awful.key({ modkey,           }, "Return",
            function ()
                awful.spawn(apps.terminal)
            end,
            {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey,           }, "r",     function () awful.screen.focused().prompt_box:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey,           }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    awful.key({ modkey,            }, "w", function() awful.spawn(apps.browser) end,
              {description = "web browser", group = "launcher"}),

    awful.key({ modkey,            }, "e", function() awful.spawn("telegram-desktop") end,
              {description = "telegram", group = "launcher"}),

    awful.key({ modkey,            }, "d", function() awful.spawn(apps.launcher) end,
              {description = "program launcher", group = "launcher"}),

    awful.key({                    }, "Print", function() awful.spawn(apps.screenshot) end,
              {description = "screenshot", group = "launcher"}),
    awful.key({ "Ctrl"             }, "Print", function() awful.spawn(apps.screenshot_interactive) end,
              {description = "interactive screenshot", group = "launcher"}),

    awful.key({ modkey,           }, "s", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    capslock.key,


    awful.key({ modkey,            }, "o",
        function()
           awful.spawn.with_shell("~/Downloads/picom/bin/picom-trans -10 --current", false)
        end,
        {description = "reduce 10% of opacity", group = "hotkeys"}),

    awful.key({ modkey, "Shift"    }, "o",
        function()
           awful.spawn.with_shell("~/Downloads/picom/bin/picom-trans +10 --current", false)
        end,
        {description = "reduce 10% of opacity", group = "hotkeys"}),

    -- Brightness
    awful.key({}, "XF86MonBrightnessUp",
        function()
            awful.spawn("xbacklight -inc 10", false)
        end,
        {description = "brightness up", group = "hotkeys"}
    ),
    awful.key({}, "XF86MonBrightnessDown",
        function()
            awful.spawn("xbacklight -dec 10", false)
        end,
        {description = "brightness down", group = "hotkeys"}
    ),

    -- ALSA volume control
    awful.key({}, "XF86AudioRaiseVolume",
        function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +3%", false)
            awesome.emit_signal("volume_change")
        end,
        {description = "volume up", group = "hotkeys"}
    ),
    awful.key({}, "XF86AudioLowerVolume",
        function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -3%", false)
            awesome.emit_signal("volume_change")
        end,
        {description = "volume down", group = "hotkeys"}
    ),
    awful.key({}, "XF86AudioMute",
        function()
            awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
            awesome.emit_signal("volume_change")
        end,
        {description = "toggle mute", group = "hotkeys"}
    ),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, altkey    }, "h",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey, altkey    }, "l",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})



-- raise focused client
local function raise_client()
   if client.focus then
      client.focus:raise()
   end
end

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({modkey}, "j",
        function()
            awful.client.focus.bydirection("down")
            raise_client()
        end,
        {description = "focus down", group = "client"}
    ),
    awful.key({modkey}, "k",
        function()
            awful.client.focus.bydirection("up")
            raise_client()
        end,
        {description = "focus up", group = "client"}
    ),
    awful.key({modkey}, "h",
        function()
            awful.client.focus.bydirection("left")
            raise_client()
        end,
        {description = "focus left", group = "client"}
    ),
    awful.key({modkey}, "l",
        function()
            awful.client.focus.bydirection("right")
            raise_client()
        end,
        {description = "focus right", group = "client"}
    ),
    awful.key({modkey}, "Down",
        function()
            awful.client.focus.bydirection("down")
            raise_client()
        end,
        {description = "focus down", group = "client"}
    ),
    awful.key({modkey}, "Up",
        function()
            awful.client.focus.bydirection("up")
            raise_client()
        end,
        {description = "focus up", group = "client"}
    ),
    awful.key({modkey}, "Left",
        function()
            awful.client.focus.bydirection("left")
            raise_client()
        end,
        {description = "focus left", group = "client"}
    ),
    awful.key({modkey}, "Right",
        function()
            awful.client.focus.bydirection("right")
            raise_client()
        end,
        {description = "focus right", group = "client"}
    ),


    awful.key({ modkey,           }, "`",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),



    awful.key({ modkey,           }, "Tab",
      function()
         awful.client.focus.byidx( 1)
      end,
      {description = "focus next by index", group = "client"}),

    awful.key({ modkey, "Shift"   }, "Tab",
      function()
         awful.client.focus.byidx(-1)
      end,
      {description = "focus previous by index", group = "client"}),



    --awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              --{description = "focus the next screen", group = "screen"}),
    --awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              --{description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Shift"   }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    --awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              --{description = "swap with next client by index", group = "client"}),
    --awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              --{description = "swap with previous client by index", group = "client"}),
    --awful.key({ modkey, altkey    }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              --{description = "increase master width factor", group = "layout"}),
    --awful.key({ modkey, altkey    }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              --{description = "decrease master width factor", group = "layout"}),
    --awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              --{description = "increase the number of master clients", group = "layout"}),
    --awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              --{description = "decrease the number of master clients", group = "layout"}),
    --awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              --{description = "increase the number of columns", group = "layout"}),
    --awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              --{description = "decrease the number of columns", group = "layout"}),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)



-- Move given client to given direction
local function move_client(c, direction)
   -- If client is floating, move to edge
   if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
      local workarea = awful.screen.focused().workarea
      if direction == "up" then
         c:geometry({nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil})
      elseif direction == "down" then
         c:geometry({nil, y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil})
      elseif direction == "left" then
         c:geometry({x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil})
      elseif direction == "right" then
         c:geometry({x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil, nil})
      end
   -- Otherwise swap the client in the tiled layout
   elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
      if direction == "up" or direction == "left" then
         awful.client.swap.byidx(-1, c)
      elseif direction == "down" or direction == "right" then
         awful.client.swap.byidx(1, c)
      end
   else
      awful.client.swap.bydirection(direction, c, nil)
   end
end


-- Resize client in given direction
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
   if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
      if direction == "up" then
         c:relative_move(0, 0, 0, -floating_resize_amount)
      elseif direction == "down" then
         c:relative_move(0, 0, 0, floating_resize_amount)
      elseif direction == "left" then
         c:relative_move(0, 0, -floating_resize_amount, 0)
      elseif direction == "right" then
         c:relative_move(0, 0, floating_resize_amount, 0)
      end
   else
      if direction == "up" then
         awful.client.incwfact(-tiling_resize_factor)
      elseif direction == "down" then
         awful.client.incwfact(tiling_resize_factor)
      elseif direction == "left" then
         awful.tag.incmwfact(-tiling_resize_factor)
      elseif direction == "right" then
         awful.tag.incmwfact(tiling_resize_factor)
      end
   end
end

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),

        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        --awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                --{description = "move to screen", group = "client"}),

        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end,
            {description = "minimize", group = "client"}),

        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),

        awful.key({modkey}, "q",
            function(c)
                c:kill()
            end,
            {description = "close", group = "client"}),

        awful.key({modkey, "Shift"}, "j",
            function(c)
                move_client(c, "down")
            end),
        awful.key({modkey, "Shift"}, "k",
            function(c)
                move_client(c, "up")
            end),
        awful.key({modkey, "Shift"}, "h",
            function(c)
                move_client(c, "left")
            end),
        awful.key({modkey, "Shift"}, "l",
            function(c)
                move_client(c, "right")
            end),



        awful.key({ modkey, "Control" }, "Down",
            function(c)
                resize_client(c, "down")
            end
        ),
        awful.key({ modkey, "Control" }, "Up",
            function(c)
                resize_client(c, "up")
            end
        ),
        awful.key({ modkey, "Control" }, "Left",
            function(c)
                resize_client(c, "left")
            end
        ),
        awful.key({ modkey, "Control" }, "Right",
            function(c)
                resize_client(c, "right")
            end
        ),
        awful.key({ modkey, "Control" }, "j",
            function(c)
                resize_client(c, "down")
            end
        ),
        awful.key({ modkey, "Control" }, "k",
            function(c)
                resize_client(c, "up")
            end
        ),
        awful.key({ modkey, "Control" }, "h",
            function(c)
                resize_client(c, "left")
            end
        ),
        awful.key({ modkey, "Control" }, "l",
            function(c)
                resize_client(c, "right")
            end
        ),
    })
end)

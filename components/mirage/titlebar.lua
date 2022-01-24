--      ████████╗██╗████████╗██╗     ███████╗██████╗  █████╗ ██████╗
--      ╚══██╔══╝██║╚══██╔══╝██║     ██╔════╝██╔══██╗██╔══██╗██╔══██╗
--         ██║   ██║   ██║   ██║     █████╗  ██████╔╝███████║██████╔╝
--         ██║   ██║   ██║   ██║     ██╔══╝  ██╔══██╗██╔══██║██╔══██╗
--         ██║   ██║   ██║   ███████╗███████╗██████╔╝██║  ██║██║  ██║
--         ╚═╝   ╚═╝   ╚═╝   ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi


-- ===================================================================
-- Titlebar Creation
-- ===================================================================


-- Add a titlebar
client.connect_signal("request::titlebars", function(c)
   local titlebar = awful.titlebar(c, {
      bg_normal = '#7700aa50',
      bg_focus = '#f4507f60',
      size = dpi(27)
   })

   titlebar: setup {
      {
         -- AwesomeWM native buttons (images loaded from theme)
         wibox.layout.margin(awful.titlebar.widget.closebutton(c), dpi(11), dpi(5), dpi(5), dpi(5)),
         wibox.layout.margin(awful.titlebar.widget.minimizebutton(c), dpi(4), dpi(5), dpi(5), dpi(5)),
         wibox.layout.margin(awful.titlebar.widget.maximizedbutton(c), dpi(4), dpi(5), dpi(5), dpi(5)),
         layout = wibox.layout.fixed.horizontal
      },
      {
          -- align = "center",
          {
             align = 'center',
             widget = awful.titlebar.widget.titlewidget(c),
          },
          layout = wibox.layout.flex.horizontal
      },
      nil,
      layout = wibox.layout.stack,
   }
end)

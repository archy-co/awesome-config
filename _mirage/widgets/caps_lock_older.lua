-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local clickable_container = require("widgets.clickable-container")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local PATH_TO_ICONS = os.getenv("HOME") .. "/.config/awesome/icons/battery/"


-- ===================================================================
-- Widget Creation
-- ===================================================================


local widget = wibox.widget {
   {
      id = "icon",
      widget = wibox.widget.imagebox,
      resize = true
   },
   layout = wibox.layout.fixed.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
widget_button:buttons(
   gears.table.join(
      awful.button({}, 1, nil,
         function()
            awful.spawn(apps.terminal)
         end
      )
   )
)


local last_battery_check = os.time()

local checker

watch("xset -q | grep Caps | awk '{print $4}'", 1,
   function(_, stdout)
      local clock_widget = wibox.widget.textclock("hello", 1)
      -- Check if there  bluetooth
      checker = tostring(stdout) -- If 'Controller' string is detected on stdout
      local status = tostring(checker)
      local widget_icon_name
      if checker == "off" then
          widget_icon_name = "caps_lock_off"
      else
          widget_icon_name = "caps_lock_on"
      end
      --widget_icon_name = "caps_lock_on"


      --local widget_icon_name = "caps_lock_on"
      --if (checker ~= nil) then
         --widget_icon_name = "caps_lock_on"
      --else
         --widget_icon_name = "caps_lock_on"
      --end

      widget.icon:set_image("/home/archy/.config/awesome/icons/caps_lock/" .. widget_icon_name .. ".png")
      widget:attach(clock_widget, "tc" , { on_pressed = true, on_hover = false })
      collectgarbage("collect")
   end,
   widget
)

return widget_button

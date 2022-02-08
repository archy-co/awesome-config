--      ██████╗ ██╗   ██╗██╗     ███████╗███████╗
--      ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
--      ██████╔╝██║   ██║██║     █████╗  ███████╗
--      ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
--      ██║  ██║╚██████╔╝███████╗███████╗███████║
--      ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")

-- define screen height and width
local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

-- define module table
local rules = {}


-- ===================================================================
-- Rules
-- ===================================================================


-- return a table of client rules including provided keys / buttons
function rules.create(clientkeys, clientbuttons)
   local rofi_rule = {}

   if beautiful.name == "mirage" then
      rofi_rule = {
         rule_any = {name = {"rofi"}},
         properties = {floating = true, titlebars_enabled = false},
         callback = function(c)
            if beautiful.name == "mirage" then
               awful.placement.left(c)
            end
         end
      }
   else rofi_rule = {
         rule_any = {name = {"rofi"}},
         properties = {fullscreen = true, floating = true, titlebars_enabled = false},
      }
   end

   return {
      -- All clients will match this rule.
      {
         rule = {},
         properties = {
            titlebars_enabled = beautiful.titlebars_enabled,
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.centered
         },
      },

      -- Floating clients.
      {
         rule_any = {
            instance = {
               "DTA",
               "copyq",
            },
            class = {
               "Nm-connection-editor",
               "gnome-screenshot", "Gnome-screenshot",
               "zoom",
            },
            name = {
               "Event Tester",
               "Steam Guard - Computer Authorization Required",
               "zoom",
               "Library",
            },
            role = {
               "pop-up",
               "GtkFileChooserDialog"
            },
            type = {
               "dialog"
            }
         }, properties = {floating = true}
      },

      {
         rule_any = {
            class = { "qtfungera" },
         },
         properties = { floating = true, width = 950, height = 750 }
      },

      -- Fullscreen clients
      {
         rule_any = {
            name = {
               "Media viewer",
            },
         }, properties = {maximized = true}
      },

      -- "Switch to tag"
      -- These clients make you switch to their tag when they appear
      {
         rule_any = {
            class = {
               "firefox",
            },
         },
         properties = {switchtotag = true},
      },

      {
         rule_any = {
            class = {
               "Minecraft* 1.18.1",
            },
         },
         properties = {ontop = true, fullscreen = true},
      },

      {
         rule_any = {
            class = { "psoc_creator.exe" },
         },
         properties = { titlebars_enabled = false }
      },

      -- Visualizer
      {
         rule_any = {name = {"cava"}},
         properties = {
            floating = true,
            maximized_horizontal = true,
            sticky = true,
            ontop = false,
            skip_taskbar = true,
            below = true,
            focusable = false,
            height = screen_height * 0.40,
            opacity = 0.6
         },
         callback = function (c)
            decorations.hide(c)
            awful.placement.bottom(c)
         end
      },

      -- rofi rule determined above
      rofi_rule,

      -- File chooser dialog
      {
         rule_any = {role = {"GtkFileChooserDialog"}},
         properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.65}
      },

      -- Pavucontrol & Bluetooth Devices
      {
         rule_any = {class = {"Pavucontrol"}, name = {"Bluetooth Devices"}},
         properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.45}
      },

      {
         rule_any = {class = {"Gnome-control-center"}},
         properties = {floating = true, width = screen_width * 0.35, height = screen_height * 0.55}
      },
   }
end

-- return module table
return rules

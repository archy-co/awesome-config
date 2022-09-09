local ruled = require("ruled")
local awful = require("awful")
local beautiful = require("beautiful")

-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            titlebars_enabled = beautiful.titlebars_enabled,
            border_width = beautiful.border_width,
            focus        = awful.client.focus.filter,
            raise        = true,
            keys         = clientkeys,
            buttons      = clientbuttons,
            screen       = awful.screen.preferred,
            placement    = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry", "DTA" },
            type     = { "dialog" },
            class    = {
                "Nm-connection-editor", "zoom",
                "Blueman-manager", "Sxiv",
                "Wpa_gui", "xtightvncviewer",
                "gnome-screenshot", "Gnome-screenshot",
                "pavucontrol", "Pavucontrol",
                "org.gnome.Nautilus", "Org.gnome.Nautilus",
                "gnome-control-center",
                "osmo", "Osmo"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",
                "Steam Guard - Computer Authorization Required",
                "zoom",
                "Library",
                "VMD Main", "Graphical Representations"
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
                "GtkFileChooserDialog"
            },
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id       = "firefox",
        rule_any = {
            class = { "Navigator", "firefox" },
        },
        properties = { }
    }

    -- Firefox
    ruled.client.append_rule {
        id         = "",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true      }
    }

    -- Floating, no titlebar
    ruled.client.append_rule {
        id       = "no_titlebar",
        rule_any = {
            name = { "zoom" },
        },
        properties = { titlebars_enabled = false }
    }

    -- ROFI
    ruled.client.append_rule {
        rule_any = { name = { "rofi" } },
        properties = { floating = true, titlebars_enabled = false, border_width = 0 },
        callback = function(c)
            awful.placement.left(c)
        end
    }

    -- Fungera
    ruled.client.append_rule {
        rule_any = { class = { "qtfungera" } },
        properties = { floating = true, width = 955, height = 800 }
    }


    ruled.client.append_rule {
        id       = "teams",
        rule_any = {
            class = { "microsoft teams - preview", "Microsoft Teams - Preview" },
        },
        properties = {
            tag = screen[1].tags[4],
        }
    }

    ruled.client.append_rule {
        id       = "games",
        rule_any = {
            class = {
                "sun-awt-X11-XFramePeer",
                "org-tlauncher-tlauncher-rmo-TLauncher",
                "Minecraft* 1.18.2", "Minecraft* 1.18.2",
                "Albion-Online", "Albion Online Launcher"
            },
        },
        properties = {
            tag = screen[1].tags[5],
        }
    }

    ruled.client.append_rule {
        id       = "telegram",
        rule_any = {
            class = {
                "telegram-desktop", "TelegramDesktop"
            },
        },
        properties = {
            tag = screen[1].tags[3],
        }
    }

    --ruled.client.append_rule {
        --id       = "sticky_viber",
        --rule_any = {
            --class = {
                --"viber", "ViberPC"
            --},
        --},
        --properties = {
            --sticky = true
        --}
    --}
end)

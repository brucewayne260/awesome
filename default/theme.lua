---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local themes_path = os.getenv("HOME") .. "/.config/awesome/"
local theme = {}

theme.font          = "SauceCodePro Nerd Font 10"
theme.squeeze       = 8

theme.black     = "#928374"
theme.red       = '#ea6962'
theme.green     = '#a9b665'
theme.yellow    = '#e3a84e'
theme.orange    = '#e78a4e'
theme.blue      = '#7daea3'
theme.magenta   = '#d3869b'
theme.cyan      = '#89b482'
theme.white     = '#ffffff'

theme.dblack    = "#665c54"
theme.dred      = theme.red..'96'
theme.dgreen    = theme.green..'96'
theme.dyellow   = theme.yellow..'96'
theme.dorange   = theme.orange..'96'
theme.dblue     = theme.blue..'96'
theme.dmagenta  = theme.magenta..'96'
theme.dcyan     = theme.cyan..'96'
theme.dwhite    = "#dfbf8e"

theme.background = "#282828"
theme.foreground = theme.black

theme.bg_normal     = theme.background
theme.bg_focus      = theme.dblack
theme.bg_urgent     = theme.red
theme.bg_minimize   = theme.background
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.foreground
theme.fg_focus      = theme.dwhite
theme.fg_urgent     = theme.white
theme.fg_minimize   = theme.foreground

theme.useless_gap         = dpi(3)
theme.border_width        = dpi(1)
theme.border_color_normal = theme.fg_normal
theme.border_color_active = theme.fg_focus
theme.border_color_marked = "#91231c"

theme.hotkeys_modifiers_fg = theme.blue
theme.hotkeys_fg = theme.fg_focus

theme.tasklist_bg_focus = "#00000000"

theme.menu_border_width = 1
theme.menu_border_color = theme.border_color_normal
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(30)
theme.menu_width  = dpi(160)

theme.wallpaper = themes_path.."default/background.png"

-- You can use your own layout icons like this:
theme.layout_fairv = themes_path.."default/layouts/fairv.png"
theme.layout_floating  = themes_path.."default/layouts/floating.png"
theme.layout_max = themes_path.."default/layouts/max.png"
theme.layout_tile = themes_path.."default/layouts/tile.png"
theme.layout_spiral  = themes_path.."default/layouts/spiral.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, "#00000000", theme.fg_normal
)

-- Icons
theme.play = themes_path.."default/extras/play.png"
theme.pause = themes_path.."default/extras/pause.png"
theme.volume_high = themes_path.."default/extras/volume-high.png"
theme.volume_medium = themes_path.."default/extras/volume-medium.png"
theme.volume_low = themes_path.."default/extras/volume-low.png"
theme.volume_zero = themes_path.."default/extras/volume-zero.png"
theme.volume_xmark = themes_path.."default/extras/volume-xmark.png"
theme.cpu = themes_path.."default/extras/server.png"
theme.memory = themes_path.."default/extras/memory.png"
theme.keyboard = themes_path.."default/extras/keyboard.png"
theme.clock = themes_path.."default/extras/clock.png"
theme.wifi = themes_path.."default/extras/wifi.png"
theme.music = themes_path.."default/extras/music.png"
theme.music_focus = themes_path.."default/extras/music-focus.png"
theme.spotify = themes_path.."default/extras/spotify.png"
theme.spotify_focus = themes_path.."default/extras/spotify-focus.png"

-- Icons but for light background
theme.play_dark = themes_path.."default/extras/play-dark.png"
theme.pause_dark = themes_path.."default/extras/pause-dark.png"
theme.volume_high_dark = themes_path.."default/extras/volume-high-dark.png"
theme.volume_medium_dark = themes_path.."default/extras/volume-medium-dark.png"
theme.volume_low_dark = themes_path.."default/extras/volume-low-dark.png"
theme.volume_zero_dark = themes_path.."default/extras/volume-zero-dark.png"
theme.volume_xmark_dark = themes_path.."default/extras/volume-xmark-dark.png"
theme.cpu_dark = themes_path.."default/extras/server-dark.png"
theme.memory_dark = themes_path.."default/extras/memory-dark.png"
theme.keyboard_dark = themes_path.."default/extras/keyboard-dark.png"
theme.clock_dark = themes_path.."default/extras/clock-dark.png"
theme.wifi_dark = themes_path.."default/extras/wifi-dark.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

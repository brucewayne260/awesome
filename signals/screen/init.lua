local awful = require'awful'
local beautiful = require'beautiful'
local wibox = require'wibox'

local vars = require'config.vars'
local widgets = require'widgets'
local gears = require'gears'

screen.connect_signal('request::wallpaper', function(s)
  awful.wallpaper{
    screen = s,
    widget = {
      image  = gears.surface.crop_surface {
        surface = gears.surface.load_uncached(beautiful.wallpaper),
        ratio = s.geometry.width/s.geometry.height,
      },
      widget = wibox.widget.imagebox,
    },
  }
end)

screen.connect_signal('request::desktop_decoration', function(s)
  awful.tag(vars.tags, s, awful.layout.layouts[1])
  s.wibar = widgets.create_wibar(s)
end)

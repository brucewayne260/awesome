local _M = {}

local wibox = require("wibox")
local beautiful = require("beautiful")

_M.clockbox = wibox.widget {
  widget = wibox.layout.fixed.horizontal,
  {
    {
      {
        widget = wibox.widget.imagebox,
        image = beautiful.clock_dark,
      },
      widget = wibox.container.margin,
      top = beautiful.squeeze - 1,
      bottom = beautiful.squeeze - 1,
    },
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
  },
  {
    widget = wibox.widget.separator,
    thickness = 0,
    forced_width = beautiful.squeeze,
  },
  {
    {
      format = '<b>%a %b %d, %H:%M</b>',
      widget = wibox.widget.textclock,
    },
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
  },
}

return _M

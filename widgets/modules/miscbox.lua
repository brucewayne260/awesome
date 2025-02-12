local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

_M.miscbox = wibox.widget {
  widget = wibox.layout.fixed.horizontal,
  {
    {
      {
        widget = wibox.widget.imagebox,
        image = beautiful.keyboard,
      },
      widget = wibox.container.margin,
      top = beautiful.squeeze,
      bottom = beautiful.squeeze,
    },
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
  },
  {
    {
      widget = wibox.layout.fixed.horizontal,
      awful.widget.keyboardlayout(),
      wibox.widget.systray(),
    },
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
  },
}

return _M

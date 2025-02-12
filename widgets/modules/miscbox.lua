local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")

local miscbox = wibox.widget {
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

function _M.box(col, darkcol, left_margin, right_margin)
  return createbox.createbox(miscbox, nil, col, darkcol, left_margin, right_margin)
end

return _M

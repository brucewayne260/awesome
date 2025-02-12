local _M = {}

local wibox = require("wibox")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")

local clockbox = wibox.widget {
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

function _M.box(col, darkcol, left_margin, right_margin)
  return createbox.createbox(clockbox, nil, col, darkcol, left_margin, right_margin)
end

return _M

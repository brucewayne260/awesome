local _M = {}

local wibox = require("wibox")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

function _M.box(col, darkcol, left_margin, right_margin)
  local new = newwidget.newwidget (
    col,
    {
      id = "text",
      widget = wibox.widget.textclock,
    },
    beautiful.squeeze - 1,
    nil,
    beautiful.clock,
    beautiful.clock_dark,
    left_margin,
    right_margin
  )
  local clockbox = wibox.widget(new[1])

  clockbox:get_children_by_id("text")[1].format = new[2]('%a %b %d, %H:%M')

  return createbox.createbox(clockbox, nil, col, darkcol)
end

return _M

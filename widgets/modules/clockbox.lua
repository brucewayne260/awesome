local _M = {}

local wibox = require("wibox")
local be = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

function _M.box(col, darkcol, left, right)
  local new = newwidget.newwidget({
    col = col,
    widget = { id = "text", widget = wibox.widget.textclock },
    squeeze = 7,
    image_light = be.clock,
    image_dark = be.clock_dark,
    left = left,
    right = right,
  })
  local clockbox = wibox.widget(new.table)
  clockbox:get_children_by_id("text")[1].format = new.bold('%a %b %d, %H:%M')
  return createbox.createbox(clockbox, nil, col, darkcol)
end

return _M

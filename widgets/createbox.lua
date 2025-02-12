local _M = {}

local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

function _M.createbox(content, col, darkcol, buttons, left_margin, right_margin)
  local darkfg
  local border
  local border_color
  if col or darkcol then
    darkfg = beautiful.bg_normal
    border = 0
  end
  if col == beautiful.fg_normal then
    border_color = beautiful.bg_focus
  end
  local box = wibox.widget {
    widget = wibox.container.background,
    shape = gears.shape.rounded_rect,
    buttons = buttons,
    {
      layout = wibox.layout.stack,
      {
        widget = wibox.container.margin,
        bottom = 0,
        top = 10,
        {
          id = "depth",
          widget = wibox.container.background,
          bg = darkcol or beautiful.bg_normal,
          border_width = border or 1,
          border_color = border_color or beautiful.fg_normal,
          shape = gears.shape.rounded_rect,
        },
      },
      {
        id = "margin",
        widget = wibox.container.margin,
        bottom = 5,
        top = 0,
        {
          id = "background",
          widget = wibox.container.background,
          bg = col or beautiful.bg_normal,
          fg = darkfg or beautiful.fg_normal,
          border_width = border or 1,
          border_color = beautiful.fg_normal,
          shape = gears.shape.rounded_rect,
          {
            widget = wibox.container.margin,
            left = left_margin,
            right = right_margin,
            content,
          },
        },
      },
    },
  }
  box:connect_signal("button::press", function()
    box:get_children_by_id("margin")[1].top = 5
    box:get_children_by_id("margin")[1].bottom = 0
    box.border_width = 0
  end)
  box:connect_signal("button::release", function()
    box:get_children_by_id("margin")[1].top = 0
    box:get_children_by_id("margin")[1].bottom = 5
    box.border_width = border or 1
  end)
  box:connect_signal("mouse::leave", function()
    box:get_children_by_id("margin")[1].top = 0
    box:get_children_by_id("margin")[1].bottom = 5
    box.border_width = border or 1
  end)
  return box
end

return _M

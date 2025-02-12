local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")

local command = "free -h | sed '2q;d' | awk '{print $3}'"

local membox = wibox.widget {
  widget = wibox.layout.fixed.horizontal,
  {
    {
      {
        widget = wibox.widget.imagebox,
        image = beautiful.memory_dark,
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
    widget = wibox.widget.separator,
    thickness = 0,
    forced_width = beautiful.squeeze,
  },
  {
    {
      id = "text",
      widget = wibox.widget.textbox,
    },
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
  },
}

local update_text = function()
	awful.spawn.easy_async_with_shell(command, function(stdout)
    membox:get_children_by_id("text")[1].markup = "<b>"..stdout.."</b>"
	end)
end

function _M.box(col, darkcol, left_margin, right_margin)
  return createbox.createbox(membox, nil, col, darkcol, left_margin, right_margin)
end

gears.timer {
  timeout   = 2,
  call_now  = true,
  autostart = true,
  callback  = function() update_text() end
}

return _M

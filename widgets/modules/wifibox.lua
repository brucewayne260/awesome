local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")

local command = "nmcli --fields NAME c show --active | sed '2q;d'"

local wifibox = wibox.widget {
  widget = wibox.layout.fixed.horizontal,
  {
    {
      {
        widget = wibox.widget.imagebox,
        image = beautiful.wifi,
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
      widget = wibox.container.constraint,
      width = 100,
      {
        id = "text",
        widget = wibox.widget.textbox,
      },
    },
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
  },
}

local update_text = function()
	awful.spawn.easy_async_with_shell(command, function(stdout)
    wifibox:get_children_by_id("text")[1].markup = stdout
	end)
end

function _M.box(col, darkcol, left_margin, right_margin)
  return createbox.createbox(wifibox, nil, col, darkcol, left_margin, right_margin)
end

gears.timer {
  timeout   = 5,
  call_now  = true,
  autostart = true,
  callback  = function() update_text() end
}

return _M

local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")

local command = "echo $({ head -n1 /proc/stat;sleep 0.5;head -n1 /proc/stat; } | awk '/^cpu /{a=$2-a;b=$3-b;c=$4-c;d=$5-d;e=$6-e;f=$7-f;g=$8-g}END{print int(100*(a+b+c+f+g)/(a+b+c+d+e+f+g))}')% > /tmp/foo.txt"

local cpubox = wibox.widget {
  widget = wibox.layout.fixed.horizontal,
  {
    {
      {
        widget = wibox.widget.imagebox,
        image = beautiful.cpu,
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
    forced_width = beautiful.squeeze - 2,
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
	awful.spawn.easy_async_with_shell(command, function()
		awful.spawn.easy_async("cat /tmp/foo.txt", function(stdout)
			cpubox:get_children_by_id("text")[1].markup = stdout
		end)
	end)
end

function _M.box(col, darkcol, left_margin, right_margin)
  return createbox.createbox(cpubox, nil, col, darkcol, left_margin, right_margin)
end

gears.timer {
  timeout   = 2,
  call_now  = true,
  autostart = true,
  callback  = function() update_text() end
}

return _M

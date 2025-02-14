local _M = {}

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

local command = "echo $({ head -n1 /proc/stat;sleep 0.5;head -n1 /proc/stat; } | awk '/^cpu /{a=$2-a;b=$3-b;c=$4-c;d=$5-d;e=$6-e;f=$7-f;g=$8-g}END{print int(100*(a+b+c+f+g)/(a+b+c+d+e+f+g))}')% > ~/.cache/awesome/cpu_usage"

function _M.box(col, darkcol, left_margin, right_margin)
  local new = newwidget.newwidget(col, nil, nil, nil, beautiful.cpu, beautiful.cpu_dark, left_margin, right_margin)
  local cpubox = wibox.widget(new[1])

  local update_text = function()
    awful.spawn.easy_async_with_shell(command, function()
      awful.spawn.easy_async_with_shell("cat ~/.cache/awesome/cpu_usage", function(stdout)
        cpubox:get_children_by_id("text")[1].markup = new[2](stdout)
      end)
    end)
  end

  gears.timer {
    timeout   = 2,
    call_now  = true,
    autostart = true,
    callback  = function() update_text() end
  }

  return createbox.createbox(cpubox, nil, col, darkcol)
end

return _M

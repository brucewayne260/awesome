local _M = {}

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local be = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

function _M.box(col, darkcol, left, right)
  local command = "echo $({ head -n1 /proc/stat;sleep 0.5;head -n1 /proc/stat; } | awk '/^cpu /{a=$2-a;b=$3-b;c=$4-c;d=$5-d;e=$6-e;f=$7-f;g=$8-g}END{print int(100*(a+b+c+f+g)/(a+b+c+d+e+f+g))}')% > ~/.cache/cpu_usage"
  local new = newwidget.newwidget({
    col = col,
    image_light = be.cpu,
    image_dark = be.cpu_dark,
    left = left,
    right = right,
  })
  local cpubox = wibox.widget(new.table)

  local update_text = function()
    awful.spawn.easy_async_with_shell(command, function()
      awful.spawn.easy_async_with_shell("cat ~/.cache/cpu_usage", function(stdout)
        cpubox:get_children_by_id("text")[1].markup = new.bold(stdout)
      end)
    end)
  end

  gears.timer {
    timeout   = 5,
    call_now  = true,
    autostart = true,
    callback  = function() update_text() end
  }

  return createbox.createbox(cpubox, nil, col, darkcol)
end

return _M

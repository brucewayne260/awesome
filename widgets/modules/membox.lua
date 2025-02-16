local _M = {}

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local be = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

function _M.box(col, darkcol, left, right)
  local command = "free -h | sed '2q;d' | awk '{print $3}'"
  local new = newwidget.newwidget({
    col = col,
    image_light = be.memory,
    image_dark = be.memory_dark,
    left = left,
    right = right,
  })
  local membox = wibox.widget(new.table)

  local update_text = function()
    awful.spawn.easy_async_with_shell(command, function(stdout)
      membox:get_children_by_id("text")[1].markup = new.bold(stdout)
    end)
  end

  gears.timer {
    timeout   = 5,
    call_now  = true,
    autostart = true,
    callback  = function() update_text() end
  }

  return createbox.createbox(membox, nil, col, darkcol)
end

return _M

local _M = {}

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

local command = "free -h | sed '2q;d' | awk '{print $3}'"

function _M.box(col, darkcol, left_margin, right_margin)
  local new = newwidget.newwidget(col, nil, nil, nil, beautiful.memory, beautiful.memory_dark, left_margin, right_margin)
  local membox = wibox.widget(new[1])

  local update_text = function()
    awful.spawn.easy_async_with_shell(command, function(stdout)
      membox:get_children_by_id("text")[1].markup = new[2](stdout)
    end)
  end

  gears.timer {
    timeout   = 2,
    call_now  = true,
    autostart = true,
    callback  = function() update_text() end
  }

  return createbox.createbox(membox, nil, col, darkcol)
end

return _M

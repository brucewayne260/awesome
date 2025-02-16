local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local be = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

local command = "nmcli --fields NAME c show --active | sed '2q;d'"

function _M.box(col, darkcol, left, right)
  local new = newwidget.newwidget({
    col = col,
    left = left,
    right = right,
    image_light = be.wifi,
    image_dark = be.wifi_dark,
    widget = {
      widget = wibox.container.constraint,
      width = 100,
      {
        id = "text",
        widget = wibox.widget.textbox,
      },
    },
  })
  local wifibox = wibox.widget(new.table)

  _M.update_text = function()
    awful.spawn.easy_async_with_shell(command, function(stdout)
      wifibox:get_children_by_id("text")[1].markup = new.bold(stdout)
    end)
  end

  gears.timer {
    timeout   = 5,
    call_now  = true,
    autostart = true,
    callback  = function() _M.update_text() end
  }

  return createbox.createbox(wifibox, nil, col, darkcol)
end

return _M

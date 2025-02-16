local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local be = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

function _M.box(col, darkcol, left, right)
  local command = "cat /etc/vconsole.conf | grep KEYMAP | cut -c 8-"
  local new = newwidget.newwidget({
    col = col,
    left = left,
    right = right,
    image_light = be.keyboard,
    image_dark = be.keyboard_dark,
    widget = {
      widget = wibox.layout.fixed.horizontal,
      {
        id = "text",
        widget = wibox.widget.textbox,
      },
      wibox.widget.systray(),
    },
  })
  local miscbox = wibox.widget(new.table)
  awful.spawn.easy_async_with_shell(command, function(stdout)
    miscbox:get_children_by_id("text")[1].markup = new.bold(stdout)
  end)
  return createbox.createbox(miscbox, nil, col, darkcol)
end

return _M

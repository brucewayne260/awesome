local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

function _M.box(col, darkcol, left_margin, right_margin)
  local command = "cat /etc/vconsole.conf | grep KEYMAP | cut -c 8-"
  local widget = {
    widget = wibox.layout.fixed.horizontal,
    {
      id = "text",
      widget = wibox.widget.textbox,
    },
    wibox.widget.systray(),
  }
  local new = newwidget.newwidget(col, widget, nil, nil, beautiful.keyboard, beautiful.keyboard_dark, left_margin, right_margin)
  local miscbox = wibox.widget(new[1])

  awful.spawn.easy_async_with_shell(command, function(stdout)
    miscbox:get_children_by_id("text")[1].markup = new[2](stdout)
  end)

  return createbox.createbox(miscbox, nil, col, darkcol)
end

return _M

local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local playerctlbox = require("widgets.modules.playerctlbox")
local tasklistbox = require("widgets.modules.tasklistbox")
local screen = screen
local createbox = require("widgets.createbox")
local middlebox
local tasklist

_M.toggle_box = function()
  if middlebox:get_children_by_id("ratio")[1]:get_ratio(1) == 1 then
    middlebox:get_children_by_id("ratio")[1]:add(tasklist)
    middlebox:get_children_by_id("ratio")[1]:adjust_ratio(2, 0, 1, 0)
    playerctlbox.playerctlbox:get_children_by_id("foreground")[1].fg = beautiful.fg_normal
    playerctlbox.focus = false
    playerctlbox.update_player()
  else
    middlebox:get_children_by_id("ratio")[1]:remove(2)
    playerctlbox.playerctlbox:get_children_by_id("foreground")[1].fg = beautiful.fg_focus
    playerctlbox.focus = true
    playerctlbox.update_player()
  end
end

local buttons = {
  awful.button {
    modifiers = {},
    button = 5,
    on_press = function()
      _M.toggle_box()
    end,
  },
  awful.button {
    modifiers = {},
    button = 4,
    on_press = function()
      _M.toggle_box()
    end,
  },
}

screen.connect_signal('request::desktop_decoration', function(s)
  tasklist = tasklistbox.create_tasklist(s)
  middlebox = wibox.widget {
    id = "ratio",
    widget  = wibox.layout.ratio.horizontal,
    inner_fill_strategy = "justify",
    playerctlbox.playerctlbox,
    tasklist,
  }
end)
middlebox:get_children_by_id("ratio")[1]:adjust_ratio(2, 0, 1, 0)

function _M.box(col, darkcol)
  return createbox.createbox(middlebox, buttons, col, darkcol)
end

return _M

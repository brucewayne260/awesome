local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local playerctlbox = require("widgets.modules.playerctlbox")
local tasklistbox = require("widgets.modules.tasklistbox")

_M.toggle_box = function()
  if _M.middlebox:get_children_by_id("ratio")[1]:get_ratio(1) == 1 then
    _M.middlebox:get_children_by_id("ratio")[1]:adjust_ratio(2, 0, 1, 0)
    -- playerctlbox.playerctlbox:get_children_by_id("foreground")[1].fg = beautiful.fg_normal
    -- playerctlbox.focus = false
    playerctlbox.update_player()
  else
    _M.middlebox:get_children_by_id("ratio")[1]:adjust_ratio(1, 0, 1, 0)
    -- playerctlbox.playerctlbox:get_children_by_id("foreground")[1].fg = beautiful.fg_focus
    -- playerctlbox.focus = true
    playerctlbox.update_player()
  end
end

screen.connect_signal('request::desktop_decoration', function(s)

  _M.buttons = {
    awful.button {
      modifiers = {},
      button = 2,
      on_press = function()
        _M.toggle_box()
      end,
    },
  }
  _M.middlebox = wibox.widget {
    id = "ratio",
    widget  = wibox.layout.ratio.horizontal,
    inner_fill_strategy = "justify",
    playerctlbox.playerctlbox,
    tasklistbox.create_tasklist(s),
  }

end)

_M.middlebox:get_children_by_id("ratio")[1]:adjust_ratio(2, 0, 1, 0)

return _M

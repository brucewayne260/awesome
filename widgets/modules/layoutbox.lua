local _M = {}
local awful = require("awful")
local wibox = require("wibox")
local createbox = require("widgets.createbox")
local screen = screen

local buttons = {
  awful.button{
    modifiers = {},
    button    = 1,
    on_press  = function() awful.layout.inc(1) end,
  },
  awful.button{
    modifiers = {},
    button    = 3,
    on_press  = function() awful.layout.inc(-1) end,
  },
  awful.button{
    modifiers = {},
    button    = 4,
    on_press  = function() awful.layout.inc(-1) end,
  },
  awful.button{
    modifiers = {},
    button    = 5,
    on_press  = function() awful.layout.inc(1) end,
  },
}

local layoutbox
screen.connect_signal('request::desktop_decoration', function(s)
  layoutbox = wibox.widget {
    widget = wibox.container.margin,
    top = 4,
    bottom = 4,
    left = 4,
    right = 4,
    awful.widget.layoutbox(s)
  }
end)

function _M.box(col, darkcol)
  return createbox.createbox(layoutbox, buttons, col, darkcol)
end

return _M

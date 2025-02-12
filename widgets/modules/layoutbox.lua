local _M = {}
local awful = require("awful")
local wibox = require("wibox")

_M.buttons = {
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

local function create_layoutbox(s)
  return awful.widget.layoutbox{
    screen = s,
  }
end

screen.connect_signal('request::desktop_decoration', function(s)

	s.layoutbox = create_layoutbox(s)
  _M.layoutbox = wibox.widget {
    widget = wibox.container.margin,
    top = 4,
    bottom = 4,
    s.layoutbox,
  }

end)

return _M

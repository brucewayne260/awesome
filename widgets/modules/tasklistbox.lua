local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local newwidget = require("widgets.newwidget")

function _M.create_tasklist(s)
	return awful.widget.tasklist{
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
    layout = {
      spacing = 10,
      spacing_widget = {
        {
          forced_width = 10,
          shape        = gears.shape.circle,
          widget       = wibox.widget.separator
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
      },
      layout  = wibox.layout.flex.horizontal
    },
    widget_template = {
      id = "background_role",
      widget = wibox.container.background,
      {
        widget = wibox.container.place,
        haligh = "center",
        newwidget.newtasklist(),
      },
    },
		buttons = {
			awful.button{
				modifiers = {},
				button    = 1,
				on_press  = function(c)
					c:activate{context = 'tasklist', action = 'toggle_minimization'}
				end,
			},
			awful.button{
				modifiers = {},
				button    = 3,
				on_press  = function() awful.menu.client_list{theme = {width = 250}} end
			},
		},
	}
end

return _M

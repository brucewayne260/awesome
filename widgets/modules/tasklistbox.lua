local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

function _M.create_tasklist(s)
	return awful.widget.tasklist{
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
    layout   = {
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
        {
          widget = wibox.layout.fixed.horizontal,
          {
            {
              {
                widget = awful.widget.clienticon,
              },
              widget = wibox.container.margin,
              top = beautiful.squeeze - 2,
              bottom = beautiful.squeeze - 2,
            },
            widget = wibox.container.place,
            valign = "center",
            halign = "center",
          },
          {
            widget = wibox.widget.separator,
            thickness = 0,
            forced_width = beautiful.squeeze - 5,
          },
          {
            {
              id = "text_margin_role",
              widget = wibox.container.margin,
              left = beautiful.squeeze,
              right = beautiful.squeeze,
              {
                id = "text_role",
                widget = wibox.widget.textbox,
              },
            },
            widget = wibox.container.place,
            valign = "center",
            halign = "center",
          },
        },
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
			awful.button{
				modifiers = {},
				button    = 4,
				on_press  = function() awful.client.focus.byidx(-1) end
			},
			awful.button{
				modifiers = {},
				button    = 5,
				on_press  = function() awful.client.focus.byidx(1) end
			},
		},
	}
end

return _M

local _M = {}
local awful = require("awful")
local gears = require("gears")
local be = require("beautiful")
local createbox = require("widgets.createbox")
local client = client
local screen = screen
local mod = require'bindings.mod'

screen.connect_signal('request::desktop_decoration', function(s)
  function _M.box(col, darkcol)
    -- borders
    be.taglist_shape_border_width = 1
    be.taglist_shape_border_color = be.fg_normal
    be.taglist_shape_border_width_empty = 0
    be.taglist_shape_border_width_focus = 0

    -- background
    be.taglist_bg_empty = be.background
    be.taglist_bg_occupied = be.background
    be.taglist_bg_focus = col or be.foreground

    -- shape and spacing
    be.taglist_shape = gears.shape.rounded_rect
    be.taglist_spacing = 5

    return awful.widget.taglist{
      screen = s,
      filter = awful.widget.taglist.filter.all,
      widget_template = createbox.createtagbox(darkcol),
      buttons = {
        awful.button{
          modifiers = {},
          button    = 1,
          on_press  = function(t) t:view_only() end,
        },
        awful.button{
          modifiers = {mod.super},
          button    = 1,
          on_press  = function(t)
            if client.focus then
              client.focus:move_to_tag(t)
            end
          end,
        },
        awful.button{
          modifiers = {},
          button    = 3,
          on_press  = awful.tag.viewtoggle,
        },
        awful.button{
          modifiers = {mod.super},
          button    = 3,
          on_press  = function(t)
            if client.focus then
              client.focus:toggle_tag(t)
            end
          end
        },
        awful.button{
          modifiers = {},
          button    = 4,
          on_press  = function(t) awful.tag.viewprev(t.screen) end,
        },
        awful.button{
          modifiers = {},
          button    = 5,
          on_press  = function(t) awful.tag.viewnext(t.screen) end,
        },
      },
    }
  end
end)

return _M

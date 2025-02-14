local _M = {}

local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

function _M.newwidget(col, widget, squeeze, spacing, image_light, image_dark, left_margin, right_margin)
  local image, bold, fg
  local sep = wibox.widget {
    widget = wibox.widget.separator,
    thickness = 0,
    forced_width = spacing or beautiful.squeeze,
  }
  if col then
    bold = function(stdout) return "<b>"..stdout.."</b>" end
    if image_dark then image = image_dark else sep = nil end
    fg = beautiful.bg_normal
  else
    bold = function(stdout) return stdout end
    if image_light then image = image_light else sep = nil end
    fg = beautiful.fg_normal
  end
  return {
    {
      layout = wibox.layout.fixed.horizontal,
      {
        widget = wibox.widget.separator,
        thickness = 0,
        forced_width = left_margin,
      },
      {
        {
          {
            widget = wibox.widget.imagebox,
            id = "image",
            image = image,
          },
          id = "squeeze",
          widget = wibox.container.margin,
          top = squeeze or beautiful.squeeze,
          bottom = squeeze or beautiful.squeeze,
        },
        widget = wibox.container.place,
        valign = "center",
      },
      sep,
      {
        {
          id = "foreground",
          widget = wibox.container.background,
          fg = fg,
          widget or {widget = wibox.widget.textbox, id = "text"},
        },
        widget = wibox.container.place,
        valign = "center",
      },
      {
        widget = wibox.widget.separator,
        thickness = 0,
        forced_width = right_margin,
      },
    },
  bold }
end

function _M.newtasklist()
  return {
    widget = wibox.layout.fixed.horizontal,
    {
      widget = wibox.widget.separator,
      thickness = 0,
      forced_width = beautiful.squeeze + 5,
    },
    {
      {
        {
          widget = awful.widget.clienticon
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
      forced_width = beautiful.squeeze,
    },
    {
      {
        widget = wibox.container.margin,
        right = beautiful.squeeze + 5,
        {
          widget = wibox.widget.textbox,
          id = "text_role"
        },
      },
      widget = wibox.container.place,
      valign = "center",
      halign = "center",
    },
  }
end

return _M

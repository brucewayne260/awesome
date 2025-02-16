local _M = {}

local wibox = require("wibox")
local awful = require("awful")
local be = require("beautiful")

function _M.newwidget(table)
  local image, bold, fg
  if table.col then
    bold = function(stdout) return "<b>"..stdout.."</b>" end
    image = table.image_dark
    fg = be.bg_normal
  else
    bold = function(stdout) return stdout end
    image = table.image_light
    fg = be.fg_normal
  end
  return {
    table = {
      widget = wibox.container.margin,
      left = table.left or 8,
      right = table.right or 8,
      {
        layout = wibox.layout.fixed.horizontal,
        {
          {
            {
              widget = wibox.widget.imagebox,
              id = "image",
              image = image,
            },
            id = "squeeze",
            widget = wibox.container.margin,
            top = table.squeeze or 8,
            bottom = table.squeeze or 8,
            right = table.spacing or 8,
          },
          widget = wibox.container.place,
          valign = "center",
        },
        {
          {
            id = "foreground",
            widget = wibox.container.background,
            fg = fg,
            table.widget or { widget = wibox.widget.textbox, id = "text" },
          },
          widget = wibox.container.place,
          valign = "center",
        },
      },
    },
  bold = bold }
end

function _M.newtasklist()
  return {
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
              widget = awful.widget.clienticon
            },
            widget = wibox.container.margin,
            top = 6,
            bottom = 6,
            left = 13,
            right = 8,
          },
          widget = wibox.container.place,
          valign = "center",
          halign = "center",
        },
        {
          {
            widget = wibox.container.margin,
            right = 13,
            {
              widget = wibox.widget.textbox,
              id = "text_role"
            },
          },
          widget = wibox.container.place,
          valign = "center",
          halign = "center",
        },
      },
    },
  }
end

return _M

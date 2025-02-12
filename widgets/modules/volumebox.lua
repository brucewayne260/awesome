local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local command = "pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | rev | cut -c 2- | rev"

local update_text = function()
	awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'", function(stdout)
    if string.match(stdout, "%S+") == "no" then
      awful.spawn.easy_async_with_shell(command, function(out)
        if tonumber(out) == 0 then
          _M.volumebox:get_children_by_id("image")[1].image = beautiful.volume_zero_dark
        elseif tonumber(out) <= 30 then
          _M.volumebox:get_children_by_id("image")[1].image = beautiful.volume_low_dark
        elseif tonumber(out) <= 60 then
          _M.volumebox:get_children_by_id("image")[1].image = beautiful.volume_medium_dark
        elseif tonumber(out) <= 90 then
          _M.volumebox:get_children_by_id("image")[1].image = beautiful.volume_high_dark
        end
      end)
    else
      _M.volumebox:get_children_by_id("image")[1].image = beautiful.volume_xmark_dark
    end
	end)
	awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}'", function(stdout)
    _M.volumebox:get_children_by_id("text")[1].markup = "<b>"..stdout.."</b>"
	end)
end

_M.vol = {}
_M.vol.mute = function()
  awful.spawn.easy_async("pactl set-sink-mute @DEFAULT_SINK@ toggle", function()
    update_text()
  end)
end
_M.vol.dec = function()
  awful.spawn.easy_async("pactl set-sink-volume @DEFAULT_SINK@ -5%", function()
    update_text()
  end)
end
_M.vol.inc = function()
  awful.spawn.easy_async("pactl set-sink-volume @DEFAULT_SINK@ +5%", function()
    update_text()
  end)
end

_M.buttons = {
  awful.button {
    modifiers = {},
    button = 1,
    on_press = function()
      _M.vol.mute()
    end,
  },
  awful.button {
    modifiers = {},
    button = 5,
    on_press = function()
      _M.vol.dec()
    end,
  },
  awful.button {
    modifiers = {},
    button = 4,
    on_press = function()
      _M.vol.inc()
    end,
  },
}
_M.volumebox = wibox.widget {
  widget = wibox.layout.fixed.horizontal,
  {
    {
      {
        id = "image",
        widget = wibox.widget.imagebox,
      },
      widget = wibox.container.margin,
      top = beautiful.squeeze,
      bottom = beautiful.squeeze,
    },
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
  },
  {
    widget = wibox.widget.separator,
    thickness = 0,
    forced_width = beautiful.squeeze - 2,
  },
  {
    {
      id = "text",
      widget = wibox.widget.textbox,
    },
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
  },
}

update_text()

return _M

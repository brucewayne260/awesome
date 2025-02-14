local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

local command = "pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | rev | cut -c 2- | rev"

local buttons = {
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

function _M.box(col, darkcol, left_margin, right_margin)
  local new = newwidget.newwidget(col, nil, nil, beautiful.squeeze - 2, beautiful.volume_medium, beautiful.volume_medium_dark, left_margin, right_margin)
  local volumebox = wibox.widget(new[1])
  local box = createbox.createbox(volumebox, buttons, col, darkcol)
  local volume_zero, volume_low, volume_medium, volume_high, volume_xmark
  if col then
    volume_zero = beautiful.volume_zero_dark
    volume_low = beautiful.volume_low_dark
    volume_medium = beautiful.volume_medium_dark
    volume_high = beautiful.volume_high_dark
    volume_xmark = beautiful.volume_xmark_dark
  end
  _M.update_text = function()
    awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'", function(stdout)
      if string.match(stdout, "%S+") == "no" then
        box:get_children_by_id("background")[1].bg = col or beautiful.background
        box:get_children_by_id("depth")[1].bg = darkcol or beautiful.background
        awful.spawn.easy_async_with_shell(command, function(out)
          if tonumber(out) == 0 then
            volumebox:get_children_by_id("image")[1].image = volume_zero or beautiful.volume_zero
          elseif tonumber(out) <= 30 then
            volumebox:get_children_by_id("image")[1].image = volume_low or beautiful.volume_low
          elseif tonumber(out) <= 60 then
            volumebox:get_children_by_id("image")[1].image = volume_medium or beautiful.volume_medium
          elseif tonumber(out) <= 90 then
            volumebox:get_children_by_id("image")[1].image = volume_high or beautiful.volume_high
          end
        end)
      else
        box:get_children_by_id("background")[1].bg = beautiful.red
        box:get_children_by_id("depth")[1].bg = beautiful.dred
        volumebox:get_children_by_id("image")[1].image = volume_xmark or beautiful.volume_xmark
      end
    end)
    awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}'", function(stdout)
      volumebox:get_children_by_id("text")[1].markup = new[2](stdout)
    end)
  end

  _M.vol = {}
  _M.vol.mute = function()
    awful.spawn.easy_async("pactl set-sink-mute @DEFAULT_SINK@ toggle", function()
      _M.update_text()
    end)
  end
  _M.vol.dec = function()
    awful.spawn.easy_async("pactl set-sink-volume @DEFAULT_SINK@ -5%", function()
      _M.update_text()
    end)
  end
  _M.vol.inc = function()
    awful.spawn.easy_async("pactl set-sink-volume @DEFAULT_SINK@ +5%", function()
      _M.update_text()
    end)
  end

  _M.update_text()

  return box
end

return _M

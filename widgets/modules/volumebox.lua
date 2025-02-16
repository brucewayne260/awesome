local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local be = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

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

function _M.box(col, darkcol, left, right)
  local new = newwidget.newwidget({
    col = col,
    spacing = 6,
    left = left,
    right = right,
  })
  local volumebox = wibox.widget(new.table)
  local box = createbox.createbox(volumebox, buttons, col, darkcol)
  local volume_zero, volume_low, volume_medium, volume_high, volume_xmark
  local command = "pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | rev | cut -c 2- | rev"
  if col then
    volume_zero = be.volume_zero_dark
    volume_low = be.volume_low_dark
    volume_medium = be.volume_medium_dark
    volume_high = be.volume_high_dark
    volume_xmark = be.volume_xmark_dark
  end
  local update_text = function()
    awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'", function(stdout)
      if string.match(stdout, "%S+") == "no" then
        box:get_children_by_id("background")[1].bg = col or be.background
        box:get_children_by_id("depth")[1].bg = darkcol or be.background
        awful.spawn.easy_async_with_shell(command, function(out)
          if tonumber(out) == 0 then
            volumebox:get_children_by_id("image")[1].image = volume_zero or be.volume_zero
          elseif tonumber(out) <= 30 then
            volumebox:get_children_by_id("image")[1].image = volume_low or be.volume_low
          elseif tonumber(out) <= 60 then
            volumebox:get_children_by_id("image")[1].image = volume_medium or be.volume_medium
          elseif tonumber(out) <= 90 then
            volumebox:get_children_by_id("image")[1].image = volume_high or be.volume_high
          end
        end)
      else
        box:get_children_by_id("background")[1].bg = be.red
        box:get_children_by_id("depth")[1].bg = be.dred
        volumebox:get_children_by_id("image")[1].image = volume_xmark or be.volume_xmark
      end
    end)
    awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}'", function(stdout)
      volumebox:get_children_by_id("text")[1].markup = new.bold(stdout)
    end)
  end

  _M.vol = {}
  _M.vol.mute = function()
    awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
  end
  _M.vol.dec = function()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false)
  end
  _M.vol.inc = function()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false)
  end

  local volume_script = [[
      bash -c "
      LANG=C pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #\"
  "]]
  update_text()
  awful.spawn.easy_async("pkill pactl", function()
    awful.spawn.with_line_callback(volume_script, {
      stdout = function()
        update_text()
      end
    })
  end)

  return box
end

return _M

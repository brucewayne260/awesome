local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")

local command = "pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | rev | cut -c 2- | rev"
local volumebox = wibox.widget {
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

local box
local update_text = function()
	awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'", function(stdout)
    if string.match(stdout, "%S+") == "no" then
      box:get_children_by_id("background")[1].bg = beautiful.blue
      box:get_children_by_id("depth")[1].bg = beautiful.dblue
      awful.spawn.easy_async_with_shell(command, function(out)
        if tonumber(out) == 0 then
          volumebox:get_children_by_id("image")[1].image = beautiful.volume_zero_dark
        elseif tonumber(out) <= 30 then
          volumebox:get_children_by_id("image")[1].image = beautiful.volume_low_dark
        elseif tonumber(out) <= 60 then
          volumebox:get_children_by_id("image")[1].image = beautiful.volume_medium_dark
        elseif tonumber(out) <= 90 then
          volumebox:get_children_by_id("image")[1].image = beautiful.volume_high_dark
        end
      end)
    else
      box:get_children_by_id("background")[1].bg = beautiful.red
      box:get_children_by_id("depth")[1].bg = beautiful.dred
      volumebox:get_children_by_id("image")[1].image = beautiful.volume_xmark_dark
    end
	end)
	awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}'", function(stdout)
    volumebox:get_children_by_id("text")[1].markup = "<b>"..stdout.."</b>"
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
  box = createbox.createbox(volumebox, buttons, col, darkcol, left_margin, right_margin)
  return box
end

update_text()
return _M

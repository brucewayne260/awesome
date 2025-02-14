local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

local command = "playerctl metadata -f '{{title}} - {{artist}}'"
local getplayer = "playerctl -l | head -n1"

_M.playerctlbox = wibox.widget {
  widget = wibox.container.place,
  halign = "center",
  buttons = {
    awful.button {
      modifiers = {},
      button = 3,
      on_press = function()
        _M.update_text()
        _M.update_player()
      end,
    },
  },
  newwidget.newwidget(nil, nil, nil, nil, beautiful.music, nil, beautiful.squeeze * 5, beautiful.squeeze * 5)[1],
}

_M.update_text = function()
	awful.spawn.easy_async(command, function(stdout)
    _M.playerctlbox:get_children_by_id("text")[1].text = stdout
	end)
end

_M.update_player = function()
	awful.spawn.easy_async_with_shell(getplayer, function(stdout)
    if string.match(stdout, "%S+") == "mpd" then
      if _M.focus == true then
        _M.playerctlbox:get_children_by_id("image")[1].image = beautiful.music_focus
        _M.playerctlbox:get_children_by_id("squeeze")[1].top = beautiful.squeeze
        _M.playerctlbox:get_children_by_id("squeeze")[1].bottom = beautiful.squeeze
      else
        _M.playerctlbox:get_children_by_id("image")[1].image = beautiful.music
        _M.playerctlbox:get_children_by_id("squeeze")[1].top = beautiful.squeeze
        _M.playerctlbox:get_children_by_id("squeeze")[1].bottom = beautiful.squeeze
      end
      _M.player = "mpd"
    else
      if _M.focus == true then
        _M.playerctlbox:get_children_by_id("image")[1].image = beautiful.spotify_focus
        _M.playerctlbox:get_children_by_id("squeeze")[1].top = beautiful.squeeze - 3
        _M.playerctlbox:get_children_by_id("squeeze")[1].bottom = beautiful.squeeze - 3
      else
        _M.playerctlbox:get_children_by_id("image")[1].image = beautiful.spotify
        _M.playerctlbox:get_children_by_id("squeeze")[1].top = beautiful.squeeze - 3
        _M.playerctlbox:get_children_by_id("squeeze")[1].bottom = beautiful.squeeze - 3
      end
      _M.player = "spotify"
    end
	end)
end

function _M.box(col, darkcol, left_margin, right_margin)

  local buttons = awful.button {
    modifiers = {},
    button = 1,
    on_press = function()
      _M.action.play_pause()
    end,
  }

  local widget = {
    widget = wibox.container.constraint,
    width = 100,
    {
      id = "text",
      widget = wibox.widget.textbox,
    },
  }

  local new = newwidget.newwidget(col, widget, nil, nil, beautiful.pause, beautiful.pause_dark, left_margin, right_margin)
  local statusbox = wibox.widget(new[1])

  local play, pause
  if col then
    play = beautiful.play_dark
    pause = beautiful.pause_dark
  end
  _M.update_icon = function()
    awful.spawn.easy_async_with_shell(getplayer, function(stdout)
      statusbox:get_children_by_id("text")[1].markup = new[2](stdout)
    end)
    awful.spawn.easy_async("playerctl status", function(stdout)
      if string.match(stdout, "%S+") == "Playing" then
        statusbox:get_children_by_id("image")[1].image = pause or beautiful.pause
      else
        statusbox:get_children_by_id("image")[1].image = play or beautiful.play
      end
    end)
  end

  _M.action = {}
  _M.action.prev = function()
    awful.spawn.easy_async("playerctl previous", function()
      awful.spawn.easy_async_with_shell("sleep 1", function()
        _M.update_text()
        _M.update_icon()
        _M.update_player()
      end)
    end)
  end
  _M.action.next = function()
    awful.spawn.easy_async("playerctl next", function()
      awful.spawn.easy_async_with_shell("sleep 1", function()
        _M.update_text()
        _M.update_icon()
        _M.update_player()
      end)
    end)
  end
  _M.action.play_pause = function()
    awful.spawn.easy_async("playerctl play-pause", function()
      _M.update_icon()
      _M.update_player()
      awful.spawn.easy_async_with_shell("sleep 1", function()
        _M.update_text()
      end)
    end)
  end

  gears.timer {
    timeout   = 5,
    call_now  = true,
    autostart = true,
    callback  = function()
      _M.update_text()
      _M.update_icon()
      _M.update_player()
    end
  }

  return createbox.createbox(statusbox, buttons, col, darkcol)
end

return _M

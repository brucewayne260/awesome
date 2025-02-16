local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local be = require("beautiful")
local createbox = require("widgets.createbox")
local newwidget = require("widgets.newwidget")

local command = "playerctl metadata -F -f '{{title}} - {{artist}}'"
local getplayer = "playerctl metadata -F -f '{{playerName}}'"
local status = "playerctl -F status"

_M.playerctlbox = wibox.widget {
  widget = wibox.container.place,
  halign = "center",
  newwidget.newwidget({
    left = 13,
    right = 13,
  }).table,
}

function _M.box(col, darkcol, left, right)

  local play, pause
  if col then
    play = be.play_dark
    pause = be.pause_dark
  end
  local new = newwidget.newwidget({
    col = col,
    left = left,
    right = right,
    widget = {
      widget = wibox.container.constraint,
      width = 100,
      { id = "text", widget = wibox.widget.textbox },
    },
  })
  local statusbox = wibox.widget(new.table)

  _M.action = {}
  _M.action.prev = function()
    awful.spawn("playerctl previous", false)
  end
  _M.action.next = function()
    awful.spawn("playerctl next", false)
  end
  _M.action.play_pause = function()
    awful.spawn("playerctl play-pause", false)
  end

  local buttons = awful.button {
    modifiers = {},
    button = 1,
    on_press = function()
      _M.action.play_pause()
    end,
  }

  local check_player = function(stdout)
    if string.match(stdout, "%S+") == "mpd" then
      _M.playerctlbox:get_children_by_id("squeeze")[1].top = be.squeeze
      _M.playerctlbox:get_children_by_id("squeeze")[1].bottom = be.squeeze
      _M.player = "mpd"
      if _M.focus == true then
        _M.playerctlbox:get_children_by_id("image")[1].image = be.music_focus
      else
        _M.playerctlbox:get_children_by_id("image")[1].image = be.music
      end
    else
      _M.playerctlbox:get_children_by_id("squeeze")[1].top = be.squeeze - 3
      _M.playerctlbox:get_children_by_id("squeeze")[1].bottom = be.squeeze - 3
      _M.player = "spotify"
      if _M.focus == true then
        _M.playerctlbox:get_children_by_id("image")[1].image = be.spotify_focus
      else
        _M.playerctlbox:get_children_by_id("image")[1].image = be.spotify
      end
    end
  end

  _M.update_icon = function()
    awful.spawn.easy_async_with_shell("playerctl metadata -f '{{playerName}}'", function(stdout)
      check_player(stdout)
    end)
  end

  awful.spawn.easy_async_with_shell("pkill playerctl", function()
    awful.spawn.with_line_callback(command, {
      stdout = function(line)
        _M.playerctlbox:get_children_by_id("text")[1].text = line
      end
    })
    awful.spawn.with_line_callback(getplayer, {
      stdout = function(line)
        statusbox:get_children_by_id("text")[1].markup = new.bold(line)
        check_player(line)
      end
    })
    awful.spawn.with_line_callback(status, {
      stdout = function(line)
        if string.match(line, "%S+") == "Playing" then
          statusbox:get_children_by_id("image")[1].image = pause or be.pause
        else
          statusbox:get_children_by_id("image")[1].image = play or be.play
        end
      end
    })
  end)

  return createbox.createbox(statusbox, buttons, col, darkcol)
end

return _M

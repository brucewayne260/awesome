local _M = {}

local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local be = require("beautiful")
local createbox = require("widgets.createbox")
local awesome = awesome
local apps = require'config.apps'

local awesomemenu = {
  {'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
  {'manual', apps.manual_cmd},
  {'edit config', apps.editor_cmd .. ' ' .. awesome.conffile},
  {'restart', awesome.restart},
  {'quit', function() awesome.quit() end},
}

local screenshot = {
  {'Crop a region', apps.screencrop },
  {'Entire screen', apps.screenshot },
}

_M.mainmenu = awful.menu{
  items = {
    { "open terminal", apps.terminal },
    { "file manager", apps.file_manager },
    { "web browser", apps.browser },
    { "awesome", awesomemenu },
    { "screenshot", screenshot },
  }
}

local launcher = awful.widget.launcher{
  image = be.awesome_icon,
  menu = _M.mainmenu,
}

function _M.box(col, darkcol)
  return createbox.createbox(launcher, nil, col, darkcol, 5)
end

return _M

local _M = {}

local awful = require("awful")
local wibox = require("wibox")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")

local apps = require'config.apps'

local awesomemenu = {
  {'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
  {'manual', apps.manual_cmd},
  {'edit config', apps.editor_cmd .. ' ' .. awesome.conffile},
  {'restart', awesome.restart},
  {'quit', function() awesome.quit() end},
}

local screenshot = {
  {'Crop a region', apps.screencrop},
  {'Entire screen', apps.screenshot},
}

_M.mainmenu = awful.menu{
  items = {
    { "awesome", awesomemenu, beautiful.awesome_icon },
    { "open terminal", apps.terminal, beautiful.terminal },
    { "file manager", apps.file_manager, beautiful.filemanager },
    { "web browser", apps.browser, beautiful.webbrowser },
    { "screenshot", screenshot, beautiful.display },
  }
}

local launcher = awful.widget.launcher{
  image = beautiful.awesome_icon,
  menu = _M.mainmenu,
}

_M.menubox = launcher

return _M

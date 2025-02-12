-- awesome_mode: api-level=4:screen=on

-- load luarocks if installed
pcall(require, 'luarocks.loader')

-- load theme
local beautiful = require'beautiful'
local gears = require'gears'
beautiful.init(os.getenv("HOME") .. "/.config/awesome/default/theme.lua")

-- load key and mouse bindings
require'bindings'

-- load rules
require'rules'

-- load signals
require'signals'

-- Run garbage collector regularly to prevent memory leaks
gears.timer {
       timeout = 60,
       autostart = true,
       callback = function() collectgarbage() end
}

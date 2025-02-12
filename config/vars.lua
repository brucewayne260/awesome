local _M = {}

local awful = require'awful'

_M.layouts = {
   awful.layout.suit.tile,
   awful.layout.suit.floating,
   awful.layout.suit.fair,
   awful.layout.suit.spiral,
   awful.layout.suit.max,
}

_M.tags = {' 1 ', ' 2 ', ' 3 ', ' 4 ', ' 5 ', ' 6 '}

return _M

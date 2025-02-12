local awful = require'awful'
local menubox = require'widgets.modules.menubox'

awful.mouse.append_global_mousebindings{
   awful.button{
      modifiers = {},
      button    = 1,
      on_press  = function() menubox.mainmenu:hide() end
   },
   awful.button{
      modifiers = {},
      button    = 3,
      on_press  = function() menubox.mainmenu:show() end
   },
   awful.button{
      modifiers = {},
      button    = 4,
      on_press  = awful.tag.viewprev
   },
   awful.button{
      modifiers = {},
      button    = 5,
      on_press  = awful.tag.viewnext
   },
}

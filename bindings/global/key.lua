local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
require'awful.hotkeys_popup.keys'
local menubar = require'menubar'

local apps = require'config.apps'
local mod = require'bindings.mod'
local menubox = require'widgets.modules.menubox'
local playerctlbox = require'widgets.modules.playerctlbox'
local volumebox = require'widgets.modules.volumebox'
local middlebox = require'widgets.modules.middlebox'
local client = client
local mouse = mouse
local awesome = awesome

menubar.utils.terminal = apps.terminal

-- general awesome keys
awful.keyboard.append_global_keybindings{
  awful.key{
    modifiers   = {mod.super},
    key         = 'b',
    description = 'Hide wibar',
    group       = 'User-defined',
    on_press    = function() mouse.screen.wibar.visible = not mouse.screen.wibar.visible end,
  },
  awful.key{
    modifiers   = {mod.alt, mod.shift},
    key         = 'm',
    description = 'toggle middlebox',
    group       = 'User-defined',
    on_press    = function()
      middlebox.toggle_box()
    end,
  },
  awful.key{
    modifiers   = {mod.alt},
    key         = 'm',
    description = 'mute volume',
    group       = 'User-defined',
    on_press    = function()
      volumebox.vol.mute()
    end,
  },
  awful.key{
    modifiers   = {mod.alt},
    key         = 'a',
    description = 'decrease volume',
    group       = 'User-defined',
    on_press    = function()
      volumebox.vol.dec()
    end,
  },
  awful.key{
    modifiers   = {mod.alt},
    key         = 'd',
    description = 'increase volume',
    group       = 'User-defined',
    on_press    = function()
      volumebox.vol.inc()
    end,
  },
  awful.key{
    modifiers   = {mod.alt, mod.shift},
    key         = '.',
    description = 'next track',
    group       = 'User-defined',
    on_press    = function()
      playerctlbox.action.next()
    end,
  },
  awful.key{
    modifiers   = {mod.alt, mod.shift},
    key         = ',',
    description = 'previous track',
    group       = 'User-defined',
    on_press    = function()
      playerctlbox.action.prev()
    end,
  },
  awful.key{
    modifiers   = {mod.alt},
    key         = 'p',
    description = 'play/pause music',
    group       = 'User-defined',
    on_press    = function()
      playerctlbox.action.play_pause()
    end,
  },
  awful.key{
    modifiers   = {mod.alt},
    key         = 's',
    description = 'screenshot',
    group       = 'User-defined',
    on_press    = function() awful.spawn.with_shell(apps.screenshot) end,
  },
  awful.key{
    modifiers   = {mod.alt, mod.shift},
    key         = 's',
    description = 'screencrop',
    group       = 'User-defined',
    on_press    = function() awful.spawn.with_shell(apps.screencrop) end,
  },
  awful.key{
    modifiers   = {mod.super},
    key         = 'space',
    description = 'terminal',
    group       = 'User-defined',
    on_press    = function() awful.spawn(apps.terminal) end,
  },
  awful.key{
    modifiers   = {mod.super},
    key         = 's',
    description = 'show help',
    group       = 'awesome',
    on_press    = hotkeys_popup.show_help,
  },
  awful.key{
    modifiers   = {mod.super},
    key         = 'w',
    description = 'show main menu',
    group       = 'awesome',
    on_press    = function() menubox.mainmenu:show() end,
  },
  awful.key{
    modifiers   = {mod.super, mod.ctrl},
    key         = 'r',
    description = 'reload awesome',
    group       = 'awesome',
    on_press    = awesome.restart,
  },
  awful.key{
    modifiers   = {mod.super, mod.shift},
    key         = 'q',
    description = 'quit awesome',
    group       = 'awesome',
    on_press    = awesome.quit,
  },
  awful.key{
    modifiers   = {mod.super},
    key         = 'Return',
    description = 'open a terminal',
    group       = 'launcher',
    on_press    = function() awful.spawn(apps.terminal) end,
  },
  awful.key{
    modifiers   = {mod.super},
    key         = 'p',
    description = 'show the menubar',
    group       = 'launcher',
    on_press    = function() menubar.show() end,
  },
}

-- tags related keybindings
awful.keyboard.append_global_keybindings{
  awful.key{
    modifiers   = {mod.super},
    key         = 'Left',
    description = 'view previous',
    group       = 'tag',
    on_press    = awful.tag.viewprev,
  },
  awful.key{
    modifiers   = {mod.super},
    key         = 'Right',
    description = 'view next',
    group       = 'tag',
    on_press    = awful.tag.viewnext,
  },
  awful.key{
    modifiers   = {mod.super},
    key         = 'Escape',
    description = 'go back',
    group       = 'tag',
    on_press    = awful.tag.history.restore,
  },
}

-- focus related keybindings
awful.keyboard.append_global_keybindings{
  awful.key{
    modifiers   = {mod.super},
    key         = 'j',
    description = 'focus next by index',
    group       = 'client',
    on_press    = function() awful.client.focus.byidx(1) end,
  },
  awful.key{
    modifiers   = {mod.super},
    key         = 'k',
    description = 'focus previous by index',
    group       = 'client',
    on_press    = function() awful.client.focus.byidx(-1) end,
  },
  awful.key{
    modifiers   = {mod.super},
    key         = 'Tab',
    description = 'go back',
    group       = 'client',
    on_press    = function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
  },
  awful.key{
    modifiers   = {mod.super, mod.ctrl},
    key         = 'j',
    description = 'focus the next screen',
    group       = 'screen',
    on_press    = function() awful.screen.focus_relative(1) end,
  },
  awful.key{
    modifiers   = {mod.super, mod.ctrl},
    key         = 'k',
    description = 'focus the previous screen',
    group       = 'screen',
    on_press    = function() awful.screen.focus_relative(-1) end,
  },
  awful.key{
    modifiers   = {mod.super, mod.ctrl},
    key         = 'n',
    description = 'restore minimized',
    group       = 'client',
    on_press    = function()
      local c = awful.client.restore()
      if c then
        c:activate{raise = true, context = 'key.unminimize'}
      end
    end,
  },
}

-- layout related keybindings
awful.keyboard.append_global_keybindings{
  awful.key{
     modifiers   = {mod.super, mod.shift},
     key         = 'j',
     description = 'swap with next client by index',
     group       = 'client',
     on_press    = function() awful.client.swap.byidx(1) end,
  },
  awful.key{
     modifiers   = {mod.super, mod.shift},
     key         = 'k',
     description = 'swap with previous client by index',
     group       = 'client',
     on_press    = function() awful.client.swap.byidx(-1) end,
  },
  awful.key{
     modifiers   = {mod.super},
     key         = 'u',
     description = 'jump to urgent client',
     group       = 'client',
     on_press    = awful.client.urgent.jumpto,
  },
  awful.key{
     modifiers   = {mod.super},
     key         = 'l',
     description = 'increase master width factor',
     group       = 'layout',
     on_press    = function() awful.tag.incmwfact(0.05) end,
  },
  awful.key{
     modifiers   = {mod.super},
     key         = 'h',
     description = 'decrease master width factor',
     group       = 'layout',
     on_press    = function() awful.tag.incmwfact(-0.05) end,
  },
  awful.key{
     modifiers   = {mod.super, mod.shift},
     key         = 'h',
     description = 'increase the number of master clients',
     group       = 'layout',
     on_press    = function() awful.tag.incnmaster(1, nil, true) end,
  },
  awful.key{
     modifiers   = {mod.super, mod.shift},
     key         = 'l',
     description = 'decrease the number of master clients',
     group       = 'layout',
     on_press    = function() awful.tag.incnmaster(-1, nil, true) end,
  },
  awful.key{
     modifiers   = {mod.super, mod.ctrl},
     key         = 'h',
     description = 'increase the number of columns',
     group       = 'layout',
     on_press    = function() awful.tag.incncol(1, nil, true) end,
  },
  awful.key{
     modifiers   = {mod.super, mod.ctrl},
     key         = 'l',
     description = 'decrease the number of columns',
     group       = 'layout',
     on_press    = function() awful.tag.incncol(-1, nil, true) end,
  },
  awful.key{
     modifiers   = {mod.alt},
     key         = 'space',
     description = 'select next',
     group       = 'layout',
     on_press    = function() awful.layout.inc(1) end,
  },
  awful.key{
     modifiers   = {mod.alt, mod.shift},
     key         = 'space',
     description = 'select previous',
     group       = 'layout',
     on_press    = function() awful.layout.inc(-1) end,
  },
}

awful.keyboard.append_global_keybindings{
  awful.key{
     modifiers   = {mod.super},
     keygroup    = 'numrow',
     description = 'only view tag',
     group       = 'tag',
     on_press    = function(index)
        local screen = awful.screen.focused()
        local tag = screen.tags[index]
        if tag then
           tag:view_only()
        end
     end
  },
  awful.key{
     modifiers   = {mod.super, mod.ctrl},
     keygroup    = 'numrow',
     description = 'toggle tag',
     group       = 'tag',
     on_press    = function(index)
        local screen = awful.screen.focused()
        local tag = screen.tags[index]
        if tag then
           awful.tag.viewtoggle(tag)
        end
     end
  },
  awful.key{
     modifiers   = {mod.super, mod.shift},
     keygroup    = 'numrow',
     description = 'move focused client to tag',
     group       = 'tag',
     on_press    = function(index)
        if client.focus then
           local tag = client.focus.screen.tags[index]
           if tag then
              client.focus:move_to_tag(tag)
           end
        end
     end
  },
  awful.key {
     modifiers   = {mod.super, mod.ctrl, mod.shift},
     keygroup    = 'numrow',
     description = 'toggle focused client on tag',
     group       = 'tag',
     on_press    = function(index)
        if client.focus then
           local tag = client.focus.screen.tags[index]
           if tag then
              client.focus:toggle_tag(tag)
           end
        end
     end,
  },
  awful.key{
     modifiers   = {mod.super},
     keygroup    = 'numpad',
     description = 'select layout directly',
     group       = 'layout',
     on_press    = function(index)
        local tag = awful.screen.focused().selected_tag
        if tag then
           tag.layout = tag.layouts[index] or tag.layout
        end
     end
  },
}

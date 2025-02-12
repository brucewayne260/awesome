local _M = {}

local awful = require'awful'
local wibox = require'wibox'
local be = require'beautiful'
local createbox = require'widgets.createbox'

local mem       = require'widgets.modules.membox'
local misc      = require'widgets.modules.miscbox'
local menu      = require'widgets.modules.menubox'
local cpu       = require'widgets.modules.cpubox'
local taglist   = require'widgets.modules.taglistbox'
local layout    = require'widgets.modules.layoutbox'
local clock     = require'widgets.modules.clockbox'
local playerctl = require'widgets.modules.playerctlbox'
local middle    = require'widgets.modules.middlebox'
local volume    = require'widgets.modules.volumebox'
local wifi      = require'widgets.modules.wifibox'

-- Widgets, colors, buttons, margins
local menubox   = createbox.createbox(menu.menubox, nil, nil, nil)
local wifibox   = createbox.createbox(wifi.wifibox, nil, nil, nil, be.squeeze)
local statusbox = createbox.createbox(playerctl.statusbox, be.green, be.dgreen, playerctl.sbuttons, be.squeeze, be.squeeze)
local middlebox = createbox.createbox(middle.middlebox, nil, nil, middle.buttons, be.squeeze * 5, be.squeeze * 5)
local volumebox = createbox.createbox(volume.volumebox, be.blue, be.dblue, volume.buttons, be.squeeze, be.squeeze)
local cpubox    = createbox.createbox(cpu.cpubox, nil, nil, nil, be.squeeze, be.squeeze)
local membox    = createbox.createbox(mem.membox, be.red, be.dred, nil, be.squeeze, be.squeeze)
local miscbox   = createbox.createbox(misc.miscbox, nil, nil, nil, be.squeeze)
local clockbox  = createbox.createbox(clock.clockbox, be.yellow, be.dyellow, nil, be.squeeze, be.squeeze)
local layoutbox = createbox.createbox(layout.layoutbox, nil, nil, layout.buttons, be.squeeze / 2, be.squeeze / 2)

function _M.create_wibar(s)
  return awful.wibar{
    screen = s,
    position = "top",
    height = 40,
    bg = "#00000000",
    widget = {
      widget = wibox.container.margin,
      top = 5,
      left = 5,
      right = 5,
      {
        layout = wibox.layout.align.horizontal,
        -- left widgets
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = 5,
          menubox,
          taglist.taglistbox,
          wifibox,
          statusbox,
        },
        -- middle widgets
        {
          widget = wibox.container.place,
          halign = "center",
          {
            widget = wibox.container.constraint,
            width = 600,
            middlebox,
          },
        },
        -- right widgets
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = 5,
          volumebox,
          cpubox,
          membox,
          miscbox,
          clockbox,
          layoutbox,
        }
      }
    }
  }
end

return _M

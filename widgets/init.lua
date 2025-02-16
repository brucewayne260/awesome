local _M = {}

local awful = require'awful'
local wibox = require'wibox'
local be = require'beautiful'

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
local menubox   = menu.box()
local tagbox    = taglist.box(be.blue, be.dblue)
local wifibox   = wifi.box(be.orange, be.dorange, 8, 0)
local statusbox = playerctl.box(be.green, be.dgreen)
local middlebox = middle.box()
local volumebox = volume.box(be.green, be.dgreen)
local cpubox    = cpu.box()
local membox    = mem.box(be.yellow, be.dyellow)
local miscbox   = misc.box()
local clockbox  = clock.box(be.blue, be.dblue)
local layoutbox = layout.box()

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
          tagbox,
          wifibox,
          statusbox,
          {
            widget = wibox.widget.separator,
            forced_width = 1,
            thickness = 0,
          },
        },
        -- middle widgets
        {
          widget = wibox.container.place,
          content_fill_vertical = true,
          halign = "center",
          middlebox,
        },
        -- right widgets
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = 5,
          {
            widget = wibox.widget.separator,
            forced_width = 1,
            thickness = 0,
          },
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

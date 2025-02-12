local awful = require'awful'
require'awful.autofocus'
local wibox = require'wibox'

client.connect_signal('mouse::enter', function(c)
  c:activate{context = 'mouse_enter', raise = false}
end)

client.connect_signal('request::titlebars', function(c)
  -- buttons for the titlebar
  local buttons = {
    awful.button{
      modifiers = {},
      button    = 1,
      on_press  = function()
        c:activate{context = 'titlebar', action = 'mouse_move'}
      end
    },
    awful.button{
      modifiers = {},
      button    = 3,
      on_press  = function()
        c:activate{context = 'titlebar', action = 'mouse_resize'}
      end
    },
  }

  awful.titlebar(c).widget = {
    -- left
    {
      -- {
      --   layout = wibox.container.margin,
      --   margins = 2,
      --   awful.titlebar.widget.iconwidget(c),
      -- },
      -- buttons = buttons,
      layout  = wibox.layout.fixed.horizontal,
    },
    -- middle
    {
      -- title
      {
        align = 'center',
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal,
    },
    -- right
    {
      -- {
      --   layout = wibox.container.margin,
      --   margins = 2,
      --   awful.titlebar.widget.floatingbutton(c),
      -- },
      -- {
      --   layout = wibox.container.margin,
      --   margins = 2,
      --   awful.titlebar.widget.maximizedbutton(c),
      -- },
      -- {
      --   layout = wibox.container.margin,
      --   margins = 2,
      --   awful.titlebar.widget.stickybutton(c),
      -- },
      -- {
      --   layout = wibox.container.margin,
      --   margins = 2,
      --   awful.titlebar.widget.ontopbutton(c),
      -- },
      -- {
      --   layout = wibox.container.margin,
      --   margins = 2,
      --   awful.titlebar.widget.closebutton(c),
      -- },
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal,
  }
end)

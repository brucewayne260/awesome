local awful = require'awful'
local ruled = require'ruled'
local gears = require'gears'

ruled.client.connect_signal('request::rules', function()
  -- All clients will match this rule.
  ruled.client.append_rule{
    id         = 'global',
    rule       = {},
    properties = {
      shape     = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 5) end,
      focus     = awful.client.focus.filter,
      raise     = true,
      screen    = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
  }

  -- Floating clients.
  ruled.client.append_rule{
    id = 'floating',
    rule_any = {
      instance = {'copyq', 'pinentry'},
      class = {
        'Arandr',
        'Gpick',
      },
      name = {
        'Event Tester',  -- xev.
      },
    },
    properties = {floating = true}
  }

  -- Add titlebars to normal clients and dialogs
  ruled.client.append_rule{
    id         = 'titlebars',
    rule_any   = {type = {'normal', 'dialog'}},
    properties = {titlebars_enabled = true},
  }

  ruled.client.append_rule {
    rule       = {class = 'Zathura'},
    properties = {
      floating = true,
      maximized_vertical   = true,
      maximized_horizontal = true,
    }
  }

  ruled.client.append_rule {
    rule       = {class = 'mpv'},
    properties = {
      floating  = true,
      placement = awful.placement.no_offscreen,
      width     = 800,
      height    = 600,
    }
  }

end)

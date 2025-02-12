local _M = {}
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local client = client
local screen = screen

local mod = require'bindings.mod'

beautiful.taglist_bg_empty = beautiful.background
beautiful.taglist_bg_occupied = beautiful.dblack
beautiful.taglist_bg_focus = beautiful.black
beautiful.taglist_shape = gears.shape.rounded_rect
beautiful.taglist_spacing = 5

local is_empty = function(tag)
  local count = 0
  for _ in pairs(tag:clients()) do
    count = count + 1
  end
  if count > 0 then
    return false
  end
  return true
end

local setcolor = function(self, t)
  if t.selected then
    self:get_children_by_id("depth")[1].bg = beautiful.dblack
    self:get_children_by_id("background_role")[1].fg = beautiful.background
  elseif not is_empty(t) then
    self:get_children_by_id("depth")[1].bg = beautiful.background
    self:get_children_by_id("background_role")[1].fg = beautiful.background
  else
    self:get_children_by_id("depth")[1].bg = beautiful.background
    self:get_children_by_id("background_role")[1].fg = beautiful.black
  end
end

local pressed = function(self, t)
  self:connect_signal("button::press", function()
    self:get_children_by_id("margin")[1].top = 5
    self:get_children_by_id("margin")[1].bottom = 0

    self:connect_signal("button::release", function()
      self:get_children_by_id("margin")[1].top = 0
      self:get_children_by_id("margin")[1].bottom = 5
      setcolor(self, t)
    end)

    self:connect_signal("mouse::leave", function()
      self:get_children_by_id("margin")[1].top = 0
      self:get_children_by_id("margin")[1].bottom = 5
      setcolor(self, t)
    end)
  end)
end

local function create_taglist(s)
  return awful.widget.taglist{
    screen = s,
    filter = awful.widget.taglist.filter.all,
    widget_template = {
      layout = wibox.layout.stack,
      {
        widget = wibox.container.margin,
        bottom = 0,
        top = 10,
        {
          id = "depth",
          widget = wibox.container.background,
          shape = gears.shape.rounded_rect,
        },
      },
      {
        id = "margin",
        widget = wibox.container.margin,
        bottom = 5,
        top = 0,
        {
          id = "background_role",
          widget = wibox.container.background,
          {
            widget  = wibox.container.margin,
            left = 4,
            right = 4,
            {
              id     = "index_role",
              widget = wibox.widget.textbox,
            },
          },
        },
      },
      create_callback = function(self, t)
        self:get_children_by_id("index_role")[1].markup = "<b> "..t.index.." </b>"
        setcolor(self, t)
        pressed(self, t)
      end,
      update_callback = function(self, t)
        self:get_children_by_id("index_role")[1].markup = "<b> "..t.index.." </b>"
        setcolor(self, t)
        pressed(self, t)
      end,
    },
    buttons = {
      awful.button{
        modifiers = {},
        button    = 1,
        on_press  = function(t) t:view_only() end,
      },
      awful.button{
        modifiers = {mod.super},
        button    = 1,
        on_press  = function(t)
          if client.focus then
            client.focus:move_to_tag(t)
          end
        end,
      },
      awful.button{
        modifiers = {},
        button    = 3,
        on_press  = awful.tag.viewtoggle,
      },
      awful.button{
        modifiers = {mod.super},
        button    = 3,
        on_press  = function(t)
          if client.focus then
            client.focus:toggle_tag(t)
          end
        end
      },
      awful.button{
        modifiers = {},
        button    = 4,
        on_press  = function(t) awful.tag.viewprev(t.screen) end,
      },
      awful.button{
        modifiers = {},
        button    = 5,
        on_press  = function(t) awful.tag.viewnext(t.screen) end,
      },
    },
  }
end

screen.connect_signal('request::desktop_decoration', function(s)

	s.taglist = create_taglist(s)
  _M.taglistbox = s.taglist

end)

return _M

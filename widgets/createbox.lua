local _M = {}

local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local be = require("beautiful")

-- borders
be.taglist_shape_border_width = 1
be.taglist_shape_border_color = be.fg_normal
be.taglist_shape_border_width_empty = 0
be.taglist_shape_border_width_focus = 0
-- background
be.taglist_bg_empty = be.background
be.taglist_bg_occupied = be.background
-- shape and spacing
be.taglist_spacing = 5

local shape = function(radius)
  return function(cr, width, height) gears.shape.rounded_rect(cr, width, height, radius) end
end

function _M.createtagbox(col, darkcol, radius)
  be.taglist_bg_focus = col or be.foreground
  be.taglist_shape = shape(radius)

  local setcolor = function(self, t)
    if awful.widget.taglist.filter.selected(t) then
      self:get_children_by_id("index_role")[1].markup = "<b> "..t.index.." </b>"
      self:get_children_by_id("depth")[1].border_width = 0
      self:get_children_by_id("depth")[1].bg = darkcol or be.dblack
      self:get_children_by_id("background_role")[1].fg = be.background
    elseif awful.widget.taglist.filter.noempty(t) then
      self:get_children_by_id("index_role")[1].markup = " "..t.index.." "
      self:get_children_by_id("depth")[1].border_width = 1
      self:get_children_by_id("depth")[1].bg = be.background
      self:get_children_by_id("background_role")[1].fg = be.foreground
    else
      self:get_children_by_id("index_role")[1].markup = " "..t.index.." "
      self:get_children_by_id("depth")[1].border_width = 0
      self:get_children_by_id("depth")[1].bg = be.background
      self:get_children_by_id("background_role")[1].fg = be.foreground
    end
  end

  local pressed = function(self)
    self:connect_signal("button::press", function()
      self:get_children_by_id("margin")[1].top = 5
      self:get_children_by_id("margin")[1].bottom = 0

      self:connect_signal("button::release", function()
        self:get_children_by_id("margin")[1].top = 0
        self:get_children_by_id("margin")[1].bottom = 5
      end)

      self:connect_signal("mouse::leave", function()
        self:get_children_by_id("margin")[1].top = 0
        self:get_children_by_id("margin")[1].bottom = 5
      end)
    end)
  end

  return {
    layout = wibox.layout.stack,
    {
      widget = wibox.container.margin,
      bottom = 0,
      top = 5,
      {
        widget = wibox.container.background,
        border_color = "#000000",
        shape = shape(radius),
      },
    },
    {
      widget = wibox.container.margin,
      bottom = 0,
      top = 5,
      {
        id = "depth",
        widget = wibox.container.background,
        border_width = 1,
        border_color = be.fg_normal,
        shape = shape(radius),
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
          margins = 4,
          widget  = wibox.container.margin,
          {
            id     = "index_role",
            widget = wibox.widget.textbox,
          },
        },
      },
    },
    create_callback = function(self, t)
      setcolor(self, t)
      pressed(self)
    end,
    update_callback = function(self, t)
      setcolor(self, t)
      pressed(self)
    end,
  }
end

function _M.createbox(widget, buttons, col, darkcol, radius)
  local border
  if darkcol then
    border = 0
  end
  local box = wibox.widget {
    widget = wibox.container.background,
    shape = shape(radius),
    buttons = buttons,
    {
      layout = wibox.layout.stack,
      {
        widget = wibox.container.margin,
        bottom = 0,
        top = 5,
        {
          widget = wibox.container.background,
          bg = "#000000",
          shape = shape(radius),
        },
      },
      {
        widget = wibox.container.margin,
        bottom = 0,
        top = 5,
        {
          id = "depth",
          widget = wibox.container.background,
          bg = darkcol or be.bg_normal,
          border_width = border or 1,
          border_color = be.fg_normal,
          shape = shape(radius),
        },
      },
      {
        id = "margin",
        widget = wibox.container.margin,
        bottom = 5,
        top = 0,
        {
          id = "background",
          widget = wibox.container.background,
          bg = col or be.bg_normal,
          border_width = border or 1,
          border_color = be.fg_normal,
          shape = shape(radius),
          widget,
        },
      },
    },
  }
  box:connect_signal("button::press", function()
    box:get_children_by_id("margin")[1].top = 5
    box:get_children_by_id("margin")[1].bottom = 0
    box.border_width = 0
    box:connect_signal("button::release", function()
      box:get_children_by_id("margin")[1].top = 0
      box:get_children_by_id("margin")[1].bottom = 5
      box.border_width = border or 1
    end)
    box:connect_signal("mouse::leave", function()
      box:get_children_by_id("margin")[1].top = 0
      box:get_children_by_id("margin")[1].bottom = 5
      box.border_width = border or 1
    end)
  end)
  return box
end

return _M

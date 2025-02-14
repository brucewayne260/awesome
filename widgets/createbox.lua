local _M = {}

local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

function _M.createtagbox(darkcol)
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
      self:get_children_by_id("index_role")[1].markup = "<b> "..t.index.." </b>"
      self:get_children_by_id("depth")[1].border_width = 0
      self:get_children_by_id("depth")[1].bg = darkcol or beautiful.dblack
      self:get_children_by_id("background_role")[1].fg = beautiful.background
    elseif not is_empty(t) then
      self:get_children_by_id("index_role")[1].markup = " "..t.index.." "
      self:get_children_by_id("depth")[1].border_width = 1
      self:get_children_by_id("depth")[1].bg = beautiful.background
      self:get_children_by_id("background_role")[1].fg = beautiful.foreground
    else
      self:get_children_by_id("index_role")[1].markup = " "..t.index.." "
      self:get_children_by_id("depth")[1].border_width = 0
      self:get_children_by_id("depth")[1].bg = beautiful.background
      self:get_children_by_id("background_role")[1].fg = beautiful.foreground
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

  return {
    layout = wibox.layout.stack,
    {
      widget = wibox.container.margin,
      bottom = 0,
      top = 5,
      {
        widget = wibox.container.background,
        border_color = "#000000",
        shape = gears.shape.rounded_rect,
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
        border_color = beautiful.fg_normal,
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
      pressed(self, t)
    end,
    update_callback = function(self, t)
      setcolor(self, t)
      pressed(self, t)
    end,
  }
end

function _M.createbox(content, buttons, col, darkcol)
  local border
  if darkcol then
    border = 0
  end
  local box = wibox.widget {
    widget = wibox.container.background,
    shape = gears.shape.rounded_rect,
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
          shape = gears.shape.rounded_rect,
        },
      },
      {
        widget = wibox.container.margin,
        bottom = 0,
        top = 5,
        {
          id = "depth",
          widget = wibox.container.background,
          bg = darkcol or beautiful.bg_normal,
          border_width = border or 1,
          border_color = beautiful.fg_normal,
          shape = gears.shape.rounded_rect,
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
          bg = col or beautiful.bg_normal,
          border_width = border or 1,
          border_color = beautiful.fg_normal,
          shape = gears.shape.rounded_rect,
          content,
        },
      },
    },
  }
  box:connect_signal("button::press", function()
    box:get_children_by_id("margin")[1].top = 5
    box:get_children_by_id("margin")[1].bottom = 0
    box.border_width = 0
  end)
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
  return box
end

return _M

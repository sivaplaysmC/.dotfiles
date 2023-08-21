-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")


-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local vicious = require("vicious")

local color_tools = require("color_tools")


local M = {}


local function add_margins(base_widget, margins)
  if type(margins) == "number" then
    return wibox.widget {
      base_widget,
      widget = wibox.container.margin,
      margins = margins
    }
  elseif type(margins) == "table" then
    return wibox.widget {
      base_widget,
      widget = wibox.container.margin,
      left = margins.left,
      right = margins.right,
      top = margins.top,
      bottom = margins.bottom,
    }
  end
end


local function add_background(base_widget, bg_, shape_)
  return wibox.widget {
    base_widget, widget = wibox.container.background, shape = shape_, bg = bg_,
  }
end

local function combine_widgets(widgets, layout)
  local new_widget = wibox.widget {
    widgets[1], widgets[2], widgets[3], layout = layout or wibox.layout.horizontal
  }

  return new_widget
end



M.get_vicious_pretty_wifi = function(bg)
  local bgcolor = bg or "#A3BE8C"
  local icon
  local vicious_interface = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span font='Iosevka Nerd Font 10' foreground='#2e3440'>$1 ($2MiB/$3MiB)</span>",
    ellipsize = "end",
    halign = "center",
    valign = "center",
  };
  icon = beautiful.wifi_icon
  vicious.register(vicious_interface, vicious.widgets.wifiiw,
    "<span font='JetBrains Mono 10' foreground='#2e3440'><b>${ssid}</b></span>", 1, "wlp0s26u1u4")
  return wibox.widget
      {
        {
          {
            {
              {
                {
                  widget = wibox.widget.imagebox,
                  image = icon,
                  resize = true

                },
                widget = wibox.container.margin,
                top = 5,
                bottom = 5,
                left = 5,
                right = 5,


              },

              {
                {
                  {
                    vicious_interface,
                    widget = wibox.container.margin,
                    margins = 5,
                  },
                  widget = wibox.container.constraint,
                  width = 120,
                },
                widget = wibox.container.background,
                bg = color_tools.lighten(bgcolor, 20),
              },
              layout = wibox.layout.align.horizontal
            },
            widget = wibox.container.background,
            bg = bgcolor,
          },
          widget = wibox.container.margin,
          margins = 5,
          left = 0,
          right = 0,
        },
        {
          {
            {
              {
                {
                  widget = wibox.widget.imagebox,
                  image = icon,
                  resize = true

                },
                widget = wibox.container.margin,
                top = 5,
                bottom = 5,
                left = 5,
                right = 5,


              },

              {
                {
                  {
                    vicious_interface,
                    widget = wibox.container.margin,
                    margins = 5,
                  },
                  widget = wibox.container.constraint,
                  width = 120,
                },
                widget = wibox.container.background,
                bg = color_tools.lighten(bgcolor, 20),
              },
              layout = wibox.layout.align.horizontal
            },
            widget = wibox.container.background,
            bg = bgcolor,
          },
          widget = wibox.container.margin,
          margins = 5,
          left = 0,
          right = 0,
        },
        layout = wibox.layout.fixed.vertical,
      }

  -- widget = wibox.container.background,
  -- width = 10 ,
  -- height = 20,
  -- shape = gears.shape.powerline,
  -- bg = bgcolor
end


M.get_vicious_pretty_net = function(bg)
  local bgcolor = bg or "#A3BE8C"
  local icon
  local vicious_interface = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span font='Iosevka Nerd Font 14' foreground='#2e3440'>$1 ($2MiB/$3MiB)</span>",
    halign = "center",
    valign = "center",
  };
  icon = beautiful.down_icon
  vicious.register(vicious_interface, vicious.widgets.net,
    "<span font='JetBrains Mono 10' foreground='#2e3440'><b>${wlp0s26u1u4 rx_mb}</b></span>", 1)
  return wibox.widget {
    {
      {
        {
          {
            widget = wibox.widget.imagebox,
            image = icon,
            resize = true

          },
          widget = wibox.container.margin,
          top = 5,
          bottom = 5,
          left = 5,
          right = 5,


        },

        {
          {
            vicious_interface,
            widget = wibox.container.margin,
            margins = 5,
          },
          widget = wibox.container.background,
          bg = color_tools.lighten(bgcolor, 20),
        },
        layout = wibox.layout.align.horizontal
      },
      widget = wibox.container.background,
      bg = bgcolor,
    },
    widget = wibox.container.margin,
    margins = 5,
    left = 0,
    right = 0,
  }
end



M.get_vicious_pretty_mem = function(bg)
  local bgcolor = bg or "#A3BE8C"
  local icon
  local vicious_interface = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span font='Iosevka Nerd Font 10' foreground='#2e3440'>$1 ($2MiB/$3MiB)</span>",
    halign = "center",
    valign = "center",
  };
  icon = beautiful.mem_icon
  vicious.register(vicious_interface, vicious.widgets.mem,
    "<span font='JetBrains Mono 10' foreground='#2e3440'>$1%</span>", 1)
  return wibox.widget {
    {
      {
        {
          {
            widget = wibox.widget.imagebox,
            image = icon,
            resize = true

          },
          widget = wibox.container.margin,
          top = 5,
          bottom = 5,
          left = 5,
          right = 5,


        },

        {
          {
            vicious_interface,
            widget = wibox.container.margin,
            margins = 5,
          },
          widget = wibox.container.background,
          bg = color_tools.lighten(bgcolor, 20),
        },
        layout = wibox.layout.align.horizontal
      },
      widget = wibox.container.background,
      bg = bgcolor,
    },
    widget = wibox.container.margin,
    margins = 5,
    left = 0,
    right = 0,
  }
end



M.get_vicious_pretty_cpu = function(bg)
  local bgcolor = bg or "#A3BE8C"
  local icon
  local vicious_interface = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span font='Iosevka Nerd Font 10' foreground='#2e3440'>$1</span>",
    halign = "center",
    valign = "center",
  };
  icon = beautiful.cpu_icon
  vicious.register(vicious_interface, vicious.widgets.cpu,
    "<span font='JetBrains Mono 10' foreground='#2e3440'>$1%</span>", 1)
  local out = wibox.widget {

    {
      {
        {
          {
            widget = wibox.widget.imagebox,
            image = icon,
            resize = true

          },
          widget = wibox.container.margin,
          top = 3,
          bottom = 3,
          left = 3,
          right = 3,


        },
        widget = wibox.container.background,
        bg = bgcolor,
        -- shape = function(cr, width, height)
        --   return gears.shape.partially_rounded_rect(cr, width, height, true, false, false, true, 10)
        -- end
      },

      {
        {
          vicious_interface,
          widget = wibox.container.margin,
          margins = 5,
        },
        widget = wibox.container.background,
        bg = color_tools.lighten(bgcolor, 20),
        -- shape = function(cr, width, height)
        --   return gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false)
        -- end
      },
      layout = wibox.layout.align.horizontal
    },
    widget = wibox.container.margin,
    margins = 5,
    left = 0,
    right = 1,

    -- create_callback = function(self, c3, index, objects) --luacheck: no unused args
    --   self:connect_signal("mouse::enter", function()
    --     local mouse_pos = awful.mouse.coords();
    --     awful.spawn(string.format("conky -c ~/.config/conky/frappe.conf -x %d -y %d"))
    --     naughty.notify {
    --       title  = "Hello world!",
    --       margin = 15,
    --     }
    --   end)
    --   self:connect_signal("mouse::leave", function()
    --     awful.spawn("killall conky")
    --   end)
    -- end,
    -- update_callback = function(self, c3, index, objects) --luacheck: no unused args
    --   self:connect_signal("mouse::enter", function()
    --     local mouse_pos = awful.mouse.coords();
    --     awful.spawn(string.format("conky -c ~/.config/conky/frappe.conf -x %d -y %d", mouse_pos.x, mouse_pos.y))
    --     naughty.notify {
    --       title  = "Hello world!",
    --       text = "alsdkjfaslkjf",
    --       margin = 15,
    --     }
    --   end)
    --   self:connect_signal("mouse::leave", function()
    --     awful.spawn("killall conky")
    --   end)
    -- end,


  }
  -- out = add_background(out, "#ffffff", gears.shape.rounded_rect)
  -- out = add_margins(out , 5)
  return out
end


M.playground = function()
  local base_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "test",
    halign = "center",
    valign = "center",
  }

  local icon_widget = wibox.widget {
    widget = wibox.widget.imagebox,
    image = beautiful.awesome_icon,
  }
  base_widget = combine_widgets({ base_widget, icon_widget })
  base_widget = add_margins(base_widget, 5)
  base_widget = add_background(base_widget, "#444444", gears.shape.rounded_bar)
  base_widget = add_margins(base_widget, 5)
  --

  return base_widget
end



M.get_vicious_pretty_cpu_exp = function(bg)
  local bgcolor = bg or "#A3BE8C"
  local vicious_interface = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span font='Iosevka Nerd Font 10' foreground='#2e3440'>$1</span>",
    halign = "center",
    valign = "center",
  };
  vicious.register(vicious_interface, vicious.widgets.cpu,
    "<span font='JetBrainsMono Nerd Font 10' foreground='#2e3440'><b>$1%</b></span>", 1)
  local icon_box = wibox.widget {
    widget = wibox.widget.imagebox,
    image = beautiful.cpu_icon,
    resize = true,
    shape = gears.shape.rounded_bar
  }
  icon_box = add_margins(icon_box, { top = 2, left = 2, bottom = 2, right = 2 })
  icon_box = add_background(icon_box, bgcolor, function(cr, w, h)
    return gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, 5)
  end)
  -- icon_box = combine_widgets({ tag_box_left, icon_box })

  local vicious_box = add_margins(vicious_interface, { top = 5, left = 2, bottom = 5, right = 2 })
  vicious_box = add_background(vicious_box, color_tools.lighten(bgcolor, 20), nil)

  local out = combine_widgets({ icon_box, vicious_box })



  out = add_margins(out, 5)

  return out
end


return M;

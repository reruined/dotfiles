local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local function get_capacity(battery)
   local file = io.popen("upower -i " .. battery .. " | grep 'percentage' | cut -d':' -f2 | tr -d '%' | xargs", "r")
   local capacity = tonumber(file:read("*l"))
   file:close()

   return capacity
end

local function get_status(battery)
   local file = io.popen("upower -i " .. battery .. " | grep 'state' | cut -d':' -f2 | tr -d '%' | xargs", "r")
   local status = file:read("*line")
   file:close()

   return status
end

local function get_details(battery)
   local file = io.popen("upower -i " .. battery, "r")
   local output = file:read("*a")
   file:close()

   return output
end

local function get_parameter(battery, parameter_name)
   local file = io.popen("upower -i " .. battery .. " | grep '" .. parameter_name .. "' | cut -d':' -f2 | tr -d '%' | xargs", "r")
   local parameter = file:read("*l")
   file:close()

   return parameter
end

local function get_warning_title(battery)
   local native_path = get_parameter(battery, 'native-path')
   return native_path .. ': battery low'
end

local function get_warning_text(battery)
   local capacity = get_capacity(battery)
   local time_to_empty = get_parameter(battery, 'time to empty')

   return table.concat({ 
      'capacity: ' .. capacity .. '%',
      'time to empty: ' .. time_to_empty,
   }, '\n')
end

local function update_widget(widget)
   local critical_threshold = 20
   local capacity = get_capacity(widget.battery)
   local status = get_status(widget.battery)
   local color = nil
   if status ~= "discharging" then
      color = "gray"
   elseif capacity <= critical_threshold then
      color = "red"
   else 
      color = "orange"
   end
   local markup_text = string.format(' <span color="%s">%d%%</span>', color, capacity)
   widget:set_markup(markup_text)

   if capacity <= critical_threshold and widget.prev_capacity > critical_threshold then
      naughty.notify({ preset = naughty.config.presets.critical, title = get_warning_title(widget.battery), text = get_warning_text(widget.battery) })
   end
   widget.prev_capacity = capacity

   widget.tooltip:set_text(get_details(widget.battery))
end

local function get_batteries()
   local lines = {}
   local file = io.popen('upower -e | grep "BAT"', 'r')
   for line in file:lines() do
      table.insert(lines, line)
   end
   file:close()

   return lines
end

local function create_widget(battery)
   local widget = wibox.widget.textbox();
   widget.battery = battery
   widget.prev_capacity = 100
   widget.tooltip = awful.tooltip({ objects = { widget } })

   local timer = timer({timeout = 5})
   timer:connect_signal("timeout", function() update_widget(widget) end)
   timer:start()

   update_widget(widget)

   return widget
end

local function create_widgets()
   local widgets = {}
   for i, battery in ipairs(get_batteries()) do
      table.insert(widgets, create_widget(battery))
   end


   return widgets
end


return {
   create_widgets = create_widgets
}

-------------------------------------------------
-- Bluetooth Widget for Awesome Window Manager
-- Shows the bluetooth status using the bluetooth command
-- Better with Blueman Manager
-------------------------------------------------

local awful               = require("lib.awful")
local watch               = require('awful.widget.watch')
local wibox               = require("lib.wibox")
local clickable_container = require('widgets.clickable-container')
local gears               = require("lib.gears")
local dpi                 = require("lib.beautiful").xresources.apply_dpi

local PATH_TO_ICONS       = os.getenv('HOME') .. '/.config/awesome/icons/bluetooth/'
local checker

local widget              = wibox.widget {
    {
        id     = 'icon',
        widget = wibox.widget.imagebox,
        resize = true
    },
    layout = wibox.layout.align.horizontal
}

local widget_button       = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
widget_button:buttons(
        gears.table.join(
                awful.button({}, 1, nil,
                             function()
                                 awful.spawn('blueman-manager')
                             end
                )
        )
)

awful.tooltip(
        {
            objects             = { widget_button },
            mode                = 'outside',
            align               = 'right',
            timer_function      = function()
                if checker ~= nil then
                    return 'Bluetooth is on'
                else
                    return 'Bluetooth is off'
                end
            end,
            preferred_positions = { 'right', 'left', 'top', 'bottom' }
        }
)

local last_bluetooth_check = os.time()
watch(
        'bluetoothctl --monitor list',
        5,
        function(_, stdout)
            -- Check if there  bluetooth
            checker = stdout:match('Controller') -- If 'Controller' string is detected on stdout
            local widgetIconName
            if (checker ~= nil) then
                widgetIconName = 'bluetooth'
            else
                widgetIconName = 'bluetooth-off'
            end
            widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
            collectgarbage('collect')
        end,
        widget
)

return widget_button
local beautiful   = require("beautiful")
local gears       = require("gears")
local pixbuf      = require("lgi").GdkPixbuf

local mywallpaper = {}

function mywallpaper:set_animated(surf, s)
    local img, err = pixbuf.PixbufAnimation.new_from_file(surf)
    if not img then
        print(err)
    else
        local iter = img:get_iter(nil)

        local function set_wp()
            local geom, cr = gears.wallpaper.prepare_context(s)
            iter:advance(nil)
            cr:set_source_pixbuf(iter:get_pixbuf(), 0, 0)
            cr.operator = "SOURCE"
            cr:paint()
            local delay = iter:get_delay_time()
            if delay ~= -1 then
                gears.timer.start_new(delay / 1000, set_wp)
            end
        end
        set_wp()
    end
end

function mywallpaper:init(s)
    local indexWallpaper = 3

     local file           = beautiful.wallpapers .. "/" .. indexWallpaper .. "/" .. capi.wmapi:screen_index(s) .. ".png"

    --local file           = beautiful.wallpapers .. "/wallpaper.png"
    if type(file) == "function" then
        file = file(s)
    end

    gears.wallpaper.maximized(file, s, true)

    return mywallpaper
end

--return mywallpaper

return setmetatable(mywallpaper, {
    __call = mywallpaper.init
})

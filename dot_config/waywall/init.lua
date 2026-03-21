local waywall = require("waywall")
local helpers = require("waywall.helpers")

local DESIRED_WIDTH = 320
local DESIRED_HEIGHT = 1080

local config = {
    theme = {
        --background = "#000000ff",
        --background_png = "",

        --cursor_theme = "",
        --cursor_icon = "",
        --cursor_size = 0,

        ninb_anchor =
        {
            position = "right",
            x = -10,
            y = 10,
        },
        ninb_opacity = 0.6,
    },
    input = {
        sensitivity = 1.7,
        remaps = {
            ["X"] = "F3",
            ["mb4"] = "9",
            ["mb5"] = "8",
        },
    },
    experimental = {
        tearing = true,
    },
}

config.actions = {
    ["Ctrl-Shift-N"] = function()
        waywall.exec("pkill -f ninjabrain-bot")
        waywall.sleep(2)
        waywall.exec("java -jar /usr/share/java/ninjabrain-bot/ninjabrain-bot.jar")
        waywall.show_floating(true)
    end,
    ["Alt-F"] = function()
        helpers.toggle_floating()
    end,
    ["Alt-Q"] = function()
        waywall.set_sensitivity(0)
        waywall.set_resolution(0,0)
    end,
    ["Alt-E"] = function()
        waywall.set_sensitivity(0.01)
        waywall.set_resolution(DESIRED_WIDTH, DESIRED_HEIGHT)
    end,
    -- experimental
    ["Alt-2"] = function()
        waywall.set_resolution(4920,380)
    end,
    ["Alt-4"] = function()
        waywall.toggle_fullscreen()
        helpers.toggle_res(320, 1080)
    end,
    ["Alt-B"] = function()
        waywall.press_key("0")
        waywall.press_key("0")
        waywall.press_key("0")
        waywall.press_key("0")
        waywall.press_key("0")
        waywall.press_key("3")
        waywall.press_key("1")
        waywall.press_key("1")
        --waywall.press_key("3")
    end,
}
local mirror = nil

waywall.listen("resolution", function()
    local width, height = waywall.active_res()

    if width == DESIRED_WIDTH and height == DESIRED_HEIGHT then
        if not mirror then
            mirror = waywall.mirror({
                src = {
                    x = 110,
                    y = 500,
                    w = 100,
                    h = 100,
                },
                dst = {
                    x = 0,
                    y = 300,
                    w = 600,
                    h = 600,
                }
            })
        end
    else
        if mirror then
            mirror:close()
            mirror = nil
        end
    end
end)

return config

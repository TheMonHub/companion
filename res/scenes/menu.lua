local game = {}

local ease = require("render.ease")
local back = require("render.back")
local text
local background = require("render.background")

local init = false

local minigames
local current = 1

local fadein, fadeout

local bg
local mousePosX, mousePosY = love.mouse.getPosition()
local beep = nil

somethingSound = love.audio.newSource(gameResourceDir .. "something.mp3", "static")
somethingSound:setVolume(0.5)

local debounce = 0

function game:load(args)
    current = 1
    fadein = 1
    fadeout = 0
    back.load()

    renderFloor = false

    love.keypressed = function(key, scancode, isrepeat)
        if menuTo ~= nil then
            return
        end
        if scancode == "space" then
            menuTo = minigames[current]["scene"]
            local temp = somethingSound:clone()
            temp:play()
            temp:release()
            return
        end

        if debounce > 0 and isrepeat == true then
            return
        end

        if scancode == "d" then
            current = (current + 1)
            if current > #minigames then
                current = 1
            end
            fadein = 1
            debounce = 0.5
            if beep then
                local temp = beep:clone()
                temp:play()
                temp:release()
            end
        elseif scancode == "a" then
            current = current - 1
            if current < 1 then
                current = #minigames
            end
            fadein = 1
            debounce = 0.5
            if beep then
                local temp = beep:clone()
                temp:play()
                temp:release()
            end
        end
    end

    if init == true then
        return
    end

    background.load()

    text = require("text.main")

    bg = {
        [1] = love.graphics.newImage(gameResourceDir .. "bg/lemon.png")
    }

    minigames = {
        {
            ["name"] = "LEMON",
            ["desc"] = "When life gives you lemon, collect it",
            ["scene"] = "transition-lemon"
        }
    }
    beep = love.audio.newSource(gameResourceDir .. "beep.mp3", "static")

    init = true
end

function game:draw()
    love.graphics.setColor(0.75,0.75,0.75,1)
    background.draw()
    love.graphics.setColor(1,1,1,0.9)
    love.graphics.draw(bg[current], -400 - mousePosX * 0.005, -290 - mousePosY * 0.005)
    text.printb(minigames[current]["name"], 0 + mousePosX * 0.01, 0 + mousePosY * 0.01, 5, 4)
    text.printb(minigames[current]["desc"], 0 + mousePosX * 0.02, 50 + mousePosY * 0.02, 2, 2)

    text.printb("A AND D TO NAVIGATE", 0 + mousePosX * 0.02, 250 + mousePosY * 0.02, 2, 2)
    text.printb("SPACE TO SELECT", 0 + mousePosX * 0.03, 275 + mousePosY * 0.03, 2, 2)
    text.printb("MINIGAMES SELECTION", -250 + mousePosX * 0.01, -275 + mousePosY * 0.01, 2, 2)
    back.draw()
    love.graphics.setColor(1,1,1,fadein + fadeout)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    local newMousePosX, newMousePosY = love.mouse.getPosition()
    mousePosX = mousePosX * love.graphics.getDPIScale()
    mousePosY = mousePosY * love.graphics.getDPIScale()

    mousePosX = ease.circleEaseOut(newMousePosX - 400, mousePosX, 3, dt)
    mousePosY = ease.circleEaseOut(newMousePosY - 300, mousePosY, 3, dt)
    background.update(dt)

    if menuTo ~= nil then
        if fadeout >= 0.95 then
            self.setScene("main-game")
        end
        fadeout = ease.circleEaseOut(1, fadeout, 10, dt)
    end

    if fadein ~= 0 then
        if fadein <= 0.05 then
            fadein = 0
        else
            fadein = ease.circleEaseOut(0, fadein, 5, dt)
        end
    end
    if back.doChange() == true then
        self.setScene("main-game")
    end
    back.update(dt)
    debounce = math.max(debounce - dt, 0)
end

return game
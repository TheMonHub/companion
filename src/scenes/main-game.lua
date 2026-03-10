local game = {}

local ease = require("render.ease")
local haru = require("render.haru")
local background = require("render.background")

local fadein = 1

local moodRn = 4
local moodValue = 500

local init = false

notSoEasterNowAreYou = true

isItTheTimeYet = 900

local mood = {}

function game:load(args)
    if init == true then
        return
    end
    haru.load()
    background.load()

    mood[1] = love.graphics.newImage(gameResourceDir .. "status/1.png")
    mood[2] = love.graphics.newImage(gameResourceDir .. "status/2.png")
    mood[3] = love.graphics.newImage(gameResourceDir .. "status/3.png")
    mood[4] = love.graphics.newImage(gameResourceDir .. "status/4.png")
    mood[5] = love.graphics.newImage(gameResourceDir .. "status/5.png")
    mood[6] = love.graphics.newImage(gameResourceDir .. "status/6.png")
    init = true
end

function game:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
    background.draw()
    haru.draw()

    if notSoEasterNowAreYou == false then
        love.graphics.draw(mood[1], -400, -300)
    else
        love.graphics.draw(mood[moodRn], -400, -300)
    end

    love.graphics.setColor(1,1,1,fadein)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    if fadein ~= 0 then
        if fadein <= 0.05 then
            fadein = 0
        else
            fadein = ease.circleEaseOut(0, fadein, 3, dt)
        end
        if fadein <= 0.5 and notSoEasterNowAreYou == false then
            love.window.setIcon(iconMain)
            love.window.setTitle("COMPANION")
            notSoEasterNowAreYou = true
        end
    end
    haru.update(dt)
    background.update(dt)
    moodValue = math.max(math.min(moodValue - dt, 500), 0)
    moodRn = math.ceil(moodValue / 100) + 1
    isItTheTimeYet = math.max(isItTheTimeYet - (dt * (moodRn - 2)), 0)

    if moodRn < 5 then
        haru.setMouthStage("sad")
    else
        haru.setMouthStage("neutral")
    end
end

return game
local game = {}

local ease = require("render.ease")
local haru = require("render.haru")
local background = require("render.background")

local fadein = 1

local moodRn = 4
local moodValue = 300

local init = false

local fadeOut = 1
local changeTo

isItTheTimeYet = 900

local mood = {}

local function transition(scene)
    changeTo = scene
end

function game:load(args)
    haru.setBodyStage("neutral")
    haru.lookUp(false)
    renderFloor = true
    fadeOut = 1
    changeTo = nil

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
    background.draw()
    haru.draw()

    love.graphics.setColor(1,1,1,fadeOut)
    love.graphics.draw(mood[moodRn], -400, -300)

    love.graphics.setColor(1,1,1,fadein)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    if changeTo ~= nil then
        if fadeOut <= 0.05 then
            fadeOut = 0
            self.setScene(changeTo)
        end
        fadeOut = ease.circleEaseOut(0, fadeOut, 15, dt)
    end
    if fadein ~= 0 then
        if fadein <= 0.05 then
            fadein = 0
            -- transition("transition-lemon")
        else
            fadein = ease.circleEaseOut(0, fadein, 3, dt)
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
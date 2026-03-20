local game = {}

local ease = require("render.ease")
local haru = require("render.haru")
local background = require("render.background")
local frame = 0
local bucketThingy
local bucketX = -50
local bucketY = -300
local init = false
local fadeOut = 0
local debounce = false

local metalpipeS
local playOnce = false

function game:load(args)
    frame = 0
    haruOffsetX = 0
    haru.setBodyStage("neutral")
    haru.lookUp(true)
    bucketX = -50
    bucketY = -300
    fadeOut = 0
    debounce = false
    playOnce = false

    if init == true then
        return
    end
    metalpipeS = love.audio.newSource(gameResourceDir .. "metalpipe.mp3", "static")
    metalpipeS:setVolume(0.5)
    haru.load()
    background.load()
    bucketThingy = love.graphics.newImage(gameResourceDir .. "haru/lemon-b.png")
    init = true
end

function game:draw()
    background.draw()
    haru.draw()
    if frame > 0.7 then
        love.graphics.draw(bucketThingy, -400 + (bucketX * 1.5), -275 - bucketX, bucketX / 300)
    elseif frame < 0.5 then
        love.graphics.draw(bucketThingy, -450, -300 + bucketY)
    end

    love.graphics.setColor(1,1,1,fadeOut)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    background.update(dt)
    haru.update(dt)
    frame = frame + dt
    if fadeOut >= 0.95 then
        metalpipeS:stop()
        self.setScene("lemon")
    end
    if frame > 0.7 then
        if debounce == false then
            haruOffsetX = 0
            debounce = true
        end
        haru.setBodyStage("lemon-2")
        haruOffsetX = ease.circleEaseOut(-100, haruOffsetX, 5, dt)
        bucketX = ease.circleEaseOut(100, bucketX, 4, dt)
        if frame > 0.8 then
            fadeOut = ease.circleEaseOut(1, fadeOut, 5, dt)
            metalpipeS:setVolume((1 - fadeOut) * 0.5)
        end
    elseif frame > 0.5 then
        if playOnce == false then
            metalpipeS:setVolume(0.5)
            metalpipeS:play()
            playOnce = true
        end
        haru.setBodyStage("lemon-1")
        if frame < 0.55 then
            haruOffsetX = love.math.random(-30, 30)
        end
    elseif frame < 0.5 and frame > 0.45 then
        bucketY = ease.circleEaseOut(0, bucketY, 50, dt)
    end
end

return game
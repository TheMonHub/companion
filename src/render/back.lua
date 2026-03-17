local module = {}

local init = false

local ease = require("render.ease")

local bgImage
local mainImage
local backImage
local backToMenu = false

local hover = 0
local fadeOut = 0

local change

function module.load(args)
    backToMenu = false
    fadeOut = 0
    change = false
    if init == true then
        return
    end

    bgImage = love.graphics.newImage(gameResourceDir .. "back-bg.png")
    mainImage = love.graphics.newImage(gameResourceDir .. "back.png")
    backImage = love.graphics.newImage(gameResourceDir .. "back-bt.png")

    init = true
end

function module.draw()
    love.graphics.setColor(1,1,1,(1 - hover))
    love.graphics.draw(bgImage, -375 - (1-hover) * 15, -325 + (1-hover) * 15)
    love.graphics.setColor(1,0.643137255,0.349019608,(1 - math.max(hover + 0.25, 0)))
    love.graphics.draw(backImage, -385 - (1-hover) * 8, -315 + (1-hover) * 8)
    love.graphics.setColor(1,1,1,(1 - hover * 0.125))
    love.graphics.draw(mainImage, -385 - (1-hover) * 5, -315 + (1-hover) * 5)

    love.graphics.setColor(1,1,1,fadeOut)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function module.update(dt)
    local mousePosX, mousePosY = love.mouse.getPosition()

    if fadeOut >= 0.95 then
        change = true
    end

    if backToMenu == true then
        fadeOut = ease.circleEaseOut(1, fadeOut, 15, dt)
    end

    if mousePosX >= 675 and mousePosY <= 125 and backToMenu == false then
        hover = ease.circleEaseOut(0, hover, 20, dt)
        if love.mouse.isDown(1) == true then
            backToMenu = true
        end
    else
        hover = ease.circleEaseOut(1, hover, 10, dt)
    end
end

function module.doChange()
    return change
end

return module
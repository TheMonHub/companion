local game = {}

local ease = require("render.ease")
local haru = require("render.haru")
local background = require("render.background")

local fadein = 1
local fadeout = 0

local moodRn = 4
moodValue = 300

local init = false

isItTheTimeYet = 900

local hover = 0
local bgImage

playedLemon = false

local menuOrigin = 0 --0 = none, 1 = to, 2 = from
local menuTranFrame = 0
local menuTranProgess = 0

local bgFade = 1

local waitUnclick = false

local debug_itstime = false
local infinite_mode = false

local mood = {}

function game:load(args)
    haru.setBodyStage("neutral")
    haru.lookUp(false)
    renderFloor = true
    fadeout = 0
    fadein = 1
    changeTo = nil

    love.keypressed = function(key, scancode, isrepeat) end
    love.keyreleased = function(key, scancode) end

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

    bgImage = love.graphics.newImage(gameResourceDir .. "menu-bg.png")
    init = true
end

function game:draw()
    love.graphics.setColor(1,1,1,bgFade)
    background.draw()
    love.graphics.setColor(1,1,1,1)
    haru.draw()

    love.graphics.setColor(1,1,1,1 - fadeout)
    love.graphics.draw(bgImage, -400 + (675 * (1- menuTranProgess)) - (1-hover) * 15, -315 - (1085 * (1- menuTranProgess)) + (1-hover) * 15)
    love.graphics.setColor(1,1,1,1 - menuTranProgess - fadeout)
    love.graphics.draw(mood[moodRn], -365 - (1-hover) * 5 - (150 * menuTranProgess), -335 + (150 * menuTranProgess) + (1-hover) * 5)

    love.graphics.setColor(1,1,1,fadein)
    love.graphics.rectangle("fill", -400, -300, 800, 600)
end

function game:update(dt)
    if fadein ~= 0 then
        if fadein <= 0.05 then
            fadein = 0
        else
            fadein = ease.circleEaseOut(0, fadein, 5, dt)
        end
    end
    haru.update(dt)
    background.update(dt)
    moodValue = math.max(math.min(moodValue - dt, 500), 0)
    moodRn = math.ceil(moodValue / 100) + 1
    isItTheTimeYet = math.max(isItTheTimeYet - (dt * (moodRn - 2)) * 0.5, 0)

    if moodRn < 5 then
        haru.setMouthStage("sad")
    else
        haru.setMouthStage("neutral")
    end

    if menuOrigin ~= 0 then

        if menuOrigin == 1 then
            if menuTranFrame >= 1 then
                menuOrigin = 2
                menuTranProgess = 1
                hover = 1
                self.setScene("menu")
            end
            menuTranFrame = menuTranFrame + dt * 3
            menuTranProgess = ease.easeInBack(math.min(menuTranFrame, 1), 1, 1)
            return
        end

        if menuOrigin == 2 then
            if menuTranProgess > 0.05 then
                menuTranProgess = ease.circleEaseOut(0, menuTranProgess, 10, dt)
                if love.mouse.isDown(1) == true then
                    waitUnclick = true
                end
                return
            else
                menuTranProgess = ease.circleEaseOut(0, menuTranProgess, 10, dt)
                menuTranFrame = 0
                if menuTo ~= nil then
                    if fadeout >= 0.95 then
                        fadeout = 1
                        if menuTo == "itstime" then
                            if bgFade <= 0.001 then
                                self.setScene("itstime")
                            end
                            bgFade = ease.circleEaseOut(0, bgFade, 2, dt)
                            haruSpeed = math.max(bgFade, 0.25)
                            haru.setLookAtYOU(true)
                            haru.setMouthStage("neutral")
                            return
                        end
                        local temp = menuTo
                        menuTo = nil
                        menuOrigin = 2
                        menuTranProgess = 1
                        hover = 1
                        self.setScene(temp)
                    else
                        fadeout = ease.circleEaseOut(1, fadeout, 10, dt)
                    end
                    return
                end
            end
        end
    end

    local mousePosX, mousePosY = love.mouse.getPosition()
    mousePosX = mousePosX * love.graphics.getDPIScale()
    mousePosY = mousePosY * love.graphics.getDPIScale()
    if mousePosX >= 675 and mousePosY <= 125 and changeTo == nil then
        hover = ease.circleEaseOut(0, hover, 20, dt)
        if love.mouse.isDown(1) == true then
            if waitUnclick == true then
                return
            end
            menuTranProgess = 0
            menuTranFrame = 0
            menuOrigin = 1
            local temp = somethingSound:clone()
            temp:play()
            temp:release()
        else
            waitUnclick = false
        end
    else
        hover = ease.circleEaseOut(1, hover, 10, dt)
    end

    if isItTheTimeYet <= 0
            and playedLemon == true
            or debug_itstime == true
            and infinite_mode == false then
        menuTo = "itstime"
    end
end

return game
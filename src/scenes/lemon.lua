local game = {}

local ease = require("render.ease")
local background = require("render.background")
local text
local fadein = 1

local lemon, lemonW, lemonH
local bucket, pX, bucketW, bucketH
local pYO = 0
local rot = 0
local bomb, bombW, bombH
local lastPickUp = 0
local explode
local score = 0
local confirm = false
local dead = false
local upForReset = false
local accumulatedTime = 0
local whenSpawn = 1
local waiiitttt = 0

local init = false

local fall = {
    ["count"] = 0,
    ["type"] = {

    },
    ["when"] = {

    },
    ["where"] = {

    }
}
local explodeT = {

} -- item contains a table with x and time member
local explodeCount = 0

local gameTickV = 1

local movingA = false
local movingD = false
function game:load(args)
    renderFloor = false
    pX = 0
    rot = 0
    score = 0
    whenSpawn = 1
    accumulatedTime = 0
    gameTickV = 1
    confirm = false
    fall = {
        ["count"] = 0,
        ["type"] = {

        },
        ["when"] = {

        },
        ["where"] = {

        }
    }
    explodeT = {

    }
    -- DRY will hate me
    if init == true then
        return
    end
    background.load()

    bucket = love.graphics.newImage(gameResourceDir .. "lemon/bucket.png")
    bucketW, bucketH = bucket:getDimensions()
    bomb = love.graphics.newImage(gameResourceDir .. "lemon/bomb.png")
    bombW, bombH = bomb:getDimensions()
    lemon = love.graphics.newImage(gameResourceDir .. "lemon/lemon.png")
    lemonW, lemonH = lemon:getDimensions()
    explode = love.graphics.newImage(gameResourceDir .. "explode.png")
    text = require("text.main")

    init = true

    love.keypressed = function(key, scancode, isrepeat)
        if waiiitttt <= 0 then
            confirm = true
            dead = false
        end
        if scancode == "d" then -- move right
            movingD = true
        elseif scancode == "a" then
            movingA = true
        end
    end
    love.keyreleased = function(key, scancode)
        if scancode == "d" then -- move right
            movingD = false
        elseif scancode == "a" then
            movingA = false
        end
    end
end

function game:draw()
    background.draw()

    for i, v in ipairs(fall["when"]) do
        local type = fall["type"][i]
        local locationX, locationY = fall["where"][i], -fall["when"][i] * 600
        if type == 0 then
            love.graphics.draw(bomb, locationX - bombW / 2, locationY + 300 - bombH / 2)
        else
            love.graphics.draw(lemon, locationX - lemonW / 2, locationY + 300 - lemonH / 2)
        end
    end

    for i, v in ipairs(explodeT) do
        love.graphics.draw(explode, v["x"] - 157, 300 - 157, 0, 0.75, 0.75)
    end

    love.graphics.draw(bucket, pX - bucketW / 2, 275 + pYO - bucketW /2 - rot * 50 + math.abs(rot * 50), rot)

    love.graphics.setColor(1,1,1,fadein)
    love.graphics.rectangle("fill", -400, -300, 800, 600)

    love.graphics.setColor(1,1,1,1)
    if dead == true then
        love.graphics.draw(explode, pX - 210, 275 + pYO - 210)
    end
    if confirm == false then
        if dead == true then
            text.print("YOU LOSE", 0, -45, 7.5)
            text.print("Press Any Button To Retry", 0, 30, 3)
        else
            text.print("Press Any Button To Start", 0, 0, 3)
        end
        text.print("A and D To Play", 0, 100, 2)
    end

    text.print(tostring(score), -350, -250, 3)
end

local function youDied()
    rot = 0
    confirm = false
    dead = true
    whenSpawn = 1
    gameTickV = 1
    upForReset = true
    waiiitttt = 0.25
end

local function spawnShit()
    local current = fall["count"] + 1
    fall["count"] = current

    if love.math.random(0, 100) >= 90 then
        fall["type"][current] = 0 -- 0 is bomb 1 is lemon
    else
        fall["type"][current] = 1
    end
    fall["when"][current] = 1.05
    fall["where"][current] = love.math.random(-300, 300)
end

local function makeItFall(dt)
    for i, v in ipairs(fall["when"]) do
        fall["when"][i] = v - (0.5 * (dt * gameTickV * 1.25))
    end
end

local function maybeCollectIt()
    for i = #fall["when"], 1, -1 do
        local when = fall["when"][i]

        if when <= 0.1 and when >= 0.075 then
            local where = fall["where"][i]
            local dif = math.abs(where - pX)
            if dif < bucketW * 1.1 and fall["type"][i] == 1 then
                score = score + 1
                lastPickUp = 0

                table.remove(fall["type"], i)
                table.remove(fall["when"], i)
                table.remove(fall["where"], i)
                fall["count"] = fall["count"] - 1
                gameTickV = gameTickV + 0.01
            elseif dif < bucketW * 0.6 and fall["type"][i] == 0 then
                youDied()
            end
        end
        if when <= -0.05 and fall["type"][i] == 1 then
            youDied()
        elseif when <= -0.05 and fall["type"][i] == 0 then
            explodeCount = explodeCount + 1
            explodeT[explodeCount] = {
                ["x"] = fall["where"][i],
                ["time"] = 0.1
            }
            table.remove(fall["type"], i)
            table.remove(fall["when"], i)
            table.remove(fall["where"], i)
            fall["count"] = fall["count"] - 1
        end
    end
end

local function gameTick(dt)
    accumulatedTime = 0

    whenSpawn = whenSpawn - (dt * (gameTickV * 2) * (gameTickV * 2))
    if whenSpawn < 0 then
        spawnShit()
        whenSpawn = 4
    end

    makeItFall(dt)
    for i, v in ipairs(explodeT) do
        explodeT[i]["time"] = explodeT[i]["time"] - dt
        if explodeT[i]["time"] <= 0 then
            table.remove(explodeT, i)
            explodeCount = explodeCount - 1
        end
    end
    maybeCollectIt()
end

local oldPx
function game:update(dt)
    background.update(dt)
    if waiiitttt >= 0 then
        waiiitttt = waiiitttt - dt
    end

    if fadein ~= 0 then
        if fadein <= 0.05 then
            fadein = 0
        else
            fadein = ease.circleEaseOut(0, fadein, 3, dt)
        end
    end

    if confirm == false then
        return
    end

    if upForReset == true then
        pX = 0
        score = 0
        fall = {
            ["count"] = 0,
            ["type"] = {

            },
            ["when"] = {

            },
            ["where"] = {

            }
        }
        explodeT = {

        }
        upForReset = false
    end

    oldPx = pX
    if movingA == true then
        pX = pX - (dt * gameTickV * gameTickV) * 400
    elseif movingD == true then
        pX = pX + (dt * gameTickV * gameTickV) * 400
    end
    pX = math.min(math.max(pX, -300), 300)
    rot = ease.circleEaseOut((oldPx - pX) * -0.05, rot, 20, dt)

    gameTick(dt)

    if lastPickUp ~= nil then
        lastPickUp = lastPickUp + dt
    end

    if lastPickUp ~= nil and lastPickUp > 1 then
        lastPickUp = nil
    end

    if lastPickUp ~= nil then
        lastPickUp = lastPickUp + dt
        local temp = (1 - lastPickUp)
        pYO = (50 ^ temp) / 3
    else
        pYO = 0
    end
end

return game
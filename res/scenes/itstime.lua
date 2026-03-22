local game = {}

local ease = require("render.ease")
local haru = require("render.haru")
local text

-- love.system.openURL("file://" .. love.filesystem.getRealDirectory(gameResourceDir) .. "/res/theultimatec.png") NOTE

local currentSay = ""
local visibleText = ""
local currentPoint = 0
local currentWait = 0
local currentSpeed = 0.05
local timer = 0
local isDone = true

function game.say(content, speed, wait)
    currentSay = content or ""
    currentPoint = 0
    visibleText = ""
    currentSpeed = speed or 0.05
    currentWait = wait or 0
    timer = 0
    isDone = false
end

local face = "now"
local sadOrNo = false
local function tick(dt)
    if currentSay == "" then
        isDone = true
    end
    if isDone then return end

    timer = timer + dt

    if timer >= currentSpeed then
        timer = timer - currentSpeed
        currentPoint = math.min(currentPoint + 1, #currentSay)

        visibleText = string.sub(currentSay, 1, currentPoint)
        if sadOrNo == true then
            haru.setMouthStage("sad-open")
        else
            haru.setMouthStage("open")
        end
        if currentPoint == #currentSay then
            if sadOrNo == true then
                haru.setMouthStage("sad")
            else
                haru.setMouthStage("neutral")
            end
            if currentWait >= 0 then
                currentWait = currentWait - dt
                return
            end
            isDone = true
        end
    end
end

local say
local ct
local ctb = false
local ctz = false
local ctC = 1
local fadeInCt = 0

local function debug()
    say = {
        {
            ["time"] = 0,
            ["say"] = "",
            ["speed"] = 0,
            ["wait"] = 2,
            ["func"] = function(self)
                local pressedButton = love.window.showMessageBox("", "", {"Yes", "No"})
                if pressedButton == 1 then
                    self.setScene("yes")
                else
                    self.setScene("no")
                end
            end
        }
    }
end

function game:load(args)
    haru.setFaceStage("now")
    haru.setBodyStage("neutral")
    love.window.setIcon(iconBlack)
    love.window.setTitle("")
    canQuit = true
    love.window.updateMode(windowWidth, windowHeight, {borderless=true})
    text = require("text.main")
    ct = {
        love.graphics.newImage(gameResourceDir .. "ct1.png"),
        love.graphics.newImage(gameResourceDir .. "ct2.png"),
        love.graphics.newImage(gameResourceDir .. "ct3.png")
    }

    say = {
        {
            ["time"] = 2,
            ["say"] = "So...",
            ["speed"] = 0.3,
            ["wait"] = 0.05
        },
        {
            ["time"] = 0.5,
            ["say"] = "I've been...",
            ["speed"] = 0.2,
            ["wait"] = 0.2
        },
        {
            ["time"] = 0.05,
            ["say"] = "very",
            ["speed"] = 0.1,
            ["wait"] = 0.05
        },
        {
            ["time"] = 0,
            ["say"] = "very",
            ["speed"] = 0.1,
            ["wait"] = 0.05
        },
        {
            ["time"] = 0.5,
            ["say"] = "lonely",
            ["speed"] = 0.1,
            ["wait"] = 0.3,
            ["func"] = function()
                sadOrNo = true
            end
        },
        {
            ["time"] = 0,
            ["say"] = "",
            ["speed"] = 0,
            ["wait"] = 2,
            ["func"] = function()
                face = "blink"
                ctb = true
            end
        },
        {
            ["time"] = 10,
            ["say"] = "Until I meet you...",
            ["speed"] = 0.1,
            ["wait"] = 0.3,
            ["func"] = function()
                ctC = 2
                fadeInCt = 0.5
            end
        },
        {
            ["time"] = 3,
            ["say"] = "You don't know how happy I am, " .. Username .. ".",
            ["speed"] = 0.1,
            ["wait"] = 0.3,
            ["func"] = function()
                ctC = 3
                ctz = true
                ctb = false
            end
        },
        {
            ["time"] = 1,
            ["say"] = "I want to return the favor.",
            ["speed"] = 0.1,
            ["wait"] = 0.3,
            ["func"] = function()
                face = "now"
                sadOrNo = false
            end
        },
        {
            ["time"] = 0.5,
            ["say"] = "I want to be your COMPANION",
            ["speed"] = 0.1,
            ["wait"] = 0.3,
            ["func"] = function()
                haru.setBodyStage("reach")
            end
        },
        {
            ["time"] = 0.1,
            ["say"] = "Your best FRIEND",
            ["speed"] = 0.1,
            ["wait"] = 0.3,
        },
        {
            ["time"] = 0.5,
            ["say"] = "Will you...?",
            ["speed"] = 0.2,
            ["wait"] = 0.5,
        },
        {
            ["time"] = 0,
            ["say"] = "",
            ["speed"] = 0,
            ["wait"] = 1,
            ["func"] = function(self)
                local pressedButton = love.window.showMessageBox("", "", {"Yes", "No"})
                if pressedButton == 1 then
                    self.setScene("yes")
                else
                    self.setScene("no")
                end
            end
        }
    }
    debug()
end

function game:draw()
    haru.draw()
    text.printn(visibleText, -text.getLength(currentSay, 2.5) / 2, -150, 2.5)
    love.graphics.setColor(1,1,1,fadeInCt)
    love.graphics.draw(ct[ctC], -400, -300)
end

local time = 0

local currentIndex = 1
local function timedSay(self)
    local v = say[currentIndex]
    if not v then return end

    if time > v.time then
        game.say(v.say, v.speed, v.wait)
        time = 0
        currentIndex = currentIndex + 1
        if v.func then
            v.func(self)
        end
    end
end

function game:update(dt)
    haru.update(dt)
    tick(dt)
    if isDone == true then
        time = time + dt
    end

    if isDone then
        currentSay = content or ""
        currentPoint = 0
        visibleText = ""
        currentSpeed = speed or 0.05
        currentWait = wait or 0
        timer = 0
    end

    haru.setFaceStage(face)

    timedSay(self)

    if ctb == true then
        fadeInCt = ease.circleEaseOut(0.75, fadeInCt, 0.5, dt)
    end
    if ctz == true then
        fadeInCt = ease.circleEaseOut(0, fadeInCt, 0.5, dt)
    end
end

return game
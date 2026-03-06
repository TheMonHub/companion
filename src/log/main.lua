local module = {}

local logFilePath = "log.txt"
local logFile, logErrorStr = love.filesystem.newFile(logFilePath, "w")
if logFile == nil then
    print("Unable to access the log file:".. logErrorStr)
    love.event.quit(3)
    return
end
print("Log will be saved to: " .. love.filesystem.getSaveDirectory() .. "\\" .. logFilePath)

function module.info(content)
    local contentF = "[INFO] " .. content .. "\r\n"
    print("[INFO] " .. content)
    local s, e = logFile:write(contentF)
    if s == false then
        print("Failed to log:".. e)
    end
end

function module.warn(content)
    local contentF = "[!WARN] " .. content .. "\r\n"
    print("[!WARN] " .. content)
    local s, e = logFile:write(contentF)
    if s == false then
        print("Failed to log:".. e)
    end
end

function module.error(content)
    local contentF = "[!!ERROR] " .. content .. "\r\n"
    print("[!!ERROR] " .. content)
    local s, e = logFile:write(contentF)
    if s == false then
        print("Failed to log:".. e)
    end
end

return module
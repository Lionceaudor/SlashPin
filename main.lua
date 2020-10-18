SlashPin = LibStub("AceAddon-3.0"):NewAddon("SlashPin", "AceConsole-3.0")

local DEBUG = false

function SlashPin:Debug(...)
    if DEBUG then
        SlashPin:Print("[DEBUG]", ...)
    end
end

local function printUsage()
    SlashPin:Print("Usage:")
    SlashPin:Print("/pin <x> <y> - Places a pin at x, y")
    SlashPin:Print("/pin clear - Removes active pin")
end

local function handlePinCmd(x, y)
    if not (x and y) then
        printUsage()
        return
    end

    x = x:gsub(",", "")
    x, y = tonumber(x), tonumber(y)
    if not (x and y) then
        printUsage()
        return
    end

    SlashPin:Debug(x)
    SlashPin:Debug(y)

    SlashPin:Pin(x / 100, y / 100)
end

local function handleCmd(str)
    local x, y = SlashPin:GetArgs(str, 2)

    SlashPin:Debug(x)
    SlashPin:Debug(y)

    if not x then
        printUsage()
        return
    end

    if x == "clear" then
        SlashPin:Clear()
    else
        handlePinCmd(x, y)
    end
end

SlashPin:RegisterChatCommand("pin", handleCmd)
SlashPin = LibStub("AceAddon-3.0"):NewAddon("SlashPin", "AceConsole-3.0")

local DEBUG = false

function SlashPin:Debug(...)
    if DEBUG then
        SlashPin:Print("[DEBUG]", ...)
    end
end

function SlashPin:Error(...)
    SlashPin:Print("|cffff0000", ...)
end

local function printUsage()
    SlashPin:Print("Usage:")
    SlashPin:Print("/pin <x> <y> - Place a pin at x, y")
    SlashPin:Print("/pin <zone> <x> <y> - Place a pin at x, y in zone")
    SlashPin:Print("/pin clear - Remove active pin")
end

local function handlePinCmd(x, y, uiMapID)
    if not (x and y) then printUsage() return end
    x, y = tonumber(x), tonumber(y)
    if not (x and y) then printUsage() return end

    SlashPin:Debug(x)
    SlashPin:Debug(y)

    SlashPin:Pin(x / 100, y / 100, uiMapID)
end

local function handleCmd(str)
    local tokens = SlashPin:ParseCmd(str)

    -- Lower the first token
    local ltoken = tokens[1] and tokens[1]:lower()

    if ltoken == "clear" then
        SlashPin:Clear()
    elseif tokens[1] and not tonumber(tokens[1]) then
        local zoneName, x, y = SlashPin:ParseTokens(tokens)
        if not zoneName then
            printUsage()
            return
        end

        local uiMapID
        SlashPin:Debug("zoneName", zoneName)

        if SlashPin:isExceptionZoneName(zoneName) then
            zoneName = SlashPin:GetUniqueZoneName(zoneName)
            SlashPin:Debug("Unique zone name", zoneName)
            uiMapID = SlashPin:GetUiMapID(zoneName)
        else
            uiMapID = SlashPin:GetUiMapID(zoneName)
            if SlashPin:IsAmbiguousZone(uiMapID) then
                SlashPin:Print("Found multiple matches for zone: " .. zoneName .. ". Please use one of the following alternatives:")
                SlashPin:PrintAlternatives(uiMapID)
                return
            end
        end

        if uiMapID == nil then
            SlashPin:Error("Could not find zone:", zoneName)
            return
        end

        handlePinCmd(x, y, uiMapID)
    elseif tonumber(tokens[1]) then
        handlePinCmd(tokens[1], tokens[2])
    else
        printUsage()
    end
end

SlashPin:RegisterChatCommand("pin", handleCmd)
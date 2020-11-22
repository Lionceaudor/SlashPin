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
	SlashPin:Print("/pin here - Place a pin at current location")
	SlashPin:Print("/pin <x> <y> - Place a pin at x, y")
	SlashPin:Print("/pin <zone> <x> <y> - Place a pin at x, y in zone")
	SlashPin:Print("/pin clear - Remove active pin")
end

local function handlePinCmd(x, y, uiMapID)
	if not (x and y) then printUsage()
		return
	end

	x, y = tonumber(x), tonumber(y)
	if not (x and y) then printUsage()
		return
	end

	SlashPin:Debug(x)
	SlashPin:Debug(y)

	x, y = SlashPin:ConvertCoordinates(x, y)

	SlashPin:Pin(x, y, uiMapID)
end

local function getUiMapIDForZoneName(zoneName)
	local uiMapID = nil
	local isAmbiguousZone = false

	SlashPin:Debug("Getting map ID for zoneName:", zoneName)

	if SlashPin:isExceptionZoneName(zoneName) then -- User specified unique name from alternatives
		zoneName = SlashPin:GetUniqueZoneName(zoneName)
		SlashPin:Debug("Unique zone name", zoneName)
		uiMapID = SlashPin:GetUiMapID(zoneName)
	else
		uiMapID = SlashPin:GetUiMapID(zoneName)
		isAmbiguousZone = SlashPin:IsAmbiguousZone(uiMapID)
	end

	return uiMapID, isAmbiguousZone
end

local function handleCmd(str)
	local tokens = SlashPin:ParseCmd(str)

	-- Lower the first token
	local ltoken = tokens[1] and tokens[1]:lower()

	if ltoken == "clear" then
		SlashPin:Clear()
	elseif ltoken == "here" then
		SlashPin:PinHere()
	elseif tokens[1] and not tonumber(tokens[1]) then -- zone name specified
		local zoneName, x, y = SlashPin:ParseTokens(tokens)
		if not zoneName then
			printUsage()
			return
		end

		local uiMapID, isAmbiguousZone = getUiMapIDForZoneName(zoneName)
		if isAmbiguousZone then
			SlashPin:Print("Found multiple matches for zone: " .. zoneName .. ". Please use one of the following alternatives:")
			SlashPin:PrintAlternatives(uiMapID)
		elseif uiMapID then
			handlePinCmd(x, y, uiMapID)
		else
			SlashPin:Error("Could not find zone:", zoneName)
		end
	elseif tonumber(tokens[1]) then -- no zone name, pin in this zone
		handlePinCmd(tokens[1], tokens[2])
	else
		printUsage()
	end
end

SlashPin:RegisterChatCommand("pin", handleCmd)
if not IsAddOnLoaded("TomTom") then -- Are there other addons that use /way?
	SlashPin:RegisterChatCommand("way", handleCmd)
end
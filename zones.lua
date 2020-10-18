local Tourist = LibStub("LibTourist-3.0")

-- uiMapID, nonLocalizedName
local lookupTable = Tourist:GetMapIDLookupTable()

local LOCALLIZED_ZONES = {}
for _, uiMapID in ipairs({
    948, -- "The Maelstrom",
    107, -- "Nagrand",
    104, -- "Shadowmoon Valley"
    41, -- "Dalaran"
}) do
    LOCALLIZED_ZONES[uiMapID] = C_Map.GetMapInfo(uiMapID).name
end

local LOCALIZED_CONTINENTS = {}
for key, uiMapID in pairs({
    OUTLAND = 101,
    NORTHREND = 113,
    DRAENOR = 572,
    BROKEN_ISLES = 619,
}) do
    LOCALIZED_CONTINENTS[key] = C_Map.GetMapInfo(uiMapID).name
end


-- TODO localize suffixes
local alternatives = {
    ["The Maelstrom"] = {
        [947] = "continent", -- "The Maelstrom" - Azeroth
        [948] = "zone", -- "The Maelstrom (zone)" - The Maelstrom
    },
    ["Nagrand"] = {
        [101] = LOCALIZED_CONTINENTS.OUTLAND, -- "Nagrand" - Outland
        [572] = LOCALIZED_CONTINENTS.DRAENOR, -- "Nagrand (Draenor)" - Draenor
    },
    ["Shadowmoon Valley"] = {
        [101] = LOCALIZED_CONTINENTS.OUTLAND, -- "Shadowmoon Valley" - Outland
        [572] = LOCALIZED_CONTINENTS.DRAENOR, -- "Shadowmoon Valley (Draenor)" - Draenor
    },
    ["Dalaran"] = {
        [113] = LOCALIZED_CONTINENTS.NORHTREND, -- "Dalaran" - Northrend
        [619] = LOCALIZED_CONTINENTS.DRAENOR, -- "Dalaran (Broken Isles)" - Broken Isles
    },
}

local uniqueZoneInfo = {
    [LOCALLIZED_ZONES[948] .. ":continent"] = {LOCALLIZED_ZONES[948], 947}, -- "The Maelstrom" - Azeroth
    [LOCALLIZED_ZONES[948] .. ":zone"] = {LOCALLIZED_ZONES[948], 948}, -- "The Maelstrom (zone)" - The Maelstrom

    [LOCALLIZED_ZONES[107] .. ":" .. LOCALIZED_CONTINENTS.OUTLAND] = {LOCALLIZED_ZONES[107], 101}, -- "Nagrand" - Outland
    [LOCALLIZED_ZONES[107] .. ":" .. LOCALIZED_CONTINENTS.DRAENOR] = {LOCALLIZED_ZONES[107], 572}, -- "Nagrand (Draenor)" - Draenor

    [LOCALLIZED_ZONES[104] .. ":" .. LOCALIZED_CONTINENTS.OUTLAND] = {LOCALLIZED_ZONES[104], 101}, -- "Shadowmoon Valley" - Outland
    [LOCALLIZED_ZONES[104] .. ":" .. LOCALIZED_CONTINENTS.DRAENOR] = {LOCALLIZED_ZONES[104], 572}, -- "Shadowmoon Valley (Draenor)" - Draenor

    [LOCALLIZED_ZONES[41] .. ":" .. LOCALIZED_CONTINENTS.NORTHREND] = {LOCALLIZED_ZONES[41], 113}, -- "Dalaran" - Northrend
    [LOCALLIZED_ZONES[41] .. ":" .. LOCALIZED_CONTINENTS.BROKEN_ISLES] = {LOCALLIZED_ZONES[41], 619}, -- "Dalaran (Broken Isles)" - Broken Isles
}

function SlashPin:isExceptionZoneName(zoneName)
    return uniqueZoneInfo[zoneName]
end

function SlashPin:GetUniqueZoneName(zoneName)
    local zoneInfo = uniqueZoneInfo[zoneName]
    return Tourist:GetUniqueZoneNameForLookup(zoneInfo[1], zoneInfo[2])
end

function SlashPin:GetUiMapID(zoneName)
    local uiMapID = Tourist:GetZoneMapID(zoneName)
    SlashPin:Debug("uiMapID", uiMapID)
    return uiMapID
end

function SlashPin:IsAmbiguousZone(uiMapID)
    return alternatives[lookupTable[uiMapID]]
end

function SlashPin:PrintAlternatives(uiMapID)
    local nonLocalizedName = lookupTable[uiMapID]
    local localizedName = C_Map.GetMapInfo(uiMapID).name

    SlashPin:Debug("nonLocalizedName", nonLocalizedName)
    SlashPin:Debug("localizedName", localizedName)

    for continent, suffix in pairs(alternatives[nonLocalizedName]) do
        print(localizedName .. ":" .. suffix)
    end
end
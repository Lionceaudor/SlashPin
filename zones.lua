local Tourist = LibStub("LibTourist-3.0")

function SlashPin:GetUiMapID(zoneName)
    local uiMapID = Tourist:GetZoneMapID(zoneName)
    SlashPin:Debug("uiMapID", uiMapID)
    return uiMapID
end
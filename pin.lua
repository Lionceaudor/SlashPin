local checkPinSupport, placePin

function SlashPin:Pin(x, y, uiMapID)
    if not SlashPin:ValidateCoordinates(x, y) then
        SlashPin:Error("Coordinates out of bounds.")
        return
    end

    if uiMapID == nil then
        uiMapID = SlashPin:GetUiMapIDForCurrentZone()
    end

    if checkPinSupport(uiMapID) then
        placePin(x, y, uiMapID)
    end
end

function SlashPin:PinHere()
    local uiMapID = SlashPin:GetUiMapIDForCurrentZone()

    if checkPinSupport(uiMapID) then
        local position = C_Map.GetPlayerMapPosition(uiMapID, "player")
        local x, y = position:GetXY()
        placePin(x, y, uiMapID)
    end
end

function SlashPin:Clear()
    C_Map.ClearUserWaypoint()
    PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_REMOVE)
end

function checkPinSupport(uiMapID)
    if C_Map.CanSetUserWaypointOnMap(uiMapID) then
        return true
    else
        SlashPin:Error("This zone does not support placing pins.")
        return false
    end
end

function placePin(x, y, uiMapID)
    local point = UiMapPoint.CreateFromCoordinates(uiMapID, x, y)

    C_Map.SetUserWaypoint(point)
    PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CONTROL_CLICK)

    -- TODO make automatic tracking optional
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_SUPER_TRACK)
end
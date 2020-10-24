function SlashPin:Pin(x, y, uiMapID)
    if not SlashPin:ValidateCoordinates(x, y) then
        SlashPin:Error("Coordinates out of bounds.")
        return
    end

    if uiMapID == nil then
        uiMapID = SlashPin:GetUiMapIDForCurrentZone()
    end

    SlashPin:Debug(uiMapID)

    if C_Map.CanSetUserWaypointOnMap(uiMapID) then
        local point = UiMapPoint.CreateFromCoordinates(uiMapID, x, y)
        C_Map.SetUserWaypoint(point)
        -- TODO make automatic tracking optional
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CONTROL_CLICK)
        PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_SUPER_TRACK)
    else
        SlashPin:Error("This zone does not support placing pins.")
    end
end

function SlashPin:Clear()
    C_Map.ClearUserWaypoint()
    PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_REMOVE)
end
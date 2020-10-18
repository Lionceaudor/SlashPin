function SlashPin:Pin(x, y)
    if x > 1 or y > 1 or x < 0 or y < 0 then
        SlashPin:Print("Coordinates out of bounds.")
        return
    end

    local map = C_Map.GetBestMapForUnit("player")
    SlashPin:Debug(map)

    if C_Map.CanSetUserWaypointOnMap(map) then
        local point = UiMapPoint.CreateFromCoordinates(map, x, y)
        C_Map.SetUserWaypoint(point)
        -- TODO make automatic tracking optional
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CONTROL_CLICK)
        PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_SUPER_TRACK)
    else
        SlashPin:Print("|cffff0000This zone does not support placing pins.")
    end
end

function SlashPin:Clear()
    C_Map.ClearUserWaypoint()
    PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_REMOVE)
end
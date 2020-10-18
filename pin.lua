function SlashPin:Pin(x, y)
    if x > 1 or y > 1 or x < 0 or y < 0 then
        SlashPin:Print("Coordinates out of bounds.")
        return
    end

    local map = C_Map.GetBestMapForUnit("player")
    SlashPin:Debug(map)
    local point = UiMapPoint.CreateFromCoordinates(map, x, y)

    C_Map.SetUserWaypoint(point)
end

function SlashPin:Clear()
    C_Map.ClearUserWaypoint()
end
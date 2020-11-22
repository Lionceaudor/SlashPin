local _G = _G

local C_Map_CanSetUserWaypointOnMap = _G.C_Map.CanSetUserWaypointOnMap
local C_Map_ClearUserWaypoint = _G.C_Map.ClearUserWaypoint
local C_Map_GetPlayerMapPosition = _G.C_Map.GetPlayerMapPosition
local C_Map_SetUserWaypoint = _G.C_Map.SetUserWaypoint
local C_SuperTrack_SetSuperTrackedUserWaypoint = _G.C_SuperTrack.SetSuperTrackedUserWaypoint
local PlaySound = _G.PlaySound

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
        local position = C_Map_GetPlayerMapPosition(uiMapID, "player")
        local x, y = position:GetXY()
        placePin(x, y, uiMapID)
    end
end

function SlashPin:Clear()
    C_Map_ClearUserWaypoint()
    PlaySound(170273) -- SOUNDKIT.UI_MAP_WAYPOINT_REMOVE
end

function checkPinSupport(uiMapID)
    if C_Map_CanSetUserWaypointOnMap(uiMapID) then
        return true
    else
        SlashPin:Error("This zone does not support placing pins.")
        return false
    end
end

function placePin(x, y, uiMapID)
    local point = UiMapPoint.CreateFromCoordinates(uiMapID, x, y)

    C_Map_SetUserWaypoint(point)
    PlaySound(170272) -- SOUNDKIT.UI_MAP_WAYPOINT_CONTROL_CLICK

    -- TODO make automatic tracking optional
    C_SuperTrack_SetSuperTrackedUserWaypoint(true)
    PlaySound(170270) -- SOUNDKIT.UI_MAP_WAYPOINT_SUPER_TRACK_ON
end
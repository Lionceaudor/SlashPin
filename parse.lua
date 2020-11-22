-- Code adapted from TomTom

local _G = _G
local select = _G.select
local table_concat = _G.table.concat
local table_insert = _G.table.insert
local tonumber = _G.tonumber
local unpack = _G.unpack

local wrongseparator = "(%d)"..(tonumber("1.1") and "," or ".").."(%d)"
local rightseparator =   "%1"..(tonumber("1.1") and "." or ",").."%2"

function SlashPin:ParseCmd(str)
    local tokens = {}

    str = str:gsub("(%d)[%.,] (%d)", "%1 %2"):gsub(wrongseparator, rightseparator)
    for token in str:gmatch("%S+") do
        table_insert(tokens, token)
    end

    return tokens
end

function SlashPin:ParseTokens(tokens)
    local zoneEnd
    for i = 1, #tokens do
        local token = tokens[i]
        if tonumber(token) then
            -- We've encountered a number, so the zone name must have ended at the prior token
            zoneEnd = i - 1
            break
        end
    end

    if not zoneEnd then
        return nil
    end

    return table_concat(tokens, " ", 1, zoneEnd), select(zoneEnd + 1, unpack(tokens))
end
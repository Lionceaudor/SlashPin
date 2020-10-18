-- Code adapted from TomTom

local wrongseparator = "(%d)" .. (tonumber("1.1") and "," or ".") .. "(%d)"
local rightseparator =   "%1" .. (tonumber("1.1") and "." or ",") .. "%2"

function SlashPin:ParseCmd(str)
    local tokens = {}

    str = str:gsub("(%d)[%.,] (%d)", "%1 %2"):gsub(wrongseparator, rightseparator)

    for token in str:gmatch("%S+") do
        table.insert(tokens, token)
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

    return table.concat(tokens, " ", 1, zoneEnd), select(zoneEnd + 1, unpack(tokens))
end
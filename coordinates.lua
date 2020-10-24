function SlashPin:ValidateCoordinates(x, y)
    return not (x > 1 or y > 1 or x < 0 or y < 0)
end

function SlashPin:ConvertCoordinates(x, y)
    return x / 100, y / 100
end
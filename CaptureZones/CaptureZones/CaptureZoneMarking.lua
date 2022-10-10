local function GetMapSize()
	print(Map.GetGridSize())
	local mapWidth, mapHeight = Map.GetGridSize()
	print("Width: " .. mapWidth)
	print("Height: " .. mapHeight)
end

local function Initialize()
	Events.TurnBegin.Add(GetMapSize)
end

Initialize()
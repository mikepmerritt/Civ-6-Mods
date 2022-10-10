local function GetMapSize()
	print(Map.GetGridSize())
	local mapWidth, mapHeight = Map.GetGridSize()
	print("Width: " .. mapWidth)
	print("Height: " .. mapHeight)
end

local function MarkPlot(previousEra, newEra)
	local unmarkedTile = Map.GetPlot(11, 11)
	local markedTile = Map.GetPlot(10, 11)
	markedTile:SetProperty("MARKED_SAM", 1)
	print("Marked tile: " .. (markedTile:GetProperty("MARKED_SAM") or "0"))
	print("Unmarked tile: " .. (unmarkedTile:GetProperty("MARKED_SAM") or "0"))
end

local function Initialize()
	-- map size
	Events.TurnBegin.Add(GetMapSize)

	-- plot marking
	Events.GameEraChanged.Add(MarkPlot)
end

Initialize()
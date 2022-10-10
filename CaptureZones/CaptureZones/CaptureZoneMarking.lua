local function GetMapSize()
	print(Map.GetGridSize())
	local mapWidth, mapHeight = Map.GetGridSize()
	print("Width: " .. mapWidth)
	print("Height: " .. mapHeight)
end

local function MarkPlot(previousEra, newEra)
	local unmarkedTile = Map.GetPlot(11, 11)
	local markedTile = Map.GetPlot(10, 11)

	if newEra == 0 then
		-- game start
		markedTile:SetProperty("MARKED_SAM", 1)
	elseif newEra == 2 then
		-- medieval
	elseif newEra == 4 then
		-- industrial
	elseif newEra == 6 then
		-- atomic
	end
	
	-- need or "0" because nil can't be printed or worked with
	print("Marked tile flag: " .. (markedTile:GetProperty("MARKED_SAM") or 0))
	print("Unmarked tile flag: " .. (unmarkedTile:GetProperty("MARKED_SAM") or 0))
end

local function Initialize()
	-- map size
	Events.TurnBegin.Add(GetMapSize)

	-- plot marking
	Events.GameEraChanged.Add(MarkPlot)
end

Initialize()
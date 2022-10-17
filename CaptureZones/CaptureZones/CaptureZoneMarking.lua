local function PrintAllMarks()
	local mapWidth, mapHeight = Map.GetGridSize()
	print("Width: " .. mapWidth)
	print("Height: " .. mapHeight)

	local allPlots:table = {}
	local markedPlots:table = {}
	local markedPlotsOutput = ""

	for x=1,mapWidth do
		for y=1,mapHeight do
			local id = "(" .. x .. ", " .. y .. ")"
			local currPlot = Map.GetPlot(x, y)
			allPlots[id] = currPlot
			if currPlot ~= nil and currPlot:GetProperty("MARKED_SAM") ~= nil then
				markedPlots[id] = Map.GetPlot(x, y)
				markedPlotsOutput = markedPlotsOutput .. id .. " "
			end
		end
	end

	print("Marked plots: " .. markedPlotsOutput)
end

-- debug function for finding out what tiles are in a city
local function CountAndPrintCityTiles() 
	local player = PlayerManager.GetAliveMajors()[1]
	local capital = player:GetCities():GetCapitalCity()
	local plots = capital:GetOwnedPlots()
	for _, plot in pairs(plots) do
		print("x: " .. plot:GetX() .. " y: " .. plot:GetY())
	end
end

local function CheckIfTileInCityMarked(city)
	local allCityTiles:table = city:GetOwnedPlots()
end

local function MarkPlot(previousEra, newEra)
	local livingPlayers:table = PlayerManager.GetAliveMajors()
	local livingPlayerIDs:table = PlayerManager.GetAliveMajorIDs()
	local livingPlayersString = ""
	for i=1,PlayerManager.GetAliveMajorsCount() do
		livingPlayersString = livingPlayersString .. livingPlayerIDs[i] .. " "
	end

	print("Players left: " .. livingPlayersString)

	--local unmarkedTile = Map.GetPlot(11, 11)
	--local markedTile = Map.GetPlot(10, 11)

	if newEra == 0 then
		-- game start, used for debugging/testing
		--markedTile:SetProperty("MARKED_SAM", 1)
	elseif newEra == 1 then
		-- classical, use only for debugging

		-- get all of the capitals
		local capitalPlots:table = {}
		for i=1, PlayerManager.GetAliveMajorsCount() do
			local player = livingPlayers[i]
			local cityList:table = player:GetCities()
			local capital = cityList:GetCapitalCity()
			local capitalPlot = capital:GetPlot()
			capitalPlots[i] = capitalPlot
		end

		-- mark tiles over one x value from capitals
		for i=1,PlayerManager.GetAliveMajorsCount() do
			local plotToMark = Map.GetPlot(capitalPlots[i]:GetX()+1, capitalPlots[i]:GetY())
			plotToMark:SetProperty("MARKED_SAM", 1)
		end

		-- print all marked tiles
		PrintAllMarks()
	elseif newEra == 2 then
		-- medieval
	elseif newEra == 4 then
		-- industrial
	elseif newEra == 6 then
		-- atomic
	end
	
	-- need or "0" because nil can't be printed or worked with
	-- print("Marked tile flag: " .. (markedTile:GetProperty("MARKED_SAM") or 0))
	-- print("Unmarked tile flag: " .. (unmarkedTile:GetProperty("MARKED_SAM") or 0))
end

local function Initialize()
	-- plot marking
	Events.GameEraChanged.Add(MarkPlot)
	Events.TurnEnd.Add(CountAndPrintCityTiles)
end

Initialize()
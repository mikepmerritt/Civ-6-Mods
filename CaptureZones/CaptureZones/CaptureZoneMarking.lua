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
local function PrintCityTiles() 
	local player = PlayerManager.GetAliveMajors()[1]
	local capital = player:GetCities():GetCapitalCity()
	local plots = capital:GetOwnedPlots()
	for _, plot in pairs(plots) do
		print("x: " .. plot:GetX() .. " y: " .. tostring(plot:GetY()))
		print("district: " .. tostring(plot:GetDistrictType()))
		print("resource: " .. tostring(plot:GetResourceType()))
		print("water: " .. tostring(plot:IsWater()))
		print("not natural wonder?: " .. tostring(plot:IsNaturalWonder()))
		print("mountain: " .. tostring(plot:IsMountain()))
	end
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

		-- goal:
		-- for each player
		-- go through all player's cities
		-- find distance between player's cities to all enemies cities
		-- save min distance along with player city
		-- look through tiles in player city chosen for:
		-- + no district 
		-- + no resource
		-- + land
		-- + passable
		-- + not natural wonder
		-- + not impassible
		-- if a suitable tile is found, mark the tile, then mark the city

		-- -- for each player
		-- for _, player in pairs(PlayerManager.GetAliveMajors()) do
		-- 	local cityMinDistancesToEnemy:table = {}

		-- 	-- go through all player's cities
		-- 	-- find distance between player's cities to all enemies cities
		-- 	for _, pCity in pairs(player:GetCities():Members()) do
		-- 		for _, enemy in pair(PlayerManager.GetAliveMajors()) do
		-- 			for _, eCity in pairs(enemy:GetCities():Members()) do
		-- 				if player:GetID() ~= enemy:GetID() and pCity:GetProperty("CAPTURE_SAM") == nil and eCity:GetProperty("CAPTURE_SAM") == nil then
		-- 					-- save min distance along with player city
		-- 					local distance = Map.GetPlotDistance(pCity:GetPlot():GetX(), pCity:GetPlot():GetY(), eCity:GetPlot():GetX(), eCity:GetPlot():GetY())
		-- 					if cityMinDistancesToEnemy[pCity:GetID()] == nil or cityMinDistancesToEnemy[pCity:GetID()] > distance then
		-- 						cityMinDistancesToEnemy[pCity:GetID()] = distance;
		-- 					end
		-- 				end
		-- 			end
		-- 		end
		-- 	end

		-- 	local markingFinished = false

		-- 	while not markFinished do
		-- 		local minID = -1
		-- 		local minDistance = -1
		-- 		for cityID, distance in pairs(cityMinDistancesToEnemy) do
		-- 			if distance > minDistance then
		-- 				minID = cityID
		-- 				minDistance = distance
		-- 			end
		-- 		end
				
		-- 		if minID < 0 and minDistance < 0 then
		-- 			print("Player " .. player:GetID() .. " had no tiles to mark as capture zones, aborting placement without placing")
		-- 			markingFinished = true
		-- 		else
		-- 			-- check conditions on every tile in city
		-- 			for _, plot in pairs(CityManager.GetCity(minID):GetOwnedPlots()) do
		-- 				if plot:GetResourceType() < 0 and plot:GetDistrictType < 0 and 
		-- 			-- if works, mark tile and exit
		-- 			-- if fails, remove entry from cityMinDistancesToEnemy
		-- 	end
		-- end

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
	Events.TurnEnd.Add(PrintCityTiles)
end

Initialize()
-- TODO: make it so that capture zones plots cannot have districts placed on them
local function MarkPlot(plot)
	plot:SetProperty("CAPTURE_SAM", true)
	ResourceBuilder.SetResourceType(plot, 52, 1)
end

-- marks any tile with a capture zone and unmarks any cities that are marked but do not have a capture zone
local function MarkCities()
	for _, player in pairs(PlayerManager.GetAliveMajors()) do
		for _, city in player:GetCities():Members() do
			local marked = false
			for _, plot in pairs(city:GetOwnedPlots()) do
				if plot:GetProperty("CAPTURE_SAM") ~= nil then
					marked = true
				end
			end
			
			if marked then
				-- if there is a capture zone in a city mark the city
				city:SetProperty("CAPTURE_SAM", true)
			elseif city:GetProperty("CAPTURE_SAM") ~= nil then
				-- if the city is marked but no longer has a capture zone unmark it
				city:SetProperty("CAPTURE_SAM", nil)
			end
		end
	end
end

-- picks a new set of plots and cities to mark as capture zones
-- a capture zone plot must have no resources, no districts, no mountains, no natural wonders, or no wonders (so we can build on it later)
-- a capture zone city must not already have a capture zone
-- TODO: add parameters to differentiate between era behavior, if deemed necessary
local function GenerateCaptureZones()
	-- general function idea:
	-- for each player
	-- go through all player's cities
	-- find distance between player's cities to all enemies cities
	-- save min distance along with player city to a table
	-- pick min distance city from that table
	-- if a suitable tile is found in min distance city, mark the tile, then mark the city, then move on to next player
	-- if a suitable tile is not found in min distance city, delete the city from the table and try next min distance city
	-- if no city can be found that can be marked, give up and move on to next player

	-- for each player
	for _, player in pairs(PlayerManager.GetAliveMajors()) do
		local cityMinDistancesToEnemy:table = {}

		-- go through all player's cities
		-- find distance between player's cities to all enemies cities
		for _, pCity in player:GetCities():Members() do
			for _, enemy in pairs(PlayerManager.GetAliveMajors()) do
				for _, eCity in enemy:GetCities():Members() do
					if player:GetID() ~= enemy:GetID() and pCity:GetProperty("CAPTURE_SAM") == nil then
						-- save min distance along with player city
						local distance = Map.GetPlotDistance(pCity:GetPlot():GetX(), pCity:GetPlot():GetY(), eCity:GetPlot():GetX(), eCity:GetPlot():GetY())
						local position = pCity:GetPlot():GetX() .. " " .. pCity:GetPlot():GetY()
						if cityMinDistancesToEnemy[position] == nil or cityMinDistancesToEnemy[pCity:GetID()] > distance then
							cityMinDistancesToEnemy[position] = distance;
						end
					end
				end
			end
		end

		local markingFinished = false

		while not markingFinished do
			local minLocation = nil -- failsafe value
			local minDistance = -1 -- failsafe value

			-- find city with minimum distance from enemy
			for location, distance in pairs(cityMinDistancesToEnemy) do
				if distance > minDistance then
					minLocation = location
					minDistance = distance
				end
			end
			
			-- -- ok
			-- print("MARKING DEBUG: ALL CITY DISTANCES")
			-- for position, distance in pairs(cityMinDistancesToEnemy) do
			-- 	print("city position: " .. position .. " distance: " .. distance)
			-- end

			-- if no city was found (the for loop didn't run because all cities were eliminated as options) exit without marking and print that for error tracking
			if minLocation == nil and minDistance < 0 then
				print("MARKING: Player " .. player:GetID() .. " had no tiles to mark as capture zones, aborting placement without placing")
				markingFinished = true
			else
				local minCityPlotCoordinates = {}
				for coord in minLocation:gmatch("%S+") do
					table.insert(minCityPlotCoordinates, coord)
				end
				
				local minCity = CityManager.GetCityAt(minCityPlotCoordinates[1], minCityPlotCoordinates[2])
				-- check conditions on every tile in the city:
				-- + a tile hasn't been marked already in this go
				-- + no district 
				-- + no resource
				-- + land (no water)
				-- + no mountain
				-- + not natural wonder
				for _, plot in pairs(minCity:GetOwnedPlots()) do
					if not markingFinished and plot:GetDistrictType() < 0 and plot:GetResourceType() < 0 and not plot:IsWater() and not plot:IsMountain() and not plot:IsNaturalWonder() then
						-- if works, mark tile and exit
						MarkPlot(plot)
						print("MARKING: Player " .. player:GetID() .. " had the tile (" .. plot:GetX() .. ", " .. plot:GetY() ..") marked successfully.")
						markingFinished = true;
					end
				end

				-- if no tile in the closest city to an enemy could be marked, delete it from cityMinDistancesToEnemy and continue while loop
				cityMinDistancesToEnemy[minLocation] = nil
			end
		end
	end
end

-- debug function, outputs a list of all marked tiles as ordered pairs
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
			if currPlot ~= nil and currPlot:GetProperty("CAPTURE_SAM") ~= nil then
				markedPlots[id] = Map.GetPlot(x, y)
				markedPlotsOutput = markedPlotsOutput .. id .. " "
			end
		end
	end

	print("Marked plots: " .. markedPlotsOutput)
end

-- debug function, prints out all plots in a city and some important information
local function PrintCityTiles() 
	local player = PlayerManager.GetAliveMajors()[1]
	local capital = player:GetCities():GetCapitalCity()
	local plots = capital:GetOwnedPlots()
	print("TILE INFORMATION:")
	for _, plot in pairs(plots) do
		print("x: " .. plot:GetX() .. " y: " .. tostring(plot:GetY()))
		print("district: " .. tostring(plot:GetDistrictType()))
		print("resource: " .. tostring(plot:GetResourceType()))
		print("water: " .. tostring(plot:IsWater()))
		print("not natural wonder?: " .. tostring(plot:IsNaturalWonder()))
		print("mountain: " .. tostring(plot:IsMountain()))
		if(plot:GetProperty("CAPTURE_SAM") ~= nil) then
			print("capture zone: true")
		else
			print("capture zone: false")
		end
		print()
	end
end

local function MarkPlotsOnEraChange(previousEra, newEra)
	local livingPlayers:table = PlayerManager.GetAliveMajors()
	local livingPlayerIDs:table = PlayerManager.GetAliveMajorIDs()
	local livingPlayersString = ""
	for i=1,PlayerManager.GetAliveMajorsCount() do
		livingPlayersString = livingPlayersString .. livingPlayerIDs[i] .. " "
	end

	print("Players left: " .. livingPlayersString)

	if newEra == 0 then
		-- game start, used for debugging/testing

	elseif newEra >= 1 then
		-- the game has reached classical era or later
		GenerateCaptureZones()
	end
end

local function Initialize()
	-- plot marking
	Events.GameEraChanged.Add(MarkPlotsOnEraChange)

	-- city marking
	Events.TurnEnd.Add(MarkCities)

	-- debug
	-- Events.TurnEnd.Add(PrintAllMarks)
	-- Events.TurnEnd.Add(PrintCityTiles)
	Events.TurnEnd.Add(GenerateCaptureZones)
end

Initialize()
-- picks a new set of plots and cities to mark as capture zones
-- a capture zone plot must have no resources, no districts, no mountains, no natural wonders, or no wonders (so we can build on it later)
-- a capture zone city must not already have a capture zone

-- TODO: make it so that capture zones plots cannot have districts placed on them
-- TODO: make a separate function to re-evaluate capture zone city markings, to handle transferring tiles, culture bombs, razing of cities, founding of new cities, etc
-- 		 essentially, call on turn start (or maybe a better event exists), search all cities, if marked tile inside mark city (1), else unmark city (nil)
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
		for _, pCity in pairs(player:GetCities():Members()) do
			for _, enemy in pair(PlayerManager.GetAliveMajors()) do
				for _, eCity in pairs(enemy:GetCities():Members()) do
					if player:GetID() ~= enemy:GetID() and pCity:GetProperty("CAPTURE_SAM") == nil and eCity:GetProperty("CAPTURE_SAM") == nil then
						-- save min distance along with player city
						local distance = Map.GetPlotDistance(pCity:GetPlot():GetX(), pCity:GetPlot():GetY(), eCity:GetPlot():GetX(), eCity:GetPlot():GetY())
						if cityMinDistancesToEnemy[pCity:GetID()] == nil or cityMinDistancesToEnemy[pCity:GetID()] > distance then
							cityMinDistancesToEnemy[pCity:GetID()] = distance;
						end
					end
				end
			end
		end

		local markingFinished = false

		while not markFinished do
			local minID = -1 -- failsafe value
			local minDistance = -1 -- failsafe value

			-- find city with minimum distance from enemy
			for cityID, distance in pairs(cityMinDistancesToEnemy) do
				if distance > minDistance then
					minID = cityID
					minDistance = distance
				end
			end
			
			-- if no city was found (the for loop didn't run because all cities were eliminated as options) exit without marking and print that for error tracking
			if minID < 0 and minDistance < 0 then
				print("MARKING: Player " .. player:GetID() .. " had no tiles to mark as capture zones, aborting placement without placing")
				markingFinished = true
			else
				-- there is an eligible city, so fetch it
				local minCity = CityManager.GetCity(minID)
				-- check conditions on every tile in the city:
				-- + a tile hasn't been marked already in this go
				-- + no district 
				-- + no resource
				-- + land (no water)
				-- + no mountain
				-- + not natural wonder
				for _, plot in pairs(minCity:GetOwnedPlots()) do
					if not markFinished and plot:GetDistrictType < 0 and plot:GetResourceType() < 0 and not plot:IsWater() and not plot:IsMountain() and not plot:IsNaturalWonder() then
						-- if works, mark tile and exit
						plot:SetProperty("CAPTURE_SAM", 1)
						minCity:SetProperty("CAPTURE_SAM", 1)
						print("MARKING: Player " .. player:GetID() .. " had the tile (" .. plot:GetX() .. ", " .. plot:GetY() ..") marked successfully.")
						markFinished = true;
					end
				end

				-- if no tile in the closest city to an enemy could be marked, delete it from cityMinDistancesToEnemy and continue while loop
				cityMinDistancesToEnemy[minID] = nil
		end
	end
end

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

-- debug function for finding out what tiles are in a city
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

local function MarkPlot(previousEra, newEra)
	local livingPlayers:table = PlayerManager.GetAliveMajors()
	local livingPlayerIDs:table = PlayerManager.GetAliveMajorIDs()
	local livingPlayersString = ""
	for i=1,PlayerManager.GetAliveMajorsCount() do
		livingPlayersString = livingPlayersString .. livingPlayerIDs[i] .. " "
	end

	print("Players left: " .. livingPlayersString)

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

	elseif newEra == 2 then
		-- medieval

		GenerateCaptureZones()

	elseif newEra == 4 then
		-- industrial

		GenerateCaptureZones()

	elseif newEra == 6 then
		-- atomic

		GenerateCaptureZones()

	end
end

local function Initialize()
	-- plot marking
	Events.GameEraChanged.Add(MarkPlot)
	-- Events.TurnEnd.Add(PrintCityTiles)
end

Initialize()
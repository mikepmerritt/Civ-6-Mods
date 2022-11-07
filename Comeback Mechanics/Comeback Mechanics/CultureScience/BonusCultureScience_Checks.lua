-- function to output all available requirement types --
local function OutputAllRequirementTypes()
	-- TAKEN FROM https://civ6pedia.x0.com/guide/modifier03.html --
	for row in GameInfo.Types() do
		if row.Kind == "KIND_REQUIREMENT" then
			print("\t" .. row.Type);
		end
	end
end

-- NOTE: add special science districts into this
scienceDistricts = {["DISTRICT_CAMPUS"] = true, ["DISTRICT_OBSERVATORY"] = true, ["DISTRICT_SEOWON"] = true}

-- creating a table to hold monument plots that need to be checked for properties --
-- creating a table to hold library plots that need to be checked for properties --

-- TODO: fix potential bugs that could come from capturing cities with monuments and libraries
-- TODO: check for bugs with buildings being destroyed
local culturePlots = {};
local sciencePlots = {};
local playerList = PlayerManager.GetAliveMajors();
for _, player in pairs(playerList) do
	culturePlots[player:GetID()] = {};
	sciencePlots[player:GetID()] = {};
end

-- TODO: change these values to be based on actual gameplay
local cultureThreshold = 3;
local scienceThreshold = 3;

-- print("Number of culture tables: " .. #culturePlots);
-- print("Number of science tables: " .. #sciencePlots);

local function ApplyProperties()
	-- culture checks --
	for playerIndex, playerPlots in pairs(culturePlots) do
		print("Player Index: " .. playerIndex);
		-- fetching other players' culture and calculating an average
		local averageCulture = 0;
		local playerCount = 0;
		for otherPlayerIndex, _ in pairs(culturePlots) do
			if playerIndex ~= otherPlayerIndex and Players[otherPlayerIndex]:IsAlive() then
				averageCulture = averageCulture + Players[otherPlayerIndex]:GetCulture():GetCultureYield();
				playerCount = playerCount + 1;
				print("\tPlayer " .. otherPlayerIndex .. " Science: " .. Players[otherPlayerIndex]:GetCulture():GetCultureYield());
			end
		end
		averageCulture = averageCulture / playerCount;
		print("\tAverage Culture of Opponents: " .. averageCulture);
		for _, plot in pairs(playerPlots) do
			if Players[playerIndex]:IsAlive() and Players[playerIndex]:GetCulture():GetCultureYield() < averageCulture - cultureThreshold then
				print("Monument property applied at (" .. plot:GetX() .. ", " .. plot:GetY() .. ")");
				plot:SetProperty("SAM_ENABLE_CULTURE_BONUS", 1);
			else
				print("Monument property removed at (" .. plot:GetX() .. ", " .. plot:GetY() .. ")");
				plot:SetProperty("SAM_ENABLE_CULTURE_BONUS", 0);
			end
		end
	end
	-- science checks --
	for playerIndex, playerPlots in pairs(sciencePlots) do
		print("Player Index: " .. playerIndex);
		-- fetching other players' science and calculating an average
		local averageScience = 0;
		local playerCount = 0;
		for otherPlayerIndex, _ in pairs(sciencePlots) do
			if playerIndex ~= otherPlayerIndex and Players[otherPlayerIndex]:IsAlive() then
				averageScience = averageScience + Players[otherPlayerIndex]:GetTechs():GetScienceYield();
				playerCount = playerCount + 1;
				print("\tPlayer " .. otherPlayerIndex .. " Science: " .. Players[otherPlayerIndex]:GetTechs():GetScienceYield());
			end
		end
		averageScience = averageScience / playerCount;
		print("\tAverage Science of Opponents: " .. averageScience);
		for _, plot in pairs(playerPlots) do
			if Players[playerIndex]:IsAlive() and Players[playerIndex]:GetTechs():GetScienceYield() < averageScience - scienceThreshold then
				print("Library property applied at (" .. plot:GetX() .. ", " .. plot:GetY() .. ")");
				plot:SetProperty("SAM_ENABLE_SCIENCE_BONUS", 1);
			else
				print("Library property removed at (" .. plot:GetX() .. ", " .. plot:GetY() .. ")");
				plot:SetProperty("SAM_ENABLE_SCIENCE_BONUS", 0);
			end
		end
	end
end

-- playerID is the number for the player that triggered the event (0 is first player) --
-- cityID is the number for the city that triggered the event (65536 is capital) --
-- iConstructionType is a number that identifies what was produced (0 is unit, 1 is building, 2 is district) --
-- unitID is the number identifier for the produced item, depends on iConstructionType (0 is monument, 4 is library) --
-- bCancelled is not clear, mostly just false --culturePlots
local function AssignPropertyOnBuildingCompletion(playerID, cityID, iConstructionType, unitID, bCancelled)
	-- print("Completed production") --
	-- print("\tplayerID: " .. playerID); --
	-- print("\tcityID: " .. cityID); --
	-- print("\tiConstructionType: " .. iConstructionType); --
	-- print("\tunitID: " .. unitID); --
	-- print("\tbCancelled: " .. tostring(bCancelled)); --

	if Players[playerID]:IsMajor() then
		-- monument
		if iConstructionType == 1 and unitID == 0 then
			print("Monument was created by player " .. playerID .. " in city " .. cityID);
			-- local cityPlot = CityManager.GetCity(cityID):GetPlot();
			-- local living_players = PlayerManager.GetAliveMajors();
			local player = Players[playerID];
			local city = player:GetCities():FindID(cityID);
			local cityPlot = city:GetPlot();
			-- cityPlot:SetProperty("SAM_ENABLE_CULTURE_BONUS", 1);
			culturePlots[playerID][#culturePlots[playerID] + 1] = cityPlot;
		end
		-- library
		if iConstructionType == 1 and unitID == 4 then
			print("Library was created by player " .. playerID .. " in city " .. cityID);
			local player = Players[playerID];
			local city = player:GetCities():FindID(cityID);
			local cityDistricts = city:GetDistricts();
			
			-- code inspired by code from City.ltp
			for district in GameInfo.Districts() do
				if cityDistricts:HasDistrict(district.Index) then
					if scienceDistricts[district.DistrictType] ~= nil then
						local cityDistrict = cityDistricts:GetDistrict(district.Index); -- add 0 parameter?
						local districtPlot = Map.GetPlot(cityDistrict:GetX(), cityDistrict:GetY());
						sciencePlots[playerID][#sciencePlots[playerID] + 1] = districtPlot;
						break;
					end
				end
			end
		end
	end
end

local function SwapBuildingOwner(newPlayerID, oldPlayerID, newCityID, iCityX, iCityY)
	print("City changed hands!")
	print("\tNew Player ID: " .. newPlayerID);
	print("\tOld Player ID: " .. oldPlayerID);
	print("\tNew City ID: " .. newCityID);
	print("\tCity X: " .. iCityX);
	print("\tCity Y: " .. iCityY);
end

-- Events.TurnBegin.Add(OutputAllRequirementTypes);
Events.CityProductionCompleted.Add(AssignPropertyOnBuildingCompletion);
Events.TurnBegin.Add(ApplyProperties);
GameEvents.CityConquered.Add(SwapBuildingOwner);
-- NOTE: add special science and culture districts into these
scienceDistricts = {["DISTRICT_CAMPUS"] = true, ["DISTRICT_OBSERVATORY"] = true, ["DISTRICT_SEOWON"] = true}
cultureDistricts = {["DISTRICT_THEATER"] = true, ["DISTRICT_ACROPOLIS"] = true}

-- table that will contain all plots with special buildings
local modifierPlots = {};
-- table of tables that will contain the district plots currently owned by a given player
local playerPlots = {};
local playerList = PlayerManager.GetAlive();
for _, player in pairs(playerList) do
	playerPlots[player:GetID()] = {};
end

-- tables to track progress in the tech and civics trees
local techProgress = {};
local civicsProgress = {};
local majorPlayerList = PlayerManager.GetAlive();
for _, player in pairs(majorPlayerList) do
	techProgress[player:GetID()] = 0;
	civicsProgress[player:GetID()] = 0;
end

-- TODO: change these values to be based on actual gameplay
local techThresholds = {[0] = 2, [1] = 4};
local civicsThresholds = {[0] = 2, [1] = 4};

local function ApplyProperties()
	-- step through each plot in modifierPlots
	for plotIndex, modifierPlot in pairs(modifierPlots) do
		local ownerID;
		for playerID, indivPlayerPlots in pairs(playerPlots) do
			for _, indivPlot in pairs(indivPlayerPlots) do
				if modifierPlot:GetX() == indivPlot:GetX() and modifierPlot:GetY() == indivPlot:GetY() then
					ownerID = playerID;
					break;
				end
			end
			-- do not check others if plot owner is found
			if ownerID ~= nil then
				break;
			end
		end

		-- if no player currently owns this building, it was removed from the game and should be forgotten
		if ownerID == nil then 
			table.remove(modifierPlots, plotIndex);
		-- otherwise, go to the plot and apply the modifiers as necessary
		else
			-- print("Handling properties on plot at (" .. modifierPlot:GetX() .. ", " .. modifierPlot:GetY() .. "):");
			if PlayerManager.GetPlayer(ownerID):IsMajor() then
				-- print("\tOwner ID: " .. ownerID);
				local majors = PlayerManager.GetAliveMajors();
				-- fetching other players' cultures and sciences, and calculating averages
				local averageTechs = 0;
				local averageCivics = 0;
				local playerCount = 0;
				for _, otherPlayer in pairs(majors) do
					if ownerID ~= otherPlayer:GetID() then
						averageTechs = averageTechs + techProgress[otherPlayer:GetID()];
						averageCivics = averageCivics + civicsProgress[otherPlayer:GetID()];
						playerCount = playerCount + 1;
						-- print("\t\tPlayer " .. otherPlayer:GetID() .. " Techs: " .. techProgress[otherPlayer:GetID()]);
						-- print("\t\tPlayer " .. otherPlayer:GetID() .. " Civics: " .. civicsProgress[otherPlayer:GetID()]);
					end
				end
				averageTechs = averageTechs / playerCount;
				averageCivics = averageCivics / playerCount;
				-- print("\tAverage Techs of Opponents: " .. averageTechs);
				-- print("\tAverage Civics of Opponents: " .. averageCivics);
				-- print("\tPlayer " .. ownerID .. " Techs: " .. techProgress[ownerID]);
				-- print("\tPlayer " .. ownerID .. " Civics: " .. civicsProgress[ownerID]);

				-- applying culture properties
				if PlayerManager.GetPlayer(ownerID):IsAlive() and civicsProgress[ownerID] <= averageCivics - civicsThresholds[1] then
					modifierPlot:SetProperty("SAM_ENABLE_CULTURE_BONUS", 2);
					-- print("\tExtra culture property applied at (" .. modifierPlot:GetX() .. ", " .. modifierPlot:GetY() .. ")");
				elseif PlayerManager.GetPlayer(ownerID):IsAlive() and civicsProgress[ownerID] <= averageCivics - civicsThresholds[0] then
					modifierPlot:SetProperty("SAM_ENABLE_CULTURE_BONUS", 1);
					-- print("\tCulture property applied at (" .. modifierPlot:GetX() .. ", " .. modifierPlot:GetY() .. ")");
				else
					modifierPlot:SetProperty("SAM_ENABLE_CULTURE_BONUS", 0);
					-- print("\tCulture property removed at (" .. modifierPlot:GetX() .. ", " .. modifierPlot:GetY() .. ")");
				end

				-- applying science properties
				if PlayerManager.GetPlayer(ownerID):IsAlive() and techProgress[ownerID] <= averageTechs - techThresholds[1] then
					modifierPlot:SetProperty("SAM_ENABLE_SCIENCE_BONUS", 2);
					-- print("\tExtra science property applied at (" .. modifierPlot:GetX() .. ", " .. modifierPlot:GetY() .. ")");
				elseif PlayerManager.GetPlayer(ownerID):IsAlive() and techProgress[ownerID] <= averageTechs - techThresholds[0] then
					modifierPlot:SetProperty("SAM_ENABLE_SCIENCE_BONUS", 1);
					-- print("\tScience property applied at (" .. modifierPlot:GetX() .. ", " .. modifierPlot:GetY() .. ")");
				else
					modifierPlot:SetProperty("SAM_ENABLE_SCIENCE_BONUS", 0);
					-- print("\tScience property removed at (" .. modifierPlot:GetX() .. ", " .. modifierPlot:GetY() .. ")");
				end
			else
				-- print("\tPlayer is a minor power, no properties applied.");
				modifierPlot:SetProperty("SAM_ENABLE_CULTURE_BONUS", 0);
				-- print("\tCulture property removed at (" .. modifierPlot:GetX() .. ", " .. modifierPlot:GetY() .. ")");
				modifierPlot:SetProperty("SAM_ENABLE_SCIENCE_BONUS", 0);
				-- print("\tScience property removed at (" .. modifierPlot:GetX() .. ", " .. modifierPlot:GetY() .. ")");
			end
		end
	end
end

-- helper function to check if a plot is already tracked for properties
local function IsPlotTracked(plot) 
	for _, modifierPlot in pairs(modifierPlots) do
		if plot:GetX() == modifierPlot:GetX() and plot:GetY() == modifierPlot:GetY() then
			return true;
		end
	end
	return false;
end

-- helper function used to assign properties to city center plot
local function AssignPropertyToCityCenter(name, playerID, cityID)
	-- print(name .. " was created by player " .. playerID .. " in city " .. cityID);
	local player = Players[playerID];
	local city = player:GetCities():FindID(cityID);
	local cityPlot = city:GetPlot();
	if not IsPlotTracked(cityPlot) then 
		modifierPlots[#modifierPlots + 1] = cityPlot;
	end
end

-- helper function used to assign properties to a district plot
local function AssignPropertyToDistrict(name, playerID, cityID, suitableDistricts)
	-- print(name .. " was created by player " .. playerID .. " in city " .. cityID);
	local player = Players[playerID];
	local city = player:GetCities():FindID(cityID);
	local cityDistricts = city:GetDistricts();
	
	-- code inspired by code from City.ltp
	for district in GameInfo.Districts() do
		if cityDistricts:HasDistrict(district.Index) then
			if suitableDistricts[district.DistrictType] ~= nil then
				local cityDistrict = cityDistricts:GetDistrict(district.Index); -- add 0 parameter?
				local districtPlot = Map.GetPlot(cityDistrict:GetX(), cityDistrict:GetY());
				if not IsPlotTracked(districtPlot) then 
					modifierPlots[#modifierPlots + 1] = districtPlot;
				end
				break;
			end
		end
	end
end

-- playerID is the number for the player that triggered the event (0 is first player)
-- cityID is the number for the city that triggered the event (65536 is capital)
-- iConstructionType is a number that identifies what was produced (0 is unit, 1 is building, 2 is district)
-- unitID is the number identifier for the produced item, depends on iConstructionType (0 is monument, 4 is library)
-- bCancelled is not clear, mostly just false
local function AssignPropertyOnBuildingCompletion(playerID, cityID, iConstructionType, unitID, bCancelled)
	-- monument
	if iConstructionType == 1 and unitID == 0 then
		AssignPropertyToCityCenter("Monument", playerID, cityID);
	end
	-- library
	if iConstructionType == 1 and unitID == 4 then
		AssignPropertyToDistrict("Library", playerID, cityID, scienceDistricts);
	end
	-- university
	if iConstructionType == 1 and unitID == 16 then
		AssignPropertyToDistrict("University", playerID, cityID, scienceDistricts);
	end
	-- research lab
	if iConstructionType == 1 and unitID == 36 then
		AssignPropertyToDistrict("Research Lab", playerID, cityID, scienceDistricts);
	end
	-- amphitheater
	if iConstructionType == 1 and unitID == 14 then
		AssignPropertyToDistrict("Amphitheater", playerID, cityID, cultureDistricts);
	end
	-- art museum
	if iConstructionType == 1 and unitID == 23 then
		AssignPropertyToDistrict("Art Museum", playerID, cityID, cultureDistricts);
	end
	-- artifact museum
	if iConstructionType == 1 and unitID == 24 then
		AssignPropertyToDistrict("Archaeological Museum", playerID, cityID, cultureDistricts);
	end
	-- broadcast center
	if iConstructionType == 1 and unitID == 34 then
		AssignPropertyToDistrict("Broadcast Center", playerID, cityID, cultureDistricts);
	end
end

-- no clue what the parameters after districtType and before percentComplete represent
-- but I need to value after it, so they are skipped
local function OnDistrictAdded(playerID, districtID, cityID, plotX, plotY, districtType, _, _, percentComplete)
	-- adding the plot to the list of plots owned by the player
	playerPlots[playerID][#playerPlots[playerID] + 1] = Map.GetPlot(plotX, plotY);
end

local function OnDistrictRemoved(playerID, districtID, cityID, plotX, plotY, districtType)
	-- removing the plot from the list of plots owned by the player
	-- finding the index of this plot from the list of the player's district plots
	local foundOnce = false;
	for plotIndex, plot in pairs(playerPlots[playerID]) do
		if plot:GetX() == plotX and plot:GetY() == plotY then
			table.remove(playerPlots[playerID], plotIndex);
			foundOnce = true;
		end
	end
	-- ensure that at least one plot was removed the plot from the list
	if foundOnce == false then
		print("ERROR: The removed district was not attached to a player!");
	end
end

-- function to track each player's progress in the tech tree
local function OnResearchCompleted(playerID, techID)
	if PlayerManager.GetPlayer(playerID):IsMajor() then
		techProgress[playerID] = techProgress[playerID] + 1;
	end
end

-- function to track each player's progress in the civics tree
local function OnCivicCompleted(playerID, civicID)
	if PlayerManager.GetPlayer(playerID):IsMajor() then
		civicsProgress[playerID] = civicsProgress[playerID] + 1;
	end
end

-- Assigning properties
Events.CityProductionCompleted.Add(AssignPropertyOnBuildingCompletion);
Events.TurnBegin.Add(ApplyProperties);

-- City changing hands
Events.DistrictAddedToMap.Add(OnDistrictAdded);
Events.DistrictRemovedFromMap.Add(OnDistrictRemoved);

-- Tracking progress
Events.ResearchCompleted.Add(OnResearchCompleted);
Events.CivicCompleted.Add(OnCivicCompleted);
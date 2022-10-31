-- function to output all available requirement types --
local function OutputAllRequirementTypes()
	-- TAKEN FROM https://civ6pedia.x0.com/guide/modifier03.html --
	for row in GameInfo.Types() do
		if row.Kind == "KIND_REQUIREMENT" then
			print("\t" .. row.Type);
		end
	end
end

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
		for _, plot in pairs(playerPlots) do
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
	for _, playerPlots in pairs(sciencePlots) do
		for _, plot in pairs(playerPlots) do
			-- TODO: Bring back the conditional logic to check if the player is behind
			if true then
				print("Library property found at (" .. plot:GetX() .. ", " .. plot:GetY() .. ")");
				plot:SetProperty("SAM_ENABLE_SCIENCE_BONUS", 1);
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

	-- TODO: ignore minor powers to fix some errors
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

	if iConstructionType == 1 and unitID == 4 then
		print("Library was created by player " .. playerID .. " in city " .. cityID);
		local player = Players[playerID];
		local city = player:GetCities():FindID(cityID);
		local cityPlot = city:GetPlot();
		sciencePlots[playerID][#sciencePlots[playerID] + 1] = cityPlot;
	end
end

-- Events.TurnBegin.Add(OutputAllRequirementTypes); --
Events.CityProductionCompleted.Add(AssignPropertyOnBuildingCompletion);
Events.TurnBegin.Add(ApplyProperties);
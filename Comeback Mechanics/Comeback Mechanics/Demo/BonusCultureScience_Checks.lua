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
-- TODO: replace with code that reads the player count and generates from that --
local plots = {};
plots[0] = {};
plots[1] = {};

local function DetectProperty()
	for _, playerPlots in pairs(plots) do
		for _, plot in pairs(playerPlots) do
			if plot:GetProperty("SAM_ENABLE_MONUMENT_BONUS") == 1 then
				print("Monument property found at (" .. plot:GetX() .. ", " .. plot:GetY() .. ")");
			end
		end
	end
end

-- playerID is the number for the player that triggered the event (0 is first player) --
-- cityID is the number for the city that triggered the event (65536 is capital) --
-- iConstructionType is a number that identifies what was produced (0 is unit, 1 is building, 2 is district) --
-- unitID is the number identifier for the produced item, depends on iConstructionType (0 is monument, 4 is library) --
-- bCancelled is not clear, mostly just false --
local function AssignPropertyOnBuildingCompletion(playerID, cityID, iConstructionType, unitID, bCancelled)
	-- print("Completed production") --
	-- print("\tplayerID: " .. playerID); --
	-- print("\tcityID: " .. cityID); --
	-- print("\tiConstructionType: " .. iConstructionType); --
	-- print("\tunitID: " .. unitID); --
	-- print("\tbCancelled: " .. tostring(bCancelled)); --

	if iConstructionType == 1 and unitID == 0 then
		print("Monument was created by player " .. playerID .. " in city " .. cityID);
		-- local cityPlot = CityManager.GetCity(cityID):GetPlot();
		-- local living_players = PlayerManager.GetAliveMajors();
		local player = Players[playerID];
		local city = player:GetCities():FindID(cityID);
		local cityPlot = city:GetPlot();
		cityPlot:SetProperty("SAM_ENABLE_MONUMENT_BONUS", 1);
		plots[playerID][#plots[playerID] + 1] = cityPlot;
	end

	if iConstructionType == 1 and unitID == 4 then
		print("Library was created by player " .. playerID .. " in city " .. cityID);
	end
end

-- Events.TurnBegin.Add(OutputAllRequirementTypes); --
Events.CityProductionCompleted.Add(AssignPropertyOnBuildingCompletion);
Events.TurnBegin.Add(DetectProperty);
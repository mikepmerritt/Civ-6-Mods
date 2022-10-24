-- function to output all available requirement types --
local function OutputAllRequirementTypes()
	-- TAKEN FROM https://civ6pedia.x0.com/guide/modifier03.html --
	for row in GameInfo.Types() do
		if row.Kind == "KIND_REQUIREMENT" then
			print("\t" .. row.Type);
		end
	end
end

-- playerID is the number for the player that triggered the event (0 is first player) --
-- cityID is the number for the city that triggered the event (65536 is capital) --
-- iConstructionType is a number that identifies what was produced (0 is unit, 1 is building, 2 is district) --
-- unitID is the number identifier for the produced item, depends on iConstructionType (0 is monument, 4 is library) --
-- bCancelled is not clear, mostly just false --
local function AssignPropertyOnBuildingCompletion(playerID, cityID, iConstructionType, unitID, bCancelled)
	print("Completed production")
	print("\tplayerID: " .. playerID);
	print("\tcityID: " .. cityID);
	print("\tiConstructionType: " .. iConstructionType);
	print("\tunitID: " .. unitID);
	print("\tbCancelled: " .. tostring(bCancelled));
end

local function Initialize()
	-- Events.TurnBegin.Add(OutputAllRequirementTypes); --
	Events.CityProductionCompleted.Add(AssignPropertyOnBuildingCompletion);
end

Initialize();
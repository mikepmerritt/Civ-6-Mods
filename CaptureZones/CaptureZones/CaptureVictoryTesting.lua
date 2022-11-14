local function PrintStuff()
    local requirementSetID:number = Game.GetVictoryRequirements(PlayerManager.GetAliveMajors()[1]:GetTeam(), victoryType);
    print(requirementSetID);
    if requirementSetID ~= nil and requirementSetID ~= -1 then

        local detailsText:string = "";
        local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);

        for _, requirementID in ipairs(innerRequirements) do
            print(requirementID);
            local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, "VictoryProgress");
            print(requirementKey);
            local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);
            print(requirementText);
        end
    end
end

local function Initialize()
	Events.TurnEnd.Add(PrintStuff);
end

Initialize();
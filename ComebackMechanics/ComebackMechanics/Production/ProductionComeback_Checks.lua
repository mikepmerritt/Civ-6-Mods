local playerList = PlayerManager.GetAliveMajors();

local function PrintCityProduction()
    for _, player in pairs(playerList) do
        print("Player " .. player:GetID());
        for _, city in player:GetCities():Members() do
            print("City " .. city:GetName() .. " Production: " .. city:GetYield(YieldTypes.PRODUCTION));
        end
    end
end

Events.TurnBegin.Add(PrintCityProduction);

-- Fetching the military strength of a player is UI only
-- local function PrintCombatRating()
--     for _, player in pairs(playerList) do
--         print("Player " .. player:GetID() .. " Combat Rating: " .. player:GetStats():GetMilitaryStrength());
--     end
-- end

-- Events.TurnBegin.Add(PrintCombatRating);
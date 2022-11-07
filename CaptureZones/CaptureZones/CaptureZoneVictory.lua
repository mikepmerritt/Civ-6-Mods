local function CheckIfPlayerHasWon()
    local mapWidth, mapHeight = Map.GetGridSize()
    for _, player in pairs(PlayerManager.GetAliveMajorIDs()) do
        local count = 0
        for x=1,mapWidth do
            for y=1,mapHeight do
                local id = "(" .. x .. ", " .. y .. ")"
                local currPlot = Map.GetPlot(x, y)
                if currPlot ~= nil and currPlot:GetProperty("CAPTURE_SAM") ~= nil and currPlot:GetOwner() == player then
                    print(id .. " belongs to " .. player)
                    count = count + 1
                end
            end
        end

        print(player .. "'s count was " .. count)

        local goal = 3 + PlayerManager.GetWasEverAliveMajorsCount()
        if count >= goal then
            print(player .. " has met the win condition, and their capital has been marked")
            PlayerManager.GetPlayer(playerId):GetCities():GetCapitalCity():GetPlot():SetProperty("CAPTURE_VICTORY_SAM", 1)
        end
    end
end

local function Initialize()
    Events.TurnEnd.Add(CheckIfPlayerHasWon)
end

Initialize()


local function PrintEraChange(previousEra, newEra)
	print("The era has changed from " .. tostring(previousEra) .. " to " .. tostring(newEra) .. "!")
	if newEra > 0 and newEra % 2 == 0 then
		print("This is an era where a location should be selected.")
		print("Lucky tile is at location (10, 11) for fun.")
		local luckyPlot = Map.GetPlot(10, 11) -- gets plot at (10, 11)
		print("Owner of lucky tile: " .. luckyPlot:GetOwner())
		print("Yield of lucky tile: " .. luckyPlot:GetYield())
		print("Resource type of lucky tile: " .. luckyPlot:GetResourceType())
		print("Terrain type of lucky tile: " .. luckyPlot:GetTerrainType())
	end
end

local function Initialize()
	print("GSDM: Initialized LUA script.")
	Events.GameEraChanged.Add(PrintEraChange)
end

Initialize()

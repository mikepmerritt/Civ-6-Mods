local function PrintEraChange(previousEra, newEra)
	print("The era has changed from " .. tostring(previousEra) .. " to " .. tostring(newEra) .. "!")
end

local function Initialize()
	print("GSDM: Initialized LUA script.")
	Events.GameEraChanged.Add(PrintEraChange)
end

Initialize()

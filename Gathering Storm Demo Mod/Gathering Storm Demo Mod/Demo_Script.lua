local function EraChangePrinter()
	print("The era has changed!")
end

local function Initialize()
	print("GSDM: Initialized LUA script.")
	Events.GameEraChanged.Add(EraChangePrinter)
end

Initialize()

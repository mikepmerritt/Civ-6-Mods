-- fetching and printing out all requirement sets
local function GetAllRequirementSets()
	-- getting requirement set details, taken from the live tuner panel Requirements.ltp --
    if (GameEffects) then
        local requirement_sets = GameEffects.GetRequirementSets() or { };
        for i, v in ipairs(requirement_sets) do
            local req_set_def = GameEffects.GetRequirementSetDefinition(v);
            local subject = GameEffects.GetRequirementSetSubject(v);
            local subject_name = Locale.Lookup(GameEffects.GetObjectName(subject) or "");
            local context = GameEffects.GetRequirementSetContext(v);
            local context_name = Locale.Lookup(GameEffects.GetObjectName(context) or "");
            local state = GameEffects.GetRequirementSetState(v);
            local inner_count = #(GameEffects.GetRequirementSetInnerRequirements(v) or {});
            local ref_count = GameEffects.GetRequirementSetReferenceCount(v);

			-- only checking for requirement sets with name PLAYER_FALLS_BEHIND_CULTURE_SAM
			if (req_set_def.Id == "PLAYER_FALLS_BEHIND_CULTURE_SAM") then
				print("i: " .. i .. " v: " .. v);
				print("defId: " .. req_set_def.Id);
				print("subject: " .. subject);
				print("subject_name: " .. subject_name);
				print("context: " .. context);
				print("context_name: " .. context_name);
				print("state: " .. state);
				print("inner_count: " .. inner_count);
				print("ref_count: " .. ref_count);
			end
        end
    end
end

local function TestOutput()
	-- check player's culture compared to other players --
	local living_players = PlayerManager.GetAliveMajors();
	print("checking players");

	local target_player_index = -1;
	-- determining which player owns the city --
	for player_index, player in ipairs(living_players) do
		print("player: " .. player_index);
		local cities = player:GetCities();

		for city_index, city in cities:Members() do
			-- getting the city name, taken from the live tuner panel City.ltp --
			local cityName = string.gsub(city:GetName(), "LOC_CITY_NAME_", "");
			local cityLocName = string.upper(Locale.Lookup(city:GetName()));
			if ( #cityName > #cityLocName ) then
				cityName = cityLocName;
			end

			local cityId = city:GetID();
            print("\tcity: " .. city_index .. ", city name: " .. cityName .. ", city localized name: " .. cityLocName .. ", city ID: " .. cityId);
		end
						
	end

	-- useful: PlayerStats:GetNumCivicsCompleted() --
end

local function Initialize()
    Events.TurnEnd.Add(GetAllRequirementSets);
	Events.TurnBegin.Add(TestOutput);
end

Initialize()
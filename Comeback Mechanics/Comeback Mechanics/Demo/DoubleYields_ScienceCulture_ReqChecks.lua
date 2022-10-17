-- fetching and printing out all requirement sets
local function GetAllRequirementSets()
	-- getting requirement set details, taken from the live tuner panel Requirements.ltp --
    if (GameEffects) then
        local requirement_sets = GameEffects.GetRequirementSets() or { };
        for i, v in ipairs(requirement_sets) do
            local req_set_def = GameEffects.GetRequirementSetDefinition(v);
            local subject_id = GameEffects.GetRequirementSetSubject(v);
			local subject_name = GameEffects.GetObjectName(subject_id) or "";
            local context_id = GameEffects.GetRequirementSetContext(v);
			local context_name = GameEffects.GetObjectName(context_id) or "";
            local state = GameEffects.GetRequirementSetState(v);

			-- only checking for requirement sets with name PLAYER_FALLS_BEHIND_CULTURE_SAM and PLAYER_FALLS_BEHIND_SCIENCE_SAM
			if (req_set_def.Id == "PLAYER_FALLS_BEHIND_CULTURE_SAM" or req_set_def.Id == "PLAYER_FALLS_BEHIND_SCIENCE_SAM") then
				print("i: " .. i .. " v: " .. v);
				print("defId: " .. req_set_def.Id);
				print("subject_id: " .. subject_id);
				print("subject_name: " .. subject_name);
				print("context_id: " .. context_id);
				print("context_name: " .. context_name);
				print("state: " .. state);

				-- check player's culture compared to other players --
				local living_players = PlayerManager.GetAliveMajors();

				local target_player_index = -1;
				-- determining which player owns the city --
				for player_index, player in ipairs(living_players) do
					local cities = player:GetCities();

					for city_index, city in cities:Members() do
						local city_name = city:GetName();

						if (city_name == subject_name) then
							target_player_index = player_index;
						end
					end
				end

                -- initially hoped to see if they were a set amount of civics behind --
                -- PlayerStats:GetNumCivicsCompleted() was UI only, so an alternative was found --
				if (target_player_index ~= -1) then
                    local target_player = living_players[target_player_index];
                    if (target_player == nil) then
                        print("Player is null");
                    elseif (target_player:GetCulture() == nil) then
                        print("Culture stats are null");
					
					elseif (target_player:GetCulture():GetCultureYield() == nil) then
                        print("Culture yield is null");
                    else
                        print("Culture yield: " .. target_player:GetCulture():GetCultureYield());
                    end
				else
					print("Player associated with this city could not be found");
				end
			end
        end
    end
end

local function Initialize()
    Events.TurnEnd.Add(GetAllRequirementSets);
end

Initialize()
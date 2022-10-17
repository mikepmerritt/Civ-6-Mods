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
				-- determining which player owns the city --
				local living_players = PlayerManager.GetAliveMajors();
				local target_player_index = -1;
				
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
					-- providing details about the requirement --
					print("i: " .. i .. " v: " .. v);
					print("defId: " .. req_set_def.Id);
					print("subject_id: " .. subject_id);
					print("subject_name: " .. subject_name);
					print("context_id: " .. context_id);
					print("context_name: " .. context_name);
					print("state: " .. state);

					if (req_set_def.Id == "PLAYER_FALLS_BEHIND_CULTURE_SAM") then 
						-- fetching the culture of the player with the building --
						local target_player_culture = living_players[target_player_index]:GetCulture():GetCultureYield();
						print("Culture yield: " .. target_player_culture);

						-- checking opponent culture -- 
						local opponent_player_index = 1;
						if (target_player_index == 1) then
							opponent_player_index = 2;
						end
						local opponent_player_culture = living_players[opponent_player_index]:GetCulture():GetCultureYield();
						print("Opponent culture yield: " .. opponent_player_culture);

						-- NOTE: THIS IS NOT WORKING SINCE I HAVE NOT FOUND A WAY TO UPDATE A REQUIREMENT STATE --
						-- if behind, activate modifiers --
						local req_def = GameEffects.GetRequirementDefinition(v-1);
						if (opponent_player_culture - 3 > target_player_culture) then
							print("Player has fallen behind in culture!");
							print("ReqId: " .. req_def.Id);
							--GameEffects.SetRequirementState(v-1, "Met");--
						-- else deactivate modifiers --
						else 
							print("Player is on track in culture.");
							print("ReqId: " .. req_def.Id);
							--GameEffects.SetRequirementState(v-1, "NotMet");--
						end
					elseif (req_set_def.Id == "PLAYER_FALLS_BEHIND_SCIENCE_SAM") then
						print("Science yield: " .. living_players[target_player_index]:GetTechs():GetScienceYield());
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
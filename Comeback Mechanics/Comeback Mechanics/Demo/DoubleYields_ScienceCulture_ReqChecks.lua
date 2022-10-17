-- fetching and printing out all requirement sets
local function GetAllRequirementSets()
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

			if (subject_name == "City Center") then
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

local function Initialize()
    Events.TurnBegin.Add(GetAllRequirementSets);
end

Initialize()
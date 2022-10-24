-- Attempt 3 at creating comeback mechanics by adding new modifiers to science and culture buildings --

-- New requirement sets and requirements --
INSERT INTO Requirements (RequirementId, RequirementType, Likeliness, Impact, Reverse, Persistent, ProgressWeight, Triggered) VALUES ('REQUIRES_HAS_BEHIND_SCIENCE_SAM', 'REQUIREMENT_PLOT_PROPERTY_MATCHES', 0, 0, 0, 0, 1, 0);
INSERT INTO Requirements (RequirementId, RequirementType, Likeliness, Impact, Reverse, Persistent, ProgressWeight, Triggered) VALUES ('REQUIRES_HAS_BEHIND_CULTURE_SAM', 'REQUIREMENT_PLOT_PROPERTY_MATCHES', 0, 0, 0, 0, 1, 0);

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('PLAYER_FALLS_BEHIND_SCIENCE_SAM', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('PLAYER_FALLS_BEHIND_CULTURE_SAM', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('PLAYER_FALLS_BEHIND_SCIENCE_SAM', 'REQUIRES_HAS_BEHIND_SCIENCE_SAM');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('PLAYER_FALLS_BEHIND_CULTURE_SAM', 'REQUIRES_HAS_BEHIND_CULTURE_SAM');

-- New modifiers and arguments --
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent, Repeatable, SubjectRequirementSetId) VALUES ('BONUS_SCIENCE_YIELD_SAM', 'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE', 0, 0, 0, 0, 'PLAYER_FALLS_BEHIND_SCIENCE_SAM');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent, Repeatable, SubjectRequirementSetId) VALUES ('BONUS_CULTURE_YIELD_SAM', 'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE', 0, 0, 0, 0, 'PLAYER_FALLS_BEHIND_CULTURE_SAM');

INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('BONUS_SCIENCE_YIELD_SAM', 'YieldType', 'ARGTYPE_IDENTITY', 'YIELD_SCIENCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('BONUS_SCIENCE_YIELD_SAM', 'Amount', 'ARGTYPE_IDENTITY', 1);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('BONUS_CULTURE_YIELD_SAM', 'YieldType', 'ARGTYPE_IDENTITY', 'YIELD_CULTURE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('BONUS_CULTURE_YIELD_SAM', 'Amount', 'ARGTYPE_IDENTITY', 1);

-- Attaching modifiers to buildings --
-- Currently only attached to library and monument --
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_LIBRARY', 'BONUS_SCIENCE_YIELD_SAM');
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_MONUMENT', 'BONUS_CULTURE_YIELD_SAM');
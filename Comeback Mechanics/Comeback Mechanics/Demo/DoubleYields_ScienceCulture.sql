-- Creating comeback mechanics by adding new modifiers to science and culture buildings --
-- These modifiers will require the player to have fallen behind by multiple techs/civics --

-- Initial attempt to make a new requirement type --
--INSERT INTO Types (Type, Kind) VALUES ('REQUIREMENT_PLAYER_FELL_BEHIND_SAM', 'KIND_REQUIREMENT');
--INSERT INTO Requirements (RequirementId, RequirementType, Likeliness, Impact, Reverse, Persistent, ProgressWeight, Triggered) VALUES ('REQUIRES_HAS_BEHIND_SCIENCE_SAM', 'REQUIREMENT_PLAYER_FELL_BEHIND_SAM', 0, 0, 0, 0, 1, 0);
--INSERT INTO Requirements (RequirementId, RequirementType, Likeliness, Impact, Reverse, Persistent, ProgressWeight, Triggered) VALUES ('REQUIRES_HAS_BEHIND_CULTURE_SAM', 'REQUIREMENT_PLAYER_FELL_BEHIND_SAM', 0, 0, 0, 0, 1, 0);

-- New requirement sets and requirements --
INSERT INTO Requirements (RequirementId, RequirementType, Likeliness, Impact, Reverse, Persistent, ProgressWeight, Triggered) VALUES ('REQUIRES_HAS_BEHIND_SCIENCE_SAM', 'REQUIREMENT_MET', 0, 0, 0, 0, 1, 0);
INSERT INTO Requirements (RequirementId, RequirementType, Likeliness, Impact, Reverse, Persistent, ProgressWeight, Triggered) VALUES ('REQUIRES_HAS_BEHIND_CULTURE_SAM', 'REQUIREMENT_MET', 0, 0, 0, 0, 1, 0);

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('PLAYER_FALLS_BEHIND_SCIENCE_SAM', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('PLAYER_FALLS_BEHIND_CULTURE_SAM', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('PLAYER_FALLS_BEHIND_SCIENCE_SAM', 'REQUIRES_HAS_BEHIND_SCIENCE_SAM');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('PLAYER_FALLS_BEHIND_CULTURE_SAM', 'REQUIRES_HAS_BEHIND_CULTURE_SAM');

-- New modifiers and arguments --
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent, Repeatable, SubjectRequirementSetId) VALUES ('DOUBLE_SCIENCE_YIELD_SAM', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIER', 0, 0, 0, 0, 'PLAYER_FALLS_BEHIND_SCIENCE_SAM');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent, Repeatable, SubjectRequirementSetId) VALUES ('DOUBLE_CULTURE_YIELD_SAM', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIER', 0, 0, 0, 0, 'PLAYER_FALLS_BEHIND_CULTURE_SAM');

INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('DOUBLE_SCIENCE_YIELD_SAM', 'YieldType', 'ARGTYPE_IDENTITY', 'YIELD_SCIENCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('DOUBLE_SCIENCE_YIELD_SAM', 'BuildingType', 'ARGTYPE_IDENTITY', 'BUILDING_LIBRARY');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('DOUBLE_SCIENCE_YIELD_SAM', 'Amount', 'ARGTYPE_IDENTITY', 100);
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('DOUBLE_CULTURE_YIELD_SAM', 'YieldType', 'ARGTYPE_IDENTITY', 'YIELD_CULTURE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('DOUBLE_CULTURE_YIELD_SAM', 'BuildingType', 'ARGTYPE_IDENTITY', 'BUILDING_MONUMENT');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('DOUBLE_CULTURE_YIELD_SAM', 'Amount', 'ARGTYPE_IDENTITY', 100);

-- Attaching modifiers to buildings --
-- Currently only attached to library and monument --
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_LIBRARY', 'DOUBLE_SCIENCE_YIELD_SAM');
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_MONUMENT', 'DOUBLE_CULTURE_YIELD_SAM');
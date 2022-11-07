-- Attempt 3 at creating comeback mechanics by adding new modifiers to science and culture buildings

-- New requirement sets, requirements, and arguments
INSERT INTO Requirements (RequirementId, RequirementType, Likeliness, Impact, Reverse, Persistent, ProgressWeight, Triggered) VALUES
('REQUIRES_HAS_BEHIND_SCIENCE_SAM', 'REQUIREMENT_PLOT_PROPERTY_MATCHES', 0, 0, 0, 0, 1, 0),
('REQUIRES_HAS_BEHIND_CULTURE_SAM', 'REQUIREMENT_PLOT_PROPERTY_MATCHES', 0, 0, 0, 0, 1, 0);

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
('REQUIRES_HAS_BEHIND_SCIENCE_SAM', 'PropertyName', 'SAM_ENABLE_SCIENCE_BONUS'),
('REQUIRES_HAS_BEHIND_SCIENCE_SAM', 'PropertyMinimum', 1),
('REQUIRES_HAS_BEHIND_CULTURE_SAM', 'PropertyName', 'SAM_ENABLE_CULTURE_BONUS'),
('REQUIRES_HAS_BEHIND_CULTURE_SAM', 'PropertyMinimum', 1);

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('PLAYER_FALLS_BEHIND_SCIENCE_SAM', 'REQUIREMENTSET_TEST_ALL'),
('PLAYER_FALLS_BEHIND_CULTURE_SAM', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('PLAYER_FALLS_BEHIND_SCIENCE_SAM', 'REQUIRES_HAS_BEHIND_SCIENCE_SAM'),
('PLAYER_FALLS_BEHIND_SCIENCE_SAM', 'REQUIRES_MAJOR_CIV_OPPONENT'),
('PLAYER_FALLS_BEHIND_CULTURE_SAM', 'REQUIRES_HAS_BEHIND_CULTURE_SAM'),
('PLAYER_FALLS_BEHIND_CULTURE_SAM', 'REQUIRES_MAJOR_CIV_OPPONENT');

-- New modifiers and arguments
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent, Repeatable, SubjectRequirementSetId) VALUES 
('BONUS_SCIENCE_YIELD_SAM', 'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE', 0, 0, 0, 0, 'PLAYER_FALLS_BEHIND_SCIENCE_SAM'),
('BONUS_CULTURE_YIELD_SAM', 'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE', 0, 0, 0, 0, 'PLAYER_FALLS_BEHIND_CULTURE_SAM');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('BONUS_SCIENCE_YIELD_SAM', 'YieldType', 'YIELD_SCIENCE'),
('BONUS_SCIENCE_YIELD_SAM', 'Amount', 1),
('BONUS_CULTURE_YIELD_SAM', 'YieldType', 'YIELD_CULTURE'),
('BONUS_CULTURE_YIELD_SAM', 'Amount', 1);

-- Attaching modifiers to buildings
-- Currently only attached to library and monument
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES 
('BUILDING_LIBRARY', 'BONUS_SCIENCE_YIELD_SAM'),
('BUILDING_MONUMENT', 'BONUS_CULTURE_YIELD_SAM');
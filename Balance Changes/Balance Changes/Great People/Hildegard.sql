-- Modifiers --
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent, Repeatable) VALUES ('GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM', 'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS', 1, 0, 1, 0);
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent, Repeatable, SubjectRequirementSetId) VALUES ('GREATPERSON_CAMPUS_PROPHET_POINTS_SAM', 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', 0, 0, 0, 0, 'DISTRICT_IS_CAMPUS');

-- GreatPersonIndividuals --
UPDATE GreatPersonIndividuals
SET ActionRequiresCompletedDistrictType = 'DISTRICT_CAMPUS'
WHERE GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN';

-- GreatPersonIndividualActionModifiers --
UPDATE GreatPersonIndividualActionModifiers
SET ModifierId = 'GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM'
WHERE GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN' AND ModifierId = 'GREATPERSON_HOLY_SITE_ADJACENCY_AS_SCIENCE';

UPDATE GreatPersonIndividualActionModifiers
SET ModifierId = 'GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM'
WHERE GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN' AND ModifierId = 'GREATPERSON_FAITH';

-- ModifierStrings --
INSERT INTO ModifierStrings (ModifierId, Context, Text) VALUES ('GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM', 'Context', 'LOC_GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM');
INSERT INTO ModifierStrings (ModifierId, Context, Text) VALUES ('GREATPERSON_CAMPUS_PROPHET_POINTS_SAM', 'Context', 'LOC_GREATPERSON_CAMPUS_PROPHET_POINTS_SAM');

-- ModifierArguments --
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM', 'YieldTypeToMirror', 'ARGTYPE_IDENTITY', 'YIELD_SCIENCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM', 'YieldTypeToGrant', 'ARGTYPE_IDENTITY', 'YIELD_FAITH');

-- TODO: add argument modifiers for GREATPERSON_CAMPUS_PROPHET_POINTS_SAM --
-- TODO: add separate script with localized text that is missing -- 
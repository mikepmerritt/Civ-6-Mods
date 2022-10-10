-- bonus 1: campus yields give faith as well
-- Modifiers --
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent, Repeatable) VALUES ('GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM', 'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS', 1, 0, 1, 0);

-- GreatPersonIndividuals --
UPDATE GreatPersonIndividuals
SET ActionRequiresCompletedDistrictType = 'DISTRICT_CAMPUS'
WHERE GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN';

-- GreatPersonIndividualActionModifiers --
-- replacing the holy site science yield with the campus faith yield --
UPDATE GreatPersonIndividualActionModifiers
SET ModifierId = 'GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM'
WHERE GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN' AND ModifierId = 'GREATPERSON_HOLY_SITE_ADJACENCY_AS_SCIENCE';

-- ModifierStrings --
INSERT INTO ModifierStrings (ModifierId, Context, Text) VALUES ('GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM', 'Summary', 'LOC_GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM');

-- ModifierArguments --
-- adding the arguments for the modifier that handles converting science yield to faith --
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM', 'YieldTypeToMirror', 'ARGTYPE_IDENTITY', 'YIELD_SCIENCE');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM', 'YieldTypeToGrant', 'ARGTYPE_IDENTITY', 'YIELD_FAITH');

-- bonus 2: adding great prophet points to the campus
-- creating new modifier type --
INSERT INTO Types (Type, Kind) VALUES ('MODIFIER_SINGLE_CITY_DISTRICT_ADJUST_GREAT_PERSON_POINTS_SAM', 'KIND_MODIFIER');

INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType) VALUES ('MODIFIER_SINGLE_CITY_DISTRICT_ADJUST_GREAT_PERSON_POINTS_SAM', 'COLLECTION_OWNER', 'EFFECT_ADJUST_DISTRICT_GREAT_PERSON_POINTS');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent, Repeatable, SubjectRequirementSetId) VALUES ('GREATPERSON_CAMPUS_PROPHET_POINTS_SAM', 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', 0, 0, 1, 0, 'DISTRICT_IS_CAMPUS');

-- replacing the additional faith modifier with the great prophet points one --
UPDATE GreatPersonIndividualActionModifiers
SET ModifierId = 'GREATPERSON_CAMPUS_PROPHET_POINTS_SAM'
WHERE GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN' AND ModifierId = 'GREATPERSON_FAITH';

INSERT INTO ModifierStrings (ModifierId, Context, Text) VALUES ('GREATPERSON_CAMPUS_PROPHET_POINTS_SAM', 'Summary', 'LOC_GREATPERSON_CAMPUS_PROPHET_POINTS_SAM');

-- adding the arguments for the modifier that handles adding great prophet points to the campus yields --
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('GREATPERSON_CAMPUS_PROPHET_POINTS_SAM', 'GreatPersonClassType', 'ARGTYPE_IDENTITY', 'GREAT_PERSON_CLASS_PROPHET');
INSERT INTO ModifierArguments (ModifierId, Name, Type, Value) VALUES ('GREATPERSON_CAMPUS_PROPHET_POINTS_SAM', 'Amount', 'ARGTYPE_IDENTITY', 4);

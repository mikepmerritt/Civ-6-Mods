INSERT INTO Types (Type, Kind) VALUES 
('IMPROVEMENT_SCIENCE_CENTER_SAM', 'KIND_IMPROVEMENT'),
('IMPROVEMENT_CULTURE_CENTER_SAM', 'KIND_IMPROVEMENT'),
('IMPROVEMENT_PRODUCTION_CENTER_SAM', 'KIND_IMPROVEMENT');

INSERT INTO Improvements (ImprovementType, Name, PrereqTech, PrereqCivic, Buildable, Description, PlunderType, PlunderAmount, Icon) VALUES
('IMPROVEMENT_SCIENCE_CENTER_SAM', 'LOC_IMPROVEMENT_SCIENCE_CENTER_SAM_NAME', 'TECH_EDUCATION', NULL, 1, 'LOC_IMPROVEMENT_SCIENCE_CENTER_SAM_DESCRIPTION', 'PLUNDER_SCIENCE', 100, 'ICON_IMPROVEMENT_SEASTEAD'),
('IMPROVEMENT_CULTURE_CENTER_SAM', 'LOC_IMPROVEMENT_CULTURE_CENTER_SAM_NAME', NULL, 'CIVIC_FEUDALISM', 1, 'LOC_IMPROVEMENT_CULTURE_CENTER_SAM_DESCRIPTION', 'PLUNDER_CULTURE', 100, 'ICON_IMPROVEMENT_POLDER'),
('IMPROVEMENT_PRODUCTION_CENTER_SAM', 'LOC_IMPROVEMENT_PRODUCTION_CENTER_SAM_NAME', 'TECH_MILITARY_TACTICS', NULL, 1, 'LOC_IMPROVEMENT_PRODUCTION_CENTER_SAM_DESCRIPTION', 'PLUNDER_GOLD', 100, 'ICON_IMPROVEMENT_FEITORIA');

INSERT INTO Improvement_ValidResources (ImprovementType, ResourceType) VALUES
('IMPROVEMENT_SCIENCE_CENTER_SAM', 'RESOURCE_VICTORY_POINTS_SAM'),
('IMPROVEMENT_CULTURE_CENTER_SAM', 'RESOURCE_VICTORY_POINTS_SAM'),
('IMPROVEMENT_PRODUCTION_CENTER_SAM', 'RESOURCE_VICTORY_POINTS_SAM');

INSERT INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
('IMPROVEMENT_SCIENCE_CENTER_SAM', 'YIELD_SCIENCE', 3),
('IMPROVEMENT_CULTURE_CENTER_SAM', 'YIELD_CULTURE', 3),
('IMPROVEMENT_PRODUCTION_CENTER_SAM', 'YIELD_PRODUCTION', 4);

INSERT INTO Improvement_BonusYieldChanges (Id, ImprovementType, YieldType, BonusYieldChange, PrereqTech, PrereqCivic) VALUES
(300, 'IMPROVEMENT_SCIENCE_CENTER_SAM', 'YIELD_SCIENCE', 2, 'TECH_SCIENTIFIC_THEORY', NULL),
(301, 'IMPROVEMENT_CULTURE_CENTER_SAM', 'YIELD_CULTURE', 2, NULL, 'CIVIC_OPERA_BALLET'),
(302, 'IMPROVEMENT_PRODUCTION_CENTER_SAM', 'YIELD_PRODUCTION', 2, 'TECH_MILITARY_SCIENCE', NULL);

INSERT INTO Improvement_ValidBuildUnits (ImprovementType, UnitType) VALUES
('IMPROVEMENT_SCIENCE_CENTER_SAM', 'UNIT_MILITARY_ENGINEER'),
('IMPROVEMENT_CULTURE_CENTER_SAM', 'UNIT_MILITARY_ENGINEER'),
('IMPROVEMENT_PRODUCTION_CENTER_SAM', 'UNIT_MILITARY_ENGINEER');
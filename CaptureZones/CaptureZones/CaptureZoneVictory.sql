-- Capture zone victory

INSERT INTO Types (Type, Kind) VALUES
('VICTORY_CAPTURE_SAM', 'KIND_VICTORY');

-- INSERT INTO Requirements (RequirementId, RequirementType, Likeliness, Impact, Reverse, Persistent, ProgressWeight, Triggered) VALUES
-- ('REQUIRES_HAS_ENOUGH_CAPTURE_ZONES_SAM', 'REQUIREMENT_PLOT_PROPERTY_MATCHES', 0, 0, 0, 0, 1, 0);

-- INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
-- ('REQUIRES_HAS_ENOUGH_CAPTURE_ZONES_SAM', 'PropertyName', 'CAPTURE_VICTORY_SAM'),
-- ('REQUIRES_HAS_ENOUGH_CAPTURE_ZONES_SAM', 'PropertyMinimum', 1);

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
('REQUIREMENTS_CAPTURE_VICTORY_SAM', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
('REQUIREMENTS_CAPTURE_VICTORY_SAM', 'REQUIRES_TECHNOLOGY_CASTLES');

INSERT INTO Victories (VictoryType, Name, Blurb, RequirementSetId) VALUES
('VICTORY_CAPTURE_SAM', 'LOC_VICTORY_CAPTURE_SAM_NAME', 'LOC_VICTORY_CAPTURE_SAM_TEXT', 'REQUIREMENTS_CAPTURE_VICTORY_SAM');
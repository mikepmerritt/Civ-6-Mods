-- creating atlases for the resources
INSERT INTO IconTextureAtlases (Name, IconSize, IconsPerRow, IconsPerColumn, Filename) VALUES
('ICON_ATLAS_SAM_RESOURCES', 256, 1, 1, 'ICON_SAM_VICTORY_POINTS_256.dds'),
('ICON_ATLAS_SAM_RESOURCES', 64, 1, 1, 'ICON_SAM_VICTORY_POINTS_64.dds'),
('ICON_ATLAS_SAM_RESOURCES', 50, 1, 1, 'ICON_SAM_VICTORY_POINTS_50.dds'),
('ICON_ATLAS_SAM_RESOURCES', 38, 1, 1, 'ICON_SAM_VICTORY_POINTS_38.dds');

-- adding the tiny one for use in text (hopefully)
INSERT INTO IconTextureAtlases (Name, Baseline, IconSize, IconsPerRow, IconsPerColumn, Filename) VALUES
('ICON_ATLAS_SAM_RESOURCES', 6, 22, 1, 1, 'ICON_SAM_VICTORY_POINTS_22.dds');

-- loading icons
INSERT OR REPLACE INTO IconDefinitions (Name, Atlas, 'Index') VALUES
('ICON_RESOURCE_SAM_VICTORY_POINTS', 'ICON_ATLAS_SAM_RESOURCES', 0),
('RESOURCE_VICTORY_POINTS_SAM', 'ICON_ATLAS_SAM_RESOURCES', 0),
('ICON_RESOURCE_VICTORY_POINTS_SAM', 'ICON_ATLAS_SAM_RESOURCES', 0);
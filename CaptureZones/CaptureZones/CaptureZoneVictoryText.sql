-- all text for the victory
-- TODO: fix the blurb - it is actually the text that comes up when you win the game

INSERT INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_PROJECT_SHOW_SUPERIORITY_SAM_NAME', 'Show Superiority'),
('en_US', 'LOC_PROJECT_SHOW_SUPERIORITY_SAM_SHORT_NAME', 'Show Superiority'),
('en_US', 'LOC_PROJECT_SHOW_SUPERIORITY_SAM_DESCRIPTION', 'Show to all of your neighbors that your civilization is not one to be messed with, and that you intend to keep control of your lands and Victory Points. Necessary for a Control Victory.'),
('en_US', 'LOC_PROJECT_EXERT_INFLUENCE_SAM_NAME', 'Exert Influence'),
('en_US', 'LOC_PROJECT_EXERT_INFLUENCE_SAM_SHORT_NAME', 'Exert Influence'),
('en_US', 'LOC_PROJECT_EXERT_INFLUENCE_SAM_DESCRIPTION', 'Demonstrate through your use of Victory Points that your civilization is the most influential in the world. Necessary for a Control Victory.'),
('en_US', 'LOC_VICTORY_CAPTURE_SAM_NAME', 'Control Victory'),
('en_US', 'LOC_VICTORY_CAPTURE_SAM_TEXT', 'Your civilization has proven itself to be the strongest and most influential!'),
('en_US', 'LOC_VICTORY_CAPTURE_SAM_DESCRIPTION', 'Prove that your civilization is the greatest by completing the Show Strength and Exert Influence projects in the Government Plaza using Victory Points! You can gain Victory Points by controlling the key areas they are placed on later in the game.'),
('en_US', 'LOC_VICTORY_CAPTURE_SHOWN_SUPERIORITY_SAM_REQUIREMENT', 'Show Superiority: [ICON_Bolt]'),
('en_US', 'LOC_VICTORY_CAPTURE_EXERTED_INFLUENCE_SAM_REQUIREMENT', 'Exert Influence: [ICON_Bolt]');

-- you can use [ICON_CheckmarkBlue] for a checkmark, and [ICON_Bolt] for the little bullet point
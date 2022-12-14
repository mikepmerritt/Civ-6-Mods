# CaptureZones

## Overview

Initially developed as a project for SER300, the CaptureZones mod seeks to add a new win condition to the game to encourage more aggression, diplomacy, and interaction in multiplayer games. The functionality was inspired by victory cards from *Europa Universalis 4*, in which the game would mark states that were owned by a potential rival as victory conditions to encourage more interesting diplomatic agreements and wars. 

## Features

The CaptureZones mod adds:
- A new strategic resource with high yields called Victory Points, which is placed in border cities at the start of the Classical, Renaissance, and Modern Eras
- Two new projects using Victory Points which can be completed at the Government Plaza for increased unit Combat Strength and Diplomatic Favor generation
- Three new tile improvements for gaining Victory Points as well as production, science, and culture
- A new victory condition for completing both new projects
- A great reason to culture bomb, loyalty flip, or declare war your friends

## Tech Stack

This project is intended to be opened on Windows 10/11, and all the setup instructions assume that you are on one of these operating systems.

At the time of development, the following tools and versions were used:
- *Sid Meier's Civilization VI* - Build ID 6640529, later 9985721
- *Sid Meier's Civilization VI Development Tools* - Build ID 4892607
- *SQLite* - Portable Version 3.12.2

In terms of why we used these tools, we chose the tools that most modders suggested using, as it meant that there would be a lot of tutorials and resources to look at if we needed help with something during the modding process.

## How to Use Project (User)

1. Begin by downloading `CaptureZones.zip` from the most recent release
2. Navigate to your local Civilization VI game files, and select the `Mods` folder
    - For the Steam installation of Civilization VI, the default location is in `Documents` in a folder called `Sid Meier's Civilization VI`
    - As an example of where you need to go, my mods need to go into `C:\Users\scarf\OneDrive\Documents\My Games\Sid Meier's Civilization VI\Mods`
3. Extract the contents of `CaptureZones.zip` into the `Mods` folder
    - If you do this correctly, the folder should now contain a folder named `CaptureZones`
4. Launch the game, and verify that the mod is listed in game by going to `Additional Content -> Mods`

## How to Setup and Run Project (Developer)

See the instructions in the main README.

## File Breakdown

The files in this mod are as follows:

- `CaptureZones.civ6sln` - solution file, use this to import the mod into ModBuddy if editing
- `HelpfulTips.md` - a list of useful information, tips, and function documentation that I made while working on this mod for future reference
- `README.md` - this file (but you probably guessed that)
- `Art/` - directory containing all the custom resource icons as PNGs, not included in builds
- `CaptureZones/` - directory containing all the scripts and textures that the mod needs
    - `XLPs` - directory that contains all our XLP files made in the Asset Editor
        - `/ResourceVictoryPoints.xlp` - built using the Asset Editor, this links the game to the custom icons for victory points
    - `Artdefs/` - directory that contains all our artdef files made in the Asset Editor
        - `UserInterface.artdef` - largely empty, but tells the mod to use the XLP file when built
    - `Icons/` - directory that contains the SQL scripts related to custom icons
        - `Icons.sql` - added icons used in `CaptureZoneResource.sql` using custom strategic resource icons found in the `Art/` Directory
    - `Textures/` - directory containing DDS and TEX files needed to show the icons in game, all made using the AssetEditor
    - `CaptureVictoryConfig.sql` - adds the new victory to the game's database before a game is started/loaded, part of the mod's frontend actions
    - `CaptureVictoryConfigText.sql` - adds localized text used in `CaptureVictoryConfig.sql`, part of the game's frontend actions
    - `CaptureZoneImprovements.sql` - adds the tile improvements and related information to the game's database, part of the mod's in-game actions
    - `CaptureZoneImprovementText.sql` - adds localized text used in `CaptureZoneImprovements.sql`, part of the game's in-game actions
    - `CaptureZoneMarking.lua` - Lua script that contains the events and algorithms for placing the Victory Points resource appropriately, part of the mod's in-game actions
    - `CaptureZoneResource.sql` - adds the Victory Points resource and related information to the game's database, part of the mod's in-game actions
    - `CaptureZoneResourceIcons.sql` - OUTDATED, previously added icons used in `CaptureZoneResource.sql` using existing icons, replaced by `Icons.sql`
    - `CaptureZoneResourceText.sql` - adds localized text used in `CaptureZoneResource.sql`, part of the game's in-game actions
    - `CaptureZoneVictory.sql` - adds the Control Victory, both projects, and related information to the game's database, part of the mod's in-game actions
    - `CaptureZoneVictoryIcons.sql` - adds icons used in `CaptureZoneVictory.sql`, part of the game's in-game actions
    - `CaptureZoneVictoryText.sql` - adds localized text used in `CaptureZoneVictory.sql`, part of the game's in-game actions
    - `CaptureZones.Art.xml` - autogenerated file related to the art assets
    - `CaptureZones.civ6proj` - project file which contains information on the mod and includes all the frontend and in-game actions, modified through ModBuddy
    
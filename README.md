# Civ-6-Mods

## Overview

Developed for SER300, this repository contains multiple mods for *Sid Meier's Civilization VI* written by Matthew Merritt and Michael Merritt. These mods are intended to improve the experience of playing in a medium sized multiplayer lobby with friends, and aim to do so by applying balance changes, adding comeback mechanics, and creating new systems for players to focus on.

## Features

This Git repository currently contains 4 distinct mods:
- `Balance Changes` - a mod that primarily aims to adjust existing game elements, including civilizations, leaders, units, buildings, districts, great people, and more.
- `CaptureZones` - inspired by victory cards in *Europa Universalis 4*, a mod that adds a new win condition for players to pursue where they must capture specific plots on the map to win.
- `ComebackMechanics` - a mod that will provide players with bonuses in science and culture if they fall behind the rest of the group, allowing them to stay in the game.
- `Gathering Storm Demo Mod` - not intended to be built or played, a mod that serves as a testing ground for features without needing to worry about breaking existing features.
The main mods are `ComebackMechanics` and `CaptureZones`, which both also have their own individual README with more information.

## Tech Stack

This project is intended to be opened on Windows 10/11, and all the setup instructions assume that you are on one of these operating systems.

At the time of development, the following tools and versions were used:
- *Sid Meier's Civilization VI* - Build ID 6640529, later 9985721
- *Sid Meier's Civilization VI Development Tools* - Build ID 4892607
- *SQLite* - Portable Version 3.12.2

In terms of why we used these tools, we chose the tools that most modders suggested using, as it meant that there would be a lot of tutorials and resources to look at if we needed help with something during the modding process.

## How to Use Project (User)

1. Begin by downloading both `CaptureZones.zip` and `ComebackMechanics.zip` from the most recent release
2. Navigate to your local Civilization VI game files, and select the `Mods` folder
    - For the Steam installation of Civilization VI, the default location is in `Documents` in a folder called `Sid Meier's Civilization VI`
    - As an example of where you need to go, my mods need to go into `C:\Users\scarf\OneDrive\Documents\My Games\Sid Meier's Civilization VI\Mods`
3. Extract the contents of both `CaptureZones.zip` and `ComebackMechanics.zip` into the `Mods` folder
    - If you do this correctly, the folder should now contain two folders named `CaptureZones` and `ComebackMechanics`
4. Launch the game, and verify that the two mods are listed in game by going to `Additional Content -> Mods`

## How to Setup and Run Project (Developer)

In order to begin working on the mods, you will need to first install *Sid Meier's Civilization VI Development Tools* on Steam. These should have come with the game for free. Installing *Sid Meier's Civilization VI Development Assets* will not be necessary. For our purposes, we will be using ModBuddy for development and FireTuner for testing.

To begin working on one of the mods, launch the *Sid Meier's Civilization VI Development Tools* on Steam and select ModBuddy. This will launch a Visual Studios window. Select `File -> Open -> Project/Solution...`, and navigate to the base directory of this repository on your computer (it should be called `Civ-6-Mods`). Navigate into the folder named after the mod you want to edit, for example, `Comeback Mechanics`. Select the .civ6sln file, in this case `Comeback Mechanics.civ6sln`, and press open. This will open the mod project in ModBuddy.

Additionally, to set up FireTuner, navigate to your `Documents` folder. From there, navigate to `My Games\Sid Meier's Civilization VI`. Open the text file named `AppOptions.txt`. Look for "[Debug]" and then change EnableTuner to be 1 and EnableDebugMenu to also be 1. To use FireTuner, launch the main game, and then launch the Development Tools and select FireTuner. FireTuner should automatically connect to the running game and display some information. To open panels made by the developers in FireTuner to get a better idea of the game's state, select `File -> Open Panel`. In the window, navigate to the location where you have your Steam installation of Civilization VI, for example, mine is at `C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization VI`. Navigate into `Debug`, and select the panels you need. For most purposes, `City.ltp` and `Map.ltp` will be sufficient.

You will likely want to install SQLite to view the state of the game's tables. The tables are located in three databases in `Documents\My Games\Sid Meier's Civilization VI\Cache`. The first database, `DebugConfiguration.sqlite`, is all the tables that affect what appears in the menus before a game is started (we call them configuration tables). This includes information about leaders and players, so custom civilizations must be added to both these configuration tables and the in-game tables. The second database, `DebugGameplay.sqlite`, is all the tables that are created when the player begins a game (we call them in-game tables). This is where you will find all the units, buildings, great people, leaders, policies, modifiers, and almost every other game element. Finally, the third database, `DebugLocalization.sqlite` will contain the localized text tables. For our purposes, we have only needed to worry about the `LocalizedText` table in this database.

Once you have your desired mod open in ModBuddy, you will be able to view the project structure in the Solution Explorer on the left side of the window. For most mods, try to keep different features in separate folders (`Gathering Storm Demo Mod` is the exception). For example, in `Balance Changes`, all the code related to Great People is contained in `Great People`. To add a folder in ModBuddy, right click on the mod name (`Balance Changes`), and select `Add -> New Folder`.

To add a file to the project, right click on the folder you wish the file to be contained in, and select `Add -> New Item...`. This brings up a window which asks you to create either a SQL file, XML file, LUA script, or text file. For our purposes, SQL and XML files will be used for adding to or modifying the games' tables, and LUA scripts will be for running code during gameplay.

Once you have written your code, you need to add actions for the game to run when starting up, that way your changes make it into the game. Right click on the name of your project in the Solution Explorer, and select `Properties`. We can edit the mod name, contributors, and other details under `Mod Info`, but we really care about `FrontEnd Actions` and `In-Game Actions`. Both will have the same types of actions, but apply them to different tables. `FrontEnd Actions` are applied to the configuration tables, and `In-Game Actions` are applied to the in-game tables. For us, there are three major types of actions: 
- `UpdateDatabase` - general feature additions to the in-game/configuration tables
- `UpdateText` - text additions to the localization tables, typically will be repeated in both `FrontEnd Actions` and `In-Game Actions`
- `AddGameplayScripts` - adding LUA scripts to run automatically
After selecting a type of action, give it a unique ID and select the `Add` Button on the right under `Files`. In the new window, select your intended file from the dropdown and press OK.

Once you have added all your actions, you can build your project by pressing `CTRL` + `SHIFT` + `B`. The built mod will automatically be placed in your game files, and you can find it the next time you launch in the menus under `Additional Content -> Mods`.
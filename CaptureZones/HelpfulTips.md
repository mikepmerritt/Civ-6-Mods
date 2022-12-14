# Helpful Tips List

Below is some documentation on the various functions and objects that I used. Return types and arguments are described as well. I may not be entirely correct about everything here, but this simply documents my findings so they can be referenced later if necessary. If I missed anything, try looking through my code - I tried to comment what I was trying to do at each step anyways.

## Using Other Mods

If you ever want to do something that may have already been done in a mod but have no idea where to start, you can look at what the other modders did in their projects by finding their mod in the mods folder. Mods can actually end up being stored in multiple places:
* If it is a mod that you built or one that you installed off of a website, GitHub repository, or forum post, it is likely in ```.../Documents/My Games/Sid Meier's Civilization VI/Mods```
* If it is a mod that you downloaded from the Steam Workshop, it is likely in ```.../steamapps/workshop/content/289070``` (the number is the Steam App ID for Civilization VI)
Since you only get to see the build of the mods by doing this, the file structure may differ and the solution file is not included, but you should still be able to see all of the mod's Lua, SQL, and XML files that add or change game content.

## File Locations

Here are some files and folders that I ended up using often, and you might need too.

* A copy of the game's databases is under ```.../Documents/My Games/Sid Meier's Civilization VI/Cache```. This is where you can see everything that was in the database from your last playthrough.
* The database log is at ```.../Documents/My Games/Sid Meier's Civilization VI/Logs/Database.log```. This is where you can check for database-related errors.
* The icons are under ```.../steamapps/common/Sid Meier's Civilization VI/Base/Assets/UI/Icons```. This is useful if you want to reuse one.
* The FireTuner panels are under ```.../steamapps/common/Sid Meier's Civilization VI/Debug```. Open these from FireTuner for easier testing and debugging.
* All of the code for the expansion packs and DLC packs are available at ```.../steamapps/common/Sid Meier's Civilization VI/DLC```, so if there is a feature added in one of the expansions or DLCs that you want to do something similar with, check there for how the developers did it. For example, when I was adding the combat strength bonus to the Show Superiority project, I started by looking at how the Mapuche's attack bonus versus civilizations in golden ages worked.
* As mentioned above, builds for mods can be found under ```.../Documents/My Games/Sid Meier's Civilization VI/Mods```, and mods you installed from the Steam Workshop can be found under ```.../steamapps/workshop/content/289070```.

## Adding Text

If you want to add text to the game, you will need to add entries to the LocalizedText table. Make sure to do this in a separate XML or SQL file, as you will need to add it as a separate ```UpdateText``` entry to the list of In-Game Actions in ModBuddy. Additionally, make sure that all of your text entry tags start with ```LOC```, as the game uses this to recognize when to look for localized text entries.

## Event Listeners

Check out [this mod](https://steamcommunity.com/sharedfiles/filedetails/?id=2776800137) for a better understanding of how to use the event listeners and what arguments they use. It lists out and has an example of all of them.

## Resources

To add a new resource type to the game, you should add new entries for your resource at least to the ```Types``` and ```Resources``` tables, but there are other ones which may also prove useful. Check out ```CaptureZoneResource.sql``` to see exactly what I changed to get mine to appear in game with the effects I wanted.

When using ```Plot:GetResourceType()```, the integer returned is a reference to the entry in the Resources table. You can figure out what this number means by opening the DebugGameplay.sqlite file in SQLite, going to the ```Resources``` table, and subtracting one from the numbers of the rows, assuming that you have not reordered it. For example, bananas is row 1 in SQLite, so ```Plot:GetResourceType()``` on a plot with bananas would return 0.

## Function Documentation

Here are my notes on a couple functions that I ended up while working in Lua with the capture zone placement.

### Map
* ```Map.GetPlot(x, y)``` - returns the Plot at x, y
* ```Map.GetPlotDistance(x1, y1, x2, y2)``` - calculate distance between two plots

### Plot
* ```Plot:IsOpenGround()``` - unknown functionality as of now, but not very helpful for what I was trying to accomplish anyways
* ```Plot:IsImpassible()``` - kept returning nil and thus crashing for some reason, stopped testing in favor of IsMountain and IsNaturalWonder
* ```Plot:IsMountain()``` - true if mountain, false otherwise
* ```Plot:IsWater()``` - true if water, false otherwise
* ```Plot:IsNaturalWonder()``` - true if natural wonder, false otherwise
* ```Plot:GetResourceType()``` - returns resource type as integer, more details in Resources section (-1 if no resource)
* ```Plot:GetDistrictType()``` - returns district type as integer (0 for city center, -1 for no district)
* ```Plot:GetProperty(key)``` - returns the value stored with the string key on this Plot
* ```Plot:SetProperty(key, value)``` - saves the value to the Plot, can be fetched later by using the key (type string) and GetProperty

### PlayerManager
* ```PlayerManager.GetAliveMajorsCount()``` - counts living civilizations
* ```PlayerManager.GetAliveMajorIDs()``` - returns table of IDs of living civilizations
* ```PlayerManager.GetAliveMajors()``` - returns table of living civilizations

### Player
* ```Player:GetCities()``` - returns a PlayerCities
* ```Player:GetID()``` - returns the ID of the Player as an integer

### PlayerCities
* ```PlayerCities:GetCapitalCity()``` - returns the capital as a City
* ```PlayerCities:Members()``` - returns a table of City instances

### City
* ```City:GetPlot()``` - returns the Plot the city is on
* ```City:GetOwnedPlots()``` - returns a table of Plot instances in the border of the City
* ```City:GetProperty(key)``` - returns the value stored with the string key on this City
* ```City:SetProperty(key, value)``` - saves the value to the City, can be fetched later by using the key (type string) and GetProperty
* ```City:GetID()``` - returns the ID of the City as an integer

### CityManager
* ```CityManager.GetCityAt(x, y)``` - returns a City at x, y

### ResourceBuilder
* ```ResourceBuilder.SetResourceType(plot, resourceID, otherParameter)``` - places a resource with id resourceID on Plot plot (if removing resource, set resourceID to -1 and exclude otherParameter; if placing, set otherParameter to 1 - not sure exactly how this works but it does)

## Icons and Art Additions

For the most part, we utilized [this guide](https://steamcommunity.com/sharedfiles/filedetails/?id=2420858843) to get started, although the process was a bit different for us since we only added icons.

When adding in resources, we had to create PNG images of the following sizes: 256x256 px, 64x64 px, 50x50 px, 38x38 px, and 22x22 px. The first four sizes will be used for showing the icons on the map, and the 22x22 px icon is used in text all across the user interface.

Once you have the images ready, open your project in ModBuddy and add two folders, `XLPs` and `Artdefs` (optionally, put `Icons` to contain the SQL script to load the icons and atlases). Then, in ModBuddy, select  `Tools -> Launch Asset Editor...`. 

Create a new Artdef from the template `UserInterfaceBLPs`. 

Create an XLP file with the XLP class `UITexture` and Package Name `UI/Icons`. In the Entries window on the XLP, select `Add New` (the folder with the plus), change the `Exporting Class` to "User Interface", press `+ Add Source File...`, select your PNG files, then press `Apply To Selected` and `Import`.

Go back to the Artdef file, and add the following code at the end of the AssetObjects..ArtDefSet tag:
```xml
	<m_BLPReferences>
		<Element>
			<xlpFile text="ResourceVictoryPoints.xlp"/>
			<blpPackage text="CaptureZones.blp"/>
			<xlpClass text="UITexture"/>
		</Element>
	</m_BLPReferences>
```
Note that the value for text in the xlpFile tag should be your XLP file name and the value for text in the blpPackage tag should be the name of the mod followed by ".blp". Without this, the game will not include the icons in the build.

Finally, add an action to the mod properties to update the art using the Mod Art Dependency File, and write and add a script to create the IconAtlases and IconDefinitions using XML or SQL.
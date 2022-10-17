# Helpful Commands List

Below is some documentation on the various functions and objects that I used. Return types and arguments are described as well. I may not be entirely correct about everything here, but this simply documents my findings so they can be referenced later if necessary. If I missed anything, try looking through my code - I tried to comment what I was trying to do at each step anyways.

## Event Listeners

Check out [this mod](https://steamcommunity.com/sharedfiles/filedetails/?id=2776800137) for a better understanding of how to use the event listeners and what arguments they use. It lists out and has an example of all of them.

## Objects

### Map
* ```Map.GetPlot(x, y)``` - returns the Plot at x, y
* ```Map.GetPlotDistance(x1, y1, x2, y2)``` - calculate distance between two plots

### Plot
* ```Plot:IsOpenGround()``` - unknown functionality as of now, but not very helpful for what I was trying to accomplish anyways
* ```Plot:IsImpassible()``` - kept returning nil and thus crashing for some reason, stopped testing in favor of IsMountain and IsNaturalWonder
* ```Plot:IsMountain()``` - true if mountain, false otherwise
* ```Plot:IsWater()``` - true if water, false otherwise
* ```Plot:IsNaturalWonder()``` - true if natural wonder, false otherwise
* ```Plot:GetResourceType()``` - returns resource type as integer (-1 if no resource)
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
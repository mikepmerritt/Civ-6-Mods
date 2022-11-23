# Comeback mechanic implementation

## Comeback mechanic implementation plan 1

To see when requirements trigger and if we can use this, we ran the following test:

### Insertions
- `Modifiers`
	- Item 1
		- ModifierId: 'REMOVE_MONUMENT_YIELD_IF_AHEAD'
		- ModifierType: 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIER'
		- RunOnce: 0
		- NewOnly: 0
		- Permanent: 0
		- Repeatable: 0
		- SubjectRequirementSetId: 'PLAYER_HAS_HIGH_SCIENCE'
- `ModifierArguments`
	- Item 1:
		- ModifierId: 'REMOVE_MONUMENT_YIELD_IF_AHEAD'
		- Name: 'YieldType'
		- Type: 'ARGTYPE_IDENTITY'
		- Value: 'YIELD_CULTURE'
	- Item 2:
		- ModifierId: 'REMOVE_MONUMENT_YIELD_IF_AHEAD'
		- Name: 'BuildingType'
		- Type: 'ARGTYPE_IDENTITY'
		- Value: 'BUILDING_MONUMENT'
	- Item 3:
		- ModifierId: 'REMOVE_MONUMENT_YIELD_IF_AHEAD'
		- Name: 'Amount'
		- Type: 'ARGTYPE_IDENTITY'
		- Value: -100
- `BuildingModifiers`
	- Item 1
		- BuildingType: 'BUILDING_MONUMENT'
		- ModifierId: 'REMOVE_MONUMENT_YIELD_IF_AHEAD'
	

### Result - FAILURE
When we attempted to use this and added the modifiers to the monument, the subject and context of the requirement set were not the intended target and it was not clear how to trigger them.

We are going to look at a new approach that manually triggers the requirements with a Lua script that checks science of each player at the start of each turn.

## Comeback mechanic implementation plan 2

A second attempt at implementing comeback mechanics for players that are falling behind in science or culture.
This approach will involve setting up empty requirements and requirement sets that will be satisfied by a Lua script. These requirement sets will be attached to modifiers that are present on relevant buildings (libraries, monuments) and will be checked at the beginning of every turn.

### Insertions
- `Requirements`
	- Item 1
		- RequirementId: 'REQUIRES_HAS_BEHIND_SCIENCE_SAM'
		- RequirementType: 'REQUIREMENT_NOT_MET'
		- Likeliness: 0 - NOTE: Unsure what these do
		- Impact: 0 - NOTE: Unsure what these do
		- Reverse: 0 - NOTE: Unsure what these do
		- Persistent: 0 - NOTE: Unsure what these do
		- ProgressWeight: 1 - NOTE: Unsure what these do
		- Triggered: 0 - NOTE: Unsure what these do
	- Item 2
		- RequirementId: 'REQUIRES_HAS_BEHIND_CULTURE_SAM'
		- RequirementType: 'REQUIREMENT_NOT_MET'
		- Likeliness: 0 - NOTE: Unsure what these do
		- Impact: 0 - NOTE: Unsure what these do
		- Reverse: 0 - NOTE: Unsure what these do
		- Persistent: 0 - NOTE: Unsure what these do
		- ProgressWeight: 1 - NOTE: Unsure what these do
		- Triggered: 0 - NOTE: Unsure what these do

- `RequirementSets`
	- Item 1
		- RequirementSetId: 'PLAYER_FALLS_BEHIND_SCIENCE_SAM'
		- RequirementSetType: 'REQUIREMENTSET_TEST_ALL'
	- Item 2
		- RequirementSetId: 'PLAYER_FALLS_BEHIND_CULTURE_SAM'
		- RequirementSetType: 'REQUIREMENTSET_TEST_ALL'

- `RequirementSetRequirements`
	- Item 1
		- RequirementSetId: 'PLAYER_FALLS_BEHIND_SCIENCE_SAM'
		- RequirementId: 'REQUIRES_HAS_BEHIND_SCIENCE_SAM'
	- Item 2
		- RequirementSetId: 'PLAYER_FALLS_BEHIND_CULTURE_SAM'
		- RequirementId: 'REQUIRES_HAS_BEHIND_CULTURE_SAM'
		
- `Modifiers`
	- Item 1
		- ModifierId: 'DOUBLE_SCIENCE_YIELD_SAM'
		- ModifierType: 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIER'
		- RunOnce: 0 - NOTE: possibly change to 1
		- NewOnly: 0
		- Permanent: 0 - NOTE: possibly change to 1
		- Repeatable: 0 
		- SubjectRequirementSetId: 'PLAYER_FALLS_BEHIND_SCIENCE_SAM'
	- Item 2
		- ModifierId: 'DOUBLE_CULTURE_YIELD_SAM'
		- ModifierType: 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIER'
		- RunOnce: 0 - NOTE: possibly change to 1
		- NewOnly: 0
		- Permanent: 0 - NOTE: possibly change to 1
		- Repeatable: 0 
		- SubjectRequirementSetId: 'PLAYER_FALLS_BEHIND_CULTURE_SAM'
	
- `ModifierArguments`
	- Item 1:
		- ModifierId: 'DOUBLE_SCIENCE_YIELD_SAM'
		- Name: 'YieldType'
		- Type: 'ARGTYPE_IDENTITY'
		- Value: 'YIELD_SCIENCE'
	- Item 2:
		- ModifierId: 'DOUBLE_SCIENCE_YIELD_SAM'
		- Name: 'BuildingType'
		- Type: 'ARGTYPE_IDENTITY'
		- Value: 'BUILDING_LIBRARY'
	- Item 3:
		- ModifierId: 'DOUBLE_SCIENCE_YIELD_SAM'
		- Name: 'Amount'
		- Type: 'ARGTYPE_IDENTITY'
		- Value: 100
	- Item 4:
		- ModifierId: 'DOUBLE_CULTURE_YIELD_SAM'
		- Name: 'YieldType'
		- Type: 'ARGTYPE_IDENTITY'
		- Value: 'YIELD_CULTURE'
	- Item 5:
		- ModifierId: 'DOUBLE_CULTURE_YIELD_SAM'
		- Name: 'BuildingType'
		- Type: 'ARGTYPE_IDENTITY'
		- Value: 'BUILDING_MONUMENT'
	- Item 6:
		- ModifierId: 'DOUBLE_CULTURE_YIELD_SAM'
		- Name: 'Amount'
		- Type: 'ARGTYPE_IDENTITY'
		- Value: 100
		
- `BuildingModifiers`
	- Item 1:
		- BuildingType: 'BUILDING_LIBRARY'
		- ModifierId: 'DOUBLE_SCIENCE_YIELD_SAM'
	- Item 2:
		- BuildingType: 'BUILDING_MONUMENT'
		- ModifierId: 'DOUBLE_CULTURE_YIELD_SAM'
		
### Result - FAILURE
We were unable to find a function in the LUA scripting library that would allow us to change the status for a requirement. As such, it is impossible to activate the modifiers.
We are looking back into using the requirements system and working with existing requirement types and arguments to make this happen.

## Comeback mechanic implementation 3
We found that it was not possible to manually set the status of requirements, meaning that we would need to work with the existing requirement system and checks to activate our modifiers.
The modifiers have been changed to add 1 to the buildings yields, to prevent the effect from stacking.

We want to attempt to attach a property to something in the game, and use the existing requirements to check if the propery is in the game.

### Exploration
I found that there is only one requirement type present in the game for checking if properties match: 'REQUIREMENT_PLOT_PROPERTY_MATCHES'

Using a spreadsheet with all the existing requirements and their arguments, available at https://docs.google.com/spreadsheets/d/1hQ8zlEHl1nfjCWvKqOlkDACezu5-igfQkVcOxeE_KG0/edit#gid=265388871, I realized that there were no examples in the base game that used this requirement type.
Comments in the spreadsheet directed me to another mod that used this property, available at https://steamcommunity.com/workshop/filedetails/?id=2104384400. 

Currently, the plan is to create a unqiue property that is added to the city center whenever the player completes building a monument/library.
I will also need to create a new requirement, with arguments, using the requirement type 'REQUIREMENT_PLOT_PROPERTY_MATCHES'. 
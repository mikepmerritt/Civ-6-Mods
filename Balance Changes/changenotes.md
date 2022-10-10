# Changes

## Hildegard of Bingen
Hopefully make Hildegard of Bingen valuable as a great scientist to more players and actually taken.

### Information to look for:
`GreatPersonIndividualType`: `GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN`
`ModifierId`: `GREATPERSON_HOLY_SITE_ADJACENCY_AS_SCIENCE`

### Tables and values to change:
* `Types`
	* Add new item
		* Type: 'MODIFIER_SINGLE_CITY_DISTRICT_ADJUST_GREAT_PERSON_POINTS_SAM'
		* Kind: 'KIND_MODIFIER'
* `DynamicModifiers`
	* Add new item
		* ModifierType: 'MODIFIER_SINGLE_CITY_DISTRICT_ADJUST_GREAT_PERSON_POINTS_SAM'
		* CollectionType: 'COLLECTION_OWNER' -- NOTE: This is always the case for great people because of how they attach modifiers to entities
		* EffectType: 'EFFECT_ADJUST_DISTRICT_GREAT_PERSON_POINTS'
* `Modifiers`
	* Add new item
		* ModifierId: 'GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM'
		* ModifierType: 'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS'
		* RunOnce: 1
		* NewOnly: 0
		* Permanent: 1
		* Repeatable: 0
	* Add new item
		* ModifierId: 'GREATPERSON_CAMPUS_PROPHET_POINTS_SAM'
		* ModifierType: 'MODIFIER_SINGLE_CITY_DISTRICT_ADJUST_GREAT_PERSON_POINTS_SAM'
		* RunOnce: 0 - NOTE: If not working, try changing this to 1
		* NewOnly: 0
		* Permanent: 0 - NOTE: If not working, try changing this to 1
		* Repeatable: 0
		* SubjectRequirementSetId: 'DISTRICT_IS_CAMPUS'
* `GreatPersonIndividuals`
	* GreatPersonIndividualType: 'GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN'
		* ActionRequiresCompletedDistrictType -> 'DISTRICT_CAMPUS'
* `GreatPersonIndividualActionModifiers`
	* GreatPersonIndividualType: 'GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN'
		* ModifierId: 'GREATPERSON_HOLY_SITE_ADJACENCY_AS_SCIENCE' -> 'GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM'
		* ModifierId: 'GREATPERSON_FAITH' -> 'GREATPERSON_CAMPUS_PROPHET_POINTS_SAM'
* `LocalizedText`
	* 'LOC_GREATPERSON_HOLY_SITE_ADJACENCY_AS_SCIENCE' may need to be replaced
	* 'LOC_GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM' needs to be added
	* 'LOC_GREATPERSON_CAMPUS_PROPHET_POINTS_SAM' needs to be added
* `ModifierStrings`
	* Add new rows for new modifier names
		* ModifierId: varies
		* Context: 'Summary'
		* Text: 'LOC_[ModifierId]'
* `ModifierArguments`:
	* Add new rows
		* 'ModifierId': 'GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM'
			* Name: 'YieldTypeToMirror'
			* Type: 'ARGTYPE_IDENTITY'
			* Value: 'YIELD_SCIENCE'
		* 'ModifierId': 'GREATPERSON_CAMPUS_ADJACENCY_AS_FAITH_SAM'
			* Name: 'YieldTypeToGrant'
			* Type: 'ARGTYPE_IDENTITY'
			* Value: 'YIELD_FAITH'
		* 'ModifierId': 'GREATPERSON_CAMPUS_PROPHET_POINTS_SAM'
			* Name: 'GreatPersonClassType'
			* Type: 'ARGTYPE_IDENTITY'
			* Value: 'GREAT_PERSON_CLASS_PROPHET'
		* 'ModifierId': 'GREATPERSON_CAMPUS_PROPHET_POINTS_SAM'
			* Name: 'Amount'
			* Type: 'ARGTYPE_IDENTITY'
			* Value: 4
		
### Useful queries:
Used to find ModifierType needed to make changes:
```sql
SELECT *
FROM Modifiers
WHERE ModifierType LIKE '%ADJUST%' AND ModifierType LIKE '%SINGLE%' AND ModifierType LIKE '%CITY%' AND ModifierType LIKE '%DISTRICT%'
```
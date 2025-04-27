-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--


-- Ruleset action types
actions = {
	["dice"] = { bUseModStack = "true" },
	["table"] = { },
	["effect"] = { sIcon = "effect_icon", sTargeting = "all" },
	["damage"] = { sIcon = "action_damage", sTargeting = "each", bUseModStack = true },
	["attack"] = { sIcon = "action_attack", sTargeting = "each", bUseModStack = true },
	["init"] = { bUseModStack = true },
	["spellsavepc"]  = { bUseModStack = "true", sTargeting = "none" };
	["heal"] = { sIcon = "action_heal", sTargeting = "all", bUseModStack = true },
	["spell"] = { sIcon = "action_damage", sTargeting = "each", bUseModStack = true },
	["reaction"] = { bUseModStack = true },
	["save"] = { bUseModStack = "true", sTargeting = "none" };
	["check"] = { bUseModStack = "true", sTargeting = "all" };
	["initiative"] = { bUseModStack = true },
	["turn"] = { sIcon = "action_damage", sTargeting = "all", bUseModStack = true },
};
targetactions = {
	"effect",
	"attack",
	"damage",
	"heal",
	"spell",
	"turn"

};

currencies = { 
	{ name = "PP", weight = 1, value = 5},
	{ name = "GP", weight = 1, value = 1 },
	{ name = "EP", weight = 1, value = 0.5 },
	{ name = "SP", weight = 1, value = 0.1 },
	{ name = "CP", weight = 1, value = 0.01 },
};


function getCharSelectDetailHost(nodeChar)
	return "";
end

function requestCharSelectDetailClient()
	return "name";
end

function receiveCharSelectDetailClient(vDetails)
	return vDetails, "";
end

function getCharSelectDetailLocal(nodeLocal)
	return DB.getValue(nodeLocal, "name", ""), "";
end


function getDistanceUnitsPerGrid()
	return 5;
end




function onInit()
	--ActionsManager.useFGUDiceValues(true);
	CharEncumbranceManager.addStandardCalc()
		registerStandardDeathMarkersOSE();
		ImageDeathMarkerManager.setEnabled(true);
  -- Languages
  languages = {
    [Interface.getString("language_value_common")] = "",
    [Interface.getString("language_value_dwarvish")] = "Dwarven",
    [Interface.getString("language_value_elvish")] = "Elven",
    [Interface.getString("language_value_giant")] = "Giant",
    [Interface.getString("language_value_gnomish")] = "Elven",
    [Interface.getString("language_value_goblin")] = "Dwarven",
    [Interface.getString("language_value_halfling")] = "",
    [Interface.getString("language_value_bugbear")] = "Giant",
    [Interface.getString("language_value_doppleganger")] = "Giant",
	[Interface.getString("language_value_dragon")] = "Dwarven",
	[Interface.getString("language_value_gargoyle")] = "Giant",
	[Interface.getString("language_value_gnoll")] = "Giant",
	[Interface.getString("language_value_harpy")] = "Giant",
	[Interface.getString("language_value_hobgoblin")] = "Giant",
	[Interface.getString("language_value_kobold")] = "Giant",
	[Interface.getString("language_value_lizardman")] = "Giant",
	[Interface.getString("language_value_medusa")] = "Giant",
	[Interface.getString("language_value_minotaur")] = "Giant",
	[Interface.getString("language_value_ogre")] = "Giant",
	[Interface.getString("language_value_pixie")] = "Elven",
	[Interface.getString("language_value_chaos")] = "Giant",
	[Interface.getString("language_value_Law")] = "Giant",
	[Interface.getString("language_value_Neutrality")] = "Elven",
	[Interface.getString("language_value_orc")] = "Elven",
  }
   languagefonts = {

    [Interface.getString("language_value_dwarvish")] = "Dwarven",
    [Interface.getString("language_value_elvish")] = "Elven",
    [Interface.getString("language_value_giant")] = "Giant", 

  }
	
end

function registerStandardDeathMarkersOSE()
	ImageDeathMarkerManager.setEnabled(true);
	
	ImageDeathMarkerManager.registerGetCreatureTypeFunction(GameSystem.getCreatureTypeOSE);

	ImageDeathMarkerManager.registerCreatureTypes(DataCommon.creaturetype);
	ImageDeathMarkerManager.setCreatureTypeDefault("construct", "blood_black");
	ImageDeathMarkerManager.setCreatureTypeDefault("plant", "blood_green");
	ImageDeathMarkerManager.setCreatureTypeDefault("undead", "blood_violet");
end


function getCreatureTypeOSE(rActor)
	local tTypes = getCreatureTypesOSE(rActor);
	if tTypes and tTypes[1] then
		return tTypes[1];
	end
	return DataCommon.creaturedefaulttype;
end
function getCreatureTypesOSE(rActor)
	local nodeActor = ActorManager.getCreatureNode(rActor);
	if not nodeActor then
		return nil;
	end
	
	local sTags = DB.getValue(nodeActor, "tags", "");
	local tTypes = {};
	local tTraitWords = StringManager.split(sTags:lower(), ",", true);
	for _, sCreatureType in ipairs(DataCommon.creaturetype) do
		if StringManager.contains(tTraitWords, sCreatureType) then
			table.insert(tTypes, sCreatureType);
			break
		end
	end
	return tTypes;
end




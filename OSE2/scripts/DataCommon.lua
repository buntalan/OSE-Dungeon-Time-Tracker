
-- Values supported in effect conditionals
conditionaltags = {
};

-- Conditions supported in effect conditionals and for token widgets
conditions = {
	"blinded", 
	"charmed",
	"cursed",
	"deafened",
	"encumbered",
	"frightened", 
	"grappled", 
	"incapacitated",
	"intoxicated",
	"invisible", 
	"paralyzed",
	"petrified",
	"poisoned",
	"prone", 
	"restrained",
	"weakened", 
	"stunned",
	"turned",
	"unconscious"
};

-- Bonus/penalty effect types for token widgets
bonuscomps = {
	"INIT",
	"CHECK",
	"AC",
	"ATK",
	"DMG",
	"HEAL",
	"SAVE",
	"STR",
	"CON",
	"DEX",
	"INT",
	"WIS",
	"CHA",
};



-- Other visible effect types for token widgets
othercomps = {

	["IMMUNE"] = "cond_immune",
	["RESIST"] = "cond_resistance",
	["VULN"] = "cond_vulnerable",
	["REGEN"] = "cond_regeneration",
	["DMGO"] = "cond_bleed",

};

-- Effect components which can be targeted
targetableeffectcomps = {
	"AC",
	"SAVE",
	"ATK",
	"DMG",
	"IMMUNE",
	"VULN",
	"RESIST"
};

connectors = {
	"and",
	"or"
};

-- Range types supported
rangetypes = {
	"melee",
	"ranged"
};

alignment_lawchaos = {
	["law"] = 1,
	["chaos"]=2,
	["neutrality"]=0
};

-- Damage types supported
dmgtypes = {
	"acid",		-- ENERGY TYPES
	"cold",
	"fire",
	"electricity",
	"chlorine",
	"poison",
	"psychic",
	"radiant",
	"magicalfire",
	"blunt",
	"piercing",
	"slashing",	
	"charm",
	"hold",
	"sleep",
	"magic",-- WEAPON PROPERTY DAMAGE TYPES
	"mundane",
	"silver",

};

-- Bonus types supported in power descriptions
bonustypes = {
};
stackablebonustypes = {
};

creaturesize = {
	["tiny"] = -2,
	["small"] = -1,
	["medium"] = 0,
	["large"] = 1,
	["huge"] = 2,
	["gargantuan"] = 3,
	["t"] = -2,
	["s"] = -1,
	["m"] = 0,
	["l"] = 1,
	["h"] = 2,
	["g"] = 3,
};

-- Values for creature type comparison
creaturedefaulttype = "humanoid";
creaturehalftype = "half-";
creaturehalftypesubrace = "human";
-- NOTE: Multi-word types must come before single word types
creaturetype = {
	"aberration",
	"beast",
	"celestial",
	"construct",
	"dragon",
	"elemental",
	"fey",
	"fiend",
	"giant",
	"humanoid",
	"monstrosity",
	"lycanthrope",
	"ooze",
	"reptile",
	"plant",
	"shapechanger",
	"enchanted",
	"giantkin",
	"spelluser",
	"regenerating",
	"undead",
};

immunetypes = {
	"acid",  		-- ENERGY DAMAGE TYPES
	"cold",
	"lightning",
	"fire",
	"poison",
	"sonic",
	"sleep",
	"mundane", 		-- OTHER IMMUNITY TYPES
	"paralysis",
	"petrification",
	"charm",
	"sleep",
	"fear",
	"disease",
	"sorcery",
	"fear",
	"electricity"
};

creaturesubtype = {

};
rangeweapons = 
{

{name= "axe" ,weapon ={5, 10,11, 20,21, 30}},
{name= "long bow" ,weapon ={5, 70,71, 140,141, 210}},
{name="short bow"  ,weapon ={5, 50,51, 100,101, 150}},
{name= "staff Sling" ,weapon ={5, 30,31, 60,61, 90}},
{name= "sling",weapon ={5, 40,41, 80,81, 160}},
{name="crossbow",weapon ={5, 80,81, 160,161, 240}},
{name="arbalest",weapon ={5, 80,81, 160,161, 240}},
{name= "dagger" ,weapon ={5, 10,11, 20,21, 30}},
{name= "holy water" ,weapon ={5, 10,11, 30,31, 50}},
{name= "spear"	 ,weapon ={5, 20,21, 40,41, 60}},
{name= "javelin" ,weapon ={5, 10,11, 20,41, 60}},
{name= "oil flask"	 ,weapon ={5, 10,11, 30,31, 50}},
{name="pistol flintlock"  ,weapon ={5, 25,26, 50,51, 90}},
{name="pistol matchlock"  ,weapon ={5, 25,26, 50,51, 90}},
{name="pistol wheelock"  ,weapon ={5, 25,26, 50,51, 90}},
{name= "pistol" ,weapon ={5, 50,51, 100,101, 150}},
{name= "heavy musket" ,weapon ={5, 70,71, 140,141, 210}},
{name= "musket" ,weapon ={5, 50,51, 100,101, 140}},
{name="blunderbuss",weapon ={5, 10,11, 25,26, 40}},
{name="carbine",weapon ={5, 70,71, 140,141, 210}},
{name="rifle",weapon ={5, 80,81, 160,161, 240}},
{name= "rock",weapon ={5, 10,11, 30,31, 50}},
{name= "war hammer",weapon ={5, 10,11, 30,31, 50}},
{name= "dart" ,weapon ={5, 10,11, 20,21, 40}},
{name= "blowgun" ,weapon ={5, 10,11, 20,21, 30}},
{name= "net" ,weapon ={5, 10,11, 20,21, 30}},
{name= "bolas" ,weapon ={5, 20,21, 40,41, 60}},
{name= "warhammer",weapon ={5, 10,11, 30,31, 50}}
};

Spellslot_Matrix_Druid = {
{1,0,0,0,0,0},
{2,0,0,0,0,0},
{2,1,0,0,0,0},
{2,2,0,0,0,0},
{2,2,1,1,0,0},
{2,2,2,1,1,0},
{3,3,2,2,1,0},
{3,3,3,2,2,0},
{4,4,3,3,2,0},
{4,4,4,3,3,0},
{5,5,4,4,3,0},
{5,5,5,4,4,0},
{6,5,5,5,4,0},
{6,6,5,5,5,0}
};

Spellslot_Matrix_MU = {                            
{1,0,0,0,0,0},
{2,0,0,0,0,0},
{2,1,0,0,0,0},
{2,2,0,0,0,0},
{2,2,1,0,0,0},
{2,2,2,0,0,0},
{3,2,2,1,0,0},
{3,3,2,2,0,0},
{3,3,3,3,2,0},
{4,3,3,3,2,1},
{4,3,3,3,2,1},
{4,4,3,3,3,2},
{4,4,4,3,3,3},
{4,4,4,4,3,3},
};

Spellslot_Matrix_Cleric = {                           
{0,0,0,0,0,0},
{1,0,0,0,0,0},
{2,0,0,0,0,0},
{2,1,0,0,0,0},
{2,2,0,0,0,0},
{2,2,1,1,0,0},
{2,2,2,1,1,0},
{3,3,2,2,1,0},
{3,3,3,2,2,0},
{4,4,3,3,2,0},
{4,4,4,3,3,0},
{5,5,4,4,3,0},
{5,5,5,4,4,0},
{6,5,5,5,4,0}
};

Spellslot_Matrix_Elf = {                           
{1,0,0,0,0,0},
{2,0,0,0,0,0},
{2,1,0,0,0,0},
{2,2,0,0,0,0},
{2,2,1,0,0,0},
{2,2,2,0,0,0},
{3,2,2,1,0,0},
{3,3,2,2,0,0},
{3,3,3,2,1,0},
{3,3,3,3,2,0}
};

Spellslot_Matrix_Drow = {                           
{1,0,0,0,0,0},
{2,0,0,0,0,0},
{2,1,0,0,0,0},
{2,2,0,0,0,0},
{2,2,1,0,0,0},
{2,2,2,1,0,0},
{3,3,2,2,1,0},
{3,3,2,2,1,0},
{3,3,3,2,2,0},
{4,4,3,3,2,0}
};

Spellslot_Matrix_Illusionist = {                            
{1,0,0,0,0,0},
{2,0,0,0,0,0},
{2,1,0,0,0,0},
{2,2,0,0,0,0},
{2,2,1,0,0,0},
{2,2,2,0,0,0},
{3,2,2,1,0,0},
{3,3,2,2,0,0},
{3,3,3,3,2,0},
{4,3,3,3,2,1},
{4,3,3,3,2,1},
{4,4,3,3,3,2},
{4,4,4,3,3,3},
{4,4,4,4,3,3}
};

Spellslot_Matrix_Bard = {                            
{0,0,0,0,0,0},
{1,0,0,0,0,0},
{2,0,0,0,0,0},
{3,0,0,0,0,0},
{3,1,0,0,0,0},
{3,2,0,0,0,0},
{3,3,0,0,0,0},
{3,3,1,0,0,0},
{3,3,2,0,0,0},
{3,3,3,0,0,0},
{3,3,3,1,0,0},
{3,3,3,2,0,0},
{3,3,3,3,0,0},
{4,4,3,3,0,}
};

Spellslot_Matrix_Gnome = {                          
{1,0,0,0,0,0},
{2,0,0,0,0,0},
{2,1,0,0,0,0},
{2,2,0,0,0,0},
{2,2,1,0,0,0},
{2,2,2,0,0,0},
{3,2,2,1,0,0},
{3,3,2,2,0,0}
};

Spellslot_Matrix_Paladin = {                           
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{1,0,0,0,0,0},
{2,0,0,0,0,0},
{2,1,0,0,0,0},
{2,2,0,0,0,0},
{2,2,1,0,0,0},
{3,2,1,0,0,0}
};

Spellslot_Matrix_Ranger = {                           
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{0,0,0,0,0,0},
{1,0,0,0,0,0},
{2,0,0,0,0,0},
{2,1,0,0,0,0},
{2,2,0,0,0,0},
{2,2,1,0,0,0},
{3,2,1,0,0,0},
{3,2,2,0,0,0}
};

turn = 
{

["1"]=	{"7",	"9",	"11",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",},
["2"]=	{"T",	"7",	"9",	"11",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",},
["3"]=	{"T",	"T",	"7",	"9",	"11",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",},
["4"]=	{"D",	"T",	"T",	"7",	"9",	"11",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",},
["5"]=	{"D",	"D",	"T",	"T",	"7",	"9",	"11",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",},
["6"]=	{"D",	"D",	"D",	"T",	"T",	"7",	"9",	"11",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",},
["7"]=	{"D",	"D",	"D",	"D",	"T",	"T",	"7",	"9",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",},
["8"]=	{"D",	"D",	"D",	"D",	"D",	"T",	"T",	"7",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",},
["9"]=	{"D",	"D",	"D",	"D",	"D",	"D",	"T",	"T",	"NT",	"NT",	"NT",	"NT",	"NT",	"NT",},
["10"]=	{"D",	"D",	"D",	"D",	"D",	"D",	"D",	"T",	"T",	"NT",	"NT",	"NT",	"NT",	"NT",},
["11"]=	{"D",	"D",	"D",	"D",	"D",	"D",	"D",	"D",	"T",	"NT",	"NT",	"NT",	"NT",	"1",},
["12"]=	{"D",	"D",	"D",	"D",	"D",	"D",	"D",	"D",	"D",	"NT",	"NT",	"NT",	"NT",	"4",},
};

monstersaves = {
{"12",	"13",	"14",	"15",	"16"},
{"12",	"13",	"14",	"15",	"16"},
{"12",	"13",	"14",	"15",	"16"},
{"10",	"11",	"12",	"13",	"14"},
{"10",	"11",	"12",	"13",	"14"},
{"10",	"11",	"12",	"13",	"14"},
{"8",	"9",	"10",	"10",	"12"},
{"8",	"9",	"10",	"10",	"12"},
{"8",	"9",	"10",	"10",	"12"},
{"6",	"7",	"8",	"8",	"10"},
{"6",	"7",	"8",	"8",	"10"},
{"6",	"7",	"8",	"8",	"10"},
{"4",	"5",	"6",	"5",	"8"},
{"4",	"5",	"6",	"5",	"8"},
{"4",	"5",	"6",	"5",	"8"},
{"2",	"3",	"4",	"3",	"6"},
{"2",	"3",	"4",	"3",	"6"},
{"2",	"3",	"4",	"3",	"6"},
{"2",	"2",	"2",	"2",	"4"},
{"2",	"2",	"2",	"2",	"4"},
{"2",	"2",	"2",	"2",	"4"},
{"2",	"2",	"2",	"2",	"2"}

}


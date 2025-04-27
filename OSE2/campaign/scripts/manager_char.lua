
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
function onInit()
	ItemManager.setCustomCharAdd(onCharItemAdd);
	ItemManager.setCustomCharRemove(onCharItemDelete);

	if Session.IsHost then
		CharInventoryManager.enableInventoryUpdates();
		CharInventoryManager.enableSimpleLocationHandling();

		CharInventoryManager.registerFieldUpdateCallback("carried", manager_char.UpdateCarried);

	end


end




function onCharItemDelete(nodeItem)


	if DB.getValue(nodeItem, "carried", 0) == 2 then
		DB.setValue(nodeItem, "carried", "number", 1);
	end
	manager_char.updateArmor(nodeItem);
  	manager_char.updateEffects(nodeItem);
	manager_char.CalcEnc(nodeItem)
	CharWeaponManager.removeFromWeaponDB(nodeItem);
end

function onCharItemAdd(nodeItem)

	local sTypeLower = StringManager.trim(DB.getValue(DB.getPath(nodeItem, "type"), "")):lower();
	if StringManager.contains({"mounts and other animals", "waterborne vehicles", "tack, harness, and drawn vehicles", "gear" }, sTypeLower) then
		DB.setValue(nodeItem, "carried", "number", 0);
	elseif StringManager.contains({"armor","weapon","shield" }, sTypeLower) then
		DB.setValue(nodeItem, "carried", "number", 1);
	else
		DB.setValue(nodeItem, "carried", "number", 1);
	end


	manager_char.updateArmor(nodeItem);

	CharWeaponManager.addToWeaponDB(nodeItem);


end

function UpdateCarried (nodeItem)

	manager_char.updateArmor(nodeItem);
  	manager_char.updateEffects(nodeItem);
  	---adds code to script for legacy weapons lists
  	manager_char.checkForWeapon(nodeItem)

end

function checkForWeapon(nodeItem)
local bExists = true

	if DB.getValue(nodeItem,"carried",0) == 2 and DB.getValue(nodeItem,"type",""):lower() == "weapon" then

	local sInvItemName = StringManager.trim(DB.getValue(nodeItem,"name",""):lower())
	local sNonidName = StringManager.trim(DB.getValue(nodeItem,"nonid_name",""):lower())
	local nodeChar = DB.getChild(nodeItem, "...")
-- add check to see if children exists after update
	local nodeWeapon = DB.getChild(nodeChar,"weaponlist")

			if DB.getChildCount(nodeWeapon) ==0 then
					CharWeaponManager.addToWeaponDB(nodeItem);
					return false
			end

		for _,vWeapon in ipairs (DB.getChildList(nodeWeapon)) do

			if sInvItemName == DB.getValue(vWeapon,"name",""):lower() then
			bExists = true
			break
			elseif sNonidName == StringManager.trim(string.gsub(DB.getValue(vWeapon,"name",""):lower(),"%*","")) then
			bExists = true
			break
			else
			bExists = false
			end
		end

	else
	return false
	end

		if bExists then
		return false
		else
		CharWeaponManager.addToWeaponDB(nodeItem);
		end
end

function updateEncumbrance(nodeChar)
CharEncumbranceManager.updateEncumbrance(nodeChar);

end



function updateArmor(nodeItem)
local nodeChar = DB.getChild(nodeItem, "...")
local bArmor = false
local nACupdate = 9
local nShielddupdate = 0
local nodeInventoryList = DB.getChild(nodeChar,"inventorylist");
local nAcmod = 0
local nDexmod = DB.getValue(nodeChar,"acmodscore_combat",0)

for sClass,rRecord in pairs(DB.getChildren(nodeInventoryList)) do

local nCarriedIndex = DB.getValue(rRecord,"carried",0);
local sType = DB.getValue(rRecord, "type",0);

        if nCarriedIndex == 2 then

            if sType == "Armor" then
            bArmor = true
            local nAC = DB.getValue(rRecord,"acbase",9);
            local nAcModar = DB.getValue(rRecord,"bonus",0);
            nACupdate = nAC - nAcModar-nDexmod;

            break;

        else
        end
    end

end

for sClass,rRecord in pairs(DB.getChildren(nodeInventoryList)) do

local nCarriedIndex = DB.getValue(rRecord,"carried",0);
local sType = DB.getValue(rRecord, "type",0);

        if nCarriedIndex == 2 then

            if sType == "Shield" then
            local nAcModsh = DB.getValue(rRecord,"bonus",0);
			nShielddupdate = 1 + nAcModsh;
            break;

        else
        end
    end
end

if bArmor then

DB.setValue(nodeChar, "ac_current", "number", nACupdate -nShielddupdate);
else
DB.setValue(nodeChar, "ac_current", "number", DB.getValue(nodeChar,"unscore_combat",9)-nShielddupdate);

end
  	manager_char.CalcEnc(nodeItem)
end



function CalcEnc(nodeItem)

local nodeWin = ActorManager.getCreatureNode(nodeItem)

if nodeWin then
nodeChar = nodeWin
else
nodeChar =DB.getChild(nodeItem,"...")

end


local nodeInventoryList = DB.getChild(nodeChar,"inventorylist");
local nAmount = 0
local nEquipTotal = 0
local nCarryTotal = 0
local nEnc = 0
    for sClass,rRecord in pairs(DB.getChildren(nodeInventoryList)) do

	local nCarriedIndex = DB.getValue(rRecord,"carried",0);

		if   nCarriedIndex == 2 then
		local nEnc = DB.getValue(rRecord, "encumbrance",1);
		local nCount = DB.getValue(rRecord, "count",1);

		nEquipTotal = nEquipTotal + (nEnc*nCount)
		end
		if   nCarriedIndex == 1 then
		local nCount = DB.getValue(rRecord, "count",1);
		local nEnc = DB.getValue(rRecord, "encumbrance",0);
		nCarryTotal = nCarryTotal + (nEnc*nCount)
		end
		if   nCarriedIndex == 0 then
		local nEnc = 0;
		nCarryTotal = nCarryTotal +nEnc
		nEquipTotal = nEquipTotal +nEnc
		end

	end
			local nodeCoin = DB.getChild(nodeChar,"coins");
			local nAmount = 0
			for k,v in pairs (DB.getChildren(nodeCoin)) do
			local nCoin = DB.getValue(v,"amount",0)
			nAmount= nAmount+nCoin
			end
if ((nAmount/100) -math.floor(nAmount/100)) > 0 then
nAmount = math.floor(nAmount/100)+1
else
nAmount = math.floor(nAmount/100)
end

DB.setValue(nodeChar,"nEquipenc","number",nEquipTotal)
DB.setValue(nodeChar,"nCarryenc","number",(nCarryTotal + nAmount))

end



function levelchar(nodeChar)

    local nodePC = DB.getChild(nodeChar,"...");

    local sClass = DB.getValue(nodePC, "class_field","")
    local nHpbonus = DB.getValue(nodePC, "hpmod_score")
    local rActor = ActorManager.resolveActor(nodePC);
    local nStr = DB.getValue(nodePC, "str_score")
    local nNewlevel = DB.getValue(nodePC, "Level_new")
    local nMaxcurrhp = DB.getValue(nodePC, "maxhp_combat")
	local sRace = DB.getValue(nodePC, "race_field")
    local bSpells = false
    local bIsBECMI = OptionsManager.isOption("OPT_BECMI", "on");

	local nodeClassData = DB.getChild(nodeChar,"characterclassdata")
		for _,v in pairs (DB.getChildren(nodeClassData)) do
			if DB.getValue(v,"Level_class") == nNewlevel then

			local sSpellSlots = DB.getValue(v,"spells","")

					if sSpellSlots == "" then
					else
					local rSpellSlot = StringManager.split(sSpellSlots, ",", true)
					i = 0
							for _,v in pairs (rSpellSlot) do
							i=i+1
					DB.setValue(nodePC,"spell_level_"..i,"number",tonumber(rSpellSlot[i]))
							bSpells = true
							end
					end
			end

		end


			if StringManager.isWord(sClass:lower(), {"Fighter","Acrobat","Knight"}) then
				if sRace == "Human" or sRace =="" then
				DB.setValue(nodePC, "senses", "string",  "Normal 10");
				end

			elseif 	sClass:lower() =="mycelian" then
			     DB.setValue(nodePC, "senses", "string",  "Infravision 60");

			elseif sClass:lower() =="tiefling" then
					DB.setValue(nodePC, "senses", "string",  "Infravision 60");
					local rHearNoise = OSE_Tables.tieflingHN
			     	for k,v in pairs (rHearNoise) do
					if tonumber(k) ==  nNewlevel then
					nHn= v[1]
					break;
					end
				end

				DB.setValue(nodePC, "ld_score", "number", nHn);


			elseif sClass:lower() =="assassin" then
				if sRace == "Human" or sRace =="" then
				DB.setValue(nodePC, "senses", "string",  "Normal 10");
				end
				local rHearNoise = OSE_Tables.assassinHN

				for k,v in pairs (rHearNoise) do

					if tonumber(k) ==  nNewlevel then
					nHn= v[1]
					break;
					end
				end

				DB.setValue(nodePC, "ld_score", "number", nHn);

			elseif sClass:lower() =="thief" then
				if sRace == "Human" or sRace =="" then
				DB.setValue(nodePC, "senses", "string",  "Normal 10");
				end
				local rHearNoise = OSE_Tables.thiefHN

				for k,v in pairs (rHearNoise) do

					if tonumber(k) ==  nNewlevel then
					nHn= v[1]
					break;
					end
				end

				DB.setValue(nodePC, "ld_score", "number", nHn);

			elseif sClass:lower() =="barbarian" then
				if sRace == "Human" or sRace =="" then
				DB.setValue(nodePC, "senses", "string",  "Normal 10");
				end

			DB.setValue(nodePC, "for_score", "number",  2);
			DB.setValue(nodePC, "hunt_score", "number",  5);
			DB.setValue(nodePC, "foragebox", "number", 1);
			DB.setValue(nodePC, "huntbox", "number", 1);

     -- Now do MU

             elseif sClass:lower() == "magic user" then
					if sRace == "Human" or sRace =="" then
                    DB.setValue(nodePC, "senses", "string",  "Normal 10");
                    end

 if bSpells and bIsBECMI then

else
local Spellslot_Matrix = DataCommon.Spellslot_Matrix_MU

if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)
end
end
        -- Now do cleric

             elseif sClass:lower() == "cleric" then
					if sRace == "Human" or sRace =="" then
                    DB.setValue(nodePC, "senses", "string",  "Normal 10");
                    end

 if bSpells and bIsBECMI then

else
local Spellslot_Matrix = DataCommon.Spellslot_Matrix_Cleric


if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)

end
 end
     -- Now do Elf

             elseif sClass:lower() == "elf" or sClass:lower() =="phase elf" then

            DB.setValue(nodePC, "senses", "string",  "Infravision 60");
			DB.setValue(nodePC, "ld_score", "number",  2);
			DB.setValue(nodePC, "sd_score", "number",  2);

 if bSpells and bIsBECMI then

else
local Spellslot_Matrix =DataCommon.Spellslot_Matrix_Elf

if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)
end
end
     -- Now do Wood Elf

             elseif sClass:lower() == "wood elf" then

            DB.setValue(nodePC, "senses", "string",  "Infravision 60");
			DB.setValue(nodePC, "ld_score", "number",  2);
			DB.setValue(nodePC, "sd_score", "number",  2);
			DB.setValue(nodePC, "for_score", "number",  2);
			DB.setValue(nodePC, "hunt_score", "number",  5);
			DB.setValue(nodePC, "foragebox", "number", 1);
			DB.setValue(nodePC, "huntbox", "number", 1);
 if bSpells and bIsBECMI then

else
local Spellslot_Matrix = DataCommon.Spellslot_Matrix_Elf

if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)
end
end
    -- Now do Halfing

             elseif sClass:lower() == "halfling" then

            DB.setValue(nodePC, "senses", "string",  "Normal 10");
			DB.setValue(nodePC, "ld_score", "number",  2);

     -- Now do Drow

             elseif sClass:lower() == "drow" then

            DB.setValue(nodePC, "senses", "string",  "Infravision 90");
			DB.setValue(nodePC, "ld_score", "number",  2);
			DB.setValue(nodePC, "sd_score", "number",  2);

 if bSpells and bIsBECMI then

else
local Spellslot_Matrix = DataCommon.Spellslot_Matrix_Drow

 if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)
end
end
     -- Now do Illusionist

             elseif sClass:lower() == "illusionist" then
					if sRace == "Human" or sRace =="" then
                    DB.setValue(nodePC, "senses", "string",  "Normal 10");
                    end

 if bSpells and bIsBECMI then

else
local Spellslot_Matrix = DataCommon.Spellslot_Matrix_Illusionist

if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)
end
end
        -- Now do Druid

             elseif sClass:lower() == "druid" then
					if sRace == "Human" or sRace =="" then
                    DB.setValue(nodePC, "senses", "string",  "Normal 10");
                    end

 if bSpells and bIsBECMI then

else
local Spellslot_Matrix = DataCommon.Spellslot_Matrix_Druid

if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)
 end
 end
     -- Now do Bard

             elseif sClass:lower() == "bard" then
					if sRace == "Human" or sRace =="" then
                    DB.setValue(nodePC, "senses", "string",  "Normal 10");
                    end

  if bSpells and bIsBECMI then

else
local Spellslot_Matrix = DataCommon.Spellslot_Matrix_Bard

if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)
end
end
    -- Now do Gnome
             elseif sClass:lower() == "gnome" then

				DB.setValue(nodePC, "hfl_hide", "number", 2);
				DB.setValue(nodePC, "senses", "string", "Infravision 90");
				DB.setValue(nodePC, "ld_score", "number", 2);
				DB.setValue(nodePC, "ct_score", "number", 2);

if bSpells and bIsBECMI then

else
local Spellslot_Matrix = DataCommon.Spellslot_Matrix_Gnome

if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)
end
end

    -- Now do Paladin

             elseif sClass:lower() == "paladin" then
					if sRace == "Human" or sRace =="" then
                    DB.setValue(nodePC, "senses", "string",  "Normal 10");
                    end

if bSpells and bIsBECMI then

else
local Spellslot_Matrix = DataCommon.Spellslot_Matrix_Paladin

if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)
end
end
    -- Now do Ranger

             elseif sClass:lower() == "ranger" then
					if sRace == "Human" or sRace =="" then
                    DB.setValue(nodePC, "senses", "string",  "Normal 10");
                    end
				DB.setValue(nodePC, "hunt_score", "number", 5);
				DB.setValue(nodePC, "for_score", "number", 2);

 if bSpells and bIsBECMI then

else
local Spellslot_Matrix = DataCommon.Spellslot_Matrix_Ranger

if Spellslot_Matrix[nNewlevel] then
 setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)
end
end
end
end

function  setSpellSlots(nodePC,Spellslot_Matrix, nNewlevel)

local First = Spellslot_Matrix [nNewlevel][1];
local Second = Spellslot_Matrix [nNewlevel][2];
local Third = Spellslot_Matrix [nNewlevel][3];
local Fourth = Spellslot_Matrix [nNewlevel][4];
local Fifth = Spellslot_Matrix [nNewlevel][5];
local Sixth = Spellslot_Matrix [nNewlevel][6];

                DB.setValue(nodePC, "spell_level_1", "number",  First);
                DB.setValue(nodePC, "spell_level_2", "number",  Second);
                DB.setValue(nodePC, "spell_level_3", "number",  Third);
                DB.setValue(nodePC, "spell_level_4", "number",  Fourth);
                DB.setValue(nodePC, "spell_level_5", "number",  Fifth);
                DB.setValue(nodePC, "spell_level_6", "number",  Sixth);

end

function fixclass(nodeChar, sClasstype, sName)

	local nodeClasslist =DB.getChild(nodeChar,"classlist")

				b=0;
				for sClass,v in pairs(DB.getChildren(nodeClasslist)) do
				b=b+1
				end

				if b >=2 then

				local msg =
						{
						   font = "reference-h",
						   icon = "portrait_troll";
							mode = "ooc",
							text = "WOW "..sName.."!? Did you really try to drop a second class on your charactersheet?\n You take 3d6 damage from a fireball and die on character creation";
						}
						Comm.deliverChatMessage(msg);

				for sClass,v in pairs(DB.getChildren(nodeClasslist)) do

				local sClasserror = DB.getValue(v, "classname")
					if sClasserror == sClasstype then
					---local sClasspath =v.getPath();

						v.delete();
						---checkclassfix(sClasspath);
					break;
					end
				end
				else
				end
				if b == 1 then
				DB.setValue(nodeChar, "class_field", "string",  sClasstype);
				else
				end


end
function fixrace(nodeChar, sRace, sName)

	local nodeClasslist =DB.getChild(nodeChar,"racelist")

				b=0;
				for sClass,v in pairs(DB.getChildren(nodeClasslist)) do
				b=b+1
				end

				if b >=2 then
				local msg =
						{
						   font = "reference-h",
						   icon = "portrait_troll";
							mode = "ooc",
							text = sName.." rolled a 1!\nThe ceiling of the cave collapses and buries you alive.\nOther players shall mock you mercilessly as you are only allowed one race!";
						}
						Comm.deliverChatMessage(msg);

				local msg =
						{
						   mode = "whisper",
						   text = "No attributes or skills were altered";
						}
						Comm.deliverChatMessage(msg);

					for sClass,v in pairs(DB.getChildren(nodeClasslist)) do

					local sClasserror = DB.getValue(v, "racename")

							if sClasserror == sRace then

								for t,u in pairs (DB.getChildren(v)) do

								u.delete()
								end

								break;

							end
					end

				end
end

function checkdata()
---set windows visible based on class and level for Advanced
local sPCClass = window.class_field.getValue();
local nLevel = window.Level_new.getValue();
local nodeChar = window.getDatabaseNode();
local sRace = DB.getValue(nodeChar,"race_field","")

if StringManager.isWord(sRace:lower(), {"gnome","halfling","svirfneblin","goblin"}) or
StringManager.isWord(sPCClass:lower(), {"gnome","halfling","svirfneblin","goblin"})then
DB.setValue(nodeChar,"race_effects","string","IFT: SIZE (>=large);AC:2")
elseif sPCClass:lower()=="dragonborn" then
DB.setValue(nodeChar,"race_effects","string","AC:1")
end
if StringManager.isWord(sPCClass:lower(),{"drow","elf","tiefling","dragonborn"}) then

			if nLevel >= 10 then
			window.Xpneed_field.setVisible(false)
			window.xpneed_label.setVisible(false)
			end

			if sPCClass:lower() =="tiefling" then
			if nLevel <= 2 then
			DB.setValue(nodeChar, "ld_score", "number", 2);
			elseif nLevel <= 6 then
			DB.setValue(nodeChar, "ld_score", "number", 3);
			elseif nLevel <= 10 then
			DB.setValue(nodeChar, "ld_score", "number", 4);
			else
			DB.setValue(nodeChar, "ld_score", "number", 4);
			end
			end

elseif sPCClass:lower() == "mycelian" then

			if nLevel >= 6 then
			window.Xpneed_field.setVisible(false)
			window.xpneed_label.setVisible(false)
			end




----DB.setValue(nodeChar, "ld_score", "number", 4);

elseif sPCClass == "Duergar" then

DB.setValue(nodeChar, "senses", "string", "Infravision 90");
DB.setValue(nodeChar, "ld_score", "number", 2);
DB.setValue(nodeChar, "ct_score", "number", 2);
DB.setValue(nodeChar, "ft_score", "number", 2);
DB.setValue(nodeChar, "ctbox", "number", 1);

manager_vis.setvis(nodeChar)
elseif sPCClass == "Gnome" or sPCClass == "Halfling" then


elseif sPCClass == "Thief" then

			if nLevel <= 2 then
			DB.setValue(nodeChar, "ld_score", "number", 2);
			elseif nLevel <= 6 then
			DB.setValue(nodeChar, "ld_score", "number", 3);
			elseif nLevel <= 10 then
			DB.setValue(nodeChar, "ld_score", "number", 4);
			else
			DB.setValue(nodeChar, "ld_score", "number", 5);
			end

elseif sPCClass == "Half-Elf" then
DB.setValue(nodeChar, "sd_score", "number", 2);
DB.setValue(nodeChar, "senses", "string", "Darkvision 60");


elseif sPCClass == "Half-Orc" then
DB.setValue(nodeChar, "senses", "string", "Darkvision 60");


elseif sPCClass == "Svirfneblin" then
DB.setValue(nodeChar, "ct_score", "number", 2);
DB.setValue(nodeChar, "ctbox", "number", 1);
DB.setValue(nodeChar, "senses", "string", "Infravision 90");

manager_vis.setvis(nodeChar)
elseif sPCClass == "Dwarf" then
DB.setValue(nodeChar, "ct_score", "number", 2);
DB.setValue(nodeChar, "ctbox", "number", 1);
DB.setValue(nodeChar, "senses", "string", "Darkvision 60");
DB.setValue(nodeChar, "ld_score", "number", 2);

manager_vis.setvis(nodeChar)

elseif sPCClass == "Wood Elf" then
				DB.setValue(nodeChar, "foragebox", "number", 1);
				DB.setValue(nodeChar, "huntbox", "number", 1);
manager_vis.setvis(nodeChar)

elseif sPCClass == "Barbarian" then
				DB.setValue(nodeChar, "foragebox", "number", 1);
				DB.setValue(nodeChar, "huntbox", "number", 1);
manager_vis.setvis(nodeChar)

elseif sPCClass == "Ranger" then
				DB.setValue(nodeChar, "foragebox", "number", 1);
				DB.setValue(nodeChar, "huntbox", "number", 1);
manager_vis.setvis(nodeChar)
elseif  sPCClass == "Cleric" then
		DB.setValue(nodeChar, "turnbox", "number", 1);
		manager_vis.setvis(nodeChar)
end
end

function updateMove()

                local nodeChar = window.getDatabaseNode();


                local nMovebase = DB.getValue(nodeChar,"movement_base.total",120)
                local nOverlnd = nMovebase * 0.2;
                local nExplore = nMovebase;
                local nEnc = nMovebase / 3;
                local nEncround = math.floor(nEnc + 0.5);
                local nExploration = math.floor(nExplore + 0.5);
                local nOver = math.floor(nOverlnd + 0.5);
                DB.setValue(nodeChar, "ov_score", "number", nOver);
                DB.setValue(nodeChar, "ex_score", "number", nExploration);
                DB.setValue(nodeChar, "en_score", "number", nEncround);

end

function updateChr()
                local nodeMod = window.getDatabaseNode();
                local nAbilityValue = window.chr_score.getValue();
				local nAbilityEffect = DB.getValue(nodeMod,"chr_effect",0)
				local nAbilityValue= nAbilityValue  +nAbilityEffect
            if nAbilityValue >= 18  then
                local nPSmod = 2;
                local nMax = 7;
                local nLoyalty = 10;
            DB.setValue(nodeMod, "chr_bonus", "number", nPSmod);
            DB.setValue(nodeMod, "max_retain", "number", nMax);
            DB.setValue(nodeMod, "max_loyalty", "number", nLoyalty);

            elseif nAbilityValue >= 16 and nAbilityValue <= 17 then
                local nPSmod = 1;
                local nMax = 6;
                local nLoyalty = 9;
            DB.setValue(nodeMod, "chr_bonus", "number", nPSmod);
            DB.setValue(nodeMod, "max_retain", "number", nMax);
            DB.setValue(nodeMod, "max_loyalty", "number", nLoyalty);


            elseif nAbilityValue >= 13 and nAbilityValue <= 15 then
                local nPSmod =  1;
                local nMax = 5;
                local nLoyalty = 8;
            DB.setValue(nodeMod, "chr_bonus", "number", nPSmod);
            DB.setValue(nodeMod, "max_retain", "number", nMax);
            DB.setValue(nodeMod, "max_loyalty", "number", nLoyalty);

            elseif    nAbilityValue >= 6 and nAbilityValue <= 8 then
                local nPSmod = (-1);
                local nMax = 3;
                local nLoyalty = 6;
            DB.setValue(nodeMod, "chr_bonus", "number", nPSmod);
            DB.setValue(nodeMod, "max_retain", "number", nMax);
            DB.setValue(nodeMod, "max_loyalty", "number", nLoyalty);

            elseif    nAbilityValue >= 4 and nAbilityValue <= 5 then
                local nPSmod = (-1);
                local nMax = 2;
                local nLoyalty = 5;
            DB.setValue(nodeMod, "chr_bonus", "number", nPSmod);
            DB.setValue(nodeMod, "max_retain", "number", nMax);
            DB.setValue(nodeMod, "max_loyalty", "number", nLoyalty);

            elseif    nAbilityValue <= 3 then
                local nPSmod = (-2);
                local nMax = 1;
                local nLoyalty = 4;
            DB.setValue(nodeMod, "chr_bonus", "number", nPSmod);
            DB.setValue(nodeMod, "max_retain", "number", nMax);
            DB.setValue(nodeMod, "max_loyalty", "number", nLoyalty);

            else
            local nPSmod = 0;
            local nMax = 4;
            local nLoyalty = 7;
            DB.setValue(nodeMod, "chr_bonus", "number", nPSmod);
            DB.setValue(nodeMod, "max_retain", "number", nMax);
            DB.setValue(nodeMod, "max_loyalty", "number", nLoyalty);
            end
end

function updateWis()
                local nodeMod = window.getDatabaseNode();

                local nAbilityValue = window.wis_score.getValue();
				local nAbilityEffect = DB.getValue(nodeMod,"wis_effect",0)
				local nAbilityValue= nAbilityValue  +nAbilityEffect

            if nAbilityValue >= 18  then
                local nPSmod = 3;
             DB.setValue(nodeMod, "wis_bonus", "number", nPSmod);

            elseif nAbilityValue >= 16 and nAbilityValue <= 17 then
                local nPSmod = 2;

             DB.setValue(nodeMod, "wis_bonus", "number", nPSmod);

            elseif nAbilityValue >= 13 and nAbilityValue <= 15 then
                local nPSmod =  1;

            DB.setValue(nodeMod, "wis_bonus", "number", nPSmod);

            elseif    nAbilityValue >= 6 and nAbilityValue <= 8 then
                local nPSmod = (-1);
            DB.setValue(nodeMod, "wis_bonus", "number", nPSmod);

            elseif    nAbilityValue >= 4 and nAbilityValue <= 5 then
                local nPSmod = (-2);

            DB.setValue(nodeMod, "wis_bonus", "number", nPSmod);
            elseif    nAbilityValue <= 3 then
                local nPSmod = (-3);
            DB.setValue(nodeMod, "wis_bonus", "number", nPSmod);
            else
            local nPSmod = 0;
            DB.setValue(nodeMod, "wis_bonus", "number", nPSmod);

            end
end
function updateEffects (nodeItem)
	local nodeChar = DB.getChild(nodeItem, "...")
local nodeInventoryList = DB.getChild(nodeChar,"inventorylist");
local rSource = ActorManager.resolveActor(nodeChar);
local aTarget = {rSource}
local nodeCT = ActorManager.getCTNode(rSource)
local nDuration = 0
local bAdd = true

	if not nodeCT then
	return false
	end
local nodeEffect = DB.getChild(nodeCT,"effects")

	for sClass,rRecord in pairs(DB.getChildren(nodeInventoryList)) do

	local nCarriedIndex =DB.getValue(rRecord,"carried");
	local sName = DB.getValue(rRecord, "name","");

            if  nCarriedIndex == 2 then

				if DB.getChild(rRecord,"spelleffects") ~= nil then
					local nodeSpelleffectlist = DB.getChild(rRecord,"spelleffects")
					for k,v in pairs (DB.getChildren(nodeSpelleffectlist)) do
					sEffect = sName..";"..DB.getValue(v,"effects_name","")
					local bAdd = true


									for i,j in pairs (DB.getChildren(nodeEffect)) do

									local sLabel = DB.getValue(j, "label")
												if sLabel then
										if StringManager.trim(sLabel):lower() == StringManager.trim(sEffect):lower()  then
										bAdd= false
										end
												end
									end

					if sEffect ~= "" and bAdd then
		EffectManager.addEffect("", "", nodeCT, { sName = sEffect, nDuration = nDuration,}, true);
					--manager_effectOSE.EffectHandler(rSource, aTarget,sEffect,nDuration);	
					end
					end

				end

            elseif nCarriedIndex == 1 or nCarriedIndex == 0 then

							local nodeEffect = DB.getChild(nodeCT,"effects")

								if nodeEffect ~= nil then
									for s,t in pairs (DB.getChildren(nodeEffect))do

									local sLabel = DB.getValue(t, "label")
									local rLabel = StringManager.split(sLabel, ";", true)


										if not sLabel then
										return false
										end

										local sLabel= string.match(sLabel,"(.*);")

										if rLabel[1] == sName then
											t.delete()

										end
									end
								end
            end
	end

end


function updateDex()
                local nodeMod = window.getDatabaseNode();
                local sClass = window.class_field.getValue()
                local sRace = window.race_field.getValue()
                local nAbilityValue = window.dex_score.getValue();
				local nAbilityEffect = DB.getValue(nodeMod,"dex_effect",0)
				local nAbilityValue= nAbilityValue  +nAbilityEffect

				local nRacial = DB.getValue(nodeMod, "Missracial", 0);
				local nUnarmored = DB.getValue(nodeMod, "natural_ac", 9);
            if nAbilityValue >= 18  then
                local nPSmod = 3;
                local nMissle = 3;
                local nInitiative = 2;

                DB.setValue(nodeMod, "acmodscore_combat", "number", nPSmod);
                if sClass == "Halfling"  or sRace:lower() == "halfling" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                DB.setValue(nodeMod, "init_score", "number", nInitiative+1);
                elseif sClass == "Wood Elf" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                else
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle + nRacial);
                DB.setValue(nodeMod, "init_score", "number", nInitiative);
                end
                DB.setValue(nodeMod, "unscore_combat", "number", nUnarmored-nPSmod);
            elseif nAbilityValue >= 16 and nAbilityValue <= 17 then
                local nPSmod = 2;
                local nMissle = 2;
                local nInitiative = 1;

                DB.setValue(nodeMod, "acmodscore_combat", "number", nPSmod);
                if sClass == "Halfling"  or sRace:lower() == "halfling" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                DB.setValue(nodeMod, "init_score", "number", nInitiative+1);
                elseif sClass == "Wood Elf" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                else
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle + nRacial);
                DB.setValue(nodeMod, "init_score", "number", nInitiative);
                end

                DB.setValue(nodeMod, "unscore_combat", "number", nUnarmored-nPSmod);
            elseif nAbilityValue >= 13 and nAbilityValue <= 15 then
                local nPSmod = 1;
                local nMissle = 1;
                local nInitiative = 1;

                DB.setValue(nodeMod, "acmodscore_combat", "number", nPSmod);
                if sClass == "Halfling"  or sRace:lower() == "halfling" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                DB.setValue(nodeMod, "init_score", "number", nInitiative+1);
                elseif sClass == "Wood Elf" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                else
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle + nRacial);
                DB.setValue(nodeMod, "init_score", "number", nInitiative);
                end

                DB.setValue(nodeMod, "unscore_combat", "number", nUnarmored-nPSmod);
            elseif    nAbilityValue >= 6 and nAbilityValue <= 8 then
                local nPSmod = -1;
                local nMissle = -1;
                local nInitiative = -1;

                DB.setValue(nodeMod, "acmodscore_combat", "number", nPSmod);
                DB.setValue(nodeMod, "unscore_combat", "number", nUnarmored-nPSmod);
                if sClass == "Halfling"  or sRace:lower() == "halfling" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                DB.setValue(nodeMod, "init_score", "number", nInitiative+1);
                elseif sClass == "Wood Elf" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                else
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle + nRacial);
                DB.setValue(nodeMod, "init_score", "number", nInitiative);
                end

            elseif    nAbilityValue >= 4 and nAbilityValue <= 5 then
                local nPSmod = -2;
                local nMissle = -2;
                local nInitiative = -1;

                DB.setValue(nodeMod, "acmodscore_combat", "number", nPSmod);
               if sClass == "Halfling" or sRace:lower() == "halfling" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                DB.setValue(nodeMod, "init_score", "number", nInitiative+1);
                elseif sClass == "Wood Elf" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                else
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle + nRacial);
                DB.setValue(nodeMod, "init_score", "number", nInitiative);
                end

                DB.setValue(nodeMod, "unscore_combat", "number", nUnarmored-nPSmod);
            elseif    nAbilityValue <= 3 then
                local nPSmod = -3;
                local nMissle = -3;
                local nInitiative = -2;

                DB.setValue(nodeMod, "acmodscore_combat", "number", nPSmod);
               if sClass == "Halfling"  or sRace:lower() == "halfling" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);

                DB.setValue(nodeMod, "init_score", "number", nInitiative+1);
                elseif sClass == "Wood Elf" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                else
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle + nRacial);
                DB.setValue(nodeMod, "init_score", "number", nInitiative);
                end

                DB.setValue(nodeMod, "unscore_combat", "number", nUnarmored-nPSmod);
            else
                local nPSmod = 0;
                local nMissle = 0;
                local nInitiative = 0;

                DB.setValue(nodeMod, "acmodscore_combat", "number", nPSmod);
               if sClass == "Halfling"  or sRace:lower() == "halfling" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                DB.setValue(nodeMod, "init_score", "number", nInitiative+1);
                elseif sClass == "Wood Elf" then
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle+1);
                else
                DB.setValue(nodeMod, "miss_bonus", "number", nMissle + nRacial);
                DB.setValue(nodeMod, "init_score", "number", nInitiative);
                end

                DB.setValue(nodeMod, "unscore_combat", "number", nUnarmored-nPSmod);
            end
end



function updateCon()

                local nodeMod = window.getDatabaseNode();

                local nAbilityValue = window.con_score.getValue();
				local nAbilityEffect = DB.getValue(nodeMod,"con_effect",0)
				local nAbilityValue= nAbilityValue  +nAbilityEffect

            if nAbilityValue >= 18  then
                local nPSmod = 3;
             DB.setValue(nodeMod, "hpmod_score", "number", nPSmod);

            elseif nAbilityValue >= 16 and nAbilityValue <= 17 then
                local nPSmod = 2;

             DB.setValue(nodeMod, "hpmod_score", "number", nPSmod);

            elseif nAbilityValue >= 13 and nAbilityValue <= 15 then
                local nPSmod =  1;

            DB.setValue(nodeMod, "hpmod_score", "number", nPSmod);

            elseif    nAbilityValue >= 6 and nAbilityValue <= 8 then
                local nPSmod = (-1);
            DB.setValue(nodeMod, "hpmod_score", "number", nPSmod);

            elseif    nAbilityValue >= 4 and nAbilityValue <= 5 then
                local nPSmod = (-2);

            DB.setValue(nodeMod, "hpmod_score", "number", nPSmod);
            elseif    nAbilityValue <= 3 then
                local nPSmod = (-3);
            DB.setValue(nodeMod, "hpmod_score", "number", nPSmod);
            else
            local nPSmod = 0;
            DB.setValue(nodeMod, "hpmod_score", "number", nPSmod);

            end
end

function updateInt()
                local nodeMod = window.getDatabaseNode();

                local nAbilityValue = window.int_score.getValue();
				local nAbilityEffect = DB.getValue(nodeMod,"int_effect",0)
				local nAbilityValue= nAbilityValue  +nAbilityEffect

            if nAbilityValue >= 18  then
             local sLanguage = "Native +3 language/Literate"
             DB.setValue(nodeMod, "lang_string", "string", sLanguage);

            elseif nAbilityValue >= 16 and nAbilityValue <= 17 then
             local sLanguage = "Native +2 language/Literate"
             DB.setValue(nodeMod, "lang_string", "string", sLanguage);

            elseif nAbilityValue >= 13 and nAbilityValue <= 15 then
             local sLanguage = "Native +1 language/Literate"
             DB.setValue(nodeMod, "lang_string", "string", sLanguage);
            elseif    nAbilityValue >= 6 and nAbilityValue <= 8 then
             local sLanguage = "Native/Basic"
             DB.setValue(nodeMod, "lang_string", "string", sLanguage);
            elseif    nAbilityValue >= 4 and nAbilityValue <= 5 then
             local sLanguage = "Native/Illiterate"
             DB.setValue(nodeMod, "lang_string", "string", sLanguage);
            elseif    nAbilityValue <= 3 then
             local sLanguage = "Native Broken/Illiterate"
             DB.setValue(nodeMod, "lang_string", "string", sLanguage);
            else
            local nPSmod = 0;
             local sLanguage = "Native/Literate"
             DB.setValue(nodeMod, "lang_string", "string", sLanguage);

            end
end

function updateStr()

                local nodeMod = window.getDatabaseNode();

                local nAbilityValue = window.str_score.getValue();
				local nAbilityEffect = DB.getValue(nodeMod,"str_effect",0)
				local nAbilityValue= nAbilityValue  +nAbilityEffect
            if nAbilityValue >= 18  then
                local nPSmod = 3;
                local nDoor = 5;
             DB.setValue(nodeMod, "attmod_score", "number", nPSmod);
              DB.setValue(nodeMod, "od_score", "number", nDoor);
            elseif nAbilityValue >= 16 and nAbilityValue <= 17 then
                local nPSmod = 2;
                local nDoor = 4;
             DB.setValue(nodeMod, "attmod_score", "number", nPSmod);
              DB.setValue(nodeMod, "od_score", "number", nDoor);
            elseif nAbilityValue >= 13 and nAbilityValue <= 15 then
                local nPSmod =  1;
                local nDoor = 3;
            DB.setValue(nodeMod, "attmod_score", "number", nPSmod);
            DB.setValue(nodeMod, "od_score", "number", nDoor);
            elseif    nAbilityValue >= 6 and nAbilityValue <= 8 then
                local nPSmod = (-1);
                local nDoor = 1;
            DB.setValue(nodeMod, "attmod_score", "number", nPSmod);
            DB.setValue(nodeMod, "od_score", "number", nDoor);
            elseif    nAbilityValue >= 4 and nAbilityValue <= 5 then
                local nPSmod = (-2);
                 local nDoor = 1;
            DB.setValue(nodeMod, "attmod_score", "number", nPSmod);
            DB.setValue(nodeMod, "od_score", "number", nDoor);
            elseif    nAbilityValue <= 3 then
                local nPSmod = (-3);
                 local nDoor = 1;
            DB.setValue(nodeMod, "attmod_score", "number", nPSmod);
            DB.setValue(nodeMod, "od_score", "number", nDoor);
            else
            local nPSmod = 0;
             local nDoor = 2;
            DB.setValue(nodeMod, "attmod_score", "number", nPSmod);
            DB.setValue(nodeMod, "od_score", "number", nDoor);

            end
end

function CheckUnarmored(nodeChar)

local bArmor = false
local nACupdate = 9
local nShielddupdate = 0
local nAcmod= DB.getValue(nodeChar,"acmodscore_combat",0)
local nodeInventoryList = DB.getChild(nodeChar,"inventorylist");
for sClass,rRecord in pairs(DB.getChildren(nodeInventoryList)) do

local nCarriedIndex = DB.getValue(rRecord,"carried");
local sType = DB.getValue(rRecord, "type",0);

        if nCarriedIndex == 2 then

            if sType == "Armor" then
            bArmor = true
            local nAC = DB.getValue(rRecord,"acbase");
            local nAcModar = DB.getValue(rRecord,"bonus");
            nACupdate = nAC - nAcModar-nAcmod ;

            break;

        else
        end
    end
end

for sClass,rRecord in pairs(DB.getChildren(nodeInventoryList)) do

local nCarriedIndex = DB.getValue(rRecord,"carried");
local sType = DB.getValue(rRecord, "type",0);

        if nCarriedIndex == 2 then

            if sType == "Shield" then
            local nAcModsh = DB.getValue(rRecord,"bonus");
			nShielddupdate = 1 + nAcModsh;
            break;
        end
    end
end


if bArmor then

DB.setValue(nodeChar, "ac_current", "number", nACupdate-nShielddupdate);
else

DB.setValue(nodeChar, "ac_current", "number", (DB.getValue(nodeChar,"unscore_combat",9)-nShielddupdate));

end

end

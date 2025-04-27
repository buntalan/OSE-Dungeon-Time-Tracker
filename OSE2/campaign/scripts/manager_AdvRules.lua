function LevelPC(nodeClass)

local nodeChar = DB.getChild(nodeClass,"...");

local nodeClassData = DB.getChild(nodeClass,"characterclassdata");
local rActor = ActorManager.resolveActor(nodeChar);

manager_AdvRules.BuildSkill(nodeClass);
manager_AdvRules.GetAbility(nodeClass);

	for _,v in pairs (DB.getChildren(nodeClassData)) do

	local nLevelcur = DB.getValue(nodeChar,"Level_new", 0)
	local nLevel =  DB.getValue(v, "Level_class", 0);


		if nLevelcur == nLevel then

		local nXp = DB.getValue(v, "XP_class", 0);
		local Dsv = DB.getValue(v, "SVD_num", 0);
		local Wsv = DB.getValue(v, "SVW_num", 0);
		local Psv = DB.getValue(v, "SVP_num", 0);
		local Bsv = DB.getValue(v, "SVB_num", 0);
		local Ssv = DB.getValue(v, "SVS_num", 0);
		local nTHACOnew = DB.getValue(v, "thaco_class", 0);
		local sDie = DB.getValue(v, "HD_class", "");
		local nNatAC = DB.getValue(v, "natural_ac", 9);

		if nNatAC < 9 and nNatAC ~= 0 then
		DB.setValue(nodeChar, "natural_ac", "number", nNatAC);
		end

                DB.setValue(nodeChar, "spellsave_base", "number", Ssv);
                DB.setValue(nodeChar, "wsave_base", "number", Wsv);
                DB.setValue(nodeChar, "dsave_score", "number", Dsv);
                DB.setValue(nodeChar, "wsave_score", "number", Wsv);
                DB.setValue(nodeChar, "psave_score", "number", Psv);
                DB.setValue(nodeChar, "bsave_score", "number", Bsv);
                DB.setValue(nodeChar, "ssave_score", "number", Ssv);
                DB.setValue(nodeChar, "Xpneed_field", "number", nXp);
				DB.setValue(nodeChar, "thaco", "number",  nTHACOnew);
                --DB.setValue(nodeChar, "ld_score", "number",  1);   
              --  DB.setValue(nodeChar, "sd_score", "number",  1);   
               -- DB.setValue(nodeChar, "ft_score", "number",  1);  

			local nHpbonus = DB.getValue(nodeChar, "hpmod_score", 0);

			if nLevelcur >= 10 then

			local sBon = DB.getValue(v, "HDbonus", "0");
			local nBon = tonumber(sBon);
			local nHpbonus = nBon;

			manager_action_buildAdvPC.performRoll(draginfo, rActor, sDie, nHpbonus);

			break;
			end

manager_action_buildAdvPC.performRoll(draginfo, rActor, sDie, nHpbonus);

break;

		else
		end



	end


end

function BuildSkill(nodeClass)

local nodeChar = DB.getChild(nodeClass,"...");
local sClassSkill = DB.getValue(nodeClass, "skill_field", "")
local nLevel = DB.getValue(nodeChar,"Level_new", 0);
local bIsD6 = OptionsManager.isOption("OPT_D6", "on");
if sClassSkill ~= ""  and nLevel <= 1 then

local rStrings =StringManager.split(sClassSkill, "," , true);

local nodeskill = DB.createChild(nodeChar,"skillslist");



for k,v in pairs (rStrings) do

		local nodeValue = nodeskill.createChild();
        DB.setValue(nodeValue, "skillname", "string", v);

			local nodeSkill = DB.getChild(nodeClass,"classskills");



			for t,p in pairs (DB.getChildren(nodeSkill)) do

			local sName = DB.getValue(p, "skill_name", "");

				if v:lower() == sName:lower() then

					local sLevel = DB.getValue(nodeChar,"Level_new", "");


					local nSkillValue = DB.getValue(p, "lvl"..sLevel, 0);
					local sDie = DB.getValue(p, "die", "d100");
						if sDie == "" then sDie = "d100" end
						if bIsD6 and DB.getValue(nodeChar,"class_field",""):lower()=="thief" then
						else
					DB.setValue(nodeValue, "chance_success", "number", nSkillValue);
						end
					DB.setValue(nodeValue, "die", "string", sDie);
				end
			end

end


elseif sClassSkill ~= ""  and nLevel >= 2 then
manager_AdvRules.SetSkillValue(nodeClass);

end

end


function SetSkillValue(nodeClass)

local nodeChar = DB.getChild(nodeClass,"...");
local sClassSkill = DB.getValue(nodeClass, "skill_field", "")
local bIsD6 = OptionsManager.isOption("OPT_D6", "on");
local nodeSkilllist = DB.getChild(nodeChar,"skillslist");


for k,v in pairs (DB.getChildren(nodeSkilllist)) do

			local nodeSkill = DB.getChild(nodeClass,"classskills");

			local sCharSkill = DB.getValue(v, "skillname", "");


			for t,p in pairs (DB.getChildren(nodeSkill)) do

			local sName = DB.getValue(p, "skill_name", "");

				if sCharSkill:lower() == sName:lower() then


					local sLevel = DB.getValue(nodeChar,"Level_new", "");


					local nSkillValue = DB.getValue(p, "lvl"..sLevel, 0);

					local sDie = DB.getValue(p, "die", "d100");
						if sDie == "" then sDie = "d100" end
					DB.setValue(v, "die", "string", sDie);
						if bIsD6 and DB.getValue(nodeChar,"class_field",""):lower()=="thief" then
						else
					DB.setValue(v, "chance_success", "number", nSkillValue);
						end
				end
			end

end
end

function GetAbility(nodeClass)

local nodeChar = DB.getChild(nodeClass,"...");
local nodeClassAbility = DB.getChild(nodeClass,"abilitylist");
local nLevel = DB.getValue(nodeChar,"Level_new", 0);


local nodeAbility = DB.createChild(nodeChar,"abilitylist");


for k,v in pairs (DB.getChildren(nodeClassAbility)) do



local nAbilityLevel = DB.getValue(v, "ability_level", 0);

if nLevel == nAbilityLevel then
local nodeValue = DB.createChild(nodeAbility);

local nAbilityLevel = DB.getValue(v, "ability_level", 0);
local sName = DB.getValue(v, "skillname", "");
local Text1 = DB.getValue(v, "description_text", "");


					DB.setValue(nodeValue, "ability_level", "number", nAbilityLevel);
					DB.setValue(nodeValue, "skillname", "string", sName);
					DB.setValue(nodeValue, "description_text", "formattedtext", "<p>" .. Text1 .. "</p>");
					DB.setValue(nodeValue, "skills_link", "windowreference", "skills" );

else
end

end

end

function addInfoDB(nodeChar, sClass, sRecord,sClassString)

local rActor = ActorManager.resolveActor(nodeChar);

	local nodeSource = DB.findNode(sRecord);

	if not nodeSource then
		return;
	end

local nodeClassData = DB.getChild(nodeSource,"characterclassdata");

		local nlevelcur = DB.getValue(nodeChar,"multlvl"..sClassString,0)+1

		DB.setValue(nodeChar, "class"..sClassString, "string", DB.getValue(nodeSource, "name", ""));
		DB.setValue(nodeChar, "class_link"..sClassString, "windowreference", sClass, nodeSource.getPath());
		local sClasses1 = DB.getValue(nodeChar,"class1","string","")
		local sClasses2 = DB.getValue(nodeChar,"class2","string","")
		local sClassstring = sClasses1.."/"..sClasses2
		DB.setValue(nodeChar,"multiclassname","string",sClassstring)

		DB.setValue(nodeChar,"Level_new", "number",nlevelcur)
		if StringManager.isWord(DB.getValue(nodeSource, "name", ""):lower(), {"cleric","friar","paladin","avenger","dervish"}) then
		DB.setValue(nodeChar,"turn_level", "number",nlevelcur)
		end
local nCon =DB.getValue(nodeChar,"con_score",0)
local sRace = DB.getValue(nodeChar,"race_field","")

if sRace== "Halfling" or sRace == "Dwarf" or sRace == "Duergar" or sRace == "Gnome" then
	if nCon >= 18 then
	nRes = 5
	elseif nCon >= 15 then
	nRes = 4
	elseif nCon >=11 then
	nRes = 3
	elseif nCon >=7 then
	nRes = 2
	elseif nCon <=6 then
	nRes = 0
	end

else
nRes = 0
end
	for k,v in pairs (DB.getChildren(nodeClassData)) do
		local nLevel =  DB.getValue(v, "Level_class", 0);

		if nlevelcur == nLevel then

		local nXp = DB.getValue(v, "XP_class", 0);
		local Dsv = DB.getValue(v, "SVD_num", 0);
		local Wsv = DB.getValue(v, "SVW_num", 0);
		local Psv = DB.getValue(v, "SVP_num", 0);
		local Bsv = DB.getValue(v, "SVB_num", 0);
		local Ssv = DB.getValue(v, "SVS_num", 0);
		local nTHACOnew = DB.getValue(v, "thaco_class", 0);
		local sDie = DB.getValue(v, "HD_class", "");

				if Dsv < DB.getValue(nodeChar,"dsave_score") or DB.getValue(nodeChar,"dsave_score") ==0 then
                DB.setValue(nodeChar, "dsave_score", "number", Dsv);
                end
				if (DB.getValue(nodeChar,"wsave_base",0)-nRes) < DB.getValue(nodeChar,"wsave_score") or DB.getValue(nodeChar,"wsave_score") ==0  then
                DB.setValue(nodeChar, "wsave_score", "number", Wsv);
                DB.setValue(nodeChar, "wsave_base", "number", Wsv);
                manager_resilience.onUpdateWandSaves(nodeChar)
                end
				if Psv < DB.getValue(nodeChar,"psave_score") or DB.getValue(nodeChar,"psave_score") ==0  then
                DB.setValue(nodeChar, "psave_score", "number", Psv);
                end
				if Bsv < DB.getValue(nodeChar,"bsave_score") or DB.getValue(nodeChar,"bsave_score") ==0  then
                DB.setValue(nodeChar, "bsave_score", "number", Bsv);
                end
				if (DB.getValue(nodeChar,"spellsave_base",0)-nRes) < DB.getValue(nodeChar,"ssave_score") or DB.getValue(nodeChar,"ssave_score") ==0  then
                DB.setValue(nodeChar, "ssave_score", "number", Ssv);
                DB.setValue(nodeChar, "spellsave_base", "number", Ssv);
                manager_resilience.onUpdateSpellSaves(nodeChar)
				end
                DB.setValue(nodeChar, "xpneed"..sClassString, "number", nXp);
				if nTHACOnew < DB.getValue(nodeChar,"thaco")  or DB.getValue(nodeChar,"thaco") ==0 then
				DB.setValue(nodeChar, "thaco", "number",  nTHACOnew);
				end
                --DB.setValue(nodeChar, "ld_score", "number",  1);   
              --  DB.setValue(nodeChar, "sd_score", "number",  1);   
               -- DB.setValue(nodeChar, "ft_score", "number",  1);  

			local nHpbonus = DB.getValue(nodeChar, "hpmod_score", 0);

			DB.setValue(nodeChar, "multlvl"..sClassString,"number",nlevelcur)

			if nlevelcur >= 10 then

			local sBon = DB.getValue(v, "HDbonus", "0");
			local nBon = tonumber(sBon);
			local nHpbonus = nBon;

			manager_action_buildAdvPC.performRoll(draginfo, rActor, sDie, nHpbonus);

			break;
			end

manager_action_buildAdvPC.performRoll(draginfo, rActor, sDie, nHpbonus);

break;




	end
end


manager_AdvRules.BuildSkillMult(nodeSource,nodeChar,sClassString);
manager_AdvRules.GetAbilityMult(nodeSource,nodeChar);
manager_AdvRules.levelchar(nodeChar,sClassString,nodeClassData)
end



function BuildSkillMult(nodeSource,nodeChar,sClassString)

local sRecordName = DB.getValue(nodeSource,"name","")
local sClassSkill = DB.getValue(nodeSource, "skill_field", "")
local nLevel = DB.getValue(nodeChar,"multlvl"..sClassString, 0);
local bIsD6 = OptionsManager.isOption("OPT_D6", "on");
if sClassSkill ~= ""  and nLevel <= 1 then

local rStrings =StringManager.split(sClassSkill, "," , true);

local nodeskill = DB.createChild(nodeChar,"skillslist");



for k,v in pairs (rStrings) do
		local nodeValue =DB.createChild(nodeskill)
        DB.setValue(nodeValue, "skillname", "string", v);

			local nodeSkillRecord = DB.getChild(nodeSource,"classskills");

			for t,p in pairs (DB.getChildren(nodeSkillRecord)) do

			local sName = DB.getValue(p, "skill_name", "");

				if v:lower() == sName:lower() then

					local nSkillValue = DB.getValue(p, "lvl"..nLevel, 0);

					local sDie = DB.getValue(p, "die", "d100");
					if sDie == "" then sDie = "d100" end
					DB.setValue(nodeValue, "die", "string", sDie);
						if bIsD6 and sRecordName:lower() =="thief" then
						else
					DB.setValue(nodeValue, "chance_success", "number", nSkillValue);
						end
				end
			end

end


elseif sClassSkill ~= ""  and nLevel >= 2 then
manager_AdvRules.SetSkillMultValue(nodeSource,nodeChar,sClassString);

end

end


function SetSkillMultValue(nodeSource,nodeChar,sClassString)
local bIsD6 = OptionsManager.isOption("OPT_D6", "on");
local sClassSkill = DB.getValue(nodeSource, "skill_field", "")
local nodeSkilllist = DB.getChild(nodeChar,"skillslist");
local sRecordName = DB.getValue(nodeSource,"name","")

for k,v in pairs (DB.getChildren(nodeSkilllist)) do

			local nodeSkillRecord = DB.getChild(nodeSource,"classskills");

			local sCharSkill = DB.getValue(v, "skillname", "");


			for t,p in pairs (DB.getChildren(nodeSkillRecord)) do

			local sName = DB.getValue(p, "skill_name", "");

				if sCharSkill:lower() == sName:lower() then


					local sLevel = DB.getValue(nodeChar,"multlvl"..sClassString, "");


					local nSkillValue = DB.getValue(p, "lvl"..sLevel, 0);

					local sDie = DB.getValue(p, "die", "d100");
					if sDie == "" then sDie = "d100" end
					DB.setValue(v, "die", "string", sDie);
						if bIsD6 and sRecordName:lower() =="thief" then
						else
					DB.setValue(v, "chance_success", "number", nSkillValue);
						end
				end
			end

end
end

function GetAbilityMult(nodeClass,nodeChar)


local nodeClassAbility = DB.getChild(nodeClass,"abilitylist");
local nLevel = DB.getValue(nodeChar,"Level_new", 0);


local nodeAbility = DB.createChild(nodeChar,"abilitylist");


for k,v in pairs (DB.getChildren(nodeClassAbility)) do



local nAbilityLevel = DB.getValue(v, "ability_level", 0);

if nLevel == nAbilityLevel then
local nodeValue = DB.createChild(nodeAbility);

local nAbilityLevel = DB.getValue(v, "ability_level", 0);
local sName = DB.getValue(v, "skillname", "");
local Text1 = DB.getValue(v, "description_text", "");


					DB.setValue(nodeValue, "ability_level", "number", nAbilityLevel);
					DB.setValue(nodeValue, "skillname", "string", sName);
					DB.setValue(nodeValue, "description_text", "formattedtext", "<p>" .. Text1 .. "</p>");
					DB.setValue(nodeValue, "skills_link", "windowreference", "skills" );

else
end

end

end


function levelchar(nodePC,sClassString,nodeClassData)
    local sClass = DB.getValue(nodePC, "class"..sClassString)
    local nHpbonus = DB.getValue(nodePC, "hpmod_score")
    local nStr = DB.getValue(nodePC, "str_score")
    local nNewlevel = DB.getValue(nodePC, "multlvl"..sClassString)
    local nMaxcurrhp = DB.getValue(nodePC, "maxhp_combat")
	local sRace = DB.getValue(nodePC, "race_field","")



    local bSpells = false
    local bIsBECMI = OptionsManager.isOption("OPT_BECMI", "on");

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
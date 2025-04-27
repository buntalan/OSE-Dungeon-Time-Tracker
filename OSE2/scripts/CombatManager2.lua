
function onInit()
	CombatManager.setCustomSort(CombatManager.sortfuncStandard);
	CombatManager.setCustomCombatReset(resetInit);
	CombatRecordManager.setRecordTypeCallback("npc", onNPCAdd);
	ActorCommonManager.setRecordTypeSpaceReachCallback("npc", ActorCommonManager.getSpaceReachFromSizeFieldCore);
	
	CombatRecordManager.addStandardVehicleCombatRecordType();
	
	
	CombatRecordManager.setRecordTypePostAddCallback("npc", onNPCPostAdd);
	ActorCommonManager.setRecordTypeSpaceReachCallback("vehicle", ActorCommonManager.getSpaceReachFromSizeFieldCore);
	
	CombatRecordManager.setRecordTypeCallback("charsheet", onPCAdd);
	
end

--
-- ACTIONS
--

function onNPCAdd(tCustom)

helperAddHiddenName(tCustom);
CombatRecordManager.addNPC(tCustom);
return true;
end

function helperAddHiddenName(tCustom)
	if not tCustom.sName then
		tCustom.sName = DB.getValue(tCustom.nodeRecord, "name", "");
	end
	tCustom.sNameHidden = tCustom.sName:match("%(.*%)");
	tCustom.sName = StringManager.trim(tCustom.sName:gsub("%(.*%)", ""));
end


function onPCAdd(tCustom)

	CombatRecordManager.addPC(tCustom);
	setRaceEffects(tCustom)
	return true;
end

function setRaceEffects(tCustom)

local nodeChar = tCustom.nodeRecord
Debug.console(DB.getValue(nodeChar,"race_effects",""))
	if DB.getValue(nodeChar,"race_effects","") ~= "" then

	EffectManager.addEffect("", "", tCustom.nodeCT , { sName = DB.getValue(nodeChar,"race_effects",""), nDuration = 0,}, true);

	end
end


function resetInit()
	for _,v in pairs(CombatManager.getCombatantNodes()) do
		DB.setValue(v, "initresult", "number", 0);
	end
end

function RollNPC()

local bIsGroup = OptionsManager.isOption("BEMP_INITTYPE", "Group")
local nGroup = math.random(6)


		for _,v in pairs(CombatManager.getCombatantNodes()) do
			local sFaction = DB.getValue(v,"friendfoe","friend")


			if sFaction == "friend" then

			else
			 if not bIsGroup then
				 nInit = math.random (6)
			 else
				nInit= nGroup
			 end
			DB.setValue(v,"initresult","number",nInit)

			end
		end
end

function helperAddBattleNPC(tCustom)
	if not tCustom.tBattleEntry or not tCustom.tBattleEntry.nodeBattleEntry then
		return;
	end

	local nHP = DB.getValue(tCustom.tBattleEntry.nodeBattleEntry, "hp_current", 0);
	if (nHP ~= 0) then
		DB.setValue(tCustom.nodeCT, "hp_current", "number", nHP);
		DB.setValue(tCustom.nodeCT, "maxhp_combat", "number", nHP);
	end
	
end	
function onNPCPostAdd(tCustom)

	if not tCustom.nodeRecord or not tCustom.nodeCT then
		return;
	end
	
	-- Setup
	local nodeNPC = tCustom.nodeRecord;	
	
local nHP= DB.getValue(nodeNPC, "hp_current", 0)
local nMaxHP = DB.getValue(nodeNPC, "maxhp_combat", 0)

local bIsRandom = OptionsManager.isOption("BEMP_HITPOINTS", "Random");

	if bIsRandom then
	-- Set current hit points


		local nHD = DB.getValue(tCustom.nodeRecord, "hd_current", 0);
		local sHDMod = DB.getValue(tCustom.nodeRecord, "bonushd", "0");

		if sHDMod == "" then sHDMod = "0" end
			if nHD == 0 then
			nHP=1
			else
			local nHPMax = nHD *8 + tonumber(sHDMod)
			local nHPMIN = nHD + tonumber(sHDMod)
			if nHPMIN <=0 then nHPMIN =1 end
				if nHPMIN==nHPMax then
				nHP=nHPMIN
				else
				nHP = math.random(nHPMIN,nHPMax)
				end
			end
	
	end	


	if nHP < 0 then
	nHP = nMaxHP
	
	elseif nHP == 0 then
	local nHD = DB.getValue(nodeNPC, "hd_current", 0)
		if nHD >=1 then
		nHP =nHD *math.random(1,8)
		else
		nHP =math.random(1,4)
		end
	end
	
DB.setValue(tCustom.nodeCT, "maxhp_combat", "number", nHP);
DB.setValue(tCustom.nodeCT, "hp_current", "number", nHP);
local nodeSpell = DB.getChild(nodeNPC,"spellwindows")
local nodeSpellCT = DB.getChild(tCustom.nodeCT,"spellsslist")

	for _,vSpells in ipairs(DB.getChildList(nodeSpell)) do

		for _,vSpellnode in ipairs(DB.getChildList(DB.getChild(vSpells,"spellslist"))) do
		
		if nodeSpellCT then
				local CTnodeSpell = DB.createChild(nodeSpellCT)
				DB.copyNode(vSpellnode,CTnodeSpell)
		end		
		end


	end	

	-- Track additional damage types and intrinsic effects
	local aEffects = {};
	
	-- Vulnerabilities
	local aVulnTypes = parseResistances(DB.getValue(tCustom.nodeCT, "damagevulnerabilities", ""));
	if #aVulnTypes > 0 then
		for _,v in ipairs(aVulnTypes) do
			if v ~= "" then
				table.insert(aEffects, "VULN: " .. v);
			end
		end
	end
			
	-- Damage Resistances
	local aResistTypes = parseResistances(DB.getValue(tCustom.nodeCT, "damageresistances", ""));

	if #aResistTypes > 0 then
		for _,v in ipairs(aResistTypes) do
			if v ~= "" then

				table.insert(aEffects, "RESIST: " .. v);
			end
		end
	end
	
	-- Damage immunities
	local aImmuneTypes = parseResistances(DB.getValue(tCustom.nodeCT, "damageimmunities", ""));
	if #aImmuneTypes > 0 then
		for _,v in ipairs(aImmuneTypes) do
			if v ~= "" then
				table.insert(aEffects, "IMMUNE: " .. v);
			end
		end
	end

	if #aEffects > 0 then
		EffectManager.addEffect("", "", tCustom.nodeCT, { sName = table.concat(aEffects, "; "), nDuration = 0, nGMOnly = 1 }, false);
	end
	
	helperAddBattleNPC(tCustom);
		
	return tCustom.nodeCT;
end

function parseResistances(sResistances)
	local aResults = {};
	sResistances = sResistances:lower();

	for _,v in ipairs(StringManager.split(sResistances, ";\r", true)) do
		local aResistTypes = {};
		
		for _,v2 in ipairs(StringManager.split(v, ",", true)) do
			if StringManager.isWord(v2, DataCommon.dmgtypes) then
				table.insert(aResistTypes, v2);
			else
				local aResistWords = StringManager.parseWords(v2);

				local i = 1;
				while aResistWords[i] do

					if StringManager.isWord(aResistWords[i], DataCommon.dmgtypes) then
						table.insert(aResistTypes, aResistWords[i]);
					elseif StringManager.isWord(aResistWords[i], "from") and StringManager.isWord(aResistWords[i+1], "nonmagical") and StringManager.isWord(aResistWords[i+2], { "weapons", "attacks" }) then
						i = i + 2;
						table.insert(aResistTypes, "mundane, !magic");
					elseif StringManager.isWord(aResistWords[i], "all") and StringManager.isWord(aResistWords[i+1], "damage") and StringManager.isWord(aResistWords[i+2],  "reduced" ) then
						i = i + 2;
						table.insert(aResistTypes, "halfdmg");
					elseif StringManager.isWord(aResistWords[i], "except")  then
						i = i + 2;
						if StringManager.isWord(aResistWords[i], "or") then
							table.insert(aResistTypes, "!"..aResistWords[i-1]..", !"..aResistWords[i+1]);
						i = i + 1;	
						else
						table.insert(aResistTypes, "!"..aResistWords[i-1]);
						end	
						
					elseif StringManager.isWord(aResistWords[i], "can") and StringManager.isWord(aResistWords[i+1], "only") and StringManager.isWord(aResistWords[i+3], "harmed")then
						i = i + 5;
						
						if StringManager.isWord(aResistWords[i], "silvered") and StringManager.isWord(aResistWords[i+2], "magical") then
							table.insert(aResistTypes, "mundane, !silver, !magic");

						end
					end
					
					i = i + 1;
				end
			end
		end

		if #aResistTypes > 0 then
			table.insert(aResults, table.concat(aResistTypes, ", "));
		end
	end

	return aResults;

end

function rest(bLong)
	CombatManager.resetInit();
	CombatManager2.clearExpiringEffects();

	for _,v in pairs(CombatManager.getCombatantNodes()) do
		local bHandled = false;
		local nHeal = math.random(3)
		local sClass, sRecord = DB.getValue(v, "link", "", "");
		if sClass == "charsheet" and sRecord ~= "" then
			local nodePC = DB.findNode(sRecord);
			if nodePC then
			local nWound = DB.getValue(v, "wounds",0)
				if (nWound -nHeal) >=0 then
				local nWound = nWound-nHeal
				DB.setValue(v,"wounds","number",nWound)
				else
				DB.setValue(v,"wounds","number",0)
				end
				bHandled = true;
			end
		end
		
	
		if not bHandled then
			--CombatManager2.resetHealth(v, bLong);
		end
		local nodePC = DB.findNode(sRecord);
		if nodePC then
		local nodeChar = ActorManager.getCreatureNode(v)

		local nodeSpell = DB.getChild(nodeChar,"spellwindows")
				if nodeSpell then
					for _,vSpell in pairs (DB.getChildren(nodeSpell)) do
					
							local nodeSpells = DB.getChild(vSpell,"spellslist")
									if nodeSpells then
										for _,vSpellReset in pairs (DB.getChildren(nodeSpells)) do
										
										local nodePower = DB.getChild(vSpellReset,"...")

										if string.find(DB.getValue(nodePower,"spelllabelstring",""):lower(),"level") or string.find(DB.getValue(nodePower,"spelllabelstring",""):lower(),"lvl")then
										DB.setValue(vSpellReset,"current","number",DB.getValue(vSpellReset,"memorized",0))
										end
										end						
									
									end
									
					end

				end		
		end
	
		
	end
	
	
	
	
end



function clearExpiringEffects()

	function checkEffectExpire(nodeEffect)
		local sLabel = DB.getValue(nodeEffect, "label", "");
		local nDuration = DB.getValue(nodeEffect, "duration", 0);
		local sApply = DB.getValue(nodeEffect, "apply", "");
		
		if nDuration ~= 0 or sApply ~= "" or sLabel == "" then
			nodeEffect.delete();
		end
	end
	CombatManager.callForEachCombatantEffect(checkEffectExpire);
end
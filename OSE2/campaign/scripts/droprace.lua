function addInfoDB(nodeChar, sClass, sRecord)
local rActor = ActorManager.resolveActor(nodeChar);

	local nodeSource = DB.findNode(sRecord);

	if not nodeSource then
		return;
	end

		DB.setValue(nodeChar, "race_field", "string", DB.getValue(nodeSource, "name", ""));
		DB.setValue(nodeChar, "race_link", "windowreference", sClass, nodeSource.getPath());
		

	
			local sSenses = DB.getValue(nodeSource, "asenses", "");
		
			DB.setValue(nodeChar, "senses","string",sSenses) 
			
			

	
---set skills
		local nLd = DB.getValue(nodeSource, "ldrace_score", 1);
		local nSd = DB.getValue(nodeSource, "asdrace_score", 1);
		local nFt = DB.getValue(nodeSource, "ftrace_score", 1);
		local nCt = DB.getValue(nodeSource, "ctrace_score", 1);
		local nHt = DB.getValue(nodeSource, "huntrace_score", 1);	
		local nHd = DB.getValue(nodeSource, "hiderace_score", 1);
		local nFg = DB.getValue(nodeSource, "foragerace_score", 1);

		DB.setValue(nodeChar, "ld_score","number",nLd) 
		DB.setValue(nodeChar, "sd_score","number",nSd) 	
		DB.setValue(nodeChar, "ft_score","number",nFt) 
		DB.setValue(nodeChar, "ct_score","number",nCt) 
		DB.setValue(nodeChar, "hunt_score","number",nHt) 
		DB.setValue(nodeChar, "hfl_hide","number",nHd) 	
		DB.setValue(nodeChar, "for_score","number",nFg)
		
--- adjust attacks and damage
		local nMelee = DB.getValue(nodeSource, "meleeracial_Bonus", 0);
		local nMissle = DB.getValue(nodeSource, "missracial_bonus", 0);
		
		local nMel =DB.getValue(nodeChar, "attmod_score", 0) + nMelee;

		
		DB.setValue(nodeChar, "attmod_score","number",nMel) 
		DB.setValue(nodeChar, "Missracial","number",nMissle) 
		
				
		
---adjust attributes	
		local nStr =DB.getValue(nodeSource, "astr_scoreBonus", 0);
		local nInt =DB.getValue(nodeSource, "int_scoreBonus", 0);
		local nWis =DB.getValue(nodeSource, "awis_scoreBonus", 0);
		local nDex =DB.getValue(nodeSource, "dex_scoreBonus", 0);
		local nCon =DB.getValue(nodeSource, "con_scoreBonus", 0);
		local nCha =DB.getValue(nodeSource, "chr_scoreBonus", 0);
		
		local nStr =DB.getValue(nodeChar, "str_score", 0) + nStr;
		local nInt =DB.getValue(nodeChar, "int_score", 0) + nInt;
		local nWis =DB.getValue(nodeChar, "wis_score", 0) + nWis;
		local nDex =DB.getValue(nodeChar, "dex_score", 0) + nDex;
		local nCon =DB.getValue(nodeChar, "con_score", 0) + nCon;
		local nCha =DB.getValue(nodeChar, "chr_score", 0) + nCha;	
		
		DB.setValue(nodeChar, "str_score","number",nStr) 
		DB.setValue(nodeChar, "int_score","number",nInt) 	
		DB.setValue(nodeChar, "wis_score","number",nWis) 	
		DB.setValue(nodeChar, "dex_score","number",nDex) 	
		DB.setValue(nodeChar, "con_score","number",nCon) 	
		DB.setValue(nodeChar, "chr_score","number",nCha) 	
			

droprace.GetAbility(nodeSource,nodeChar);
end


function GetAbility(nodeSource,nodeChar)

local nodeRaceData = DB.getChild(nodeSource,"mracial_abilitylist");

local nodeAbility = DB.createChild(nodeChar,"abilitylist");

for k,v in pairs (DB.getChildren(nodeRaceData)) do

local nodeValue = DB.createChild(nodeAbility);

local nAbilityLevel = DB.getValue(v, "ability_level", 0);
local sName = DB.getValue(v, "skillname", "");
local Text1 = DB.getValue(v, "description_text", "");

					DB.setValue(nodeValue, "ability_level", "number", nAbilityLevel);
					DB.setValue(nodeValue, "skillname", "string", sName);
					DB.setValue(nodeValue, "description_text", "formattedtext", "<p>" .. Text1 .. "</p>");
					DB.setValue(nodeValue, "skills_link", "windowreference", "skills" );
					

end


end
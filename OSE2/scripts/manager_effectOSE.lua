OOB_MSGTYPE_APPLYEFFECT = "applyeffect";


function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYEFFECT, handleApplyEffect);

end


function EffectHandler(rSource, aTarget, sEffect, nDuration)

		if not sEffect or (sEffect or "") == "" then
		return true;
		end
for k,v in pairs (aTarget) do

	local nodeCT = DB.findNode(v.sCTNode)

	local nSaved = DB.getValue(nodeCT,"SvDamage_reduction",0)
	DB.setValue(nodeCT,"SvDamage_reduction","number",0)
	
		if nSaved == 0 then
EffectManager.addEffect("", "", nodeCT, { sName = sEffect, nDuration = nDuration, nGMOnly = 1 }, false);

				local msg = 
						{
							font = "reference-b", 
							icon = "portrait_troll";
							text ="Effect Applied: ".. sEffect.. "-> to "..DB.getValue(nodeCT,"name","");
						}
						Comm.deliverChatMessage(msg);
	
	---manager_effectOSE.notifyApplyEffect(rSource,nodeCT, sEffect, nDuration);
		end
end

			


end

function handleApplyEffect(msgOOB)
	local rSource = ActorManager.resolveActor(msgOOB.sSourceNode);
	local rTarget = ActorManager.resolveActor(msgOOB.sTargetNode);

	applyEffect(rSource, rTarget, msgOOB.sEffect, msgOOB.nDuration);
end
function notifyApplyEffect(rSource, rTarget, sEffect, nDuration)

	if not rTarget then
		return;
	end

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYEFFECT;

	msgOOB.nDuration = nDuration
	msgOOB.sEffect = sEffect;
	msgOOB.sSourceNode = ActorManager.getCreatureNodeName(rSource);
	msgOOB.sTargetNode = ActorManager.getCreatureNodeName(rTarget);

	Comm.deliverOOBMessage(msgOOB, "");
end

function applyEffect(rSource, rTarget, sEffect, nDuration)

	local nodeCT = DB.findNode(rTarget.sCTNode);

	DB.createChild(nodeCT,"effects")
	local nodeEffect = nodeCT.getChild("effects")
	DB.createChild(nodeEffect);
	
		for s,t in pairs (DB.getChildren(nodeEffect) )do

		local sLabel = DB.getValue(t, "label")	
		if sLabel ~= "" then			
		else			
			DB.setValue(t, "label","string",sEffect);
			DB.setValue(t, "duration","number",nDuration);
			end
	end 
end



function DecodeDamEffects(rActor,rFilterActor,rRoll)

local nDamageEffect = 0
local nDmgmult =1

---check attacker
for _,v in pairs(DB.getChildren(ActorManager.getCTNode(rActor), "effects")) do

				local sLabel = DB.getValue(v, "label", "");
				local nActive = DB.getValue(v, "isactive", 0);
	if (nActive ~= 0) then
	
				local aEffectComps = EffectManager.parseEffect(sLabel);
			
	local nMatch = 0;
				for kEffectComp, sEffectComp in ipairs(aEffectComps) do
					local rEffectComp = parseEffectComp(sEffectComp);


					-- Handle conditionals
					if rEffectComp.type == "IF" then
						if not checkConditional(rActor, v, rEffectComp.remainder) then
							break;
						end
					elseif rEffectComp.type == "IFT" then

					local bMatch = checkConditional(rFilterActor, v, rEffectComp.remainder, rFilterActor, aIgnore)

						if bMatch then

						local i = 0
							for _,v in ipairs(aEffectComps) do
							i= i +1
							if sEffectComp == v then
							break;
							end
								
							end			

							repeat
						
							local rBonus = StringManager.split(aEffectComps[i +1], ":", true)

							
							if string.match(rBonus[1],"DMG") then
									local bNumber = isNUmeric(rBonus[2]) 

									if StringManager.isDiceString(rBonus[2]) and not bNumber then
									local sDice = string.match(rBonus[2],"%d+%a?(%d+)")
									local nDice = tonumber(sDice)
									nDamageEffect = nDamageEffect + math.random(1,nDice)
									elseif string.match(rBonus[2]:lower(),"%d+[.]?%d?x") then
									nDmgmult = tonumber(string.match(rBonus[2]:lower(),"(%d+[.]?[%d]?)x")) or 1
									else
									nDamageEffect = nDamageEffect +tonumber(rBonus[2])
									end
							elseif string.match(rBonus[1],"DMGTYPE") then
								local  aClauses, aClauseStats = StringManager.split(vEffects,":", true)
								rRoll.sDesc = rRoll.sDesc.." ["..aClauses[2].."]"
												
							elseif string.match(rBonus[1],"DMGX") then	
								nDmgmult = rBonus[2]
					
							end

							i= i+1
							until ((aEffectComps[i +1]) == nil)
						end	

							if not rFilterActor then
								break;
							end
					
					end
				end	
				
if string.find(sLabel,"IFT") then

else



		for _,vEffects in pairs (aEffectComps) do
		local rEffect = StringManager.split(vEffects, ":");


			if rEffect[2] ~= nil then
				if rEffect[1] == "DMG" then
				
						local bNumber = isNUmeric(rEffect[2])
						
					if StringManager.isDiceString(rEffect[2])  and not bNumber then
					local sDice = string.match(rEffect[2],"%d+%a?(%d+)")
					local nDice = tonumber(sDice)
					nDamageEffect = nDamageEffect + math.random(1,nDice)
					elseif string.match(rEffect[2]:lower(),"%d+[.]?%d?x") then
					
					nDmgmult = tonumber(string.match(rEffect[2]:lower(),"(%d+[.]?[%d]?)x")) or 1

					else
					nDamageEffect = tonumber(rEffect[2]) + nDamageEffect;
					end
				elseif rEffect[1] == "DMGTYPE" then
					local  aClauses, aClauseStats = StringManager.split(vEffects,":", true)
					rRoll.sDesc = rRoll.sDesc.." ["..aClauses[2].."]"
				elseif string.match(rEffect[1],"DMGX") then	
				nDmgmult = tonumber(rEffect[2])

				end
				
			end	

		end

end
end	
end
	return nDamageEffect,nDmgmult;
end			

function CheckSize(rSource,rTarget,sSpace)
local sSpace = StringManager.trim(sSpace):lower()

 if rSource ~= nil then
 
local nodeAttacker = ActorManager.getCTNode(rSource)
local nSpace = DB.getValue(nodeAttacker,"space",5)
local nSizeEffect = 0; 

local NodeCT = ActorManager.getCTNode(rTarget)    

	if NodeCT then
	nodeEffect = DB.getChild(NodeCT,"effects" or "");
	else
	nodeEffect = nil
	end

if nSpace <=5 then
nSizeEffect = 0;
return nSizeEffect;
end

		if nodeEffect ~= nil then

				local rEffect = DB.getChildren(nodeEffect);


					for k,v in pairs (rEffect) do

					local sEffect = DB.getValue(v, "label", "");
	
					local rEffectString = StringManager.split(sEffect, ":");

											
							if rEffectString[2] ~= nil then
								if StringManager.trim(rEffectString[1]) == "Defensive Bonus" then

								nSizeEffect = tonumber(rEffectString[2]) + nSizeEffect;

								end
							end	
						
					end

		else
		nSizeEffect = 0;
		end

		return nSizeEffect;

elseif sSpace == "large" or sSpace == "huge" or sSpace == "gargantuan" then

local nSizeEffect = 0; 
local NodeCT = ActorManager.getCTNode(rTarget)    

	if NodeCT then
	nodeEffect = DB.getChild(NodeCT,"effects" or "");
	else
	nodeEffect = nil
	end
		if nodeEffect ~= nil then

				local rEffect = DB.getChildren(nodeEffect);


					for k,v in pairs (rEffect) do

					local sEffect = DB.getValue(v, "label", "");
	
					local rEffectString = StringManager.split(sEffect, ":");

											
							if rEffectString[2] ~= nil then
								if StringManager.trim(rEffectString[1]) == "Defensive Bonus" then

								nSizeEffect = tonumber(rEffectString[2]) + nSizeEffect;

								end
							end	
						
					end

		else
		nSizeEffect = 0;
		end
		return nSizeEffect;
else
nSizeEffect = 0;

return nSizeEffect;
end


end

function DecodeAttackEffects(rActor,rFilterActor)
local nEffectATK = 0
---check attacker
for _,v in pairs(DB.getChildList(ActorManager.getCTNode(rActor), "effects")) do

				local sLabel = DB.getValue(v, "label", "");
				local nActive = DB.getValue(v, "isactive", 0);
	if (nActive ~= 0) then
	
				local aEffectComps = EffectManager.parseEffect(sLabel);
			
	local nMatch = 0;
				for kEffectComp, sEffectComp in ipairs(aEffectComps) do
					local rEffectComp = parseEffectComp(sEffectComp);


					-- Handle conditionals
					if rEffectComp.type == "IF" then
						if not checkConditional(rActor, v, rEffectComp.remainder) then
							break;
						end
					elseif rEffectComp.type == "IFT" then

					local bMatch = checkConditional(rFilterActor, v, rEffectComp.remainder, rFilterActor, aIgnore)

						if bMatch then

						local i = 0
							for _,v in ipairs(aEffectComps) do
							i= i +1
							if sEffectComp == v then
							break;
							end
								
							end			

							repeat
						
							local rBonus = StringManager.split(aEffectComps[i +1], ":", true)

							
							if string.match(rBonus[1],"ATK") then
									local bNumber = isNUmeric(rBonus[2]) 

									if StringManager.isDiceString(rBonus[2]) and not bNumber then
									local sDice = string.match(rBonus[2],"%d+%a?(%d+)")
									local nDice = tonumber(sDice)
									nEffectATK = nEffectATK + math.random(1,nDice)
									else
										if 	rBonus[2] then
									nEffectATK = nEffectATK +tonumber(rBonus[2])
										end
									end
					
							end

							i= i+1
							until ((aEffectComps[i +1]) == nil)
						end	

							if not rFilterActor then
								break;
							end
					
					end
				end	
				
if string.find(sLabel,"IFT") then

else

		for _,vEffects in pairs (aEffectComps) do
		local rEffect = StringManager.split(vEffects, ":");


			if rEffect[2] ~= nil then
				if rEffect[1] == "ATK" then
				
						local bNumber = isNUmeric(rEffect[2])
						
						if StringManager.isDiceString(rEffect[2])  and not bNumber then
							local sDice = string.match(rEffect[2],"%d+%a?(%d+)")
							local nDice = tonumber(sDice)
							nEffectATK = nEffectATK + math.random(1,nDice)
						else
							nEffectATK = tonumber(rEffect[2]) + nEffectATK;
						end

				end
				
			end	

		end

end
end	
end
	return nEffectATK;
end

function DecodeAcEffects(rActor,rFilterActor)

local nEffectAC = 0
---check defender
for _,v in pairs(DB.getChildren(ActorManager.getCTNode(rFilterActor), "effects")) do

				local sLabel = DB.getValue(v, "label", "");
				
				local nActive = DB.getValue(v, "isactive", 0);
	if (nActive ~= 0) then
					

					local aEffectComps = EffectManager.parseEffect(sLabel);
				
		local nMatch = 0;
					for kEffectComp, sEffectComp in ipairs(aEffectComps) do
						local rEffectComp = parseEffectComp(sEffectComp);


						-- Handle conditionals
						if rEffectComp.type == "IF" then
							if not checkConditional(rFilterActor, v, rEffectComp.remainder) then
								break;
							end
						elseif rEffectComp.type == "IFT" then

						local bMatch = checkConditional(rActor, v, rEffectComp.remainder, rActor, aIgnore)

							if bMatch then

							local i = 0
								for _,v in ipairs(aEffectComps) do
								i= i +1
								if sEffectComp == v then
								break;
								end
									
								end			

								repeat
							
								local rBonus = StringManager.split(aEffectComps[i +1], ":", true)

								
								if string.match(rBonus[1],"AC") then
										local bNumber = isNUmeric(rBonus[2]) 

										if StringManager.isDiceString(rBonus[2]) and not bNumber then
										local sDice = string.match(rBonus[2],"%d+%a?(%d+)")
										local nDice = tonumber(sDice)
										nEffectAC = nEffectAC + math.random(1,nDice)
										else

										nEffectAC = nEffectAC +tonumber(rBonus[2])
										end
						
								end

								i= i+1
								until ((aEffectComps[i +1]) == nil)
							end	

								if not rFilterActor then
									break;
								end
						
						end
					end	
			
if string.find(sLabel,"IFT") then

else

		for _,vEffects in pairs (aEffectComps) do
		local rEffect = StringManager.split(vEffects, ":");


			if rEffect[2] ~= nil then
				if rEffect[1] == "AC" then
				
						local bNumber = isNUmeric(rEffect[2])
						
					if StringManager.isDiceString(rEffect[2])  and not bNumber then
					local sDice = string.match(rEffect[2],"%d+%a?(%d+)")
					local nDice = tonumber(sDice)
					nEffectAC = nEffectAC + math.random(1,nDice)
					else
					nEffectAC = tonumber(rEffect[2]) + nEffectAC;
					end

				end
				
			end	

		end

end
end	
end
	return nEffectAC;
end

function DecodeSaveEffects(rActor,rFilterActor, SaveType)
local nSaveType = tonumber(SaveType)

if nSaveType==1 then 
sSave = "DEATH"
elseif nSaveType==2 then 
sSave = "WAND"
elseif nSaveType==3 then 
sSave = "PARALYSIS"
elseif nSaveType==4 then 
sSave = "BREATH"
elseif nSaveType==5 then 
sSave = "SPELL" 
elseif nSaveType==6 then 
sSave = "POISON" 
end

local nEffectSave = 0
---check defender
for _,v in pairs(DB.getChildren(ActorManager.getCTNode(rFilterActor), "effects")) do

				local sLabel = DB.getValue(v, "label", "");

				local aEffectComps = EffectManager.parseEffect(sLabel);
			
	local nMatch = 0;
				for kEffectComp, sEffectComp in ipairs(aEffectComps) do
					local rEffectComp = parseEffectComp(sEffectComp);


					-- Handle conditionals
					if rEffectComp.type == "IF" then
						if not checkConditional(rFilterActor, v, rEffectComp.remainder) then
							break;
						end
					elseif rEffectComp.type == "IFT" then

					local bMatch = checkConditional(rActor, v, rEffectComp.remainder, rActor, aIgnore)

						if bMatch then

						local i = 0
							for _,v in ipairs(aEffectComps) do
							i= i +1
							if sEffectComp == v then
							break;
							end
								
							end			

							repeat
						
							local rBonus = StringManager.split(aEffectComps[i +1], ":", true)
	
							if StringManager.isWord(rBonus[1],{"DEATH","WAND","PARALYSIS","BREATH","SPELL","POISON"}) and sSave== rBonus[1] then
									local bNumber = isNUmeric(rBonus[2]) 

									if StringManager.isDiceString(rBonus[2]) and not bNumber then
									local sDice = string.match(rBonus[2],"%d+%a?(%d+)")
									local nDice = tonumber(sDice)
									nEffectSave = nEffectSave + math.random(1,nDice)
									else

									nEffectSave = nEffectSave +tonumber(rBonus[2])
									end
                            elseif   rBonus[1]=="SAVE" then
                                    local bNumber = isNUmeric(rBonus[2]) 
                
                                    if StringManager.isDiceString(rBonus[2]) and not bNumber then
                                    local sDice = string.match(rBonus[2],"%d+%a?(%d+)")
                                    local nDice = tonumber(sDice)
                                    nEffectSave = nEffectSave + math.random(1,nDice)
                                    else
                
                                    nEffectSave = nEffectSave +tonumber(rBonus[2])
                                    end
                
							end

							i= i+1
							until ((aEffectComps[i +1]) == nil)
						end	

							if not rFilterActor then
								break;
							end
					
					end
				end	
				
if string.find(sLabel,"IFT") then

else

		for _,vEffects in pairs (aEffectComps) do
		local rEffect = StringManager.split(vEffects, ":");


			if rEffect[2] ~= nil then
                if StringManager.isWord(rEffect[1],{"DEATH","WAND","PARALYSIS","BREATH","SPELL","POISON"}) and sSave== rEffect[1] then
                    local bNumber = isNUmeric(rEffect[2]) 

                    if StringManager.isDiceString(rEffect[2]) and not bNumber then
                    local sDice = string.match(rEffect[2],"%d+%a?(%d+)")
                    local nDice = tonumber(sDice)
                    nEffectSave = nEffectSave + math.random(1,nDice)
                    else

                    nEffectSave = nEffectSave +tonumber(rEffect[2])
                    end
                elseif   rEffect[1]=="SAVE" then
                    local bNumber = isNUmeric(rEffect[2]) 

                    if StringManager.isDiceString(rEffect[2]) and not bNumber then
                    local sDice = string.match(rEffect[2],"%d+%a?(%d+)")
                    local nDice = tonumber(sDice)
                    nEffectSave = nEffectSave + math.random(1,nDice)
                    else

                    nEffectSave = nEffectSave +tonumber(rEffect[2])
                    end


                 end
	
			end	

		end

end
end	

	return nEffectSave;

end				


function CheckBane (rSource,rTarget,sLabel)

local nEffectBane =0;
if rTarget then

local NodeCT = ActorManager.getCTNode(rTarget)  
local sTags = DB.getValue(NodeCT, "tags",""):lower()

local sLabel = sLabel:lower()
local rWeapon = StringManager.split(sLabel, ",", true);
local rMonster = StringManager.split(sTags, ",", true);

for k,v in pairs (rMonster) do
	for s,t in pairs (rWeapon) do

	local sBane = string.find(t, v);

		if sBane then
			local sBaneBonus = string.match(t,"[+-]?%d+") or 0

			nEffectBane = tonumber(sBaneBonus)+nEffectBane

			sBonus ="0"
			sBonus = string.match(rWeapon[1],"(%d+)") or 0
			local bBonus = isNUmeric(sBonus)
			if bBonus then
			nEffectBane = nEffectBane - tonumber(sBonus)
			end
		break
		end
	end
end

end
return nEffectBane
end



function getImmuneResist(rTarget,sSub)
local rActor = ActorManager.resolveActor(rTarget)
local bImmune = false
local bResist = false
if not sSub then return bImmune,bResist end

local rWeaponProperties = StringManager.parseWords(sSub:lower())

 
for _,v in pairs(DB.getChildren(ActorManager.getCTNode(rActor), "effects")) do

				local sLabel = DB.getValue(v, "label", "");

				local aEffectComps = EffectManager.parseEffect(sLabel);

			if string.find(sLabel,"IMMUNE") or string.find(sLabel,"RESIST") then 

				local rImmuned = StringManager.split(sLabel, ";", true)
				local sResist = ""
				local sImmune = ""
					for k,v in pairs (rImmuned) do
					local rImmuneResist = StringManager.split(v, ":", true)
					
						if string.find(rImmuneResist[1],"IMMUNE") then
						sImmune = rImmuneResist[2]
						elseif  string.find(rImmuneResist[1],"RESIST") then
						sResist = rImmuneResist[2]
						end
					end
				
				local rImmunity = StringManager.split(sImmune, ",", true)
				local rResistance = StringManager.split(sResist, ",", true)
				nImmune = 0
				nResist = 0



				for _,v in pairs(rImmunity) do
				
				local sDamageLookup,sRemainder = StringManager.extractPattern(v:lower(), "%a+")

						if StringManager.isWord(sDamageLookup,DataCommon.dmgtypes) then

						for _,j in pairs (rWeaponProperties) do
						
							if sDamageLookup == j and sRemainder ~= "!" then

							nImmune = 100
							bImmune=true
						
							elseif sDamageLookup =="mundane" then
							nImmune = nImmune+1

							elseif StringManager.isWord(sDamageLookup:lower(),DataCommon.dmgtypes) and sRemainder =="!" then

									for _,n in pairs (rWeaponProperties) do
									if n:lower() == sDamageLookup:lower() then
									nImmune = nImmune-1	

									end
									end	
																		
							end	
		
						end

					end

				end
						if nImmune <= 0 then
						else
						bImmune=true
						end
						
				for _,v in pairs (rResistance) do
				
				local sDamageLookupResist,sRemainderResist = StringManager.extractPattern(v, "%a+")


						if StringManager.isWord(sDamageLookupResist:lower(),DataCommon.dmgtypes) then

							for _,j in pairs (rWeaponProperties) do

								if sDamageLookupResist:lower() == j:lower() and sRemainderResist ~= "!" then

								nResist = 100
								bResist=true
								
								elseif sDamageLookupResist =="mundane" then
								nResist = nResist+1

								elseif StringManager.isWord(sDamageLookupResist:lower(),DataCommon.dmgtypes) and sRemainderResist =="!" then
								
										for _,n in pairs (rWeaponProperties) do

										if n:lower() == sDamageLookupResist then
										nResist = 0	

										break;
										end
										end			
													
								end	
			
							end	
								
						end

				end

								if nResist <= 0 then
								else
								bResist=true

								end
			
		end

end

return bImmune,bResist
end


function isNUmeric(value)

	if value == tostring(tonumber(value)) then
	return true
	else
	return false
	end
end
function parseEffectComp(s)
	local sType = nil;
	local aDice = {};
	local nMod = 0;
	local aRemainder = {};
	local nRemainderIndex = 1;
	
	local aWords, aWordStats = StringManager.parseWords(s, "/\\%.%[%]%(%):{}");
	if #aWords > 0 then
		sType = aWords[1]:match("^([^:]+):");
		if sType then
			nRemainderIndex = 2;
			
			local sValueCheck = aWords[1]:sub(#sType + 2);
			if sValueCheck ~= "" then
				table.insert(aWords, 2, sValueCheck);
				table.insert(aWordStats, 2, { startpos = aWordStats[1].startpos + #sType + 1, endpos = aWordStats[1].endpos });
				aWords[1] = aWords[1]:sub(1, #sType + 1);
				aWordStats[1].endpos = #sType + 1;
			end
			
			if #aWords > 1 then
				if StringManager.isDiceString(aWords[2]) then
					aDice, nMod = StringManager.convertStringToDice(aWords[2]);
					nRemainderIndex = 3;
				end
			end
		end
		
		if nRemainderIndex <= #aWords then
			while nRemainderIndex <= #aWords and aWords[nRemainderIndex]:match("^%[%d?%a+%]$") do
				table.insert(aRemainder, aWords[nRemainderIndex]);
				nRemainderIndex = nRemainderIndex + 1;
			end
		end
		
		if nRemainderIndex <= #aWords then
			local sRemainder = s:sub(aWordStats[nRemainderIndex].startpos);
			local nStartRemainderPhrase = 1;
			local i = 1;
			while i < #sRemainder do
				local sCheck = sRemainder:sub(i, i);
				if sCheck == "," then
					local sRemainderPhrase = sRemainder:sub(nStartRemainderPhrase, i - 1);
					if sRemainderPhrase and sRemainderPhrase ~= "" then
						sRemainderPhrase = StringManager.trim(sRemainderPhrase);
						table.insert(aRemainder, sRemainderPhrase);
					end
					nStartRemainderPhrase = i + 1;
				elseif sCheck == "(" then
					while i < #sRemainder do
						if sRemainder:sub(i, i) == ")" then
							break;
						end
						i = i + 1;
					end
				elseif sCheck == "[" then
					while i < #sRemainder do
						if sRemainder:sub(i, i) == "]" then
							break;
						end
						i = i + 1;
					end
				end
				i = i + 1;
			end
			local sRemainderPhrase = sRemainder:sub(nStartRemainderPhrase, #sRemainder);
			if sRemainderPhrase and sRemainderPhrase ~= "" then
				sRemainderPhrase = StringManager.trim(sRemainderPhrase);
				table.insert(aRemainder, sRemainderPhrase);
			end
		end
	end

	return  {
		type = sType or "", 
		mod = nMod, 
		dice = aDice, 
		remainder = aRemainder, 
		original = StringManager.trim(s)
	};
end

function checkConditional(rActor, nodeEffect, aConditions, rTarget, aIgnore)

	local bReturn = true;
	
	if not aIgnore then
		aIgnore = {};
	end
	table.insert(aIgnore, nodeEffect.getPath());
	
	for _,v in ipairs(aConditions) do
		local sLower = v:lower();

		if StringManager.contains(DataCommon.conditions, sLower) then
			if not checkConditionalHelper(rActor, sLower, rTarget, aIgnore) then
				bReturn = false;
				break;
			end
		elseif StringManager.contains(DataCommon.conditionaltags, sLower) then
			if not checkConditionalHelper(rActor, sLower, rTarget, aIgnore) then
				bReturn = false;
				break;
			end
		else
			local sAlignCheck = sLower:match("^align%s*%(([^)]+)%)$");
			local sSizeCheck = sLower:match("^size%s*%(([^)]+)%)$");
			local sTypeCheck = sLower:match("^type%s*%(([^)]+)%)$");
			local sCustomCheck = sLower:match("^custom%s*%(([^)]+)%)$");

			if sAlignCheck then
				if not ActorCommonManager2.isCreatureAlignmentDnD(rActor, sAlignCheck) then
					bReturn = false;
					break;
				end
			elseif sSizeCheck then

				if not ActorCommonManager2.isCreatureSizeDnD3(rActor, sSizeCheck) then
					bReturn = false;
					break;
				end
			elseif sTypeCheck then
				if not ActorCommonManager2.isCreatureTypeDnD(rActor, sTypeCheck) then
					bReturn = false;
					break;
				end
			elseif sCustomCheck then
				if not checkConditionalHelper(rActor, sCustomCheck, rTarget, aIgnore) then
					bReturn = false;
					break;
				end
			end
		end
	end
return bReturn	
end

function checkConditionalHelper(rActor, sEffect, rTarget, aIgnore)
	if not rActor then
		return false;
	end
	
	for _,v in ipairs(DB.getChildList(ActorManager.getCTNode(rActor), "effects")) do
		local nActive = DB.getValue(v, "isactive", 0);
		if nActive ~= 0 and not StringManager.contains(aIgnore, DB.getPath(v)) then
			-- Parse each effect label
			local sLabel = DB.getValue(v, "label", "");
			local aEffectComps = EffectManager.parseEffect(sLabel);

			-- Iterate through each effect component looking for a type match
			for _,sEffectComp in ipairs(aEffectComps) do
				local rEffectComp = parseEffectComp(sEffectComp);
				
				-- CHECK CONDITIONALS
				if rEffectComp.type == "IF" then
					if not checkConditional(rActor, v, rEffectComp.remainder, nil, aIgnore) then
						break;
					end
				elseif rEffectComp.type == "IFT" then
					if not rTarget then
						break;
					end
					if not checkConditional(rTarget, v, rEffectComp.remainder, rActor, aIgnore) then
						break;
					end
				
				-- CHECK FOR AN ACTUAL EFFECT MATCH
				elseif rEffectComp.original:lower() == sEffect then
					if EffectManager.isTargetedEffect(v) then
						if EffectManager.isEffectTarget(v, rTarget) then
							return true;
						end
					else
						return true;
					end
				end
			end
		end
	end
	
	return false;
end
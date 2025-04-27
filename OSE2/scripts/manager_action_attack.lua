function onInit()
	ActionsManager.registerResultHandler("attack", AttackHandler);

end


function performRoll(dragInfo,rActor, sLabel,  nAtk_roll, nAtk_bonus,sType, Thaco) 

	local rRoll = getRoll(rActor, sLabel, nAtk_roll, nAtk_bonus,sType, Thaco);

	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end
	
	ActionsManager.performAction(dragInfo, rActor, rRoll);
	

end

function getRoll(rActor, sLabel,  nAtk_roll, nAtk_bonus,sType, Thaco)

	local rRoll = {};
	rRoll.sType = "attack";
	rRoll.aDice = "d20";
	rRoll.atk_roll = nAtk_roll;
	rRoll.atk_bonus = nAtk_bonus;
	rRoll.type_select = sType;
	rRoll.nMod = 0;
	rRoll.sDesc = sLabel..", [THACO "..Thaco.."] ,"..sType;
	rRoll.sLabel = sLabel	
	
manager_actions2.encodeDesktopMods(rRoll);	
return rRoll;
end

function AttackHandler(rSource,rTarget,rRoll)

local nEffectATK = 0;
local nEffectBane =0;
local nSizeEffect = 0;
local nRange = 0
local bRanged = false
local sTextmsg = ""
		if rTarget then

			if rSource == nil then
			local sName= string.match(rRoll.sDesc, "%w+%s?%w*%s?%w*%s?%w*%s%w*")

				for k,vCTnode in pairs (CombatManager.getCombatantNodes()) do

					if StringManager.trim(DB.getValue(vCTnode,"name",""))== StringManager.trim(sName) then
					
					Source = vCTnode
					break
					end
				end
			else	
			Source= ActorManager.getCTNode(rSource.sCTNode)
			end

		local Target = ActorManager.getCTNode(rTarget.sCTNode)
		nRange = manager_actions2.getRangeBetween(Source,Target)
		end

		if string.find(rRoll.sDesc,"Ranged") then
		bRanged = true
		end
		Debug.console(bRanged,nRange)
if rTarget then
local nEffectATK = manager_effectOSE.DecodeAttackEffects(rSource,rTarget);
if nEffectATK ~= 0 then  rRoll.sDesc = rRoll.sDesc.." [ATK EFFECTS :"..nEffectATK.."]" end
local nEffectAC =  manager_effectOSE.DecodeAcEffects(rSource,rTarget);
if nEffectAC ~= 0 then  rRoll.sDesc = rRoll.sDesc.." [AC EFFECTS :"..nEffectAC.."]" end



            local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

			
            local rDefender = DB.findNode(rTarget.sCTNode);

            local sID = DB.getValue(rDefender, "name")

			local nRangeMod ,sTextmsg= manager_actions2.getRangeModifier(rRoll.sDesc,nRange,bRanged) 
				if sTextmsg then
				rMessage.text = rMessage.text .." "..sTextmsg
				end
			  

            if rSource ~=nil then
            rAttack = ActorManager.getCreatureNode(rSource);

            nThaco = DB.getValue(rAttack, "thaco"); 
            sSpace = " "      
            else
            sThaco = string.match(rRoll.sDesc, "%[THACO (%d+)]") or "19"; 
            nThaco = tonumber(sThaco);
            sSpace = string.match(rRoll.sDesc, "%[SIZE (%a+)]") or "Medium"; 
            end
            
			local nSizeEffect = manager_effectOSE.CheckSize(rSource,rTarget,sSpace)


            local nAC = DB.getValue(rDefender, "armor_class") - nEffectAC - nSizeEffect;
            local nType = string.find(rRoll.sDesc, "%[NPC]"); 


   
                    if rSource ~=nil then
					rMessage.diemodifier = rRoll.atk_bonus +rRoll.atk_roll + rRoll.nMod + nEffectATK+ nEffectBane+ nRangeMod;
					nTotal = ActionsManager.total(rRoll) + rRoll.atk_bonus +rRoll.atk_roll + nEffectATK+ nEffectBane+ nRangeMod; 
					else
					nTotal = ActionsManager.total(rRoll)+nEffectBane+nRangeMod
					rMessage.diemodifier = nEffectBane+rMessage.diemodifier+nRangeMod
					end  
					local nValue =  nThaco -  nAC;

					if nTotal >= nValue or ActionsManager.total(rRoll) == 20 then
            
                    rMessage.text = rMessage.text .."\n[HIT]\nTarget: "..rTarget.sName;
                    else 
            
					rMessage.text = rMessage.text .."\n[MISS]\nTarget: "..rTarget.sName;
					end
					
								if nSizeEffect > 0 then
								rMessage.text = rMessage.text .." (Size Bonus +"..nSizeEffect..")"
								end		
			
                        Comm.deliverChatMessage(rMessage);     
else 

			local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
			rMessage.text = "["..rSource.sName.."] "..rMessage.text
            local nodeRecord = rSource.sCreatureNode;
            local nThaco = DB.getValue(nodeRecord.. ".thaco");  
            
            if rSource ~=nil then

            local nEffectATK =  manager_effectOSE.DecodeAttackEffects(rSource,rTarget);
			if nEffectATK ~= 0 then  rMessage.text = rMessage.text.." [ATK EFFECTS :"..nEffectATK.."]" end
			
            nTotal = ActionsManager.total(rRoll) + rRoll.atk_bonus +rRoll.atk_roll + nEffectATK+ nEffectBane;
            rMessage.diemodifier = rRoll.atk_bonus + rRoll.atk_roll + rRoll.nMod + nEffectATK+ nEffectBane;
			end

            sThaco = string.match(rRoll.sDesc, "%[THACO (%d+)]") or "19"; 
            nThaco = tonumber(sThaco);

            local nValue =  nThaco -  nTotal; 

			if ActionsManager.total(rRoll) == 20 then
			rMessage.text = rMessage.text ..  " AUTOMATIC HIT"
			else																
			rMessage.text = rMessage.text .." Attack\nAttacker Hits an AC of ["..nValue.."]";
			end

			Comm.deliverChatMessage(rMessage); 

 
   end

end
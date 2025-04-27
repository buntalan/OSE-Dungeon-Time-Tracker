OOB_MSGTYPE_APPLYDMG = "applydmg";


function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYDMG, handleApplyDamage);

	ActionsManager.registerResultHandler("damage", DamageHandler);

end

function performRoll(dragInfo,rActor, sLabel, sDamageDie, nAtk_roll, nBonus,sTypeatk,sSub,nDamageAdd,nDouble) 
	local rRoll = getRoll(rActor, sLabel, sDamageDie, nAtk_roll, nBonus,sTypeatk,sSub,nDamageAdd,nDouble);
	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end

	ActionsManager.performAction(dragInfo, rActor, rRoll);
	

end

function getRoll(rActor, sLabel, sDamageDie, nAtk_roll, nBonus, sTypeatk,sSub,nDamageAdd,nDouble)

	local rRoll = {};
	rRoll.sType = "damage";
	rRoll.aDice = StringManager.convertStringToDice(sDamageDie);
	rRoll.atk_roll = nAtk_roll
	rRoll.nDamageAdd =  nDamageAdd
	rRoll.dmg_bonus = nBonus
	rRoll.type_select = sTypeatk;
	rRoll.nMod = 0;
	rRoll.sDesc = "[Damage] "..sLabel.." "..sSub;
	rRoll.sLabel = sLabel
	rRoll.nDouble = nDouble	
	
manager_actions2.encodeDesktopMods(rRoll);
return rRoll;
end

function DamageHandler (rSource,rTarget,rRoll)

local bImmune = false
local bResist = false
local nEffectBane =0;
local nDamageEffect = 0;
local nDmgmult = 1
local nDamageEffect,nDmgmult =  manager_effectOSE.DecodeDamEffects(rSource,rTarget,rRoll);

---local nEffectBane = manager_effectOSE.CheckBane(rSource,rTarget,rRoll.sDesc)
local nDmg_bonus = 0
local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	if rSource then
		if rRoll.type_select == "2" then
		nDmg_bonus = rRoll.nDamageAdd;
		else
		nDmg_bonus = rRoll.nDamageAdd + tonumber(rRoll.dmg_bonus)
		end
	end
	

	
	
       if rTarget then
        nTotal =0;   
local bImmune,bResist = manager_effectOSE.getImmuneResist(rTarget,rRoll.sDesc)


			if bImmune then

							local msg = 
									{
										font = "reference-b", 
										icon = "portrait_gm_token";
										text ="IMMUNE. No Damage";
									}
									Comm.deliverChatMessage(msg);

			return false;
			end

			

			if rSource ~= nil then 


			nStr_bonus = rRoll.atk_roll + nDamageEffect + nDmg_bonus + nEffectBane;

			nTotal = (ActionsManager.total(rRoll) + nStr_bonus)*tonumber(rRoll.nDouble)*nDmgmult;

								if nTotal <=0 then
								nTotal = 1
								end
			else
			nStr_bonus = nEffectBane;


				local nDouble = string.find(rRoll.sDesc,"Double")

					if nDouble ~= nil then
					nTotal = ((ActionsManager.total(rRoll)+nStr_bonus)*2)
						if nTotal < 0 then
						nTotal = 1 
						end
					else
					nTotal = (ActionsManager.total(rRoll)+nStr_bonus)
						if nTotal < 0 then
						nTotal = 1 
						end
					end

			end




			--resets for DMGO effect
			if (rRoll.nBonuses) then
			local bNum = manager_effectOSE.isNUmeric(tostring(rRoll.nBonuses))
				if bNum then
					nTotal = ActionsManager.total(rRoll)+tonumber(rRoll.nBonuses);
				end
			end

		if 	bResist then

		nTotal = math.max(math.floor(nTotal/2),1)
		rMessage.text = rMessage.text.." [RESIST]"
		end

		
            local rDefender = DB.findNode(rTarget.sCTNode);
            local nWoundcurr = DB.getValue(rDefender, "wounds")
            local nTHPcurr = DB.getValue(rDefender, "temp_hp")
            local nWoundstotal = nWoundcurr + nTotal;
            local nHPcurr = DB.getValue(rDefender, "hp_current")
            local sID = DB.getValue(rDefender, "name")
        
            if nTHPcurr <= 0 then           
				local nHPnew = nHPcurr - nTotal;

                                        if (nHPcurr-nWoundstotal) <= 0 then
                                        rMessage.text = rMessage.text .. "\nYou have Slain "..sID.." takes ["..nTotal.." damage]";
                                        rMessage.diemodifier = nStr_bonus + rRoll.nMod;  
                                        else          
                                        rMessage.text = rMessage.text .. "\n"..sID.." takes ["..nTotal.." damage]"; 
                                        rMessage.diemodifier = nStr_bonus + rRoll.nMod; 
                                        end
            elseif nTHPcurr >= 1 then
                local nTemp = nTHPcurr - nTotal;
                        if nTemp <= 0 then            
                        local nHPnew = nTemp + nHPcurr
                        local nWounddim = nTemp *-1 + nWoundcurr;  

                                        if (nHPcurr-nWoundstotal) <=0 then
                                        rMessage.text = rMessage.text .. "\nYou have Slain "..sID.." takes ["..nTotal.." damage]"; 
                                        rMessage.diemodifier = nStr_bonus + rRoll.nMod; 
                                        else          
                                        rMessage.text = rMessage.text .. "\n"..sID.." takes ["..nTotal.." damage]";
                                        rMessage.diemodifier = nStr_bonus + rRoll.nMod; 
                                        end
                        else                                          
                        rMessage.text = rMessage.text .. "\n"..sID.." takes ["..nTotal.." damage]";
                        rMessage.diemodifier = nStr_bonus + rRoll.nMod;              
                        end
            end      
    else
	 
		local nStr_bonus = nDmg_bonus + rRoll.atk_roll + nDamageEffect + nEffectBane;

		----rMessage.text = rMessage.text .. " [DAMAGE]";
		rMessage.diemodifier = nStr_bonus + rRoll.nMod; 
    end
  

---Set minimum damage
			local nMinDam =0
			local nValue = 0
			for x, y in ipairs (rMessage.dice) do
			nValue = rMessage.dice[x].result + nValue
			end

			local nTotalMod = tonumber(rMessage.diemodifier)
			local nMinDam = nValue + nTotalMod;

				if nMinDam <=0 then
				nTotalMod = math.abs(nMinDam) + 1 + nTotalMod
				rMessage.diemodifier =nTotalMod
				rMessage.text = rMessage.text.." [Minimum Damage Attack]"
				
				end

Comm.deliverChatMessage(rMessage); 
manager_action_damage.notifyApplyDamage(rSource, rTarget, rRoll.bTower, rRoll.sType, rMessage.text, nTotal);
  
end
function handleApplyDamage(msgOOB)
	local rSource = ActorManager.resolveActor(msgOOB.sSourceNode);
	local rTarget = ActorManager.resolveActor(msgOOB.sTargetNode);
	if rTarget then
		rTarget.nOrder = msgOOB.nTargetOrder;
	end
	
	local nTotal = tonumber(msgOOB.nTotal) or 0;
	applyDamage(rSource, rTarget, (tonumber(msgOOB.nSecret) == 1), msgOOB.sRollType, msgOOB.sDamage, nTotal);
end

function notifyApplyDamage(rSource, rTarget, bSecret, sType, sDesc, nTotal)

	if not rTarget then
		return;
	end

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYDMG;


	if bSecret then
		msgOOB.nSecret = 1;
	else
		msgOOB.nSecret = 0;
	end
	msgOOB.sType = sType;
	
	msgOOB.nTotal = nTotal;
	msgOOB.sDamage = sDesc;

	msgOOB.sSourceNode = ActorManager.getCreatureNodeName(rSource);
	msgOOB.sTargetNode = ActorManager.getCreatureNodeName(rTarget);
	msgOOB.nTargetOrder = rTarget.nOrder;

	Comm.deliverOOBMessage(msgOOB, "");
end

function applyDamage(rSource, rTarget, bSecret, sType, sDamage, nTotal)


       if rTarget then


           local rDefender = DB.findNode(rTarget.sCTNode);
           local nWoundcurr = DB.getValue(rDefender, "wounds")
           local nTHPcurr = DB.getValue(rDefender, "temp_hp")
           local nWoundstotal = nWoundcurr + nTotal;
            local nHPcurr = DB.getValue(rDefender, "hp_current")
   
            if nTHPcurr <= 0 then           
            local nHPnew = nHPcurr - nTotal;

            DB.setValue(rDefender, "wounds", "number", nWoundstotal);
                                   
            elseif nTHPcurr >= 1 then
                local nTemp = nTHPcurr - nTotal;
                        if nTemp <= 0 then            
                        local nHPnew = nTemp + nHPcurr
                        local nWounddim = nTemp *-1 + nWoundcurr;  
                        DB.setValue(rDefender, "wounds", "number", nWounddim);
                        DB.setValue(rDefender, "temp_hp", "number", 0);
                                        
                        else
                                                                            
                        DB.setValue(rDefender, "wounds", "number", nWoundcurr);
                        DB.setValue(rDefender, "temp_hp", "number", nTemp);
                        
                        end
            end
        
    else
    end

end
OOB_MSGTYPE_APPLYSPELLDMG = "applyspelldmg";


function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYSPELLDMG, handleApplySpellDamage);

	ActionsManager.registerResultHandler("spell", SpellDamageHandler);

end

function handleApplySpellDamage(msgOOB)

	local rSource = ActorManager.resolveActor(msgOOB.sSourceNode);
	local rTarget = ActorManager.resolveActor(msgOOB.sTargetNode);

	if rTarget then
		rTarget.nOrder = msgOOB.nTargetOrder;
	end
	
	local nTotal = tonumber(msgOOB.nTotal) or 0;
	applySpellDamage(rSource, rTarget, (tonumber(msgOOB.nSecret) == 1), msgOOB.sRollType, msgOOB.sDamage, nTotal);
end

function notifyApplySpellDamage(rSource, rTarget, bSecret, sType, sDesc, nTotal)

	if not rTarget then
		return;
	end

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYSPELLDMG;
	
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


function performRoll(draginfo, rActor, sLabel, sDie, nBonuses,sProperties) 
	local rRoll = getRoll(rActor, sLabel, sDie, nBonuses,sProperties);
	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end
	
	ActionsManager.performAction(draginfo, rActor, rRoll);
	

end

function getRoll(rActor, sLabel, sDie, nBonuses,sProperties)

	local rRoll = {};
	rRoll.sType = "spell";
	rRoll.aDice = StringManager.convertStringToDice(sDie);
	rRoll.nBonuses = nBonuses;
	rRoll.nMod = 0;
	rRoll.properties = sProperties
	rRoll.sDesc = "[Damage] "..sLabel;
manager_actions2.encodeDesktopMods(rRoll);	
return rRoll;
end

function applySpellDamage(rSource, rTarget, bSecret, sType, sDamage, nTotal)


if rTarget then
  
            local rDefender = ActorManager.getCTNode(rTarget)

            local nDamreduce = DB.getValue(rDefender, "SvDamage_reduction")     
       
    if  nDamreduce == 2 then 

            DB.setValue(rDefender, "SvDamage_reduction","number", 0);


    elseif nDamreduce == 1 then  

            local nTotal = math.floor((nTotal) * 0.5 + 0.5);
            local nWoundcurr = DB.getValue(rDefender, "wounds")
            local nTHPcurr = DB.getValue(rDefender, "temp_hp")
            local nWoundstotal = nWoundcurr + nTotal;
            local nHPcurr = DB.getValue(rDefender, "hp_current")

            if nTHPcurr <= 0 then           
            local nHPnew = nHPcurr - nTotal;
          DB.setValue(rDefender, "wounds", "number", nWoundstotal);
                                        if (nHPcurr-nWoundstotal) <=0 then

                                       DB.setValue(rDefender, "SvDamage_reduction","number", 0);
    
                                        else          
                                      DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                                        end
            elseif nTHPcurr >= 1 then
                local nTemp = nTHPcurr - nTotal;
                        if nTemp <= 0 then            
                        local nHPnew = nTemp + nHPcurr
                        local nWounddim = nTemp *-1 + nWoundcurr;  
                      DB.setValue(rDefender, "wounds", "number", nWounddim);
                       DB.setValue(rDefender, "temp_hp", "number", 0);
                                        if (nHPcurr-nWoundstotal) then

                                        else          
                                      DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                                        end
                        else
                                                                            
                       DB.setValue(rDefender, "wounds", "number", nWoundcurr);
                      DB.setValue(rDefender, "temp_hp", "number", nTemp);
                        DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                                       
                        end
              
            end 

    else 

            
            local nTotal = nTotal;
            local nWoundcurr = DB.getValue(rDefender, "wounds")
            local nTHPcurr = DB.getValue(rDefender, "temp_hp")
            local nWoundstotal = nWoundcurr + nTotal;
            local nHPcurr = DB.getValue(rDefender, "hp_current")
            
        if nTHPcurr <= 0 then           
            local nHPnew = nHPcurr - nTotal;
          DB.setValue(rDefender, "wounds", "number", nWoundstotal);
                                        if (nHPcurr-nWoundstotal) <=0 then
                                      DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                                        else          
                                     DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                                        end
         elseif nTHPcurr >= 1 then
                local nTemp = nTHPcurr - nTotal;
                        if nTemp <= 0 then            
                        local nHPnew = nTemp + nHPcurr
                        local nWounddim = nTemp *-1 + nWoundcurr;  
                      DB.setValue(rDefender, "wounds", "number", nWounddim);
                      DB.setValue(rDefender, "temp_hp", "number", 0);
                                        if (nHPcurr-nWoundstotal) <=0 then
                                       DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                                        else          
                                      DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                                        end
                        else
                                                                            
                        DB.setValue(rDefender, "wounds", "number", nWoundcurr);
                        DB.setValue(rDefender, "temp_hp", "number", nTemp);
                        DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                                        
                        end
     
        
       else 
        
    DB.setValue(rDefender, "SvDamage_reduction","number", 0);
        end

    end
end

nTotal =0;
end



function SpellDamageHandler (rSource,rTarget,rRoll) 

local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
local bImmune = false
local bResist = false

if rTarget then
bImmune,bResist = manager_effectOSE.getImmuneResist(rTarget,rRoll.properties)

end

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


             local nTotal =0;
             
			if rSource ~= nil then
			nTotal = ActionsManager.total(rRoll) + tonumber(rRoll.nBonuses);
			rMessage.diemodifier = rRoll.nBonuses + rRoll.nMod; 

			else
				nTotal = ActionsManager.total(rRoll)
				rRoll.nBonuses = 0
			end
			
				if 	bResist then

				nTotal = math.max(math.floor(nTotal/2),1)
				rMessage.text = rMessage.text.." [RESIST]"
				end
			
			
if rTarget then
 
            local rDefender = ActorManager.getCTNode(rTarget)

            local sID = DB.getValue(rDefender, "name")
            local nDamreduce = DB.getValue(rDefender, "SvDamage_reduction")     
 
    if  nDamreduce == 2 then 
    
                rMessage.text = rMessage.text .. "\n"..sID.." takes [0] damage";
                            

    elseif nDamreduce == 1 then  

            local nTotal = math.floor(nTotal * 0.5 + 0.5);
            local nWoundcurr = DB.getValue(rDefender, "wounds")
            local nTHPcurr = DB.getValue(rDefender, "temp_hp")
            local nWoundstotal = nWoundcurr + nTotal;
            local nHPcurr = DB.getValue(rDefender, "hp_current")

            if nTHPcurr <= 0 then           
            local nHPnew = nHPcurr - nTotal;

                                        if nHPnew <=0 then
                                        rMessage.text = rMessage.text .. "\nYou have Slain "..sID;
                                
                                        else          
                                        rMessage.text = rMessage.text .. "\n"..sID.." takes "..nTotal.." Half damage"; 


                                        end
            elseif nTHPcurr >= 1 then
                local nTemp = nTHPcurr - nTotal;
                        if nTemp <= 0 then            
                        local nHPnew = nTemp + nHPcurr
                        local nWounddim = nTemp *-1 + nWoundcurr;  
                                        if nHPnew <=0 then
                                        rMessage.text = rMessage.text .. "\nYou have Slain "..sID; 

                                        else          
                                        rMessage.text = rMessage.text .. "\n"..sID.." takes "..nTotal.." Half damage";

                                        end
                        else
                                                                            
                        rMessage.text = rMessage.text .. "\n"..sID.." takes "..nTotal.." Half damage";
						rMessage.diemodifier = rRoll.nBonuses + rRoll.nMod;               
                        end     
        
            end 

    else 

            local nWoundcurr = DB.getValue(rDefender, "wounds")
            local nTHPcurr = DB.getValue(rDefender, "temp_hp")
            local nWoundstotal = nWoundcurr + nTotal;
            local nHPcurr = DB.getValue(rDefender, "hp_current")
			if nTHPcurr <= 0 then           
				local nHPnew = nHPcurr - nTotal;

											if nHPnew <=0 then
											rMessage.text = rMessage.text .. "\nYou have Slain "..sID;

											else          
											rMessage.text = rMessage.text .. "\n"..sID.." takes "..nTotal.." damage"; 

											end
			 elseif nTHPcurr >= 1 then
					local nTemp = nTHPcurr - nTotal;
							if nTemp <= 0 then            
							local nHPnew = nTemp + nHPcurr
							local nWounddim = nTemp *-1 + nWoundcurr;  

											if nHPnew <=0 then
											rMessage.text = rMessage.text .. "\nYou have Slain "..sID; 

											else          
											rMessage.text = rMessage.text .. "\n"..sID.." takes "..nTotal.." damage";

											end
							else
																				
							rMessage.text = rMessage.text .. "\n"..sID.." takes "..nTotal.." damage";
			   
							end
		 
			
		   else

			rMessage.text = rMessage.text .. " [DAMAGE]";

			end

    end
else
rMessage.text = rMessage.text .. " [DAMAGE]";

end

      rMessage.font = "reference-b"; 
Comm.deliverChatMessage(rMessage); 
	manager_action_spelldamage.notifyApplySpellDamage(rSource, rTarget, rRoll.bTower, rRoll.sType, rMessage.text, nTotal);
  
end
OOB_MSGTYPE_APPLYSPELLSAVE = "applyspellsave";


function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYSPELLSAVE, handleApplySpellSave);


	
	ActionsManager.registerResultHandler("spellsave", SpellDamageSaveHandler);

end

function handleApplySpellSave(msgOOB)
	local rSource = ActorManager.resolveActor(msgOOB.sSourceNode);
	local rTarget = ActorManager.resolveActor(msgOOB.sTargetNode);
	if rTarget then
		rTarget.nOrder = msgOOB.nTargetOrder;
	end
	
	local nTotal = tonumber(msgOOB.nTotal) or 0;
	
	applySpellSave(rSource, rTarget, (tonumber(msgOOB.nSecret) == 1), msgOOB.sRollType, msgOOB.sDamage, nTotal, msgOOB.onsave_cycler, msgOOB.save_type);
end

function notifyApplySpellSave(rSource, rTarget, bSecret, sType, sDesc, nTotal, onsave_cycler, save_type)

	if not rTarget then
		return;
	end

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYSPELLSAVE;

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
    msgOOB.onsave_cycler = onsave_cycler;
    msgOOB.save_type = save_type;

	Comm.deliverOOBMessage(msgOOB, "");
end

function applySpellSave(rSource, rTarget, bSecret, sType, sDamage, nTotal, onsave_cycler, save_type)

if rTarget then
    
            local rDefender = DB.findNode(rTarget.sCTNode);
           
            local nD = DB.getValue(rDefender, "dsave_score")
            local nW = DB.getValue(rDefender, "wsave_score")       
            local nP = DB.getValue(rDefender, "psave_score")
            local nB = DB.getValue(rDefender, "bsave_score")     
            local nS = DB.getValue(rDefender, "ssave_score")

      
          if onsave_cycler == "1" or onsave_cycler == "2" then
                 
            if save_type == "1" then
            local nSave = nD;
                            if nTotal >= nSave then
                           
                  
                                        DB.setValue(rDefender, "SvDamage_reduction", "number", onsave_cycler);
         
                            else 
            
                                        DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                            end
            elseif save_type == "2" then
            local nSave = nW;
                            if nTotal >= nSave then
               
         
                            DB.setValue(rDefender, "SvDamage_reduction", "number", onsave_cycler);
                 
                            else 
             
                            DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                   
                            
                            end
                            
            elseif save_type == "3" then
            local nSave = nP;

                            if nTotal >= nSave then
               
                       
                            DB.setValue(rDefender, "SvDamage_reduction", "number", tonumber(onsave_cycler));
                            
                            else 
               
                            DB.setValue(rDefender, "SvDamage_reduction","number", 0);
      
                            
                            end
            elseif save_type == "4" then
            local nSave = nB;

                            if nTotal >= nSave then
               
  
                            DB.setValue(rDefender, "SvDamage_reduction", "number", onsave_cycler);
        
                            else 
           
                            DB.setValue(rDefender, "SvDamage_reduction","number", 0);
         
                            
                            end
            elseif save_type == "5" then
            local nSave = nS- DB.getValue(rDefender,"wis_bonus",0);
            
                            if nTotal >= nSave then
               
                            DB.setValue(rDefender, "SvDamage_reduction", "number", onsave_cycler);
 
                            else 
       
                            DB.setValue(rDefender, "SvDamage_reduction","number", 0);
                 
                            end
            else 
     
                            DB.setValue(rDefender, "SvDamage_reduction", "number", 0);

            end           
else

end                   
       
          
end
   nTotal =0;
 
                                                                                                                                                     
end

function SpellDamageSaveHandler (rSource,rTarget,rRoll)
local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

if rTarget then

local nEffectSave = manager_effectOSE.DecodeSaveEffects(rSource,rTarget, rRoll.save_type ); 
  
            nTotal =0;
            nTotal = ActionsManager.total(rRoll) + rRoll.nBonuses + nEffectSave;

           local rDefender = DB.findNode(rTarget.sCTNode);
           
           local sID = DB.getValue(rDefender, "name")

            local nCanSave = rRoll.onsave_cycler;
            local nSVType = rRoll.save_type;

            local nD = DB.getValue(rDefender, "dsave_score")
            local nW = DB.getValue(rDefender, "wsave_score")       
            local nP = DB.getValue(rDefender, "psave_score")
            local nB = DB.getValue(rDefender, "bsave_score")     
            local nS = DB.getValue(rDefender, "ssave_score")
            local nPoi = DB.getValue(rDefender, "poison")
          if nCanSave == "1" or nCanSave == "2"then
                 
            if nSVType == "1" then
            local nSave = nD;
                            if nTotal >= nSave then
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[ Death SAVE SUCCESS]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            else 
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[ Death SAVE FAIL]";
                            rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);

                            end
            elseif nSVType == "2" then
            local nSave = nW;
                            if nTotal >= nSave then
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[ Wands SAVE SUCCESS]";
							rMessage.font = "reference-b";              
                            Comm.deliverChatMessage(rMessage);
                            else 
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[ Wands SAVE FAIL]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            
                            end
            elseif nSVType == "3" then
            local nSave = nP;
                            if nTotal >= nSave then
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[Paralysis SAVE SUCCESS]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            else 
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[Paralysis SAVE FAIL]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            
                            end
            elseif nSVType == "4" then
            local nSave = nB;
                            if nTotal >= nSave then
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[Breath SAVE SUCCESS]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            else 
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[Breath SAVE FAIL]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            
                            end
            elseif nSVType == "6" then
            
		if rTarget.sType == "npc" then
					local nSave = nD;
					                 if nTotal >= nSave then
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[Poison SAVE SUCCESS]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            else 
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[Poison SAVE FAIL]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            
                            end
		else

            local nSave = nPoi;
                            if nTotal >= nSave then
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[Poison SAVE SUCCESS]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            else 
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[Poison SAVE FAIL]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            
                            end
                            
		end                 
                            
                            
            elseif nSVType == "5" then
            local nSave = nS - DB.getValue(rDefender,"wis_bonus",0);
                            if nTotal >= nSave then

							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[Spell SAVE SUCCESS]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            else 
							rMessage.diemodifier = rMessage.diemodifier + nEffectSave;
                            rMessage.text = rMessage.text .. "\n"..sID.."\n[Spell SAVE FAIL]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
                            end
            else 
                            rMessage.text = rMessage.text .. "\n"..sID.." [NO SAVE]";
							rMessage.font = "reference-b"; 
                            Comm.deliverChatMessage(rMessage);
            end  
            
                     
                              
                                                
		end

                  
 else
      rMessage.font = "reference-b"; 
Comm.deliverChatMessage(rMessage);      
             
end


	manager_action_CTsaveroll.notifyApplySpellSave(rSource, rTarget, rRoll.bTower, rRoll.sType, rMessage.text, nTotal, rRoll.onsave_cycler, rRoll.save_type);
  
end
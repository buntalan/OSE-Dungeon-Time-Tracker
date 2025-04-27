OOB_MSGTYPE_APPLYHEAL = "applyheal";


function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYHEAL, handleApplyHeal);


	
	ActionsManager.registerResultHandler("heal", SpellHealHandler);

end

function handleApplyHeal(msgOOB)
	local rSource = ActorManager.resolveActor(msgOOB.sSourceNode);
	local rTarget = ActorManager.resolveActor(msgOOB.sTargetNode);
	if rTarget then
		rTarget.nOrder = msgOOB.nTargetOrder;
	end
	
	local nTotal = tonumber(msgOOB.nTotal) or 0;
	
	applyHeal(rSource, rTarget, (tonumber(msgOOB.nSecret) == 1), msgOOB.sRollType, msgOOB.sDamage, nTotal);
end

function notifyApplyHeal(rSource, rTarget, bSecret, sType, sDesc, nTotal)

	if not rTarget then
		return;
	end

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYHEAL;

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

function applyHeal(rSource, rTarget, bSecret, sType, sDamage, nTotal)

if rTarget then
       
 
           local rDefender = DB.findNode(rTarget.sCTNode);

           local nWoundcurr = DB.getValue(rDefender, "wounds")
           
local nWoundnew = nWoundcurr - nTotal;

                    if nWoundnew < 0 then

                    local nWoundnew = 0;
                    DB.setValue(rDefender, "wounds", "number", nWoundnew);


                    else
                    DB.setValue(rDefender, "wounds", "number", nWoundnew);
                    end

             
end 


nTotal =0;
                                                            
                                                                                                    
end
function performRoll(dragInfo, rActor, sLabel, sDie, nBonuses) 
	local rRoll = getRoll(rActor, sLabel, sDie, nBonuses);
	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end
	
	ActionsManager.performAction(dragInfo, rActor, rRoll);
	

end

function getRoll(rActor, sLabel, sDie, nBonuses)

	local rRoll = {};
	rRoll.sType = "heal";
	rRoll.aDice = StringManager.convertStringToDice(sDie);
	rRoll.nBonuses = nBonuses;
	rRoll.nMod = 0;
	rRoll.sDesc = "[HEAL] "..sLabel;
manager_actions2.encodeDesktopMods(rRoll);
return rRoll;
end
function SpellHealHandler (rSource,rTarget,rRoll)
local bNum = false
local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
local nTotal = ActionsManager.total(rRoll)

if (rRoll.nBonuses) then  
bNum = manager_effectOSE.isNUmeric(tostring(rRoll.nBonuses))

end    
			if rSource or bNum then
			           
			nTotal = nTotal + tonumber(rRoll.nBonuses);

			rMessage.diemodifier = rRoll.nBonuses + rRoll.nMod; 
			end		
			
if rTarget then	

           local rDefender = DB.findNode(rTarget.sCTNode);
           local sID = DB.getValue(rDefender, "name")
           local nWoundcurr = DB.getValue(rDefender, "wounds")
  
                       

rMessage.text = rMessage.text .."\n".. sID.." has been healed for "..nTotal;
else 
          
end 

       rMessage.font = "reference-b"; 
Comm.deliverChatMessage(rMessage); 

	manager_action_heal.notifyApplyHeal(rSource, rTarget, rRoll.bTower, rRoll.sType, rMessage.text, nTotal);
  
end
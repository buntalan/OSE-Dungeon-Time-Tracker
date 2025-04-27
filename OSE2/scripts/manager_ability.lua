function onInit()
	ActionsManager.registerResultHandler("abilroll", onRoll);
end

function performroll(draginfo, rActor, nSelf,sName)

local rRoll = getRoll(rActor, nSelf,sName);

	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end
	
	ActionsManager.performAction(draginfo, rActor, rRoll, nSelf);

end

function getRoll(rActor, nSelf,sName)


        local rRoll = {};
        rRoll.sType = "abilroll";
        rRoll.aDice = {"d20"};
        rRoll.nMod = 0 ;
        rRoll.nSelf = nSelf;
        rRoll.sDesc = sName.." Ability Check" ;
		manager_actions2.encodeDesktopMods(rRoll);
        return rRoll;
     
end


function onRoll(rSource, rTarget, rRoll)
local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
local nTotal = 0;
        for i=1, #rRoll.aDice do
            nTotal = nTotal + rRoll.aDice[i].result;
        end

        local nTotal= tonumber(nTotal) + (-1*rRoll.nMod);
        
 rMessage.diemodifier =   (-1* rMessage.diemodifier)
  
    local nTargetDC = tonumber(rRoll.nSelf);
 
    rMessage.text = rMessage.text .. " (vs. DC " .. nTargetDC .. ")";

    
    if nTotal <= nTargetDC then
        rMessage.text = rMessage.text .. " [SUCCESS]";
    else
        rMessage.text = rMessage.text .. " [FAILURE]";
    end
      rMessage.font = "reference-b"; 
    Comm.deliverChatMessage(rMessage);
    
   end
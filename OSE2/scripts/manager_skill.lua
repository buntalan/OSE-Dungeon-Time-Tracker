function onInit()
	ActionsManager.registerResultHandler("skillroll", onRoll);
end

function performroll(draginfo, rActor, nSelf, sName,aDice,sDice)

local rRoll = getRoll(rActor, nSelf, sName,aDice,sDice);

	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end
	
	ActionsManager.performAction(draginfo, rActor, rRoll);

end

function getRoll(rActor, nSelf, sName,aDice,sDice)


        local rRoll = {};
        rRoll.sType = "skillroll";
        rRoll.aDice = aDice;
        rRoll.nMod = 0 ;
        rRoll.DiceRolled = sDice
        rRoll.nSelf = nSelf;
        rRoll.sDesc = sName.." Check" ;
     manager_actions2.encodeDesktopMods(rRoll);
        return rRoll;

end


function onRoll(rSource, rTarget, rRoll)

local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    
	    local nTotal = 0;
        local nTarget = tonumber(rRoll.nSelf);
        
        for i=1, #rRoll.aDice do
            nTotal = nTotal + rRoll.aDice[i].result;
        end

        local nTotal= tonumber(nTotal) + (-1*rRoll.nMod);
        
 rMessage.diemodifier =   (-1* rMessage.diemodifier) 
        
        if nTotal  <= nTarget then

        rMessage.text = rMessage.text .."\nYou have a "..nTarget.." in "..rRoll.DiceRolled.." chance\n[SUCCESS]";
        
        else
  
        rMessage.text = rMessage.text .."\nYou have a "..nTarget.." in "..rRoll.DiceRolled.." chance\n[FAILURE]";
        end

	rMessage.font = "reference-b"; 
       Comm.deliverChatMessage(rMessage);
            end
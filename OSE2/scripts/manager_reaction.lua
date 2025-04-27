function onInit()
	ActionsManager.registerResultHandler("reaction", hirelingroll);
end

function performroll(draginfo, rActor, nSelf)

local rRoll = getRoll(rActor, nSelf);

	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end
	
	ActionsManager.performAction(draginfo, rActor, rRoll, nSelf);

end

function getRoll(rActor, nSelf)


        local rRoll = {};
        rRoll.sType = "reaction";
        rRoll.aDice = {"d6", "d6"};
        rRoll.nMod = 0 ;
        rRoll.nSelf = nSelf;
        rRoll.sDesc = "Reaction Roll" ;
manager_actions2.encodeDesktopMods(rRoll);
        return rRoll;
     
end


function hirelingroll(rSource,rTarget,rRoll)

local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

        local nTotal= ActionsManager.total(rRoll) + tonumber(rRoll.nSelf);
        if nTotal <= 2 then
  
          rMessage.text = rMessage.text .. "\nI'll Will [FAILURE]";
        
        elseif nTotal <= 5 then
 
        rMessage.text = rMessage.text .. "\nOffer Refused [FAILURE]";
        
        elseif nTotal >=6 and nTotal <= 8 then
        
        
        rMessage.text = rMessage.text .. "\nRoll again! [NOT SURE]";

                        manager_reaction.performroll(nil, ActorManager.getCreatureNode(rSource), rRoll.nSelf);

        elseif nTotal >=9 and nTotal <= 11 then
        
           rMessage.text = rMessage.text .. "\nOffer Accepted [SUCCESS]";
           
          elseif nTotal >= 12 then
                     rMessage.text = rMessage.text .. "\nOffer Accepted +1 Loyalty [SUCCESS]";
        end
        
 rMessage.diemodifier =  rMessage.diemodifier + tonumber(rRoll.nSelf)
			rMessage.font = "reference-b";  
            Comm.deliverChatMessage(rMessage);
   end
---@diagnostic disable: unused-local

function onInit()
	ActionsManager.registerResultHandler("morale", npcmorale);
end

function performroll(dragInfo, rActor, nSelf)

local rRoll = getRoll( rActor, nSelf);

	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end

	ActionsManager.performAction(draginfo, rActor, rRoll)

end

function getRoll( rActor, nSelf)


        local rRoll = {};
        rRoll.sType = "morale";
        rRoll.aDice = {"d6","d6"};
        rRoll.nMod = 0 ;
        rRoll.nSelf = nSelf;
        rRoll.sDesc = "[Morale Roll]";
     manager_actions2.encodeDesktopMods(rRoll);
     rRoll.nMod = tonumber(rRoll.nMod*-1)
        return rRoll;

end



function npcmorale (rSource,rTarget,rRoll)
local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
            local nTotal = ActionsManager.total(rRoll);
			local nTarget = tonumber(rRoll.nSelf);

			if nTotal > nTarget then

			    rMessage.text = rMessage.text  .."\nThe Monster attempts to surrender or flee " ;

			else

			    rMessage.text = rMessage.text  .."\nThe Monster continues to fight! " ;

			end

			rMessage.font = "reference-b";

                        Comm.deliverChatMessage(rMessage);
end





function ondamageroll(rSource,rTarget,rRoll)


    local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    local nTotal = ActionsManager.total(rRoll);
    local nodeChar = rSource.sCreatureNode;

    rMessage.diemodifier = rMessage.diemodifier

   Comm.deliverChatMessage(rMessage);
   end




function SpellHealHandler (rSource,rTarget,rRoll)

local rMessage = ActionsManager.createActionMessage(rSource, rRoll);


if rTarget then

            local nTotal =0;
            local nTotal = ActionsManager.total(rRoll) + rRoll.nBonuses;

           local rDefender = DB.findNode(rTarget.sCTNode);
           local sID = DB.getValue(rDefender, "name")
           local nWoundcurr = DB.getValue(rDefender, "wounds")

local nWoundnew = nWoundcurr - nTotal;

if nWoundnew < 0 then

local nWoundnew = 0;

DB.setValue(rDefender, "wounds", "number", nWoundnew);


else
            DB.setValue(rDefender, "wounds", "number", nWoundnew);
end




            rMessage.text = rMessage.text .."\n".. sID.." has been healed for "..nTotal;
            Comm.deliverChatMessage(rMessage);

  else
 			rMessage.font = "reference-b-large";
            Comm.deliverChatMessage(rMessage);

end

end



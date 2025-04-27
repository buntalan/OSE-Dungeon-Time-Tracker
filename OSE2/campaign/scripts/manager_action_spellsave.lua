function onInit()
	ActionsManager.registerResultHandler("spell_save", onRoll);
end

function performRoll(draginfo, rActor, sLabel, nSaveType, nSavedmg)


	local rRoll = getRoll(rActor, sLabel, nSaveType, nSavedmg);
	
	
	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end
	
	ActionsManager.performAction(draginfo, rDefender, rRoll);
end

function getRoll(rActor, sLabel, nSaveType, nSavedmg)  


        local rRoll = {};
        rRoll.sType = "spell_save";
        rRoll.aDice = { "d20"};
        rRoll.sLabel = "sLabel"
        rRoll.nSaveType = nSaveType;
        rRoll.nSavedmg = nSavedmg;
        rRoll.nMod = 0;
        rRoll.sDesc = "[Saving Throw]" ;

        return rRoll;
        
end

function onRoll(rSource, rTarget, rRoll)

local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

if rRoll.nSavedmg == "1" then



           local rDefender = DB.findNode(rTarget.sCTNode);
           local sID = DB.getValue(rDefender, "name")
           local nSaveType = rRoll.nSaveType;     


            local rEffected = DB.findNode(rSource.sCTNode);
            local nD = DB.getValue(rEffected, "dsave_score")
            local nW = DB.getValue(rEffected, "wsave_score")       
            local nP = DB.getValue(rEffected, "psave_score")
            local nB = DB.getValue(rEffected, "bsave_score")     
            local nS = DB.getValue(rEffected, "ssave_score")

rMessage.font = "reference-b-large";  
Comm.deliverChatMessage(rMessage);
end
end
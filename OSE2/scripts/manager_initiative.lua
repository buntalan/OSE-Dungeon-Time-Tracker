function onInit()
	ActionsManager.registerResultHandler("initiative", orderHandler2);
end

function performroll(draginfo, rActor, nSelf, sName)

local rRoll = getRoll(rActor, nSelf, sName);

	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end
	
	ActionsManager.performAction(draginfo, rActor, rRoll);

end

function getRoll(rActor, nSelf, sName)


        local rRoll = {};
        rRoll.sType = "initiative";
        rRoll.aDice = {"d6"};
        rRoll.nMod = 0 ;
        rRoll.nSelf = nSelf;
        rRoll.sDesc = sName.." Initiative" ;
        
manager_actions2.encodeDesktopMods(rRoll);
        return rRoll;
     
end


function orderHandler2 (rSource,rTarget,rRoll)
local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
            local nTotal = ActionsManager.total(rRoll) + rRoll.nSelf;
            
			local nodeChar = ActorManager.getCreatureNode(rSource)
            
            DB.setValue(nodeChar, "initresult", "number", nTotal);
			rMessage.diemodifier = rMessage.diemodifier + rRoll.nSelf

                  
	if ActorManager.hasCT(rSource) then
			local sNode = DB.getChild(ActorManager.getCTNode(rSource),"...")                  
                    
	local bIsGroup = OptionsManager.isOption("BEMP_INITTYPE", "Group");
	
			if bIsGroup then
			local nodeList = DB.getChild(sNode,"list")

				for k,v in pairs (DB.getChildren(nodeList)) do
				
				local rCtActor = ActorManager.resolveActor(v)
				local sFriendFoe = DB.getValue(v,"friendfoe","")
				local nodeSourceActor = ActorManager.getCTNode(rSource)
				local sFactionSource = DB.getValue(nodeSourceActor,"friendfoe","")

					if sFactionSource == sFriendFoe then
					RulesetWizard.changeDBValueOOB(DB.getChild(v,"initresult"), nTotal)
					end

				end
				

			end
     end                  
			rMessage.font = "reference-b";  
            Comm.deliverChatMessage(rMessage);                           
end 
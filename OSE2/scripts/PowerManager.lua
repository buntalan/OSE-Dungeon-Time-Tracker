function performRoll(draginfo,rActor,sType,aDice,nBonus,sName,sAction)
	local rRoll = getRoll(rActor,sType,aDice,nBonus,sName,sAction);

	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end

	ActionsManager.performAction(draginfo, rActor, rRoll);
	

end
	
function getRoll(rActor,sType,aDice,nBonus,sName,sAction)

	local rRoll = {};
	rRoll.sType = sType;
	rRoll.aDice = aDice;
	rRoll.nBonuses = nBonus;
	rRoll.nMod = 0;
	rRoll.sDesc = StringManager.capitalize(sName);
	rRoll.Action = sAction
	manager_actions2.encodeDesktopMods(rRoll)


return rRoll;
end
function actionDrag(draginfo)

	local rEffect = EffectManager.getEffect(getDatabaseNode());
		if not rEffect or (rEffect.sName or "") == "" then
		return true;
	end
	    				local msg = 
						{
							font = "reference-b", 
							icon = "portrait_troll";
							text ="Effect Applied: ";
						}
						Comm.deliverChatMessage(msg);

	return ActionEffect.performRoll(draginfo, nil, rEffect);
end

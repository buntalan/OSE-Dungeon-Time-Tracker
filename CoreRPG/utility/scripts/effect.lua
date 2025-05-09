--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	if module then
		local tModuleInfo = Module.getModuleInfo(DB.getModule(getDatabaseNode()));
		if tModuleInfo then
			module.setVisible(true);
			module.setTooltipText(tModuleInfo.displayname);
			if spacer_module then
				spacer_module.setVisible(false);
			end
		end
	end
end

function actionDrag(draginfo)
	local rEffect = EffectManager.getEffect(getDatabaseNode());
	if not rEffect or (rEffect.sName or "") == "" then
		return true;
	end
	return ActionEffect.performRoll(draginfo, nil, rEffect);
end
function action()
	local rEffect = EffectManager.getEffect(getDatabaseNode());
	if not rEffect or (rEffect.sName or "") == "" then
		return false;
	end
	local rRoll = ActionEffect.getRoll(nil, nil, rEffect);
	if not rRoll then
		return true;
	end

	rRoll.sType = "effect";

	local rTarget = nil;
	if Session.IsHost then
		rTarget = ActorManager.resolveActor(CombatManager.getActiveCT());
	else
		local sIdentity = User.getCurrentIdentity();
		if sIdentity then
			rTarget = ActorManager.resolveActor(CombatManager.getCTFromNode("charsheet." .. sIdentity));
		end
	end

	ActionsManager.resolveAction(nil, rTarget, rRoll);
	return true;
end

function onGainFocus()
	window.setFrame("rowshade");
end
function onLoseFocus()
	window.setFrame(nil);
end

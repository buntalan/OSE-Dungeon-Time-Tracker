
function onInit()
	initActorHealth();
	--initTokendrop();
end


--
--	HEALTH
-- 

function initActorHealth()
	ActorHealthManager.registerStatusHealthColor(ActorHealthManager.STATUS_UNCONSCIOUS, ColorManager.COLOR_HEALTH_DYING_OR_DEAD);

	ActorHealthManager.getWoundPercent = getWoundPercent;
end

-- NOTE: Always default to using CT node as primary to make sure 
--		that all bars and statuses are synchronized in combat tracker
--		(Cross-link network updates between PC and CT fields can occur in either order, 
--		depending on where the scripts or end user updates.)
-- NOTE 2: We can not use default effect checking in this function; 
-- 		as it will cause endless loop with conditionals that check health
function getWoundPercent(v)
	local rActor = ActorManager.resolveActor(v);

	local nHP = 0;
	local nWounds = 0;
	local nDeathSaveFail = 0;

	local nodeCT = ActorManager.getCTNode(rActor);

	if rActor.sType == "npc" then
		nHP = math.max(DB.getValue(nodeCT, "maxhp_combat", 0), 0);
		nWounds = math.max(DB.getValue(nodeCT, "wounds", 0), 0);

	elseif ActorManager.isPC(rActor) then
		local nodePC = ActorManager.getCreatureNode(rActor);
		if nodePC then

			nHP = math.max(DB.getValue(nodePC, "maxhp_combat", 0), 0);
			nWounds = math.max(DB.getValue(nodePC, "wounds", 0), 0);
		end
	end
	
	local nPercentWounded = 0;
	if nHP > 0 then
		nPercentWounded = nWounds / nHP;
	end
	
	local sStatus;
	if nPercentWounded >= 1 then

			sStatus = ActorHealthManager.STATUS_DEAD;


	else
		sStatus = ActorHealthManager.getDefaultStatusFromWoundPercent(nPercentWounded);
	end

	return nPercentWounded, sStatus;
end

function getPCSheetWoundColor(nodePC)
	local nHP = 0;
	local nWounds = 0;
	if nodePC then
		nHP = math.max(DB.getValue(nodePC, "maxhp_combat", 0), 0);
		nWounds = math.max(DB.getValue(nodePC, "wounds", 0), 0);
	end

	local nPercentWounded = 0;
	if nHP > 0 then
		nPercentWounded = nWounds / nHP;
	end
	
	local sColor = ColorManager.getHealthColor(nPercentWounded, false);
	return sColor;
end
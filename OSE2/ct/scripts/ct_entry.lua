function onInit()
	super.onInit();
	self.onHealthChanged();
local nodeCT = getDatabaseNode();
DB.addHandler(DB.getPath(nodeCT, "effects"),"onChildDeleted", updateForEffects);
DB.addHandler(DB.getPath(nodeCT, "effects.*.label"), "onUpdate", updateForEffects);
DB.addHandler(DB.getPath(nodeCT, "effects.*.isactive"), "onUpdate", updateForEffects)
end

function onClose()
local nodeCT = getDatabaseNode();
DB.removeHandler(DB.getPath(nodeCT, "effects"), "onChildDeleted", updateForEffects);
DB.removeHandler(DB.getPath(nodeCT, "effects.*.label"), "onUpdate", updateForEffects);
DB.removeHandler(DB.getPath(nodeCT, "effects.*.isactive"), "onUpdate", updateForEffects);

end

function onHealthChanged()
	local rActor = ActorManager.resolveActor(getDatabaseNode());
	local _,sStatus,sColor = ActorHealthManager.getHealthInfo(rActor);

	wounds.setColor(sColor);
	status.setValue(sStatus);

	if not self.isPC() then
		idelete.setVisible(ActorHealthManager.isDyingOrDeadStatus(sStatus));
	end
end

function linkPCFields()
	local nodeChar = link.getTargetDatabaseNode();
	if nodeChar then
		name.setLink(DB.createChild(nodeChar,"name", "string"), true);
		initresult.setLink(DB.createChild(nodeChar,"initresult", "number"), false);
		senses.setLink(DB.createChild(nodeChar,"senses", "string"), true);
		armor_class.setLink(DB.createChild(nodeChar,"ac_current", "number"), true);
		thaco.setLink(DB.createChild(nodeChar,"thaco", "number"), true);
		dsave_score.setLink(DB.createChild(nodeChar,"dsave_score", "number"), true);	
		wsave_score.setLink(DB.createChild(nodeChar,"wsave_score", "number"), true);
		psave_score.setLink(DB.createChild(nodeChar,"psave_score", "number"), true);	
		bsave_score.setLink(DB.createChild(nodeChar,"bsave_score", "number"), true);		
		ssave_score.setLink(DB.createChild(nodeChar,"ssave_score", "number"), true);
		wis_bonus.setLink(DB.createChild(nodeChar,"wis_bonus", "number"), true);
		poison.setLink(DB.createChild(nodeChar,"poison", "number"), true);
		hp_current.setLink(DB.createChild(nodeChar,"hp_current", "number"), false);	
		wounds.setLink(DB.createChild(nodeChar,"wounds", "number"), false);	
		temp_hp.setLink(DB.createChild(nodeChar,"temp_hp", "number"), false);	
		maxhp_combat.setLink(DB.createChild(nodeChar,"maxhp_combat", "number"), false);
		Level_current.setLink(DB.createChild(nodeChar,"Level_new", "number"), false);	
		init_score.setLink(DB.createChild(nodeChar,"init_score", "number"), true);					
	end
end

function updateForEffects(effect)

   local nodeChar = getDatabaseNode();
   local rActor = ActorManager.resolveActor(nodeChar);
   local sType,sNode = ActorManager.getTypeAndNode(rActor)

   if sType == "pc" then
     nodeChar = ActorManager.getCreatureNode(rActor);
   end

  ---local nodeCT = ActorManager.getCTNode(rTarget)

  Manager_AbilityScoreOSE.updateForEffects(nodeChar);

end
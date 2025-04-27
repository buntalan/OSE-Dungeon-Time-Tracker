function onInit()
	if GameSystem.targetactions == nil then
		GameSystem.targetactions = { };
	end
		GameSystem.actions["save"] = { bUseModStack = "true", sTargeting = "each" };
		GameSystem.actions["spells_2RollAction"] = { bUseModStack = "true" };
		ActionsManager.registerResultHandler("save", manager_action_CTsaveroll.SpellDamageSaveHandler);
	table.insert(GameSystem.targetactions, "save");
	table.insert(GameSystem.targetactions, "save");
	table.insert(GameSystem.targetactions, "save");
end

function calcBattleXP(nodeBattle)
	local sTargetNPCList = LibraryData.getCustomData("battle", "npclist") or "npclist";

	local nXP = 0;
	for _, vNPCItem in pairs(DB.getChildren(nodeBattle, sTargetNPCList)) do
		local sClass, sRecord = DB.getValue(vNPCItem, "link", "", "");
		if sRecord ~= "" then
			local nodeNPC = DB.findNode(sRecord);
			if nodeNPC then
				nXP = nXP + (DB.getValue(vNPCItem, "count", 0) * DB.getValue(nodeNPC, "XP_field", 0));
			else
				local sMsg = string.format(Interface.getString("enc_message_refreshxp_missingnpclink"), DB.getValue(vNPCItem, "name", ""));
				ChatManager.SystemMessage(sMsg);
			end
		end
	end
	
	DB.setValue(nodeBattle, "exp", "number", nXP);
end


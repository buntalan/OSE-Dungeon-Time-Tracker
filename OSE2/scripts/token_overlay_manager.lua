OOB_MSGTYPE_DELETE_ALL_WOUND_OVERLAYS = "delete_all_wound_overlays";

function onInit()

	if Session.IsHost then
		Comm.registerSlashHandler("clearWoundOverlays", sendMessageDeleteAllWoundOverlays);
	end

	DB.addHandler("combattracker.list.*.status", "onUpdate", handleStatusOnUpdate);
	
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_DELETE_ALL_WOUND_OVERLAYS, handleMessageDeleteAllWoundOverlays);
end

function handleStatusOnUpdate(statusNode)
	
	local nodeCT = DB.getParent(statusNode);
	token_overlay_manager.updateWoundOverlay(nodeCT);
end

function updateWoundOverlay(nodeCT)
	---Interface.openWindow("combattracker_host", "combattracker");
	local tokenCT = CombatManager.getTokenFromCT(nodeCT);
	


	local status = DB.getChild(nodeCT,"status").getValue();
	
		if not status then
		return;
	end
	

	status = translateStatus(status);


	if not status then
		return;
	end

	if tokenCT then
		local nDU = GameSystem.getDistanceUnitsPerGrid();
		local nNodeSpace = DB.getValue(nodeCT, "space", nDU);
		if nNodeSpace == 0 then
			nNodeSpace = .1
		end
		local nSpace = math.ceil(nNodeSpace / nDU)*100;
		local tokenWidth = nSpace;
		local tokenHeight = nSpace;

		local woundWidget = tokenCT.findWidget("wound");
		if woundWidget then woundWidget.destroy(); end

		woundWidget = tokenCT.addBitmapWidget();
		woundWidget.setName("wound");
		woundWidget.setSize(math.floor(tokenWidth*1), math.floor(tokenHeight*1));
		if status == "WOUNDED" then
			woundWidget.setBitmap("overlay_wounded");
		elseif status == "HEAVY" then
			woundWidget.setBitmap("overlay_heavy");
		elseif status == "DEAD" then
			woundWidget.setBitmap("overlay_death");
		end
		woundWidget.bringToFront();
	else
	end
end


function handleEffectOnUpdate(nodeCT)
local sName = ""
local nodeEffect = DB.getChild(nodeCT,"effects")
for _,vEffect in pairs (DB.getChildren(nodeEffect)) do
	sName = DB.getValue(vEffect,"label","").."|"..sName
end
		local tokenCT = CombatManager.getTokenFromCT(nodeCT);

	if tokenCT then
		local nDU = GameSystem.getDistanceUnitsPerGrid();
		local nNodeSpace = DB.getValue(nodeCT, "space", nDU);
			if nNodeSpace == 0 then
				nNodeSpace = .1
			end
		local nSpace = math.ceil(nNodeSpace / nDU)*100;
		local tokenWidth = nSpace;
		local tokenHeight = nSpace;

		local effectWidget = tokenCT.findWidget("sleep");
		if effectWidget then effectWidget.destroy(); end

		effectWidget = tokenCT.addBitmapWidget();
		effectWidget.setName("sleep");
		effectWidget.setSize(math.floor(tokenWidth*1), math.floor(tokenHeight*1));

		if string.find(sName:lower(),"sleep") or string.find(sName:lower(),"unconscious") or string.find(sName:lower(),"incapacitated") or string.find(sName:lower(),"paralyzed") or string.find(sName:lower(),"petrified") then
		effectWidget.setBitmap("overlay_sleep");

		end
	
		effectWidget.bringToFront();
	end

	if tokenCT then
		local nDU = GameSystem.getDistanceUnitsPerGrid();
		local nNodeSpace = DB.getValue(nodeCT, "space", nDU);
			if nNodeSpace == 0 then
				nNodeSpace = .1
			end
		local nSpace = math.ceil(nNodeSpace / nDU)*100;
		local tokenWidth = nSpace;
		local tokenHeight = nSpace;

		local effectWidget = tokenCT.findWidget("entangle");
		if effectWidget then effectWidget.destroy(); end

		effectWidget = tokenCT.addBitmapWidget();
		effectWidget.setName("entangle");
		effectWidget.setSize(math.floor(tokenWidth*1), math.floor(tokenHeight*1));
		
		if string.find(sName:lower(),"entangle") or string.find(sName:lower(),"restrained") then
		effectWidget.setBitmap("overlay_entangle");

		end	
		effectWidget.bringToFront();
	end


end

function translateStatus(status)


	if status == "Healthy" then
		return "HEALTHY";
	elseif status == "Wounded" then
		return "WOUNDED";
	elseif status == "Heavy" or status == "Severe Damage" then
		return "HEAVY";
	elseif string.match(status, "Dead") then
		return "DEAD";
	end
end

function updateAllWoundOverlays()

	local combatants = CombatManager.getCombatantNodes();
	for _,combatant in pairs(combatants) do
		updateWoundOverlay(combatant);
		handleEffectOnUpdate(combatant)
	end
end

function handleMessageDeleteAllWoundOverlays(msgOOB)

	local aEntries = CombatManager.getSortedCombatantList();

	for _, node in ipairs(aEntries) do
		local token = CombatManager.getTokenFromCT(node);

		if token then
			woundWidget = token.findWidget("wound");
			if woundWidget then 
				woundWidget.setVisible(false);
				woundWidget.destroy(); 
			end
			
			
		end

	end
end

function sendMessageDeleteAllWoundOverlays()

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_DELETE_ALL_WOUND_OVERLAYS;
	Comm.deliverOOBMessage(msgOOB);
end

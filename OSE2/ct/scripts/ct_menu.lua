-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if Session.IsHost then
		registerMenuItem(Interface.getString("ct_menu_initmenu"), "turn", 7);
		registerMenuItem(Interface.getString("ct_menu_initreset"), "pointer_circle", 7, 4);

		registerMenuItem(Interface.getString("ct_menu_itemdelete"), "delete", 3);
		registerMenuItem(Interface.getString("ct_menu_itemdeletenonfriendly"), "delete", 3, 1);
		registerMenuItem(Interface.getString("ct_menu_itemdeletefoe"), "delete", 3, 3);
		
		registerMenuItem("Roll NPC Initiatives", "gnome", 5);
		registerMenuItem(Interface.getString("menu_rest"), "rest", 8);
	end
end

function onClickDown(button, x, y)
	return true;
end

function onClickRelease(button, x, y)
	if button == 1 then
		Interface.openRadialMenu();
		return true;
	end
end

function onMenuSelection(selection, subselection, subsubselection)
	if Session.IsHost then
		if selection == 7 then
			if subselection == 4 then
				CombatManager.resetInit();
			end
		elseif selection == 3 then
			if subselection == 1 then
				CombatManager.deleteFaction("foe");
				CombatManager.deleteFaction("neutral");
			elseif subselection == 3 then
				CombatManager.deleteFaction("foe");
			end

		elseif selection == 8 then
				ChatManager.Message(Interface.getString("ct_message_rest"), true);
				CombatManager2.rest(true);
				
		elseif 	selection == 5 then
				CombatManager2.RollNPC(true);

		end
		
		
	end
end

function clearNPCs(bDeleteOnlyFoe)
	for _, vChild in pairs(window.list.getWindows()) do
		local sFaction = vChild.friendfoe.getStringValue();
		if bDeleteOnlyFoe then
			if sFaction == "foe" then
				vChild.delete();
			end
		else
			if sFaction ~= "friend" then
				vChild.delete();
			end
		end
	end
end

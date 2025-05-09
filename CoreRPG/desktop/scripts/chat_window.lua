--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onDiceLanded(draginfo)
	if ChatManager.onDiceLanded(draginfo) then
		return true;
	end
	return ActionsManager.onDiceLanded(draginfo);
end
function onReceiveMessage(msg)
	return ChatManager.onReceiveMessage(msg);
end

function onDragStart(_, _, _, draginfo)
	return ActionsManager.onChatDragStart(draginfo);
end
function onDrop(_, _, draginfo)
	if ChatManager.onDrop(draginfo) then
		return true;
	end

	local bReturn = ActionsManager.actionDrop(draginfo, nil);
	if bReturn then
		local aDice = draginfo.getDiceData();
		if aDice and #aDice > 0 and not OptionsManager.isOption("MANUALROLL", "on") then
			return;
		end
		return true;
	end
end

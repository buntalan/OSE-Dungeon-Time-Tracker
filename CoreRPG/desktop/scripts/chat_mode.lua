--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	Input.addEventHandler("onAlt", self.updateStateGraphic);
	Input.addEventHandler("onShift", self.updateStateGraphic);
	Input.addEventHandler("onControl", self.updateStateGraphic);
end

function updateStateGraphic()
	local nState = 0;
	if Input.isControlPressed() then
		nState = nState + 1;
	end
	if Input.isShiftPressed() then
		nState = nState + 2;
	end
	if Input.isAltPressed() then
		nState = nState + 4;
	end

	if (nState == 1) then
		if Session.IsHost then
			setIcon("chat_story");
		else
			setIcon("chat_action");
		end
	elseif (nState == 3) then
		setIcon("chat_emote");
	elseif (nState >= 4) and (nState <= 7) then
		setIcon("chat_ooc");
	else
		setIcon("chat_speak");
	end
end

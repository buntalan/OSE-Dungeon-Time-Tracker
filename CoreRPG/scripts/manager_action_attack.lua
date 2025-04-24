--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function encodeActionText(rAction)
	local tOutput = {};
	table.insert(tOutput, Interface.getString("action_attack_tag"));
	if (rAction.order or 1) > 1 then
		table.insert(tOutput, string.format("#%d", rAction.order));
	end
	if (rAction.range or "") ~= "" then
		table.insert(tOutput, string.format("(%s)", rAction.range));
	end
	return string.format("[%s] %s", table.concat(tOutput, " "), StringManager.capitalizeAll(rAction.label or ""));
end
function decodeRollData(rRoll)
	if not rRoll then
		return;
	end
	if not rRoll.nOrder then
		local sPattern = string.format("%%[%s.-#(%%d+)", Interface.getString("action_attack_tag"));
		rRoll.nOrder = tonumber(rRoll.sDesc:match(sPattern)) or nil;
	end
	if not rRoll.sRange then
		local sPattern = string.format("%%[%s.-%%((%%w+)%%)%%]", Interface.getString("action_attack_tag"));
		rRoll.sRange = rRoll.sDesc:match(sPattern);
	end
	if not rRoll.sLabel then
		local sPattern = string.format("%%[%s.-%%]([^%%[]+)", Interface.getString("action_attack_tag"));
		rRoll.sLabel = StringManager.trim(rRoll.sDesc:match(sPattern));
	end
end
function decodeRangeText(s)
	if not s then
		return "M";
	end
	local sPattern = string.format("%%[%s.*%%((%%w+)%%)%%]", Interface.getString("action_attack_tag"));
	return s:match(sPattern) or "M";
end
function decodeLabelText(s)
	if not s then
		return "";
	end
	local sPattern = string.format("%%[%s[^]]*%%] ([^[]+)", Interface.getString("action_attack_tag"));
	return StringManager.trim(s:match(sPattern) or "");
end

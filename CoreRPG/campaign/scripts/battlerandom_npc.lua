--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	self.onLockModeChanged(WindowManager.getWindowReadOnlyState(self));
end

function onLockModeChanged(bReadOnly)
	WindowManager.callSafeControlsSetLockMode(self, { "expr", "token", "name", "faction", "isidentified", "idelete", }, bReadOnly);
end

function onDrop(_, _, draginfo)
	local sDragType = draginfo.getType();
	if sDragType == "number" then
		self.addNumber(draginfo.getNumberData());
	elseif sDragType == "dice" then
		local aDropDice = draginfo.getDiceData();
		local aDice = {};
		for _,vDie in ipairs(aDropDice) do
			table.insert(aDice, vDie.type);
		end
		self.addDice(aDice);
		return true;
	end
end
function addNumber(n)
	local sValue = expr.getValue();
	if sValue == "" then
		sValue = tostring(n) or "";
	elseif n < 0 then
		sValue = sValue .. n;
	else
		sValue = sValue .. "+" .. n;
	end
	expr.setValue(sValue);
end
function addDice(aDice)
	local aDieCounts = {};
	for _,sDie in ipairs(aDice) do
		if not aDieCounts[sDie] then
			aDieCounts[sDie] = 0;
		end
		aDieCounts[sDie] = aDieCounts[sDie] + 1;
	end

	local aResults = {};
	for sDie,nCount in pairs(aDieCounts) do
		table.insert(aResults, tostring(nCount) .. sDie);
	end

	local sValue = expr.getValue();
	if sValue == "" then
		sValue = table.concat(aResults, "+");
	else
		sValue = sValue .. "+" .. table.concat(aResults, "+");
	end
	expr.setValue(sValue);
end

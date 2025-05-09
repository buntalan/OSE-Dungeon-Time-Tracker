--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

--luacheck: globals allowsinglespacing maxslotperrow spacing stateicons

local slots = {};
local nMaxSlotRow = 10;
local nDefaultSpacing = 10;
local nSpacing = nDefaultSpacing;

local sSheetMode = "";
local bSpontaneous = false;
local nAvailable = 0;
local nTotalCast = 0;

local _sDisabledColor = "B0FFFFFF";
local _sFullColor = "FFFFFFFF";

function onInit()
	-- Get any custom fields
	if maxslotperrow then
		nMaxSlotRow = tonumber(maxslotperrow[1]) or 10;
	end

	if spacing then
		nSpacing = tonumber(spacing[1]) or nDefaultSpacing;
	end
	if allowsinglespacing then
		setAnchoredHeight(nSpacing);
	else
		setAnchoredHeight(nSpacing*2);
	end
	setAnchoredWidth(nSpacing);

	local node = window.getDatabaseNode();
	DB.addHandler(DB.getPath(node, "prepared"), "onUpdate", self.onValueChanged);
	DB.addHandler(DB.getPath(node, "cast"), "onUpdate", self.onValueChanged);
end
function onClose()
	local node = window.getDatabaseNode();
	DB.removeHandler(DB.getPath(node, "prepared"), "onUpdate", self.onValueChanged);
	DB.removeHandler(DB.getPath(node, "cast"), "onUpdate", self.onValueChanged);
end

function onWheel(notches)
	if not Input.isControlPressed() then
		return false;
	end

	self.adjustCounter(notches);
	return true;
end
function onClickDown()
	if not isReadOnly() then
		return true;
	end
end
function onClickRelease(_, x, y)
	if isReadOnly() then
		return;
	end

	local nPrepared = self.getPreparedValue();
	local bPrepMode = (sSheetMode == "preparation");
	local nMax = nPrepared;
	if bSpontaneous or bPrepMode then
		nMax = nAvailable;
	end

	local nClickH = math.floor(x / nSpacing) + 1;
	local nClickV;
	if nMax > nMaxSlotRow then
		nClickV	= math.floor(y / nSpacing);
	else
		nClickV = 0;
	end
	local nClick = (nClickV * nMaxSlotRow) + nClickH;

	if bPrepMode then
		local nCurrent = self.getPreparedValue();

		if nClick > nCurrent then
			self.adjustCounter(1);
		else
			self.adjustCounter(-1);
		end
	else
		local nCurrent = self.getCastValue();

		if bSpontaneous then
			if nClick > nTotalCast then
				self.adjustCounter(1);
			elseif nCurrent > 0 then
				self.adjustCounter(-1);
			end
		else
			if nClick > nCurrent then
				self.adjustCounter(1);
			else
				self.adjustCounter(-1);
			end
		end

		if self.getCastValue() > nCurrent then
			PowerManagerCore.usePower(window.getDatabaseNode());
		end
	end

	return true;
end

function update(sNewSheetMode, bNewSpontaneous, nNewAvailable, nNewTotalCast)
	sSheetMode = sNewSheetMode;
	bSpontaneous = bNewSpontaneous;
	nAvailable = nNewAvailable;
	nTotalCast = nNewTotalCast;

	self.updateSlots();
end
function updateSlots()
	-- Construct based on values
	local nPrepared = self.getPreparedValue();
	local nCast = self.getCastValue();
	local bPrepMode = (sSheetMode == "preparation");

	local nMax = nPrepared;
	if bSpontaneous or bPrepMode then
		nMax = nAvailable;
	end

	if #slots ~= nMax then
		-- Clear
		for _,v in ipairs(slots) do
			v.destroy();
		end
		slots = {};

		-- Build the slots, based on the all the spell cast statistics
		for i = 1, nMax do
			local sIcon, sColor;
			if bSpontaneous then
				if i > nTotalCast then
					sIcon = stateicons[1].off[1];
				else
					sIcon = stateicons[1].on[1];
				end

				if i <= nTotalCast - nCast or bPrepMode then
					sColor = _sDisabledColor;
				else
					sColor = _sFullColor;
				end
			else
				if i > nCast then
					sIcon = stateicons[1].off[1];
				else
					sIcon = stateicons[1].on[1];
				end

				if i > nPrepared then
					sColor = _sDisabledColor;
				else
					sColor = _sFullColor;
				end
			end

			local nW = (i - 1) % nMaxSlotRow;
			local nH = math.floor((i - 1) / nMaxSlotRow);

			local nX = (nSpacing * nW) + math.floor(nSpacing / 2);
			local nY;
			if nMax > nMaxSlotRow then
				nY = (nSpacing * nH) + math.floor(nSpacing / 2);
			else
				nY = (nSpacing * nH) + nSpacing;
			end

			slots[i] = addBitmapWidget({ icon = sIcon, color = sColor, position="topleft", x = nX, y = nY });
		end

		-- Determine final width of control based on slots
		if nMax > nMaxSlotRow then
			setAnchoredWidth(nMaxSlotRow * nSpacing);
			setAnchoredHeight((math.floor((nMax - 1) / nMaxSlotRow) + 1) * nSpacing);
		else
			setAnchoredWidth(nMax * nSpacing);
			setAnchoredHeight(nSpacing * 2);
		end
	else
		for i = 1, nMax do
			if bSpontaneous then
				if i > nTotalCast then
					slots[i].setBitmap(stateicons[1].off[1]);
				else
					slots[i].setBitmap(stateicons[1].on[1]);
				end

				if i <= nTotalCast - nCast or bPrepMode then
					slots[i].setColor(_sDisabledColor);
				else
					slots[i].setColor(_sFullColor);
				end
			else
				if i > nCast then
					slots[i].setBitmap(stateicons[1].off[1]);
				else
					slots[i].setBitmap(stateicons[1].on[1]);
				end

				if i > nPrepared then
					slots[i].setColor(_sDisabledColor);
				else
					slots[i].setColor(_sFullColor);
				end
			end
		end
	end
end

function adjustCounter(val_adj)
	if sSheetMode == "preparation" then
		if bSpontaneous then
			return true;
		end

		local val = self.getPreparedValue() + val_adj;

		if val > nAvailable then
			self.setPreparedValue(nAvailable);
		elseif val < 0 then
			self.setPreparedValue(0);
		else
			self.setPreparedValue(val);
		end
	else
		local val = self.getCastValue() + val_adj;
		local nTempTotal = nTotalCast + val_adj;

		if bSpontaneous then
			if nTempTotal > nAvailable then
				if val - (nTempTotal - nAvailable) > 0 then
					self.setCastValue(val - (nTempTotal - nAvailable));
				else
					self.setCastValue(0);
				end
			elseif val < 0 then
				self.setCastValue(0);
			else
				self.setCastValue(val);
			end
		else
			local nPrepared = self.getPreparedValue();

			if val > nPrepared then
				self.setCastValue(nPrepared);
			elseif val < 0 then
				self.setCastValue(0);
			else
				self.setCastValue(val);
			end
		end
	end

	if self.onValueChanged then
		self.onValueChanged();
	end
end
function onValueChanged()
	WindowManager.callOuterWindowFunction(window, "onSpellCounterUpdate");
end

function canCast()
	if bSpontaneous then
		return (nTotalCast < nAvailable);
	else
		return (self.getCastValue() < self.getPreparedValue());
	end
end

function getPreparedValue()
	return DB.getValue(window.getDatabaseNode(), "prepared", 0);
end
function setPreparedValue(nNewValue)
	return DB.setValue(window.getDatabaseNode(), "prepared", "number", nNewValue);
end

function getCastValue()
	return DB.getValue(window.getDatabaseNode(), "cast", 0);
end
function setCastValue(nNewValue)
	return DB.setValue(window.getDatabaseNode(), "cast", "number", nNewValue);
end

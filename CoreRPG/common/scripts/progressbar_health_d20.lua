--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

local sMaxHealthNodePath = nil;
local sTempHealthNodePath = nil;
local sWoundNodePath = nil;
local sNonlethalWoundNodePath = nil;

local _bParsed = false;
local _bInitialized = false;

function parse()
	if _bParsed then
		return;
	end
	_bParsed = true;

	local node = window.getDatabaseNode();
	sMaxHealthNodePath = DB.getPath(node, "hptotal");
	sTempHealthNodePath = DB.getPath(node, "hptemp");
	sWoundNodePath = DB.getPath(node, "wounds");
	sNonlethalWoundNodePath = DB.getPath(node, "nonlethal");
end
function init()
	if _bInitialized then
		return;
	end
	_bInitialized = true;

	self.parse();
	self.addHandlers();
	self.initFillControl();
	self.onHealthChanged();
	self.update();
end

function addHandlers()
	if sMaxHealthNodePath then
		DB.addHandler(sMaxHealthNodePath, "onUpdate", self.onMaxChanged);
	end
	if sTempHealthNodePath then
		DB.addHandler(sTempHealthNodePath, "onUpdate", self.onTempChanged);
	end
	if sWoundNodePath then
		DB.addHandler(sWoundNodePath, "onUpdate", self.onWoundChanged);
	end
	if sNonlethalWoundNodePath then
		DB.addHandler(sNonlethalWoundNodePath, "onUpdate", self.onNonlethalChanged);
	end

	OptionsManager.registerCallback("BARC", self.update);
	OptionsManager.registerCallback("WNDC", self.update);
	if not Session.IsHost then
		OptionsManager.registerCallback("SHPC", self.update);
	end
end
function removeHandlers()
	if sMaxHealthNodePath then
		DB.removeHandler(sMaxHealthNodePath, "onUpdate", self.onMaxChanged);
	end
	if sTempHealthNodePath then
		DB.removeHandler(sTempHealthNodePath, "onUpdate", self.onTempChanged);
	end
	if sWoundNodePath then
		DB.removeHandler(sWoundNodePath, "onUpdate", self.onWoundChanged);
	end
	if sNonlethalWoundNodePath then
		DB.removeHandler(sNonlethalWoundNodePath, "onUpdate", self.onNonlethalChanged);
	end

	OptionsManager.unregisterCallback("BARC", self.update);
	OptionsManager.unregisterCallback("WNDC", self.update);
	if not Session.IsHost then
		OptionsManager.unregisterCallback("SHPC", self.update);
	end
end

function onMaxChanged()
	self.onHealthChanged();
end
function onTempChanged()
	self.onHealthChanged();
end
function onWoundChanged()
	self.onHealthChanged();
end
function onNonlethalChanged()
	self.onHealthChanged();
end

function onHealthChanged()
	local nHP = DB.getValue(sMaxHealthNodePath, 0);
	local nTempHP = DB.getValue(sTempHealthNodePath, 0);

	local nWounds = DB.getValue(sWoundNodePath, 0);
	local nNonlethal = DB.getValue(sNonlethalWoundNodePath, 0);

	local nPercentWounded = 0;
	local nPercentNonlethal = 0;
	if nHP > 0 then
		nPercentWounded = nWounds / (nHP + nTempHP);
		nPercentNonlethal = (nWounds + nNonlethal) / (nHP + nTempHP);
	end

	self.setMax(nHP + nTempHP, true);
	self.setValue(nHP + nTempHP - nWounds, true);

	local sColor;
	if nPercentWounded <= 1 and nPercentNonlethal > 1 then
		sColor = ColorManager.getUIColor("health_unconscious");
	elseif nPercentWounded == 1 or nPercentNonlethal == 1 then
		sColor = ColorManager.getUIColor("health_simple_bloodied");
	else
		sColor = ColorManager.getHealthColor(nPercentNonlethal, true);
	end
	self.setFillColor(sColor);

	if Session.IsHost or OptionsManager.isOption("SHPC", "detailed") then
		local sText = "" .. (nHP - nWounds);
		if nTempHP > 0 then
			sText = sText .. " (+" .. nTempHP .. ")";
		end
		sText = sText .. " / " .. nHP;
		if nTempHP > 0 then
			sText = sText .. " (+" .. nTempHP .. ")";
		end
		local sPrefix = Interface.getString("hp");
		if (sPrefix or "") ~= "" then
			sText = sPrefix .. ": " .. sText;
		end
		self.setText(sText);
	else
		self.setText("");
	end
end

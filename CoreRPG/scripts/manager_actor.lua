--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

--
-- NOTE: You should not access actor variable information directly;
--		as format and usage may change over time.
--		Use the functions provided to interact with actor records
--
--  **DATA STRUCTURES**
--
-- rActor
--		sType
--		sCreatureNode
-- 		sCTNode
--		sName
--

local _tActorRecordTypes = {};
local _tActorTypePathHandlers = {};
local _tCombatTrackerLookups = {};

function onInit()
	ActorManager.registerStandardRecordTypes();
	ActorManager.registerStandardCTLookup();
end

function registerStandardRecordTypes()
	ActorManager.registerActorRecordType("charsheet");
	ActorManager.registerActorRecordType("npc");
	ActorManager.registerActorRecordType("vehicle");
end
function registerStandardCTLookup()
	ActorManager.registerCTNodeLookup(CombatManager.getCTFromNode);
end

--
-- ACTOR RESOLUTION
--

function registerActorRecordType(sRecordType)
	if sRecordType == "ct" then
		return;
	end
	_tActorRecordTypes[sRecordType] = true;
end
function registerActorTypePathHandler(sPath, v)
	_tActorTypePathHandlers[sPath] = v;
end

function registerCTNodeLookup(fn)
	table.insert(_tCombatTrackerLookups, fn);
end

function resolveActor(v)
	-- Get actor node
	local nodeActor = nil;
	local sVarType = type(v);
	if sVarType == "table" then
		return v;
	elseif sVarType == "string" then
		if v ~= "" then
			nodeActor = DB.findNode(v);
			-- Note: Handle cases where PC targets another PC they do not own,
			--	 	which means they do not have access to PC record but they
			--		do have access to CT record.
			if not nodeActor then
				local sCTPath = ActorManager.getCTPathFromActorNode(v);
				if sCTPath then
					nodeActor = DB.findNode(sCTPath);
				end
			end
		end
	elseif sVarType == "databasenode" then
		nodeActor = v;
	elseif sVarType == "tokeninstance" then
		nodeActor = CombatManager.getCTFromToken(v);
	end
	if not nodeActor then
		return nil;
	end

	-- Determine type unless specified
	local sActorNodePath = DB.getPath(nodeActor);
	local sActorType = ActorManager.getActorRecordTypeFromPath(sActorNodePath);
	if not sActorType then
		return nil;
	end

	-- Return actor information
	local rActor = {};
	if sActorType == "ct" then
		local sClass, sRecord = DB.getValue(nodeActor, "link", "", "");
		rActor.sType = ActorManager.getActorRecordTypeFromPath(sRecord);
		if rActor.sType and rActor.sType ~= "ct" then
			rActor.sCreatureNode = sRecord;
		else
			rActor.sType = RecordDataManager.getRecordTypeFromDisplayClass(sClass);
			rActor.sCreatureNode = sActorNodePath;
		end
		rActor.sCTNode = sActorNodePath;
	else
		rActor.sType = sActorType;
		rActor.sCreatureNode = sActorNodePath;
		rActor.sCTNode = ActorManager.getCTPathFromActorNode(nodeActor);
	end

	rActor.sName = ActorManager.resolveDisplayName(rActor);

	return rActor;
end

-- Internal use only
function getCTPathFromActorNode(nodeActor)
	for _,fn in ipairs(_tCombatTrackerLookups) do
		local nodeCT = fn(nodeActor);
		if nodeCT then
			return DB.getPath(nodeCT);
		end
	end
	return nil;
end

-- Internal use only
function getActorRecordTypeFromPath(sPath)
	if CombatManager.isTrackerCT(sPath) then
		return "ct";
	end

	local sType = RecordDataManager.getRecordTypeFromRecordPath(sPath);
	if _tActorRecordTypes[sType] then
		return sType;
	end

	for sTypePath, vType in pairs(_tActorTypePathHandlers) do
		if UtilityManager.isPathMatch(sPath, sTypePath) then
			if type(vType) == "function" then
				return vType(sPath);
			else
				return vType;
			end
		end
	end

	return nil;
end

-- Internal use only
function resolveDisplayName(rActor)
	if RecordDataManager.getIDMode(rActor.sType) then
		local node = ActorManager.getCTNode(rActor);
		if not node then
			node = ActorManager.getCreatureNode(rActor);
		end
		if node then
			if RecordDataManager.getIDState(rActor.sType, node, true) then
				return DB.getValue(node, "name", "");
			else
				return DB.getValue(node, "nonid_name", "");
			end
		end
	else
		local node = ActorManager.getCTNode(rActor);
		if not node then
			node = ActorManager.getCreatureNode(rActor);
		end
		if node then
			return DB.getValue(node, "name", "");
		end
	end

	return "";
end

--
-- PROPERTIES
--

function getRecordType(v)
	local rActor = ActorManager.resolveActor(v);
	if rActor then
		return rActor.sType or "";
	end
	return "";
end
function isRecordType(v, sRecordType)
	return (ActorManager.getRecordType(v) == sRecordType);
end
function isPC(v)
	return ActorManager.isRecordType(v, "charsheet");
end
function isOwner(v)
	if Session.IsHost then
		return true;
	end
	local nodeActor = ActorManager.getCreatureNode(v);
	if not nodeActor then
		return false;
	end
	return DB.isOwner(nodeActor);
end

function hasCT(v)
	return (ActorManager.getCTNodeName(v) ~= "");
end
function getCTNodeName(v)
	local rActor = ActorManager.resolveActor(v);
	if rActor then
		return rActor.sCTNode or "";
	end
	return "";
end
function getCTNode(v)
	local sCTNode = ActorManager.getCTNodeName(v);
	if (sCTNode or "") ~= "" then
		return DB.findNode(sCTNode);
	end
	return nil;
end

function getCreatureNodeName(v)
	local rActor = ActorManager.resolveActor(v);
	if rActor then
		return rActor.sCreatureNode or "";
	end
	return "";
end
function getCreatureNode(v)
	local rActor = ActorManager.resolveActor(v);
	if rActor and ((rActor.sCreatureNode or "") ~= "") then
		return DB.findNode(rActor.sCreatureNode);
	end
	return nil;
end

function getFaction(v)
	local rActor = ActorManager.resolveActor(v);
	local nodeCT = ActorManager.getCTNode(rActor);
	return CombatManager.getFactionFromCT(nodeCT);
end
function isFaction(v, sFaction)
	return (ActorManager.getFaction(v) == sFaction);
end

function getDisplayName(v)
	local rActor = ActorManager.resolveActor(v);
	if not rActor then
		return "";
	end
	return rActor.sName;
end

--
-- EFFECT RESOLUTION
--

-- NOTE: Requires actor to be previously resolved before being able to store active effect nodes
function addActiveEffectNode(rActor, vNode)
	if type(rActor) ~= "table" then
		return;
	end
	if not vNode then
		return;
	end
	if type(vNode) == "string" then
		if vNode == "" then
			return;
		end
	end

	if not rActor.tActiveEffectNodes then
		rActor.tActiveEffectNodes = {};
	end
	table.insert(rActor.tActiveEffectNodes, vNode);
end

function getActiveEffectNodes(rActor)
	if type(rActor) ~= "table" then
		return;
	end
	return rActor.tActiveEffectNodes or {};
end

function getCTEffects(v)
	local rActor = ActorManager.resolveActor(v);
	if not rActor then
		return {};
	end
	local sCTNode = ActorManager.getCTNodeName(rActor);
	if sCTNode == "" then
		return {};
	end
	return DB.getChildList(sCTNode .. ".effects");
end

function getEffects(v)
	local rActor = ActorManager.resolveActor(v);
	if not rActor then
		return {};
	end
	local tCTEffects = ActorManager.getCTEffects(rActor);
	if not rActor.tActiveEffectNodes or (#(rActor.tActiveEffectNodes) == 0) then
		return tCTEffects;
	end
	local tAllEffects = {};
	for _,nodeEffect in ipairs(tCTEffects) do
		table.insert(tAllEffects, nodeEffect);
	end
	for _,nodeActive in ipairs(rActor.tActiveEffectNodes) do
		for _,nodeEffect in ipairs(DB.getChildList(DB.getPath(nodeActive, "effects"))) do
			table.insert(tAllEffects, nodeEffect);
		end
	end
	return tAllEffects;
end

--
-- LEGACY
--

function getTypeAndNode(v)
	Debug.console("ActorManager.getTypeAndNode/getTypeAndNodeName - DEPRECATED - 2025-04-22 - Use ActorManager.isPC/isRecordType/getCreatureNode/getCTNode");
	local rActor = ActorManager.resolveActor(v);
	if not rActor then
		return nil, nil;
	end

	if ActorManager.isPC(rActor) then
		local nodeCreature = ActorManager.getCreatureNode(rActor);
		if nodeCreature and DB.isOwner(nodeCreature) then
			return "pc", nodeCreature;
		end
	end

	local nodeCT = ActorManager.getCTNode(rActor);
	if nodeCT then
		return "ct", nodeCT;
	end

	if not ActorManager.isPC(rActor) then
		local nodeNPC = ActorManager.getCreatureNode(rActor);
		if nodeNPC then
			return rActor.sType, nodeNPC;
		end
	end

	return nil, nil;
end
function getTypeAndNodeName(v)
	local sType, nodeCreature = ActorManager.getTypeAndNode(v);
	if nodeCreature then
		return sType, DB.getPath(nodeCreature);
	end
	return sType, nil;
end

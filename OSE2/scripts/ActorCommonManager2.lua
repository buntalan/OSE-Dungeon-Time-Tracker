
function isCreatureAlignmentDnD(rActor, sParam)
	
	local sActorAlign = ActorCommonManager2.internalGetCreatureAlignmentDnDActor(rActor);

	if not sActorAlign then
		return false;
	end
	if sActorAlign:lower() =="chaotic" then sActorAlign="chaos"
	elseif sActorAlign:lower() =="lawful" then sActorAlign="law"
	elseif sActorAlign:lower() =="neutral" then sActorAlign="neutrality" end
	local bReturn = true;
	
	if sParam:lower() == sActorAlign then
	return true;
	end
	return false;
end

-- NOTE: Assume standard values of:
--		nCheckLawChaosAxis = Lawful = 1, Neutral = 0, Chaos = 2


function internalGetCreatureAlignmentDnDActor(rActor)
	local nodeActor = ActorManager.getCreatureNode(rActor);
	if not nodeActor then
		return nil;
	end

	if ActorManager.isPC(rActor) then
		sField = "alignment";
	else
		sField = "alignment_dropdown";
	end
	local sActorAlign = DB.getValue(nodeActor, sField, "");
	return sActorAlign:lower()
end

function isCreatureSizeDnD3(rActor, sParam)
	if not DataCommon.creaturesize then
		return false;
	end

	local tParamSize = ActorCommonManager2.internalIsCreatureSizeDnDParam(sParam);

	if not tParamSize then
		return false;
	end
	
	local nActorSize = ActorCommonManager2.getCreatureSizeDnD3(rActor);

	return ActorCommonManager2.internalIsCreatureSizeDnDCompare(tParamSize, nActorSize);
end

function internalIsCreatureSizeDnDParam(sParam)

	local tParams = StringManager.splitByPattern(sParam:lower(), ",", true);

	local tParamSize = {};
	for _,sParamComp in ipairs(tParams) do
		local sParamCompLower = StringManager.trim(sParamComp):lower();
		local sParamOp = sParamCompLower:match("^[<>]?=?");
		if sParamOp then
			sParamCompLower = StringManager.trim(sParamCompLower:sub(#sParamOp + 1));
		end

		local nParamSize = DataCommon.creaturesize[sParamCompLower];
		if nParamSize then
			table.insert(tParamSize, { nParamSize = nParamSize, sParamOp = sParamOp });
		end
	end
	if #tParamSize == 0 then
		return nil;
	end
	return tParamSize;
end

function internalIsCreatureSizeDnDCompare(tParamSize, nActorSize)
	for _,t in ipairs(tParamSize) do
		local bReturn;
		if t.sParamOp then
			if t.sParamOp == "<" then
				bReturn = (nActorSize < t.nParamSize);
			elseif t.sParamOp == ">" then
				bReturn = (nActorSize > t.nParamSize);
			elseif t.sParamOp == "<=" then
				bReturn = (nActorSize <= t.nParamSize);
			elseif t.sParamOp == ">=" then
				bReturn = (nActorSize >= t.nParamSize);
			else
				bReturn = (nActorSize == t.nParamSize);
			end
		else
			bReturn = (nActorSize == t.nParamSize);
		end
		if bReturn then
			return true;
		end
	end
	return false;
end

function getCreatureSizeDnD3(rActor)
	if ActorManager.isPC(rActor) then
		return ActorCommonManager2.getCreatureSizeFromSizeFieldCore(rActor);
	end
	return ActorCommonManager2.getCreatureSizeFromTypeFieldCore(rActor);
end


function getCreatureSizeFromTypeFieldCore(rActor)
	if not DataCommon.creaturesize then
		return 0;
	end

	local nodeActor = ActorManager.getCreatureNode(rActor);
	if not nodeActor then
		return 0;
	end

	local nActorSize = nil;
	
	local sType = DB.getValue(nodeActor, "size", ""):lower();
	local tLines = StringManager.splitLines(sType);
	for _,sLine in ipairs(tLines) do
		local tWords = StringManager.splitWords(sLine);
		if #tWords > 0 then
			if DataCommon.creaturesize[tWords[1]] then
				nActorSize = DataCommon.creaturesize[tWords[1]];
			elseif (DataCommon.alignment_lawchaos and DataCommon.alignment_lawchaos[tWords[1]])
					or (DataCommon.alignment_goodevil and DataCommon.alignment_goodevil[tWords[1]])
					or (DataCommon.alignment_neutral and (tWords[1] == DataCommon.alignment_neutral))
					then
				for _,sWord in ipairs(tWords) do
					if DataCommon.creaturesize[sWord] then
						nActorSize = DataCommon.creaturesize[sWord];
						break;
					end
				end
			end
		end
		if nActorSize then
			break;
		end
	end
	
	return nActorSize or 0;
end

function getCreatureSizeFromSizeFieldCore(rActor)
	if not DataCommon.creaturesize then
		return 0;
	end

	local nodeActor = ActorManager.getCreatureNode(rActor);
	if not nodeActor then
		return 0;
	end

	local nActorSize = nil;
	
	local sSize = DB.getValue(nodeActor, "size", ""):lower();
	local tLines = StringManager.splitLines(sSize);
	for _,sLine in ipairs(tLines) do
		local tWords = StringManager.parseWords(sLine);
		if tWords[1] and DataCommon.creaturesize[tWords[1]] then
			nActorSize = DataCommon.creaturesize[tWords[1]];
			break;
		end
	end
	
	return nActorSize or 0;
end

function isCreatureTypeDnD(rActor, sParam)
	local tCheckTypes = ActorCommonManager2.internalGetCreatureTypeDnDParam(sParam);
	if not tCheckTypes then
		return false;
	end

	local tActorTypes = ActorCommonManager2.getCreatureTypesDnD(rActor);
	if not tActorTypes then
		return false;
	end

	for s,t in pairs(tCheckTypes) do
		for _,sCheck in ipairs(t) do

			if StringManager.contains(tActorTypes, sCheck) then
				return true;
				
			end
		end
	end
	return false;
end

function getCreatureTypesDnD(rActor)
	local nodeActor = ActorManager.getCreatureNode(rActor);
	if not nodeActor then
		return nil;
	end

	local sField;
	if ActorManager.isPC(rActor) then
		sField = "race";
	else
		sField = "tags";
	end
	local sActorType = DB.getValue(nodeActor, sField, "");

		tActorTypes = StringManager.split(sActorType, ",", true)
		return tActorTypes
	--return ActorCommonManager2.internalGetCreatureTypesFromStringDnD(sActorType, true);
end

function internalGetCreatureTypeDnDParam(sParam)
	local tParams = StringManager.splitByPattern(sParam:lower(), ",", true);

	local tCheckTypes = {};
	for _,sParamComp in ipairs(tParams) do
		local tParamCompTypes = ActorCommonManager2.internalGetCreatureTypesFromStringDnD(sParamComp, false);
		for sParamCompTypeKey, tParamCompType in pairs(tParamCompTypes) do
			if not tCheckTypes[sParamCompTypeKey] then
				tCheckTypes[sParamCompTypeKey] = {};
			end
			for _,s in ipairs(tParamCompType) do
				table.insert(tCheckTypes[sParamCompTypeKey], s);
			end
		end
	end

	for _,t in pairs(tCheckTypes) do
		if #t > 0 then
			return tCheckTypes;
		end
	end
	return nil;
end
-- Known usage notes:
--		5E/PFRPG/3.5E/SFRPG/d20Modern/DCC - type/subtype
--		4E - origin/type/subtype
--		13A/MCC - type
function internalGetCreatureTypesFromStringDnD(sType, bUseDefaultType)

	-- Build parameter tracking
	local tSource = { nIndex = 1 };
	tSource.tWords = StringManager.split(sType:lower(), ", %(%)", true);
	
	
	-- Check each type set
	local tResult = {};
	
	tResult["tag"] = ActorCommonManager.internalIsCreatureTypeDnDMatch(tSource, DataCommon.creaturetype, true, bUseDefaultType, DataCommon.creaturedefaulttype);
	

	-- Return types and subtypes
	return tResult;
end
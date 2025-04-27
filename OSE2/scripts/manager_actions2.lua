function encodeDesktopMods(rRoll)
  local nMod = 0;
  
  if ModifierStack.getModifierKey("PLUS1") then
    nMod = nMod + 1;
  end
  if ModifierStack.getModifierKey("PLUS2") then
    nMod = nMod + 2;
  end
  if ModifierStack.getModifierKey("PLUS3") then
    nMod = nMod + 3;
  end
  if ModifierStack.getModifierKey("PLUS4") then
    nMod = nMod + 4;
  end
  if ModifierStack.getModifierKey("PLUS5") then
    nMod = nMod + 5;
  end

  if ModifierStack.getModifierKey("MINUS1") then
    nMod = nMod - 1;
  end
  if ModifierStack.getModifierKey("MINUS2") then
    nMod = nMod - 2;
  end
  if ModifierStack.getModifierKey("MINUS3") then
    nMod = nMod - 3;
  end
  if ModifierStack.getModifierKey("MINUS4") then
    nMod = nMod - 4;
  end
  if ModifierStack.getModifierKey("MINUS5") then
    nMod = nMod - 5;
  end
  
  if nMod == 0 then
    return;
  end
  
  

  rRoll.nMod = rRoll.nMod + nMod;

  rRoll.sDesc = rRoll.sDesc .. string.format(" [%+d]", nMod);
end

-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  ActionsManager.registerModHandler("dice", modRoll);
  ActionsManager.registerResultHandler("dice", onRoll);
end

function onRoll(rSource, rTarget, rRoll)
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  Comm.deliverChatMessage(rMessage);
end

function modRoll(rSource, rTarget, rRoll)
  manager_actions2.encodeDesktopMods(rRoll);
  
end

function onRoll(rSource, rTarget, rRoll)


  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  Comm.deliverChatMessage(rMessage);
end


function getRangeBetween(Source, Target)

    local sourceType = type(Source);
    local sourceToken;

    local targetType = type(Target);
    local targetToken;


    if sourceType ~= "tokeninstance" then
        sourceToken = CombatManager.getTokenFromCT(Source);
    else
        sourceToken = Source;
    end
    if targetType ~= "tokeninstance" then
        targetToken = CombatManager.getTokenFromCT(Target);
    else
        targetToken = Target;
    end

    if not sourceToken or not targetToken then
        Debug.console("[Warning] Unknown range between the source and target", Source, Target);
        return 0;
    end
    
    local nRange = Token.getDistanceBetween(sourceToken, targetToken);

    if nRange ~= nil then
		return math.floor(nRange);
	end

	-- Unknown
	Debug.console("[Warning] Unknown range between the source and target", Source, Target);
    return 0;
end

function getRangeModifier(sText,nRange,bRanged)
local rRanged = DataCommon.rangeweapons
local nRangeMod = 0
Debug.console(bRanged,sText,nRange)
local sTextmsg = ""

for _,vRanges in ipairs (rRanged) do

	if string.find(sText:lower(),(vRanges.name):lower()) then

		if nRange >=vRanges.weapon[1] and nRange <=vRanges.weapon[2] then
		sTextmsg = "Short range"
		nRangeMod=1
		elseif nRange >=vRanges.weapon[3] and nRange <=vRanges.weapon[4] then
		sTextmsg = "Medium range"
		nRangeMod =0
		elseif nRange >=vRanges.weapon[5] and nRange <=vRanges.weapon[6] then
		sTextmsg = "Long range"
		nRangeMod =-1
		elseif nRange >vRanges.weapon[6] then
		sTextmsg = "Attack Beyond Maximum Range of Weapon"
		nRangeMod=0
		end
				if bRanged then
				return nRangeMod,sTextmsg
				else
				sTextmsg = ""
				nRangeMod = 0
				return nRangeMod,sTextmsg
				end
	break			
	end			
end


return nRangeMod
end
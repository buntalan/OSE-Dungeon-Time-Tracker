-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local aFieldMap = {};

function onInit()

	WindowTabManager.registerTab("partysheet_host", { sName = "xp",sTabRes ="tab_xp", sClass = "ps_xp" });
  if Session.IsHost then
    DB.addHandler("charsheet.*.classes", "onChildUpdate", linkPCClasses);
  end
  PartyXPManager.onDrop = onDrop;
end

function linkPCClasses(nodeClass)
  if not nodeClass then
    return;
  end
  local nodeChar = DB.getParent(nodeClass);
 
  local nodePS = PartyManager.mapChartoPS(nodeChar);
  if not nodePS then
    return;
  end
 

end

function linkPCFields(nodePS)
  local sClass, sRecord = DB.getValue(nodePS, "link", "", "");
  if sRecord == "" then
    return;
  end
  local nodeChar = DB.findNode(sRecord);
  if not nodeChar then
    return;
  end
  
  PartyManager.linkRecordField(nodeChar, nodePS, "name", "string");
  PartyManager.linkRecordField(nodeChar, nodePS, "token", "token", "token");

	PartyManager.linkRecordField(nodeChar, nodePS,"xp_field",  "number","exp");
	PartyManager.linkRecordField(nodeChar, nodePS, "Xpneed_field", "number","expneeded");

  
  
  linkPCClasses(nodeChar.getChild("classes"));
end

--
-- DROP HANDLING
function onDrop(draginfo)
  if Session.IsHost and draginfo.isType("shortcut") then
      local sClass = draginfo.getShortcutData();
      if sClass == "quest" then
          PartyManager2.addQuest(draginfo.getDatabaseNode());
      elseif sClass == "battle" then
          PartyManager2.addEncounter(draginfo.getDatabaseNode());
      elseif sClass == "treasureparcel" then
          PartyManager2.addEncounterParcel(draginfo.getDatabaseNode());
      end
      return true;
  end
end

function addEncounter(nodeEnc)
  if not nodeEnc then
    return;
  end
  
  local nodePSEnc = DB.createChild("partysheet.encounters");
  DB.copyNode(nodeEnc, nodePSEnc);
  
 --
  
end


-- bulk add exp from coins
function addEncounterParcel(nodeParcel)

local sName = DB.getValue(nodeParcel,"name","")
local nEXP = 0
  -- convert gp to exp
  ---OSE_Tables.expForCoinRate[1]
  for _,nodeCoin in ipairs(DB.getChildList(nodeParcel, "coinlist")) do
    sCurrency = DB.getValue(nodeCoin, "description", "");
    nCurrency = DB.getValue(nodeCoin, "amount", 0);
-- add exp for currency value
	  for _,aRate in ipairs(OSE_Tables.expForCoinRate) do
		local sCoin = aRate[1];
		local nReward = aRate[2];
		if sCurrency:lower() == sCoin:lower() then
		  nEXP = math.floor(nCurrency * nReward + .5) + nEXP;
		  
		  --break;
		end
	  end
end
        if (nEXP > 0) then 
        local nodePSEnc = DB.createChild("partysheet.encounters");
        DB.setValue(nodePSEnc,"exp","number",nEXP);
        DB.setValue(nodePSEnc,"name","string",sName.." [COINS]");
        end
end



--
-- XP DISTRIBUTION
--

function awardQuestsToParty(nodeEntry)
  local nXP = 0;
  if nodeEntry then
    if DB.getValue(nodeEntry, "xpawarded", 0) == 0 then
      nXP = DB.getValue(nodeEntry, "xp", 0);
      DB.setValue(nodeEntry, "xpawarded", "number", 1);
    end
  else
    for _,v in ipairs(DB.getChildList("partysheet.quests")) do
      if DB.getValue(v, "xpawarded", 0) == 0 then
        nXP = nXP + DB.getValue(v, "xp", 0);
        DB.setValue(v, "xpawarded", "number", 1);
      end
    end
  end
  if nXP ~= 0 then
    awardXP(nXP);
  end
end

function awardEncountersToParty(nodeEntry)
  local nXP = 0;
  if nodeEntry then
    if DB.getValue(nodeEntry, "xpawarded", 0) == 0 then
      nXP = DB.getValue(nodeEntry, "exp", 0);
      DB.setValue(nodeEntry, "xpawarded", "number", 1);
    end
  else
    for _,v in ipairs(DB.getChildList("partysheet.encounters")) do
      if DB.getValue(v, "xpawarded", 0) == 0 then
        nXP = nXP + DB.getValue(v, "exp", 0);
        DB.setValue(v, "xpawarded", "number", 1);
      end
    end
  end
  if nXP ~= 0 then
    awardXP(nXP);
  end
end

function awardXP(nXP) 
  -- Determine members of party
  local aParty = {};
  for _,v in ipairs(DB.getChildList("partysheet.partyinformation")) do
    local sClass, sRecord = DB.getValue(v, "link");
    if sClass == "charsheet" and sRecord then
      local nodePC = DB.findNode(sRecord);
      if nodePC then
        local sName = DB.getValue(v, "name", "");
        table.insert(aParty, { name = sName, node = nodePC } );
      end
    end
  end

  -- Determine split
  local nAverageSplit;
  if nXP >= #aParty then
    nAverageSplit = math.floor((nXP / #aParty) + 0.5);
  else
    nAverageSplit = 0;
  end
  local nFinalSplit = math.max((nXP - ((#aParty - 1) * nAverageSplit)), 0);
  
  -- Award XP
  for _,v in ipairs(aParty) do
    local nAmount;
    if k == #aParty then
      nAmount = nFinalSplit;
    else
      nAmount = nAverageSplit;
    end
    
    if nAmount > 0 then

      awardXPtoPC(nAmount, v.node);

    end

    v.given = nAmount;
  end
  

end

function awardXPtoPC(nXP, nodePC)
  local nCharXP = DB.getValue(nodePC, "exp", 0);

  nCharXP = nCharXP + nXP;
  DB.setValue(nodePC, "exp", "number", nCharXP);
              
  local msg = {font = "msgfont"};
  msg.icon = "xp";
  msg.text = "[" .. nXP .. " XP] -> " .. DB.getValue(nodePC, "name");
  Comm.deliverChatMessage(msg, "");

  local sOwner = nodePC.getOwner();
  if (sOwner or "") ~= "" then
    Comm.deliverChatMessage(msg, sOwner);
  end
end

-- return array of all party sheet member nodes
function getPartySheetMembers()
  local aParty = {};
  for _,v in ipairs(DB.getChildList("partysheet.partyinformation")) do
    local sClass, sRecord = DB.getValue(v, "link");
    if sClass == "charsheet" and sRecord then
      local nodePC = DB.findNode(sRecord);
      if nodePC then
        table.insert(aParty, nodePC );
      end
    end
  end

  return aParty;
end

-- add all party sheet members to combat tracker if they are not there already.
function addPartyToCombatTracker()
  local bAdded = false;
  for _, nodePS in pairs(getPartySheetMembers()) do
    if not CombatManager.getCTFromNode(nodePS) then
      CombatManager.addPC(nodePS);
      bAdded = true;
    end
  end
  if bAdded then
    Interface.openWindow("combattracker_host", "combattracker");
  end
end

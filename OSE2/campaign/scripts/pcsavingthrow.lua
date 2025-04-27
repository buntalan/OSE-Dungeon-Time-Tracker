function onInit()
	ActionsManager.registerResultHandler("spellsavepc", spellsaveroll);
end

function performroll(dragInfo, rActor, nSelf,sName,save_type,sType)

local rRoll = getRoll( rActor, nSelf,sName,save_type,sType);

	if Session.IsHost and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end

	ActionsManager.performAction(dragInfo, rActor, rRoll)

end

function getRoll(rActor, nSelf,sName,save_type,sType)


        local rRoll = {};
        rRoll.sType = sType;
        rRoll.aDice = {"d20"};
        rRoll.nMod = 0 ;
        rRoll.nSelf = nSelf;
        rRoll.sDesc = sName;
        rRoll.save_type = save_type
     manager_actions2.encodeDesktopMods(rRoll);
        return rRoll;

end

function spellsaveroll(rSource,rTarget,rRoll)

local nEffectSave = manager_effectOSE.DecodeSaveEffects(rSource,rSource, rRoll.save_type);

local rMessage = ActionsManager.createActionMessage(rSource, rRoll);


    local nTotal = ActionsManager.total(rRoll);
    local nodeChar = rSource.sCreatureNode;
    local nTargetDC = tonumber(rRoll.nSelf)

    if string.match(rRoll.sDesc,"Vs Spells") then
    nSpellsave = DB.getValue(nodeChar.. ".wis_bonus");
	else
	nSpellsave = 0
	end

	rMessage.diemodifier = rMessage.diemodifier + nSpellsave + nEffectSave;
    local nTotal = nTotal + nSpellsave + nEffectSave;
    rMessage.text = rMessage.text .. " (vs. Target Number " ..nTargetDC.. ")";
	rMessage.font = "reference-b";


    if nTotal >= nTargetDC then
        rMessage.text = rMessage.text .. " [SUCCESS]";
    else
        rMessage.text = rMessage.text .. " [FAILURE]";
    end

    Comm.deliverChatMessage(rMessage);

    end
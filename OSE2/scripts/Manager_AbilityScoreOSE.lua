-- update all ability scores because effects were updated.
function updateForEffects(nodeChar)
    updateCharisma(nodeChar)
    updateConstitution(nodeChar)
    updateDexterity(nodeChar)
    updateIntelligence(nodeChar)
    updateStrength(nodeChar)
    updateWisdom(nodeChar)
end

function updateStrength(nodeChar)
    local rActor = ActorManager.resolveActor(nodeChar)
    local nScore = 0
    if rActor then
        -- adjust ability scores from effects!
        local sAbilityEffect = "STR"
        local nAbilityMod, nAbilityEffects = manager_effect5E.getEffectsBonus(rActor, sAbilityEffect, true)
        if (nAbilityMod ~= 0) then
            nScore = nAbilityMod
        end
        DB.setValue(nodeChar, "str_effect", "number", nScore)
    end

    return dbAbility
end

function updateCharisma(nodeChar)
    local rActor = ActorManager.resolveActor(nodeChar)
    local nScore = 0
    if rActor then
        -- adjust ability scores from effects!
        local sAbilityEffect = "CHA"
        local nAbilityMod, nAbilityEffects = manager_effect5E.getEffectsBonus(rActor, sAbilityEffect, true)
        if (nAbilityMod ~= 0) then
            nScore = nAbilityMod
        end
        DB.setValue(nodeChar, "chr_effect", "number", nScore)
    end

    return dbAbility
end

function updateConstitution(nodeChar)
    local rActor = ActorManager.resolveActor(nodeChar)
    local nScore = 0
    if rActor then
        -- adjust ability scores from effects!
        local sAbilityEffect = "CON"
        local nAbilityMod, nAbilityEffects = manager_effect5E.getEffectsBonus(rActor, sAbilityEffect, true)
        if (nAbilityMod ~= 0) then
            nScore = nAbilityMod
        end
        DB.setValue(nodeChar, "con_effect", "number", nScore)
    end

    return dbAbility
end

function updateDexterity(nodeChar)
    local rActor = ActorManager.resolveActor(nodeChar)
    local nScore = 0
    if rActor then
        -- adjust ability scores from effects!
        local sAbilityEffect = "DEX"
        local nAbilityMod, nAbilityEffects = manager_effect5E.getEffectsBonus(rActor, sAbilityEffect, true)
        if (nAbilityMod ~= 0) then
            nScore = nAbilityMod
        end
        DB.setValue(nodeChar, "dex_effect", "number", nScore)
    end

    return dbAbility
end
function updateIntelligence(nodeChar)
    local rActor = ActorManager.resolveActor(nodeChar)
    local nScore = 0
    if rActor then
        -- adjust ability scores from effects!
        local sAbilityEffect = "INT"
        local nAbilityMod, nAbilityEffects = manager_effect5E.getEffectsBonus(rActor, sAbilityEffect, true)
        if (nAbilityMod ~= 0) then
            nScore = nAbilityMod
        end
        DB.setValue(nodeChar, "int_effect", "number", nScore)
    end

    return dbAbility
end
function updateWisdom(nodeChar)
    local rActor = ActorManager.resolveActor(nodeChar)
    local nScore = 0
    if rActor then
        -- adjust ability scores from effects!
        local sAbilityEffect = "WIS"
        local nAbilityMod, nAbilityEffects = manager_effect5E.getEffectsBonus(rActor, sAbilityEffect, true)
        if (nAbilityMod ~= 0) then
            nScore = nAbilityMod
        end
        DB.setValue(nodeChar, "wis_effect", "number", nScore)
    end

    return dbAbility
end

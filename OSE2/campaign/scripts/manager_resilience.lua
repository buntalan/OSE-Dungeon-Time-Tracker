function onUpdateSpellSaves(nodeChar)
local sRace = DB.getValue(nodeChar,"race_field","")
local nCon =DB.getValue(nodeChar,"con_score",0) + DB.getValue(nodeChar,"con_effect",0)

if nCon >= 18 then
nRes = 5
elseif nCon >= 15 then
nRes = 4
elseif nCon >=11 then
nRes = 3
elseif nCon >=7 then
nRes = 2
elseif nCon <=6 then
nRes = 0
end
local nSpellbase = DB.getValue(nodeChar,"spellsave_base",0)
local nDeath = DB.getValue(nodeChar,"dsave_score",0)
if StringManager.isWord(sRace, {"Halfling", "Dwarf", "Duergar", "Gargantua", "Goblin","Gnome"}) then
	if nSpellbase > 0 then
	DB.setValue(nodeChar,"ssave_score","number",(nSpellbase-nRes))
	end
else
DB.setValue(nodeChar,"poison","number",nDeath)
end



end
function onUpdatePoisonSaves(nodeChar)
local sRace = DB.getValue(nodeChar,"race_field","")
local nCon =DB.getValue(nodeChar,"con_score",0) + DB.getValue(nodeChar,"con_effect",0)

if nCon >= 18 then
nRes = 5
elseif nCon >= 15 then
nRes = 4
elseif nCon >=11 then
nRes = 3
elseif nCon >=7 then
nRes = 2
elseif nCon <=6 then
nRes = 0
end
local nDeath = DB.getValue(nodeChar,"dsave_score",0)


if StringManager.isWord(sRace, {"Halfling", "Dwarf", "Duergar", "Gargantua", "Goblin"}) then
DB.setValue(nodeChar,"poison","number",(nDeath-nRes))

else
DB.setValue(nodeChar,"poison","number",nDeath)
end
onUpdateWandSaves(nodeChar)

end
function onUpdateWandSaves(nodeChar)

local sRace = DB.getValue(nodeChar,"race_field","")
local nCon =DB.getValue(nodeChar,"con_score",0) + DB.getValue(nodeChar,"con_effect",0)
if nCon >= 18 then
nRes = 5
elseif nCon >= 15 then
nRes = 4
elseif nCon >=11 then
nRes = 3
elseif nCon >=7 then
nRes = 2
elseif nCon <=6 then
nRes = 0
end
local nWandBase = DB.getValue(nodeChar,"wsave_base",0)
local nDeath = DB.getValue(nodeChar,"dsave_score",0)

if StringManager.isWord(sRace, {"Halfling", "Dwarf", "Duergar", "Gargantua", "Goblin","Gnome"}) then
	if nWandBase >0 then
	DB.setValue(nodeChar,"wsave_score","number",(nWandBase -nRes))
	end
else
DB.setValue(nodeChar,"poison","number",nDeath)
end

onUpdateSpellSaves(nodeChar)
end
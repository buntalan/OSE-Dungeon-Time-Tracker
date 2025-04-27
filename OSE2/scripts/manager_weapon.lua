function CheckProficiency(nodeChar,sLabel)
local nBonuswep = 0
local nProficient = 0
local nProf =0
local nSpec =0
local nodeProficiency = DB.getChild(nodeChar,"proficiencylist")
local sClass = DB.getValue(nodeChar,"class_field",""):lower()

for k,v in pairs (DB.getChildren(nodeProficiency)) do

local sName = StringManager.trim(DB.getValue(v,"name","")):lower()

local sName =string.gsub(sName,'%W','')

local sLabel = StringManager.trim(sLabel):lower()
local sLabel =string.gsub(sLabel,'%W','')

if sLabel==sName then
nProf = DB.getValue(v,"proficient",0)
nSpec = DB.getValue(v,"hitadj",0)

break;
end

end
	if nProf == 0 then
if StringManager.isWord(sClass,{"fighter","barbarian", "knight","halfling","ranger","paladin","dwarf","elf", "half-elf", "svirfneblin"}) then
	nProficient = -2
elseif StringManager.isWord(sClass,{"thief","kineticist","acolyte","assassin","acrobat","bard","cleric","duergar", "half-orc"}) then
	nProficient = -3
elseif StringManager.isWord(sClass,{"druid", "mage","gnome","illusionist","magic user"}) then
	nProficient = -5
else
	nProficient = -3
end
	end	
local nBonuswep = nSpec + nProficient

return nBonuswep
end

function CheckSpecial(nodeChar,sLabel)

local nBonusdam = 0
local nSpec = 0
local nodeProficiency = DB.getChild(nodeChar,"proficiencylist")
local sClass = DB.getValue(nodeChar,"class_field",""):lower()

for k,v in pairs (DB.getChildren(nodeProficiency)) do

local sName = StringManager.trim(DB.getValue(v,"name","")):lower()

local sName =string.gsub(sName,'%W','')

local sLabel = StringManager.trim(sLabel):lower()
local sLabel =string.gsub(sLabel,'%W','')

		if string.find(sLabel, sName) then
		nSpec = DB.getValue(v,"dmgadj",0)
		break;
		end

end

local nBonusdam = nSpec 


return nBonusdam
end
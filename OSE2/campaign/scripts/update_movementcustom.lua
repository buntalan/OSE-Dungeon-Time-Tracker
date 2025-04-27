function updateMove()
local nodeChar = window.getDatabaseNode();


local nEquipped =DB.getValue(nodeChar,"nEquipenc",0)
local nCarry =DB.getValue(nodeChar,"nCarryenc",0) 
local nStr = DB.getValue(nodeChar,"attmod_score",0)
	local bIsAdvance = OptionsManager.isOption("BEMP_ENCTYPE", "Detailed");
	local bIsItemBased = OptionsManager.isOption("BEMP_ENCTYPE", "Item");
	local bIsDefault = (bIsAdvance);
local nNewmove = DB.getValue(nodeChar,"movement_base.score",120)
if bIsAdvance then

local nTotal = DB.getValue(nodeChar,"totalwt",0)



if nTotal <= 400 then
 nNewmove = nNewmove;
DB.setValue(nodeChar, "encumbstatus", "string", "Not Encumbered");
elseif nTotal <= 600 and nTotal >= 401 then
DB.setValue(nodeChar, "encumbstatus", "string", "Lightly Encumbered");
nNewmove = math.floor(nNewmove*.75)

elseif nTotal <= 800 and nTotal >= 601 then
DB.setValue(nodeChar, "encumbstatus", "string", "Moderately Encumbered");
nNewmove = math.floor(nNewmove*.5)

elseif  nTotal <= 1600 and nTotal >= 801 then
DB.setValue(nodeChar, "encumbstatus", "string", "Heavily Encumbered");
nNewmove = math.floor(nNewmove*.25)

elseif nTotal > 1600 then
DB.setValue(nodeChar, "encumbstatus", "string", "YOU CANT MOVE");
nNewmove = 0;

end


DB.setValue(nodeChar, "movement_base.total", "number", nNewmove);

elseif bIsItemBased then

local aMod = Module.getModuleInfo("OSE Carcass Crawler 02")

if aMod ~= nil then
		if  aMod.loaded then
		



					if (nCarry-nStr) <=10 and nEquipped <=3 then
					 nNewmove = nNewmove;

					DB.setValue(nodeChar, "encumbstatus", "string", "Not Encumbered");
					elseif (nCarry-nStr) <=12 and nEquipped <=5 then
					 nNewmove = math.floor(nNewmove*.75)

					DB.setValue(nodeChar, "encumbstatus", "string", "Lightly Encumbered");
					elseif (nCarry-nStr) <=14 and nEquipped <=7 then
					 nNewmove = math.floor(nNewmove*.5)

					DB.setValue(nodeChar, "encumbstatus", "string", "Moderately Encumbered");
					elseif (nCarry-nStr) <=16 and nEquipped <=9 then
					 nNewmove = math.floor(nNewmove*.25)

					DB.setValue(nodeChar, "encumbstatus", "string", "Heavily Encumbered");
					else
					nNewmove = 0;
					DB.setValue(nodeChar, "encumbstatus", "string", "YOU CANT MOVE");
					end
					

					
DB.setValue(nodeChar, "movement_base.total", "number", nNewmove);				
		else


		end
else
						
	
end		
else 
DB.setValue(nodeChar, "movement_base.total", "number", nNewmove);
DB.setValue(nodeChar, "encumbstatus", "string", "Not Encumbered");

end
end
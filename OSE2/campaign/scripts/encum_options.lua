function updateMove()
manager_char.CalcEnc(window.getDatabaseNode())

local nodeChar = window.getDatabaseNode();

local nEncur = window.encumbranceload.getValue();
local nGen = window.generalwt.getValue()
local nEquipped =DB.getValue(nodeChar,"nEquipenc",0)
local nCarry =DB.getValue(nodeChar,"nCarryenc",0) 
local nStr = DB.getValue(nodeChar,"attmod_score",0)
	local bIsAdvance = OptionsManager.isOption("BEMP_ENCTYPE", "Detailed");
	local bIsItemBased = OptionsManager.isOption("BEMP_ENCTYPE", "Item");
	local bIsDefault = (bIsAdvance);
local nNewmove = DB.getValue(nodeChar,"movement_base.score",120)

if bIsAdvance then
window.nEquipenc.setVisible(false)
window.nCarryenc.setVisible(false)
window.equipedgear.setVisible(false)
window.carriedgear.setVisible(false)
window.totalwt.setVisible(true)
window.generalwt.setVisible(true)
window.totalcoinlabel.setVisible(true)
window.genwtlabel.setVisible(true)
window.encumbranceload.setVisible(true)
window.encumbrance_label.setVisible(true)
local nTotal = nGen + nEncur
DB.setValue(nodeChar,"totalwt","number", nTotal)


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
		
window.totalwt.setVisible(false)
window.generalwt.setVisible(false)
window.totalcoinlabel.setVisible(false)
window.genwtlabel.setVisible(false)		
window.nEquipenc.setVisible(true)
window.nCarryenc.setVisible(true)
window.equipedgear.setVisible(true)
window.carriedgear.setVisible(true)	
window.encumbranceload.setVisible(false)		
window.encumbrance_label.setVisible(true)




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
window.totalwt.setVisible(false)
window.generalwt.setVisible(false)
window.totalcoinlabel.setVisible(false)
window.genwtlabel.setVisible(false)		
window.nEquipenc.setVisible(true)
window.nCarryenc.setVisible(true)
window.equipedgear.setVisible(true)
window.carriedgear.setVisible(true)	
window.encumbranceload.setVisible(false)		
window.encumbrance_label.setVisible(true)	
						local msg = 
								{
									font = "reference-b", 
									icon = "portrait_troll";
									text ="Please Load Carcass Crawler 2 to use Item Based Encumbrance" ;
								}
								Comm.deliverChatMessage(msg);
		end
else
window.totalwt.setVisible(false)
window.generalwt.setVisible(false)
window.totalcoinlabel.setVisible(false)
window.genwtlabel.setVisible(false)		
window.nEquipenc.setVisible(true)
window.nCarryenc.setVisible(true)
window.equipedgear.setVisible(true)
window.carriedgear.setVisible(true)	
window.encumbranceload.setVisible(false)		
window.encumbrance_label.setVisible(true)							
						local msg = 
								{
									font = "reference-b", 
									icon = "portrait_troll";
									text ="Item Based Encumbrance Requires the purchase of Carcass Crawler 2" ;
								}
								Comm.deliverChatMessage(msg);		
end		
else 

DB.setValue(nodeChar, "movement_base.total", "number", nNewmove);
DB.setValue(nodeChar, "encumbstatus", "string", "Not Encumbered");
window.totalwt.setVisible(false)
window.generalwt.setVisible(false)
window.totalcoinlabel.setVisible(false)
window.genwtlabel.setVisible(false)
window.encumbranceload.setVisible(false)
window.encumbrance_label.setVisible(false)
window.nEquipenc.setVisible(false)
window.nCarryenc.setVisible(false)
window.equipedgear.setVisible(false)
window.carriedgear.setVisible(false)
end
end


function updateflavortext()

local nodeChar = window.getDatabaseNode();
local nEquipped =DB.getValue(nodeChar,"nEquipenc",0)
local nCarry =DB.getValue(nodeChar,"nCarryenc",0) 
local nStr = DB.getValue(nodeChar,"attmod_score",0)
	local bIsAdvance = OptionsManager.isOption("BEMP_ENCTYPE", "Detailed");
	local bIsItemBased = OptionsManager.isOption("BEMP_ENCTYPE", "Item");
	local bIsDefault = (bIsAdvance);

if bIsItemBased then

local aMod = Module.getModuleInfo("OSE Carcass Crawler 02")

if aMod ~= nil then
		if  aMod.loaded then
		
local nNewmove = DB.getValue(nodeChar,"movement_base.total",120)

					if (nCarry-nStr) <=10 and nEquipped <=3 then
					local nNewmove = nNewmove
					DB.setValue(nodeChar, "movement_base.total", "number", nNewmove);
					DB.setValue(nodeChar, "encumbstatus", "string", "Not Encumbered");
					elseif (nCarry-nStr) <=12 and nEquipped <=5 then
					 nNewmove = math.floor(nNewmove*.75)
					DB.setValue(nodeChar, "movement_base.total", "number", nNewmove);
					DB.setValue(nodeChar, "encumbstatus", "string", "Lightly Encumbered");
					elseif (nCarry-nStr) <=14 and nEquipped <=7 then
					 nNewmove = math.floor(nNewmove*.5)
					DB.setValue(nodeChar, "movement_base.total", "number", nNewmove);
					DB.setValue(nodeChar, "encumbstatus", "string", "Moderately Encumbered");
					elseif (nCarry-nStr) <=16 and nEquipped <=9 then
					 nNewmove = math.floor(nNewmove*.25)
					DB.setValue(nodeChar, "movement_base.total", "number", nNewmove);
					DB.setValue(nodeChar, "encumbstatus", "string", "Heavily Encumbered");
					else
					DB.setValue(nodeChar, "movement_base.total", "number", 0);
					DB.setValue(nodeChar, "encumbstatus", "string", "YOU CANT MOVE");
					end		
		
end
end
end
end

function updateWeaponProf()


	local bIsAdvance = OptionsManager.isOption("BEMP_WEAPON", "Yes");
	local bIsBasic = OptionsManager.isOption("BEMP_WEAPON", "No");
	local bIsDefault = (bIsBasic);	
	
	if bIsAdvance then
wpnproflabel.setVisible(true)
namelabelwpnprof.setVisible(true)
proficiencylist.setVisible(true)
proficiencylist_iadd.setVisible(true)
proficiencylist_iedit.setVisible(true)
	elseif bIsBasic then
wpnproflabel.setVisible(false)
namelabelwpnprof.setVisible(false)
proficiencylist.setVisible(false)
proficiencylist_iadd.setVisible(false)
proficiencylist_iedit.setVisible(false)
	end
end



function setvis(nodeChar)

local nToggle1 = DB.getValue(nodeChar, "turnbox");
DB.setValue(nodeChar, "TURN","number", nToggle1);

local nToggle2 = DB.getValue(nodeChar, "foragebox");
DB.setValue(nodeChar, "FORAGE","number", nToggle2);

local nToggle3 = DB.getValue(nodeChar, "hidebox");
DB.setValue(nodeChar, "HIDE","number", nToggle3);

local nToggle4 = DB.getValue(nodeChar, "ctbox");
DB.setValue(nodeChar, "TRICKS","number", nToggle4);

local nToggle5 = DB.getValue(nodeChar, "huntbox");
DB.setValue(nodeChar, "HUNT","number", nToggle5);

local nToggle6 = DB.getValue(nodeChar, "stealthbox");
DB.setValue(nodeChar, "STEALTH","number", nToggle6);


end
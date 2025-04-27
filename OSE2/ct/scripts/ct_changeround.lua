function UpdateRoundData()

local nodeCT = window.getDatabaseNode();
	
local nLastround = window.lastround.getValue()
local nNewround = window.round.getValue()	
local nSecond = DB.getValue(nodeCT, "second",0)	
local nTime = 	nSecond+10*(nNewround -nLastround)

---DB.setValue(nodeCT,"second","number",nTime)

if nTime >=60 then
local nMinute = DB.getValue(nodeCT, "minute",0)	
local nNewMinute = math.floor(nTime/60) + nMinute

local nNewsecond = math.floor((((nTime/60)- math.floor(nTime/60))*60)+0.5)


local nRandom = DB.getValue(nodeCT,"randomenc",0)
local nTimetoRand = nRandom - math.floor(nTime/60)
			if nTimetoRand < 0 then
			nTimetoRand =0;
			end
			
DB.setValue(nodeCT, "randomenc","number",nTimetoRand);
DB.setValue(nodeCT, "minute","number",nNewMinute)		
DB.setValue(nodeCT, "second","number",nNewsecond);		
else
DB.setValue(nodeCT, "second","number",nSecond+10);
end
local nMinute = DB.getValue(nodeCT, "minute",0)	

if nMinute >=60 then
local nHour = DB.getValue(nodeCT,"hour",0)
local nNewHour = math.floor(nMinute/60) + nHour
DB.setValue(nodeCT, "hour","number",nNewHour)
local nNewminute = math.floor(((((nMinute/60)- math.floor(nMinute/60)))*60)+0.5)
DB.setValue(nodeCT, "minute","number",nNewminute);
else
end
local nHour = DB.getValue(nodeCT,"hour",0)
if nHour >=24 then
local nNewHour = nHour-24;
local nDay = DB.getValue(nodeCT,"day",0)
DB.setValue(nodeCT,"day","number",nDay+1)
DB.setValue(nodeCT,"hour","number",nNewHour)

end
DB.setValue(nodeCT, "lastround","number",(nNewround-1));	

	local bIsBasic = OptionsManager.isOption("BEMP_AUTOINIT", "Yes");
	local bIsIndividual = OptionsManager.isOption("BEMP_INITTYPE", "Individual");	
	
	if bIsBasic and bIsIndividual then
	
	local nodeList = DB.getChild(nodeCT,"list")
	for k,v in pairs(DB.getChildren(nodeList)) do

	local nInitBonus  = DB.getValue(v, "init_score", 0)
	local nInit = math.random(1,6)+nInitBonus

	DB.setValue(v, "initresult", "number",nInit);
	end
	
	end


end
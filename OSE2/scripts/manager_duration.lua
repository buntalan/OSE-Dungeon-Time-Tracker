function sumDuration(sDuration,nodeChar)

if sDuration == nil then
return false
end

    local nLevel = 1;
    local nTotal=0;
	local aDurations = StringManager.parseWords(sDuration)
    local nMulti = getDurationMultiplier(sDuration) or 0;
    local nTime = tonumber(string.match(sDuration, ("%d+"))) or 0; 

		if aDurations[3] then
		 nLevel = DB.getValue(nodeChar, "Level_new", 1);
		end   

local nTotal = nMulti * nLevel*nTime

return nTotal;
end

--Converts common time units to OSE rounds.

function getDurationMultiplier(sDuration)
    local _,_,sMulti = string.find(sDuration,"(ro?u?n?ds?)");

    if sMulti then return 1; end

    _,_,sMulti = string.find(sDuration,"(minu?t?e?s?)");
    if sMulti then return 6; end

    _,_,sMulti = string.find(sDuration,"(ho?u?rs?)");
    if sMulti then return 360; end

    _,_,sMulti = string.find(sDuration,"(turns?)");
    if sMulti then return 60; end
    
    return 0;
end

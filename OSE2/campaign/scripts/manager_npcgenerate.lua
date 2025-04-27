function generatenpc (nodeNpc)

local sStatblock = string.gsub((DB.getValue(nodeNpc, "gen_npc", "")), ",", "");
local sStatgen = DB.getValue(nodeNpc, "gen_npc", "")
local sStatblock = string.gsub(sStatblock, "x","");

local sText = DB.getValue(nodeNpc, "zzdescription_text", "");

DB.setValue(nodeNpc, "notes","formattedtext", sStatgen.."/n<p>" .. sText .. "</p>");

local rString = StringManager.parseWords(sStatblock);


local nCount = 0
		for k,v in pairs (rString) do

		nCount = nCount +1;

			if v == "AC" then
			local sValue = rString[nCount+1]
			local nValue = tonumber(sValue);

			DB.setValue(nodeNpc, "armor_class", "number", nValue);

			elseif v == "HD" then

			local sValue = string.match((rString[nCount+1]),"%d+");
			local nValue = tonumber(sValue);
			DB.setValue(nodeNpc, "hd_current", "number", nValue);
			local sValue = string.match((rString[nCount+1]), "%+(.*)");

			DB.setValue(nodeNpc, "bonushd", "string", sValue);


			elseif v == "THAC0" then

			local sValue =  rString[nCount+1]
			local nValue = tonumber(sValue);


			DB.setValue(nodeNpc, "thaco", "number", nValue);

			elseif v == "MV" then

				if rString[nCount+3] ~= "SV" then

			local sValue = rString[nCount+1].."'".."("..rString[nCount+2].."')/ "..rString[nCount+3].."'".."("..rString[nCount+4].."') "..rString[nCount+5];
			DB.setValue(nodeNpc, "movement_str", "string", sValue);

				else
			local sValue = rString[nCount+1].."'".."("..rString[nCount+2].."')";
			DB.setValue(nodeNpc, "movement_str", "string", sValue);

				end

			elseif v == "SV" then

			local sValue = string.match(rString[nCount+1], "%d+");
			local nValue = tonumber(sValue);
			DB.setValue(nodeNpc, "dsave_score", "number", nValue);
			local sValue = string.match(rString[nCount+2], "%d+");
			local nValue = tonumber(sValue);
			DB.setValue(nodeNpc, "wsave_score", "number", nValue);
			local sValue = string.match(rString[nCount+3], "%d+");
			local nValue = tonumber(sValue);
			DB.setValue(nodeNpc, "psave_score", "number", nValue);
			local sValue = string.match(rString[nCount+4], "%d+");
			local nValue = tonumber(sValue);
			DB.setValue(nodeNpc, "bsave_score", "number", nValue);
			local sValue = string.match(rString[nCount+5], "%d+");
			local nValue = tonumber(sValue);
			DB.setValue(nodeNpc, "ssave_score", "number", nValue);

			elseif v == "AL" then

			local sValue = string.gsub(rString[nCount+1],",","");


			DB.setValue(nodeNpc, "alignment_dropdown", "string", sValue);

			elseif v == "XP" then

			local sValue = string.gsub(rString[nCount+1],",","");
			local nValue = tonumber(sValue);

			DB.setValue(nodeNpc, "XP_field", "number", nValue);

			elseif v == "NA" then

			local sValue = string.gsub(rString[nCount+1],",","");

			DB.setValue(nodeNpc, "numappear", "string", sValue.."("..rString[nCount+2]..")");


			elseif v == "TT" then

			local sValue = string.gsub(rString[nCount+1],",","");

			DB.setValue(nodeNpc, "Treasure_type", "string", sValue);

			elseif v == "ML" then

			local sValue = string.gsub(rString[nCount+1],",","");

			local nValue = tonumber(sValue);

			DB.setValue(nodeNpc, "morale_npc", "number", nValue);


			elseif v == "Att" then

					local nodeWeapon = DB.createChild(nodeNpc,"weaponslist");

					local sValue1 = rString[nCount+1];
					local sValue2 = rString[nCount+2];
					local nodeWeapons = DB.createChild(nodeWeapon);
					DB.setValue(nodeWeapons, "name","string", sValue1.." x "..sValue2);
					local sValue3 = rString[nCount+3];
					DB.setValue(nodeWeapons, "Damagedie","string", sValue3);

					if rString[nCount+4] == "THACO" or rString[nCount+4] == "or" then
					else
					local nodeWeapon = DB.createChild(nodeNpc,"weaponslist");
					local sValue1 = rString[nCount+4];
					local sValue2 = rString[nCount+5];
					local nodeWeapons = DB.createChild(nodeWeapon);
					DB.setValue(nodeWeapons, "name","string", sValue1.." x "..sValue2);
					local sValue3 = rString[nCount+6];
					DB.setValue(nodeWeapons, "Damagedie","string", sValue3);
					end


			elseif v == "or" then

					local nodeWeapon = DB.createChild(nodeNpc,"weaponslist");
					local sValue1 = rString[nCount+1];
					local sValue2 = rString[nCount+2];
					local nodeWeapons = DB.createChild(nodeWeapon);
							if sValue2 ~= "THAC0" then
							DB.setValue(nodeWeapons, "name","string", sValue1.." x "..sValue2);
							local sValue3 = rString[nCount+3];
								if sValue3 ~= "THAC0" then
								DB.setValue(nodeWeapons, "Damagedie","string", sValue3);
								end
							else
							DB.setValue(nodeWeapons, "name","string", sValue1);
							end


			end

		end
DB.setValue(nodeNpc, "zzdescription_text", "formattedtext", "<p></p>");
DB.setValue(nodeNpc, "gen_npc", "string", "");

end
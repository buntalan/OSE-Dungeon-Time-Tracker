function getpcdata(nodeNpc)




		local sName = DB.getValue(nodeNpc, "name", "");
		local nAc = tonumber(DB.getValue(nodeNpc, "ac_current", 9));
		local sSize = "Medium";
		local Text = DB.getValue(nodeNpc, "text", " ");

		local nXp = tonumber(DB.getValue(nodeNpc, "xp", 0));	
		local Token = DB.getValue(nodeNpc, "token");

		local nThaco = DB.getValue(nodeNpc, "thaco", 0);
		local sTreasure = DB.getValue(nodeNpc, "treasure", "U");
		local sMove = DB.getValue(nodeNpc, "en_score", "30");		
		local nMorale = 12;	
		local nHp = DB.getValue(nodeNpc, "maxhp_combat", 0);	
		local nDamage = DB.getValue(nodeNpc, "damage", 0);
		local sHd = DB.getValue(nodeNpc, "Level_new", 1);
		local sAlign = DB.getValue(nodeNpc, "alignment_dropdown", "");
		local sNumapp = DB.getValue(nodeNpc, "numberappearing", "1");

local nodeNPC = DB.findNode("npc")


if nodeNPC then
else
msg ={
text="Open NPCs from the sidebar"
}

Comm.deliverChatMessage(msg)
return false

end

local sPath = DB.getPath(DB.createChild(nodeNPC));
local NodeOSEnpc = DB.findNode(sPath);

		DB.setValue(NodeOSEnpc, "name","string",sName) 	
		DB.setValue(NodeOSEnpc, "size","string",sSize) 	
		DB.setValue(NodeOSEnpc, "Treasure_type","string",sTreasure) 	
		DB.setValue(NodeOSEnpc,"notes", "formattedtext", "<p>\n" ..Text.. "</p>"); 	
		DB.setValue(NodeOSEnpc, "thaco","number",nThaco) 
		DB.setValue(NodeOSEnpc, "movement_str","string",sMove) 	
		DB.setValue(NodeOSEnpc, "armor_class","number",nAc) 
		DB.setValue(NodeOSEnpc, "morale_npc","number",nMorale) 
		DB.setValue(NodeOSEnpc, "XP_field","number",nXp) 
		DB.setValue(NodeOSEnpc, "hp_current","number",nHp)
		DB.setValue(NodeOSEnpc, "token","token",Token)
		
 
		DB.setValue(NodeOSEnpc, "alignment_dropdown","string",sAlign) 	

			
		
		DB.setValue(NodeOSEnpc, "numappear","string",sNumapp) 	
		
		
		local nHdonly =tonumber(string.match(sHd,"%d+"));
		local sHDbon =tonumber(string.match(sHd,"%+(.*)")) or 0;

		DB.setValue(NodeOSEnpc, "bonushd","string",sHDbon)
		DB.setValue(NodeOSEnpc, "hd_current","number",nHdonly)
		
local Save_Matrix = {};                            
                            table.insert(Save_Matrix,{12,13,14,15,16});
                            table.insert(Save_Matrix,{12,13,14,15,16});
                            table.insert(Save_Matrix,{12,13,14,15,16});
                            table.insert(Save_Matrix,{10,11,12,13,14});
                            table.insert(Save_Matrix,{10,11,12,13,14});
                            table.insert(Save_Matrix,{10,11,12,13,14});
                            table.insert(Save_Matrix,{8,9,10,10,12});
                            table.insert(Save_Matrix,{8,9,10,10,12});
                            table.insert(Save_Matrix,{8,9,10,10,12});
                            table.insert(Save_Matrix,{6,7,8,8,10});
                            table.insert(Save_Matrix,{6,7,8,8,10});
                            table.insert(Save_Matrix,{6,7,8,8,10});
							table.insert(Save_Matrix,{4,5,6,5,8});
                            table.insert(Save_Matrix,{4,5,6,5,8});
							table.insert(Save_Matrix,{4,5,6,5,8});		
                            table.insert(Save_Matrix,{2,3,4,3,6});
                            table.insert(Save_Matrix,{2,3,4,3,6});
                            table.insert(Save_Matrix,{2,3,4,3,6});
                            table.insert(Save_Matrix,{2,2,2,2,4}); 
                            table.insert(Save_Matrix,{2,2,2,2,4});
                            table.insert(Save_Matrix,{2,2,2,2,4}); 
                            table.insert(Save_Matrix,{2,2,2,2,2});
                            table.insert(Save_Matrix,{2,2,2,2,2});
                            table.insert(Save_Matrix,{2,2,2,2,2});                            
                            table.insert(Save_Matrix,{2,2,2,2,2});
                            table.insert(Save_Matrix,{2,2,2,2,2});
                            table.insert(Save_Matrix,{2,2,2,2,2});
                            table.insert(Save_Matrix,{2,2,2,2,2});
                            
                            if nHdonly <= 0 then
                            
                            nHdonly = 1
                          
                            
                            
                            end
                            
                                                                                                                                            
local nD = Save_Matrix [nHdonly][1];
local nP = Save_Matrix [nHdonly][2];
local nB = Save_Matrix [nHdonly][3];
local nW = Save_Matrix [nHdonly][4];
local nS = Save_Matrix [nHdonly][5];     


		DB.setValue(NodeOSEnpc, "dsave_score","number",nD)
		DB.setValue(NodeOSEnpc, "psave_score","number",nP)
		DB.setValue(NodeOSEnpc, "bsave_score","number",nB)
		DB.setValue(NodeOSEnpc, "wsave_score","number",nW)
		DB.setValue(NodeOSEnpc, "ssave_score","number",nS)			
		
		
		
		local NodeWeaponNpc = DB.getChild(nodeNpc,"inventorylist");
		local nCount = 0;
		
				for k,v in pairs (DB.getChildren(NodeWeaponNpc)) do
				
					if DB.getValue(v,"type"):lower() == "weapon" then

						
							nCount = nCount +1;
							local nAtkbon = DB.getValue(v, "atk_roll",0);
							local sDie =StringManager.convertDiceToString(DB.getValue(v, "Damagedie", {}));
							local sName = DB.getValue(v, "name","");

							local nodeWeaponOSE = DB.createChild(NodeOSEnpc,"weaponslist");
							local nodeWeapons = DB.createChild(nodeWeaponOSE);
							DB.setValue(nodeWeapons, "name","string", sName); 
							DB.setValue(nodeWeapons, "Damagedie","string", sDie); 
							DB.setValue(nodeWeapons, "atk_roll","number", nAtkbon); 
								
					end		

				
				end
	
Interface.openWindow("npc",NodeOSEnpc)
end
-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

WEAPON_TYPE_RANGED = "Ranged";

WEAPON_PROP_AMMUNITION = "ammunition";

WEAPON_PROP_MAGIC = "magic";
WEAPON_PROP_REACH = "reach";
WEAPON_PROP_THROWN = "thrown";
WEAPON_PROP_SILVER="silver"
function onInit()
	DB.addHandler("charsheet.*.inventorylist.*.isidentified", "onUpdate", onItemIDChanged);
end

--
--	Weapon inventory management
--
function isWeapon(nodeItem)
	local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
	local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();


	local bIsWeapon = ((StringManager.isWord(sTypeLower,{"weapon","magic weapon"})) and (sSubtypeLower ~= "ammunition"));
	return bIsWeapon;
end

function addToWeaponDB(nodeItem)

	-- Parameter validation
	if not isWeapon(nodeItem) then
		return;
	end
	
	-- Get the weapon list we are going to add to
	local nodeChar = DB.getChild(nodeItem, "...");
	local nodeWeapons = DB.createChild(nodeChar, "weaponlist");
	if not nodeWeapons then
		return;
	end
	
	-- Set new weapons as equipped


	-- Determine identification
	local nItemID = 0;
	if LibraryData.getIDState("item", nodeItem, true) then
		nItemID = 1;
	end
	
	-- Grab some information from the source node to populate the new weapon entries
	local sName;
	if nItemID == 1 then
		sName = DB.getValue(nodeItem, "name", "");
	else
		sName = DB.getValue(nodeItem, "nonid_name", "");
		if sName == "" then
			sName = Interface.getString("item_unidentified");
		end
		sName = "** " .. sName .. " **";
	end
	local nBonus = 0;
	if nItemID == 1 then
		nBonus = DB.getValue(nodeItem, "bonus", 0);
	end

	-- Handle special weapon properties damage types
	local sProps = DB.getValue(nodeItem, "properties", "");
	--sett thrown to false leaving it in there just in case
	local bThrown = False;

	local sType = DB.getValue(nodeItem, "type_select", ""):lower();
	local bMelee = true;
	local bRanged = false;

	if sType:find(WEAPON_TYPE_RANGED) then
		bMelee = false;
		bRanged = true;
	end
	
	-- Parse damage field
	local sDamage = DB.getValue(nodeItem, "Damagedies", "")
	
	
	-- Create weapon entries

		local nodeWeapon = DB.createChild(nodeWeapons);
		if nodeWeapon then
			DB.setValue(nodeWeapon, "shortcut", "windowreference", "item", "....inventorylist." .. DB.getName(nodeItem));
			
			local sAttackAbility = "";
			local sDamageAbility = "base";
			
			DB.setValue(nodeWeapon, "name", "string", sName);
			DB.setValue(nodeWeapon, "atk_roll", "number",  DB.getValue(nodeItem, "atk_roll", 0));
			DB.setValue(nodeWeapon, "Damagedies", "string",  sDamage);
			DB.setValue(nodeWeapon, "versatile_damage", "string",  DB.getValue(nodeItem, "versatile_damage", ""));
			
			if bMelee then nAttackType =1 else nAttackType = 2 end
			
			DB.setValue(nodeWeapon, "Attk_cycler", "string",  tostring(nAttackType));
			DB.setValue(nodeWeapon, "properties", "string", sProps);


			

		end

	DB.setValue(nodeItem, "carried", "number", 2);
end

function removeFromWeaponDB(nodeItem)

	if not nodeItem then
		return false;
	end
	
	-- Check to see if any of the weapon nodes linked to this item node should be deleted
	local sItemNode = DB.getPath(nodeItem);
	local sItemNode2 = "....inventorylist." .. DB.getName(nodeItem);
	local bFound = false;
	for _,v in ipairs(DB.getChildList(nodeItem, "...weaponlist")) do
		local sClass, sRecord = DB.getValue(v, "shortcut", "", "");
		if sRecord == sItemNode or sRecord == sItemNode2 then
			bFound = true;
			DB.deleteNode(v);
		end
	end

	return bFound;
end

--
--	Identification handling
--

function onItemIDChanged(nodeItemID)
	local nodeItem = DB.getChild(nodeItemID, "..");
	local nodeChar = DB.getChild(nodeItemID, "....");
	
	local sPath = DB.getPath(nodeItem);
	for _,vWeapon in ipairs(DB.getChildList(nodeChar, "weaponlist")) do
		local _,sRecord = DB.getValue(vWeapon, "shortcut", "", "");
		if sRecord == sPath then
			--checkWeaponIDChange(vWeapon);
		end
	end
end

function checkWeaponIDChange(nodeWeapon)
	local _,sRecord = DB.getValue(nodeWeapon, "shortcut", "", "");
	if sRecord == "" then
		return;
	end
	local nodeItem = DB.findNode(sRecord);
	if not nodeItem then
		return;
	end
	
	local bItemID = LibraryData.getIDState("item", DB.findNode(sRecord), true);
	local bWeaponID = (DB.getValue(nodeWeapon, "isidentified", 1) == 1);
	if bItemID == bWeaponID then
		return;
	end
	
	local sName;
	if bItemID then
		sName = DB.getValue(nodeItem, "name", "");
	else
		sName = DB.getValue(nodeItem, "nonid_name", "");
		if sName == "" then
			sName = Interface.getString("item_unidentified");
		end
		sName = "** " .. sName .. " **";
	end
	DB.setValue(nodeWeapon, "name", "string", sName);
	
	local nBonus = 0;

	
	if bItemID then
		DB.setValue(nodeWeapon, "isidentified", "number", 1);
	else
		DB.setValue(nodeWeapon, "isidentified", "number", 0);
	end
end



function onInit()
LibraryData.overrideRecordTypes(aRecordOverrides);
LibraryData.setRecordViews(aListViews);
--LibraryData.setRecordTypeInfo("vehicle", nil);
CombatListManager.setEnabled(true)
end


aRecordOverrides = {

["race"] = {
bExport = true,
aDataMap = { "race", "reference.race" },

sRecordDisplayClass = "race",
},

["magic"] = {
bExport = true,
aDataMap = { "magic", "reference.spells" },

sRecordDisplayClass = "spells",
		aCustomFilters = {
      ["Type"] = { sField = "class_cycler" },
      ["Level"] = { sField = "spelllevel" },
			
},
},

["class"] = {
bExport = true,
aDataMap = { "class", "reference.class" },
sRecordDisplayClass = "class",
},
["skills"] = {
bExport = true,
aDataMap = { "skills", "reference.skills" },
sRecordDisplayClass = "skills",
},

["item"] = {
		bExport = true,
		bID = true,
		aDataMap = { "item", "reference.equipmentdata", "reference.magicitemdata" }, 
		aGMListButtons = { "button_item_armor", "button_item_weapon", "button_item_shield"  },
		aPlayerListButtons = { "button_item_armor", "button_item_weapon", "button_item_shield"  },
		fRecordDisplayClass = getItemRecordDisplayClass,
		aRecordDisplayClasses = { "item", "reference_magicitem", "reference_armor", "reference_weapon", "reference_equipment","reference_shield"},
		aCustomFilters = {
      ["Type"] = { sField = "type" },
      ["Sub-Type"] = { sField = "subtype" },
			
},
},
};

aListViews = {

	["item"] = {
	
		["shield"] = {
					sTitleRes = "item_button_shield",
			aColumns = {
				{ sName = "name", sType = "string", sHeading = "Name", nWidth=150 },
				{ sName = "cost", sType = "string", sHeading = "Cost", nWidth=80 , bCentered=true },
				{ sName = "weight", sType = "number", sHeading = "Weight", nWidth=100, bCentered=true },
			},
			aFilters = {{ sDBField = "type", vFilterValue = "Shield"  }},
			aGroups = {{ sDBField = "subtype" } },
			aGroupValueOrder = { "Std. Equipment","Shield", "Magic" },
		},	
	
	
		["armor"] = {
					sTitleRes = "item_button_armor",
			aColumns = {
				{ sName = "name", sType = "string", sHeading = "Name", nWidth=150 },
				{ sName = "cost", sType = "string", sHeading = "Cost", nWidth=80 , bCentered=true },
				{ sName = "weight", sType = "number", sHeading = "Weight", nWidth=100, bCentered=true },
			},
			aFilters = {{ sDBField = "type", vFilterValue = "Armor"  }},
			aGroups = { {sDBField = "subtype" } },
			aGroupValueOrder = {"Std. Equipment","Shield", "Magic"  },
		},
		["weapon"] = {
					sTitleRes = "item_button_weapon",
			aColumns = {
				{ sName = "name", sType = "string", sHeading = "Name", nWidth=150 },
				{ sName = "cost", sType = "string", sHeading = "Cost", nWidth=80 , bCentered=true },
				{ sName = "weight", sType = "number", sHeading = "Weight", nWidth=100, bCentered=true },
			},
			aFilters = {{ sDBField = "type", vFilterValue = "Weapon"  }},
			aGroups = { {sDBField = "subtype" } },
			aGroupValueOrder = {"Std. Equipment","Weapon", "Magic"  },
			},
},
}
function getItemRecordDisplayClass(vNode)

	local sRecordDisplayClass = "item";
	if vNode then
		local sBasePath, sSecondPath = UtilityManager.getDataBaseNodePathSplit(vNode);

		if sBasePath == "reference" then
			if sSecondPath == "equipmentdata" then
				local sTypeLower = StringManager.trim(DB.getValue(DB.getPath(vNode, "type"), ""):lower());
				if sTypeLower == "weapon" then
					sRecordDisplayClass = "reference_weapon";
				elseif sTypeLower == "armor" then
					sRecordDisplayClass = "reference_armor";
				elseif sTypeLower == "shield" then
					sRecordDisplayClass = "reference_shield";
				else
					sRecordDisplayClass = "reference_equipment";
				end
			else
				sRecordDisplayClass = "reference_magicitem";
			end
		end
	end
	return sRecordDisplayClass;
end

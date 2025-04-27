-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	super.onInit();
	onHealthChanged();
end

function onFactionChanged()
	super.onFactionChanged();
	updateHealthDisplay();
end
function onActiveChanged()
	super.onActiveChanged();
	
	local sClass = link.getValue();
	local sRecordType = LibraryData.getRecordTypeFromDisplayClass(sClass);
	if (sRecordType == "vehicle") and name.isVisible() then
		sub_active.setValue("client_ct_section_active_vehicle", getDatabaseNode());
		sub_active.setVisible(true);
	else
		sub_active.setValue("", "");
		sub_active.setVisible(false);
	end
end
function onIDChanged()
	super.onIDChanged();
	
	self.onActiveChanged();
end
function onHealthChanged()
	local rActor = ActorManager.resolveActor(getDatabaseNode())
	local sColor = ActorHealthManager.getHealthColor(rActor);
	
	wounds.setColor(sColor);
	status.setColor(sColor);
end

function updateHealthDisplay()
	local sOption;
	if friendfoe.getStringValue() == "friend" then
		sOption = OptionsManager.getOption("SHPC");
	else
		sOption = OptionsManager.getOption("SHNPC");
	end
	
	local nodeRecord = getDatabaseNode();
	local sClass = DB.getValue(nodeRecord, "link", "npc", "");
	if sClass == "npc" then
		local bID = LibraryData.getIDState("npc", nodeRecord, true);
		name.setVisible(bID);
		nonid_name.setVisible(not bID);
		hp_current.setVisible(false);
		temp_hp.setVisible(false);
		wounds.setVisible(false);
		status.setVisible(true);
	else
		hp_current.setVisible(true);
		temp_hp.setVisible(true);
		name.setVisible(true);
		nonid_name.setVisible(false);
		status.setVisible(false);
		wounds.setVisible(true);
	end
end

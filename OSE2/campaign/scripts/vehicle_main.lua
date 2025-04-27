-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()

	update();
end

function VisDataCleared()
	self.update();
end

function InvisDataAdded()
	self.update();
end


function update()

	if Session.IsHost then
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local sTypeLower = StringManager.trim(DB.getValue(nodeRecord, "type", "")):lower();
		

	local bSection1 = false;

	WindowManager.callSafeControlUpdate(self,"type", bReadOnly);
	WindowManager.callSafeControlUpdate(self,"size", bReadOnly);

	WindowManager.callSafeControlUpdate(self,"crew", bReadOnly);
	WindowManager.callSafeControlUpdate(self,"cost", bReadOnly);
	WindowManager.callSafeControlUpdate(self,"movement", bReadOnly);


		if sTypeLower =="water vessels" then
			type_lists.setValue("watervessel", nodeRecord);
		elseif StringManager.isWord(sTypeLower,{"air ships","air ship"}) then
			type_lists.setValue("airship", nodeRecord);
		elseif sTypeLower =="land vehicles" then
			type_lists.setValue("landvehicle", nodeRecord);	
		elseif sTypeLower =="siege vehicles" then
			type_lists.setValue("siegevehicle", nodeRecord);	
		else
			type_lists.setValue("", "");
		end	
	end
	type_lists.update(bReadOnly);
end

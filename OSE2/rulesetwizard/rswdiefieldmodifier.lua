local modifierWidget = nil;
local modifierFieldNode = nil;

function getModifier()
	if not modifierFieldNode then
		return 0;
	end
	
	return DB.getValue(modifierFieldNode);
end

function setModifier(value)
	if modifierFieldNode then
        DB.setValue(modifierFieldNode, "", "number", value);
	end
end

function setModifierDisplay(value)
	if value > 0 then
		modifierWidget.setText("+" .. value);
	else
		modifierWidget.setText(value);
	end
	
	if value == 0 then
		modifierWidget.setVisible(false);
	else
		modifierWidget.setVisible(true);
	end
end

function updateModifier(source)
	if modifierFieldNode then
		setModifierDisplay(DB.getValue(modifierFieldNode));
	end
end

function onInit()
	local lwidgetposition = "topright";
	if widgetposition then
		lwidgetposition = widgetposition[1];
	end

	modifierWidget = addTextWidget("sheetlabelmini", "0");
	modifierWidget.setFrame("tempmodmini", 3, 1, 6, 3);
	modifierWidget.setPosition(lwidgetposition, 0, 0);
	modifierWidget.setVisible(false);

	-- By default, the modifier is in a field named based on the parent control.
	local modifierFieldName = getName() .. "modifier";
	if modifierfield then
		-- Use a <modifierfield> override
		modifierFieldName = modifierfield[1];
	end

	local dbnode = getDatabaseNode();
    if dbnode then
		modifierFieldNode = DB.createChild(DB.getParent(dbnode), modifierFieldName, "number");
		if modifierFieldNode then
			DB.addHandler(modifierFieldNode, "onUpdate", updateModifier);
			updateModifier(modifierFieldNode);
		end
    end
end

function onWheel(notches)
	if not Input.isControlPressed() then
		return false;
	end

	setModifier(getModifier() + notches);
	return true;
end
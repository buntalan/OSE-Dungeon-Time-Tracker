function onInit()
	update();
end

function VisDataCleared()
	update();
end

function InvisDataAdded()
	update();
end

function updateControl(sControl, bReadOnly, bForceHide)
	if not self[sControl] then
		return false;
	end
		
	return self[sControl].update(bReadOnly, bForceHide);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
            
            class_cycler.setReadOnly(bReadOnly);
            duration.setReadOnly(bReadOnly);
            spells_die.setReadOnly(bReadOnly);
            spelldescription_text.setReadOnly(bReadOnly);
            range.setReadOnly(bReadOnly);
            Spelluse_type.setReadOnly(bReadOnly);
            level_field.setReadOnly(bReadOnly);
            spelllevel.setReadOnly(bReadOnly);
            modifier.setReadOnly(bReadOnly);
            onsave_cycler.setReadOnly(bReadOnly);
            save_type.setReadOnly(bReadOnly);
            numbertoroll.setReadOnly(bReadOnly);
            properties.setReadOnly(bReadOnly);

	
	
end

 
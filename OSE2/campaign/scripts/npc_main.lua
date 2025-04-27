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
	local bID = LibraryData.getIDState("npc", nodeRecord);
	local bVis = true

	if bReadOnly then
	bVis = false
	end


	space.setReadOnly(bReadOnly);
	movement_str.setReadOnly(bReadOnly);
	size.setReadOnly(bReadOnly);
	armor_class.setReadOnly(bReadOnly);
	thaco.setReadOnly(bReadOnly);
	movement_field.setReadOnly(bReadOnly);
	hd_current.setReadOnly(bReadOnly);
    dsave_score.setReadOnly(bReadOnly);
	wsave_score.setReadOnly(bReadOnly);
	psave_score.setReadOnly(bReadOnly);
	bsave_score.setReadOnly(bReadOnly);
	ssave_score.setReadOnly(bReadOnly);
	morale_npc.setReadOnly(bReadOnly);
	numappear.setReadOnly(bReadOnly);
	Treasure_type.setReadOnly(bReadOnly);
	alignment_dropdown.setReadOnly(bReadOnly);
	hp_current.setReadOnly(bReadOnly);
	bonushd.setReadOnly(bReadOnly);
	nonid_name.setReadOnly(bReadOnly);
	XP_field.setReadOnly(bReadOnly);
	tags.setReadOnly(bReadOnly);
	specHD.setReadOnly(bReadOnly);
    for _,w in ipairs(weaponslist.getWindows()) do
        w.name.setReadOnly(bReadOnly);
        w.Damagedie.setReadOnly(bReadOnly);
        w.type_select.setReadOnly(bReadOnly);
        w.atk_roll.setReadOnly(bReadOnly);
        w.properties.setReadOnly(bReadOnly);
        w.andoroperator.setReadOnly(bReadOnly);
    end




end
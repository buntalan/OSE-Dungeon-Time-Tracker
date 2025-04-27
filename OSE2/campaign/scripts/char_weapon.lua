function onInit()
	local nodeWeapon = getDatabaseNode();
	DB.addHandler(nodeWeapon, "onChildUpdate", onDataChanged);

	onDataChanged();
end

function onClose()
	local nodeWeapon = getDatabaseNode();
	DB.removeHandler(nodeWeapon, "onChildUpdate", onDataChanged);

end

function onLinkChanged()
	local node = getDatabaseNode();
	local sClass, sRecord = DB.getValue(node, "shortcut", "", "");
	if sClass ~= m_sClass or sRecord ~= m_sRecord then
		m_sClass = sClass;
		m_sRecord = sRecord;

		local sInvList = DB.getPath(DB.getChild(node, "..."), "inventorylist") .. ".";
		if sRecord:sub(1, #sInvList) == sInvList then
			carried.setLink(DB.findNode(DB.getPath(sRecord, "carried")));
		end
	end
end

function onDataChanged()
	onLinkChanged();
end
function onInit()
	onNameUpdated();
end

function onLockChanged()


local nodeClass = getDatabaseNode();
DB.setValue(nodeClass, "locked_status", "number", 1)
DB.setValue(nodeClass, "locked_status", "number", 2)

				local nodeRecord = getDatabaseNode();

				local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
				name.setReadOnly(bReadOnly);


end
function onNameUpdated()

	local nodeRecord = getDatabaseNode();

	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
				name.setReadOnly(bReadOnly);


local nodeClass = getDatabaseNode();
DB.setValue(nodeClass, "locked_status", "number", 1)
DB.setValue(nodeClass, "locked_status", "number", 2)



end
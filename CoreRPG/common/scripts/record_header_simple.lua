--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	self.update();
	Debug.console("record_header_simple - DEPRECATED - 2024-03-05 - Use record_header instead");
	ChatManager.SystemMessage("record_header_simple - DEPRECATED - 2024-03 - Contact ruleset/extension/forge author");
end

function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
	name.setReadOnly(bReadOnly);
end

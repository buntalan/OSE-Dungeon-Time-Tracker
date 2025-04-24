--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onHover(bHover)
	setUnderline(bHover, -1);
end
function onClickDown()
	return true;
end
function onClickRelease()
	window.link.activate();
	return true;
end
function onDragStart(_, _, _, draginfo)
	draginfo.setType("shortcut");
	draginfo.setIcon("button_link");
	local sClass, sRecord = window.link.getValue();
	draginfo.setShortcutData(sClass, sRecord);
	draginfo.setDescription(getValue());
	return true;
end

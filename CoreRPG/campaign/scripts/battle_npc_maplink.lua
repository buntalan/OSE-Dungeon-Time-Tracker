--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	self.checkLink();
end
function onClose()
	self.deleteLink();
end

function tokenDeleted()
	imageid.setValue(0);
end
function tokenMoved(tokenLinked)
	local x,y = tokenLinked.getPosition();
	imagex.setValue(x);
	imagey.setValue(y);
end

function deleteLink()
	if imageid.getValue() ~= 0 then
		local _, sRecord = imageref.getValue();
		local tokenLinked = Token.getToken(sRecord, imageid.getValue());
		if tokenLinked then
			tokenLinked.delete();
		end
	end
end
function checkLink()
	local _, sRecord = imageref.getValue();
	if sRecord == "" then
		token.setVisible(true);
		linked.setVisible(false);
	else
		token.setVisible(false);
		linked.setVisible(true);
	end
end
function setLink(tokenLinked)
	if tokenLinked then
		local nodeContainer = tokenLinked.getContainerNode();
		if nodeContainer then
			imageref.setValue("imagewindow", DB.getPath(nodeContainer));
			imageid.setValue(tokenLinked.getId());
			local x,y = tokenLinked.getPosition();
			imagex.setValue(x);
			imagey.setValue(y);

			tokenLinked.onDelete = self.tokenDeleted;
			tokenLinked.onMove = self.tokenMoved;
		end
	end
	self.checkLink();
end
function clearLink()
	self.deleteLink();
	imageref.setValue("", "");
	imageid.setValue(0);
	self.checkLink();
end

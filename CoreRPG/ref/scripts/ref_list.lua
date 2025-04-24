--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

--luacheck: globals altfilter

local sFilter = "filter";
local sFilterValue = "";

function onInit()
	if altfilter then
		sFilter = altfilter[1];
	end
end

function onListChanged()
	if window.update then
		local wTop = UtilityManager.getTopWindow(window);
		local bReadOnly = WindowManager.getReadOnlyState(wTop.getDatabaseNode());
		window.update(bReadOnly);
	end
end

function updateFilter()
	local s = self.getFilter();
	if s ~= sFilterValue then
		sFilterValue = s;
		if sFilterValue == "" then
			self.setHeadersVisible(true);
			self.setPathVisible(true);
		else
			self.setHeadersVisible(false);
		end
	end
end

function getFilter()
	local wTop = UtilityManager.getTopWindow(window);
	if not wTop[sFilter] then
		return "";
	end
	return wTop[sFilter].getValue():lower();
end

function setHeadersVisible(bShow)
	UtilityManager.callStackedWindowFunction(window, "showFullHeaders", bShow);
end

function setPathVisible()
	setVisible(true);
	UtilityManager.setStackedWindowVisibility(window, true);
end

function onFilter(w)
	self.updateFilter();

	if sFilterValue == "" then
		return true;
	end

	local bShow = true;
	if w.keywords then
		local sKeyWordsLower = w.keywords.getValue():lower();
		for sWord in sFilterValue:gmatch("%w+") do
			if not sKeyWordsLower:find(sWord, 0, true) then
				bShow = false;
			end
		end
	else
		local sNameLower = w.name.getValue():lower();
		for sWord in sFilterValue:gmatch("%w+") do
			if not sNameLower:find(sWord, 0, true) then
				bShow = false;
			end
		end
	end

	if bShow then
		self.setPathVisible();
	end

	return bShow;
end

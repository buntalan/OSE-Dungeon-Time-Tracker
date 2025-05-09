--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	self.onDateChanged();
end

function onDateChanged()
	local sEpoch = epoch.getValue();
	local nYear = year.getValue();
	local nMonth = month.getValue();
	local nDay = day.getValue();

	name.setValue(CalendarManager.getDateString(sEpoch, nYear, nMonth, nDay, false, false));
	if holiday then
		holiday.setValue(CalendarManager.getHolidayName(nMonth, nDay));
	end
end

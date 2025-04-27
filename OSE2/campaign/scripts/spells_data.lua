function onInit()
self.update();
end


function update()
local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());


	if bReadOnly then bShow = false else bShow = true end
		spelleffects_iedit.setVisible(bShow)
		spelleffects_iadd.setVisible(bShow)

		for _,w in ipairs(spelleffects.getWindows()) do
			w.effects_name.setReadOnly(bReadOnly);
		end
end
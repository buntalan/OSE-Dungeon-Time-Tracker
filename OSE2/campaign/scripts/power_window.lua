function actionDrag(draginfo)
local bWindow = spellslist.isVisible()
if bWindow then
spellslist.setVisible(false)
else
spellslist.setVisible(true)
end
end
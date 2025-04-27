
function onInit()
	---UDGCoreRPGWoundOverlayHelper.verbose({"campaign/scripts/imagewindow_toolbar::oninit()"});
	update();
	if super and super.onInit then
		super.onInit();
	end
end

function update()
	---UDGCoreRPGWoundOverlayHelper.verbose({"campaign/scripts/imagewindow_toolbar::update()"});
	--local image = getImage();
	--local bHasTokens = image.hasTokens();

	if Session.IsHost and bHasTokens then
		toolbar_clear_wounds.setVisible(true);
		clear_wound_separator.setVisible(true);
	elseif Session.IsHost and not bHasTokens then
		toolbar_clear_wounds.setVisible(false);
		clear_wound_separator.setVisible(false);
	end

	if bHasTokens then
		token_overlay_manager.updateAllWoundOverlays();
	end

	if super and super.update then
		super.update();
	end
end


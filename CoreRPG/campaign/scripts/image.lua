--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onCursorModeChanged()
	WindowManager.callInnerWindowFunction(UtilityManager.getTopWindow(window), "onImageCursorModeChanged");
end
function onViewModeChanged()
	WindowManager.callInnerWindowFunction(UtilityManager.getTopWindow(window), "onImageViewModeChanged");
end
function onViewTokenChanged(tokenMap)
	ActorDisplayManager.setImageViewTokenDetail(UtilityManager.getTopWindow(window), tokenMap);
end
function onStateChanged()
	WindowManager.callInnerWindowFunction(UtilityManager.getTopWindow(window), "onImageStateChanged");
end

function onTokenAdded()
	WindowManager.callInnerWindowFunction(UtilityManager.getTopWindow(window), "onImageTokenCountChanged");
end
function onTokenDeleted()
	WindowManager.callInnerWindowFunction(UtilityManager.getTopWindow(window), "onImageTokenCountChanged");
end
function onTargetSelect(tTargets)
	return ImageManager.onImageTargetSelect(self, tTargets);
end

function onDrop(x, y, draginfo)
	return ImageManager.onImageDrop(self, x, y, draginfo);
end

function onInit()
    
    -- reconfigure Light Effect Presets
    setupLightEffectPresets();
    

end

--[[
	We adjust all of the lighting presets here to match ose style
]]
_tTokenLightDefaults_OSE = {
	["candle"] = {
		sColor = "FFFFFCC3",
		nBright = 1,
		nDim = 2,
		sAnimType = "flicker",
		nAnimSpeed = 100,
		nDuration = 360,
	},
	["torch"] = {
		sColor = "FFFFF3E1",
		nBright = 6,
		nDim = 6,
		sAnimType = "flicker",
		nAnimSpeed = 25,
		nDuration = 360,
	},
	["lantern"] = {
		sColor = "FFF9FEFF",
		nBright = 6,
		nDim = 6,
		nDuration = 1440,
	},
	["spell_darkness"] = {
		sColor = "FF000000",
		nBright = 3,
		nDim = 3,
		nDuration = 0,
	},
	["spell_light"] = {
		sColor = "FFFFF3E1",
		nBright = 3,
		nDim = 3,
		nDuration = 0,
	},

};
function setupLightEffectPresets()
    VisionManager.removeLightDefault("lamp");
    VisionManager.addLightDefaults(_tTokenLightDefaults_OSE);
    VisionManager.updateLightPresets();
    VisionManager.addVisionType(Interface.getString("vision_infravision"), "infravision");
    VisionManager.addVisionType(Interface.getString("vision_normal"), "normal");
end
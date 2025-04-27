function onInit()

	DecalManager.setDefault("images/decals/OSE Cover Rules Tome.png@OSE Decal");


		OptionsManager.registerOption2("BEMP_INITTYPE", false, "option_header_OSE_INIT", "option_label_OSE_type", "option_entry_cycler",
	 	{
			labels = "Individual|Group|",
			values = "Individual|Group|", 
			baselabel = "Individual",
			default = "Individual"
		});
	
		OptionsManager.registerOption2("BEMP_RACETYPE", false, "option_header_OSE_INIT", "option_label_OSE_RACE", "option_entry_cycler",
	 	{
			labels = "Advanced|Basic|",
			values = "Advanced|Basic|", 
			baselabel = "Advanced",
			default = "Advanced"
		});	
	
		OptionsManager.registerOption2("BEMP_ENCTYPE", false, "option_header_OSE_INIT", "option_label_OSE_ENC", "option_entry_cycler",
	 	{
			labels = "Detailed|None|Item|",
			values = "Detailed|None|Item|", 
			baselabel = "Detailed",
			default = "Detailed"
		});		
	
		OptionsManager.registerOption2("BEMP_WEAPON", false, "option_header_OSE_INIT", "option_label_OSE_Weapon", "option_entry_cycler",
	 	{
			labels = "Yes",
			values = "Yes", 
			baselabel = "option_val_no",
			baseval ="No",
			default = "No"
		});	
		
		   OptionsManager.registerOption2("BEMP_HITPOINTS", false, "option_header_OSE_INIT", "option_label_DW_RND", "option_entry_cycler",
   {
	  labels = "Random|Average",
	  values = "Random|Average", 
	  baselabel = "Random",
	  default = "Random"
  });
		
		
				OptionsManager.registerOption2("BEMP_AUTOINIT", false, "option_header_OSE_INITAUTO", "option_label_OSE_Auto", "option_entry_cycler",
	 	{
			labels = "Yes",
			values = "Yes", 
			baselabel = "option_val_no",
			baseval ="No",
			default = "No"
		});
	
				OptionsManager.registerOption2("OPT_BECMI", false, "option_header_OSE_INIT", "option_label_OSE_BECMI", "option_entry_cycler",
	 	{ labels = "option_val_on", values = "on", baselabel = "option_val_off", baseval = "off", default = "off" })
	 	
				OptionsManager.registerOption2("OPT_D6", false, "option_header_OSE_INIT", "option_label_OSE_D6", "option_entry_cycler",
	 	{ labels = "option_val_on", values = "on", baselabel = "option_val_off", baseval = "off", default = "off" })
end
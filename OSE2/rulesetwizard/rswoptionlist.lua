local sourcenode = nil;
local sourcenodename = "";

local labels = {};
local values = {};

local widgetfont = "sheetlabel";
local option_width = 80;
local option_height = 25;
local optiontext_margin = 5;
local labelwidgets = {};
local boxwidgets = {};

local radio_index = 0;
local default_index = 1;

local bVertical = false;

function onInit()
	-- Get any custom fields
	local bResource = false;
	local labeltext = "";
	local valuetext = "";
	local defaultval = "";
	if parameters then
		if parameters[1].optionwidth then
			option_width = tonumber(parameters[1].optionwidth[1]);
		end
		if parameters[1].optionheight then
			option_height = tonumber(parameters[1].optionheight[1]);
		end
		if parameters[1].optiontextmargin then
			optiontext_margin = tonumber(parameters[1].optiontextmargin[1]);
		end
		
		if parameters[1].labelsres then
			bResource = true;
			labeltext = parameters[1].labelsres[1];
		elseif parameters[1].labels then
			labeltext = parameters[1].labels[1];
		end
		
		if parameters[1].values then
			valuetext = parameters[1].values[1];
		end
		if parameters[1].defaultindex then
			defaultval = parameters[1].defaultindex[1];
		end

		if parameters[1].vertical then
			bVertical = true;
		end
	end
	if font then
		widgetfont = font[1];
	end
	
	-- Initialize the labels, values, widgets and size
	initialize(bResource, labeltext, valuetext, option_width, option_height, tonumber(defaultval) or 1);

	-- SET ACCESS RIGHTS
	local bLocked = false;
	
	-- Get the data node set up and synched
	if not sourceless then
		sourcenodename = getName();
		if source then
			sourcenodename = source[1];
		end
	end
	if sourcenodename ~= "" then
		-- DETERMINE DB READ-ONLY STATE
		local node = window.getDatabaseNode();
		if node.isReadOnly() then
			bLocked = true;
		end

		-- Catch any future node updates
		sourcenode = node.createChild(sourcenodename, "string");
		if sourcenode then
			sourcenode.onUpdate = onSourceUpdate;
		elseif node then
			node.onChildAdded = registerUpdate;
		end
		
		-- Synchronize to the current source value
		synch_index(getStringValue());
		setIndex(radio_index);
	end
	
	-- Set the correct read only value
	if bLocked then
		setReadOnly(bLocked);
	end
	
	-- Set the right display
	updateDisplay();
end

function registerUpdate(nodeSource, nodeChild)
	if nodeChild.getName() == sourcenodename then
		nodeSource.onChildAdded = function () end;
		nodeChild.onUpdate = onSourceUpdate;
		sourcenode = nodeChild;
		update();
	end
end

function initialize(bResource, sLabels, sValues, nOptionWidth, nOptionHeight, varDefault)
	-- Clean up previous values, if any
	labels = {};
	values = {};
	for k, v in pairs(labelwidgets) do
		v.destroy();
	end
	labelwidgets = {};
	for k, v in pairs(boxwidgets) do
		v.destroy();
	end
	boxwidgets = {};
	
	-- Parse the labels to determine the options we should show
	if sLabels then
		if bResource then
			local aStr = StringManager.split(sLabels, "|", true);
			for _,v in ipairs(aStr) do
				table.insert(labels, Interface.getString(v));
			end
		else
			labels = StringManager.split(sLabels, "|", true);
		end
	end
	
	-- Parse the values to determine the underlying data
	if sValues then
		values = StringManager.split(sValues, "|", true);
	end
	
	-- Set the option width and height
	if nOptionWidth then
		option_width = nOptionWidth;
	end
	if nOptionHeight then
		option_height = nOptionHeight;
	end

	-- Create a set of widgets for each option
	for k,v in ipairs(values) do
		-- Create a label widget
		local w = 0;
		local h = 0;

		boxwidgets[k] = addBitmapWidget(stateicons[1].off[1]);
		local iconw, iconh = boxwidgets[k].getSize();

		-- Create the label widget
		if labels[k] then
			labelwidgets[k] = addTextWidget({ font = widgetfont, text = labels[k] });
			if bVertical then
				local textw, texth = labelwidgets[k].getSize();
				labelwidgets[k].setPosition("topleft", iconw + (textw/2)+optiontext_margin+optiontext_margin, ((k-1)*option_height) + math.floor(option_height / 2));
			else
				w,h = labelwidgets[k].getSize();
				labelwidgets[k].setPosition("left", ((k-1)*option_width)+(w/2)+iconw+optiontext_margin, 0);
			end
		end
		
		-- Create the checkbox widget
		if h == 0 then
			w,h = boxwidgets[k].getSize();
		end
				
		if bVertical then
			boxwidgets[k].setPosition("topleft", (iconw/2)+optiontext_margin, ((k-1)*option_height) + math.floor(option_height / 2));
		else
			boxwidgets[k].setPosition("left", ((k-1)*option_width)+(iconw/2), 0);
		end
	end
	
	-- Set the selected value
	if varDefault then
		if type(varDefault) == "string" then
			synch_index(sDefault);
			default_index = radio_index;
		elseif type(varDefault) == "number" then
			radio_index = varDefault;
			default_index = varDefault;
		end
	end

	-- Set the right display
	updateDisplay();
end

function synch_index(srcval)
	local match = 0;
	for k, v in pairs(values) do
		if v == srcval then
			match = k;
		end
	end

	if match > 0 then
		radio_index = match;
	else
		radio_index = default_index;
	end
end

function updateDisplay()
	for k,v in ipairs(boxwidgets) do
		if radio_index == k then
			v.setBitmap(stateicons[1].on[1]);
		else
			v.setBitmap(stateicons[1].off[1]);
		end
	end
end

function update(val)
	synch_index(val);
	updateDisplay();

	if self.onValueChanged then
		self.onValueChanged();
	end
end

function onSourceUpdate()
	update(DB.getValue(sourcenode));
end

function getDatabaseNode()
	return sourcenode;
end

function setStringValue(srcval)
	if sourcenode then
		DB.setValue(sourcenode, "", "string", srcval);
	else
		update(srcval);
	end
end

function setValue(srcval)
	setStringValue(srcval);
end

function getStringValue()
	local srcval = "";

	if sourcenode then
		srcval = DB.getValue(sourcenode);
	else
		srcval = values[radio_index];
	end

	return srcval;
end

function getValue()
	return getStringValue();
end

function onClickDown(button, x, y)
	return true;
end

function onClickRelease(button, x, y)
	-- If we're in read-only mode, then don't change
	if isReadOnly() then
		return true;
	end
	
	-- Enable the option if different than current selection
	local k;
	if bVertical then
		k = math.floor(y / option_height) + 1;
	else
		k = math.floor(x / option_width) + 1;
	end
	
	if radio_index ~= k then
		setIndex(k);
	end
		
	return true;
end

function getIndex()
	return radio_index;
end

function setIndex(index)
	if index > 0 and index <= #values then
		setStringValue(values[index]);
	else
		setStringValue(values[default_index]);
	end
end
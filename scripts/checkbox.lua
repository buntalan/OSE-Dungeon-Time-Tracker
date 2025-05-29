-- [[Checkbox Script]]
-- TODO: Make check marks sequential. It should be able to
-- go backward and forward. 
-- TODO: Roll table every two checks
-- TODO: Make optional rest reminder on 6th check
-- TODO: Pass time on checkbox checked
-- TODO: Reverse time on checkbox unchecked
-- TODO: Add button to clear all checkboxes at bottom

-- [[Give checkboxes new icons for all states]]
function onInit()
    setStateIcons(0, "unchecked_box");
    setStateIcons(1, "checked_box");
end

function onButtonPress()
    --[[
        This function is called when the checkbox is pressed.
        It toggles the state of the checkbox and updates the icon accordingly.
    ]]
    local currentState = getState();
    --[[
        Toggle the state between 0 and 1 if prior box is unchecked. 
    ]]
    setState(1 - currentState); -- Toggle between 0 and 1
end
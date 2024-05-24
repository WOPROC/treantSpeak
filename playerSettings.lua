-- Function to handle the ADDON_LOADED event
settingKeys = {"speakLanguageInParty","displayUntranslatedMessages", "displayTranslated"}



local function OnAddonLoaded(event, addonName, ...)
    -- Check if the loaded addon is your addon
	local str=...
	if str =="Treant_Speak" then
		doStuffWithSavedVariables()
	end
end



function doStuffWithSavedVariables()
local data = treantSettings

        -- Check if the saved variables exist
        if data then
			activateCertainButtons()

            -- Access specific data within the saved variables
			
        else
            print("Saved variables not found.")
			treantSettings = {
				["speakLanguageInParty"] = false,
				["displayUntranslatedMessages"] = true,
				["displayTranslated"] = true
			}
        end

end

-- Register the event handler for ADDON_LOADED
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnAddonLoaded)
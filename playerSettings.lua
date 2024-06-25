-- Function to handle the ADDON_LOADED event
settingKeys = {"speakLanguageInParty","displayUntranslatedMessages", "displayTranslated", "showErrorMsgs"}





local function OnAddonLoaded(event, addonName, ...)
    -- Check if the loaded addon is your addon
	local str=...
	if str =="Treant_Speak" then
		doStuffWithSavedVariables()
		
		
		for key, value in pairs(treantSettings["languages"]) do
			table.insert(dropdown_items, {text=value, func= function() changeLanguage(value) end })
		end
		
		
	end
end

local defaultValues = 
{
	["speakLanguageInParty"] = false,
	["displayUntranslatedMessages"] = true,
	["displayTranslated"] = true,
	["showErrorMsgs"]=true,
	['languages']={"NONE", "TREANT", "FELINE", 'BEAR'}
}


function doStuffWithSavedVariables()
local data = treantSettings

        -- Check if the saved variables exist
        if data then
			

            -- Access specific data within the saved variables
			for key, value in pairs(defaultValues) do
				if data[key] == nil then
					data[key] = value
				end
			end
			
			activateCertainButtons()
        
		else
            print("Saved variables not found.")
			treantSettings = defaultvalues
        end

end

-- Register the event handler for ADDON_LOADED
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnAddonLoaded)



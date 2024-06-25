local chatHistory = {}
local textBoxes = {}
checkBoxes = {}


---------------------------- CREATING UI -----------------------------------------------------
frame = CreateFrame("Frame", "Tree Translator", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(300, 200)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

title = frame:CreateFontString(nil, "OVERLAY")
title:SetFontObject("GameFontHighlight")
title:SetPoint("CENTER", frame.TitleBg, "CENTER", 15, 0)
title:SetText("Treant Speak+: Translator")

local settingsButton = CreateFrame("Button", "settingsButtonYay", frame, "UIPanelButtonTemplate")
settingsButton:SetPoint("TOPLEFT")
settingsButton:SetSize(60, 25)
settingsButton:SetText("Settings")

---Treant Chat Box---
local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -30)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(270, 800) -- Assuming content height is greater than frame height
scrollFrame:SetScrollChild(content)


for i = 1, 40 do
    local item = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    table.insert(textBoxes, item)
	item:SetWordWrap(true)
	item:SetPoint("TOPLEFT", 10, -20 * (i - 1))
    item:SetText("")

end

------------------------
--	  Setttings	      --
------------------------
local settingsScroller = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
settingsScroller:SetPoint("TOPLEFT", 10, -30)
settingsScroller:SetPoint("BOTTOMRIGHT", -30, 10)

-- Create a content frame for the scroll frame
local settingsContent = CreateFrame("Frame", nil, settingsScroller)
settingsContent:SetSize(270, 600) -- Ensure the content frame is larger than the scroll frame's viewable area

-- Set the scroll child of the scroll frame to the content frame
settingsScroller:SetScrollChild(settingsContent)

-- Create and position the "Settings" text
local settingsTxt = settingsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
settingsTxt:SetPoint("TOP", 0, -10) -- Slight adjustment to be visible
settingsTxt:SetText("Settings")



local function CreateCheckBox(parent, name, text, yOffset)
    local checkBox = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
    checkBox:SetPoint("TOPLEFT", 20, -yOffset) -- Adjust the yOffset to position the checkbox
    checkBox:SetSize(20, 20)
    
    local checkBoxText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    checkBoxText:SetPoint("LEFT", checkBox, "RIGHT", 5, 0)
    checkBoxText:SetText(text)

    -- Function to handle checkbox value change
    checkBox:SetScript("OnClick", function(self)
        local isChecked = self:GetChecked()
        -- Do something when checkbox value changes
        local number=tonumber(name)
		treantSettings[settingKeys[number]] = isChecked
		
		--big sadge that we dont have switch statements in lua bruh this smells
    end)

    return checkBox
end

-- Create multiple checkboxes
local yOffset = 20 -- Initial y offset
local txtSettings = {"Speak Treant in Party", "Display Untranslated Messages", "Display Translated Messages", 'Display Error Messages'}

for i = 1, 4 do
    local checkBox = CreateCheckBox(settingsContent, i, txtSettings[i], yOffset)
    yOffset = yOffset + 30 -- Increase y offset for the next checkbox
    table.insert(checkBoxes, checkBox) -- Add checkbox to the table
end




--------------
---Creating Dropdown Menu to select language
--------------
dropdown = CreateFrame("Frame", "MyAddonDropdown", frame, "UIDropDownMenuTemplate")
dropdown:SetPoint("BOTTOM", 90, -23)
UIDropDownMenu_SetWidth(dropdown, 100)

-- Dropdown menu items
dropdown_items = {}

function changeLanguage(language)
	applyLanguage(language)
	if currentLanguage == language and language~="NONE" then
		UIDropDownMenu_SetText(dropdown, capitalizeFirstLetter(string.lower(language)))
	else
		UIDropDownMenu_SetText(dropdown, "Pick language")
	end
	
end






-- Dropdown initialization function
local function InitializeDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo()
    for _, item in ipairs(dropdown_items) do
        info.text = item.text
        info.func = item.func
        UIDropDownMenu_AddButton(info, level)
    end
end

-- Set the dropdown's initialization function
UIDropDownMenu_Initialize(dropdown, InitializeDropdown)
UIDropDownMenu_SetText(dropdown, "Pick language")
UIDropDownMenu_JustifyText(dropdown, "LEFT")
-- Function to create and initialize a dropdown box

settingsScroller:Hide()


-----~ Creating Language Learning Section -------~

yOffset=-yOffset

--~ Settings: Learn new language ~--
--We will list every single language available, along with the ability to learn/unlearn them.
--To do this, it will be a simple text field with a button. 
local languageLearningSectionText = settingsContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
languageLearningSectionText:SetPoint("TOP", 0, yOffset)
languageLearningSectionText:SetText("Add or Remove Languages")
yOffset=yOffset-30


function createNewLanguage(languageToAdd)
	local txt = settingsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	txt:SetPoint("TOPLEFT",15,yOffset)
	txt:SetText(languageToAdd)
	
	
	
	local learnLanguage = CreateFrame("Button", "Enlargerner", settingsContent, "UIPanelButtonTemplate")
	learnLanguage:SetPoint("TOP", 50, yOffset+5)
	learnLanguage:SetSize(150, 25)
	
	if contains(treantSettings['languages'], languageToAdd) then
		learnLanguage:SetText("Unlearn Language")
	else
		learnLanguage:SetText("Learn Language")
	end
	
	
	learnLanguage:SetScript("OnClick", function(self)
        -- Do something when checkbox value changes
        if contains(treantSettings['languages'], languageToAdd) then
			unlearnLanguage(languageToAdd)
			self:SetText("Learn Language")
		else
			learnNewLanguage(languageToAdd)
			self:SetText("Unlearn Language")
		end
		
		--big sadge that we dont have switch statements in lua bruh this smells
    end)
	
	yOffset=yOffset-30
	
end

function addListOfLangs()
		for keys, vals in pairs(languages) do
			if keys~="NONE" then
				createNewLanguage(keys)
			end
		end
end




local function OnAddonLoaded(event, addonName, ...)
    -- Check if the loaded addon is your addon
	local str=...
	if str =="Treant_Speak" then
		--Give it a 1 second buffer to add any other misc. languages not included in the addon
		C_Timer.After(1,addListOfLangs)
		C_Timer.After(1, function()local maxScroll = scrollFrame:GetVerticalScrollRange() scrollFrame:SetVerticalScroll(maxScroll) end)
		--Also, fix the scroll-bar not always being at the bottom (just waiting 1 second after initilization)
		
		
		
	end
end




----- Finished with Settings -------------------------------------
------------------------------------------------------------------
local shrink = CreateFrame("Button", "Squish", frame, "UIPanelButtonTemplate")
shrink:SetPoint("BOTTOMLEFT", -8, 0)
shrink:SetSize(25, 25)
shrink:SetText("-")

local grow = CreateFrame("Button", "Enlargerner", frame, "UIPanelButtonTemplate")
grow:SetPoint("BOTTOMLEFT", -8, 30)
grow:SetSize(25, 25)
grow:SetText("+")

partyModeb = CreateFrame("Button", "Enlargerner", frame, "UIPanelButtonTemplate")
partyModeb:SetPoint("BOTTOMLEFT",5, -18)
partyModeb:SetSize(110, 25)
partyModeb:SetText("Party Mode: Off")

whisperTargetButton = CreateFrame("Button", "Enlargerner", frame, "UIPanelButtonTemplate")
whisperTargetButton:SetPoint("BOTTOMLEFT",118, -18)
whisperTargetButton:SetSize(60, 25)
whisperTargetButton:SetText("Whisper")




------------------------ Finished creating UI ----------------------------------------
--------------------------------------------------------------------------------------




local function calculateMaxCharactersPerLine()
	local theString ='a'
	local maxValue = 1
	for i=1,300 do
		textBoxes[1]:SetText(theString)
		if textBoxes[1]:GetWidth() > frame:GetWidth() then
			break
		end
		
		maxValue = maxValue + 1
		theString = theString .. "a"
	end
	
	maxCharactersPerLine = maxValue-5
	
	if #chatHistory>=40 then
		textBoxes[1]:SetText(chatHistory[#chatHistory])
	else
		textBoxes[1]:SetText("")
	end
	
end


local function displayTextOnMultipleLines(text)
	local lnes = {}
    local currentLine = ""
	
    for word in text:gmatch("%S+") do
        if #currentLine + #word <= maxCharactersPerLine then
			currentLine = currentLine .. " " .. word
        else
            table.insert(lnes, currentLine)
            currentLine = word
        end
    end

    table.insert(lnes, currentLine)

    return lnes
end

local function rebuildChatHistory()
    calculateMaxCharactersPerLine()
    newChatHistory = {}

    for i, msg in ipairs(chatHistory) do
        local textie = displayTextOnMultipleLines(msg)
        for _, txt in ipairs(textie) do
            table.insert(newChatHistory, txt)
        end
    end
	
	local indexC=0
	for i=#textBoxes,1,-1 do
		textBoxes[i]:SetText(newChatHistory[#newChatHistory-indexC])
		indexC = indexC + 1
	end
	


end


function newTranslation(message)
	message = message:gsub("|c%x%x%x%x%x%x%x%x", "")
	table.insert(chatHistory, message)
	if #chatHistory > 100 then
		table.remove(chatHistory, 1)
	end
	rebuildChatHistory()

end

function activateCertainButtons()
	for i=1,#checkBoxes do
		checkBoxes[i]:SetChecked(treantSettings[settingKeys[i]])
	end

end







--------------------------------------
------------------------ Create button functions -------------------------------------

----~
local function showSettings(self)
	
	if scrollFrame:IsShown() then
		scrollFrame:Hide()
		settingsScroller:Show()
		settingsButton:SetText("Chat Box")
	else
		scrollFrame:Show()
		settingsScroller:Hide()
		settingsButton:SetText("Settings")
	end
end



settingsButton:SetScript("OnClick", showSettings)
----~

----~
local function togglePartyMode(self)
	if translateToParty then
		setTranslation(false,nil)
	else
		setTranslation(true, nil)
	end

end


partyModeb:SetScript("OnClick",togglePartyMode)



----~
local function setFixedTarget(self)
	if UnitIsPlayer("target") then
		setTranslation(false, UnitName("target"))
	else
		setTranslation(false, nil)
	end
	
end



whisperTargetButton:SetScript("OnClick", setFixedTarget)
----~

local function growFrame(self)
	local frameWidth = frame:GetWidth()
	local frameHeight = frame:GetHeight()
	if frameHeight < 600 and frameWidth < 600 then
		frame:SetSize(frameWidth + 10, frameHeight+10)
	end
	rebuildChatHistory()
end

grow:SetScript("OnClick", growFrame)



----~

----~

local function shrinkFrame(self)
	local frameWidth = frame:GetWidth()
	local frameHeight = frame:GetHeight()
	
	if frameHeight > 200 and frameWidth > 300 then
		frame:SetSize(frameWidth - 10, frameHeight-10)
	end
	
	rebuildChatHistory()

end

shrink:SetScript("OnClick",shrinkFrame)








local onLoad = CreateFrame("Frame")
onLoad:RegisterEvent("ADDON_LOADED")
onLoad:SetScript("OnEvent", OnAddonLoaded)



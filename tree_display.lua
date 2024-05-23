local chatHistory = {}
local textBoxes = {}
checkBoxes = {}


---------------------------- CREATING UI -----------------------------------------------------
local frame = CreateFrame("Frame", "Tree Translator", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(300, 200)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

title = frame:CreateFontString(nil, "OVERLAY")
title:SetFontObject("GameFontHighlight")
title:SetPoint("CENTER", frame.TitleBg, "CENTER", 5, 0)
title:SetText("Treant Speak - Translator")

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


local settingsContent = CreateFrame("Frame", "TreeTranslatorSettingsContent", frame)
settingsContent:SetPoint("TOPLEFT", 10, -35)
settingsContent:SetPoint("BOTTOMRIGHT", -10, 35)

local settingsTxt = settingsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
settingsTxt:SetPoint("TOP")
settingsTxt:SetText("Settings")

local helpTxt = settingsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
helpTxt:SetPoint("BOTTOM")
helpTxt:SetText("Do /treant help for help!")


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
local txtSettings = {"Speak Treant in Party", "Display Untranslated Messages", "Display Translated Messages"}

for i = 1, 3 do
    local checkBox = CreateCheckBox(settingsContent, i, txtSettings[i], yOffset)
    yOffset = yOffset + 30 -- Increase y offset for the next checkbox
    table.insert(checkBoxes, checkBox) -- Add checkbox to the table
end


settingsContent:Hide()

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
partyModeb:SetPoint("BOTTOMLEFT",15, -18)
partyModeb:SetSize(110, 25)
partyModeb:SetText("Party Mode: Off")

whisperTargetButton = CreateFrame("Button", "Enlargerner", frame, "UIPanelButtonTemplate")
whisperTargetButton:SetPoint("BOTTOMLEFT",150, -18)
whisperTargetButton:SetSize(125, 25)
whisperTargetButton:SetText("Whisper Translation")




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
		settingsContent:Show()
		settingsButton:SetText("Chat Box")
	else
		scrollFrame:Show()
		settingsContent:Hide()
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



-----~
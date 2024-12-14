

---------------------------- CREATING UI -----------------------------------------------------
local frameC = CreateFrame("Frame", "Tree Language Maker", UIParent, "BasicFrameTemplateWithInset")
frameC:SetSize(300, 200)
frameC:SetPoint("CENTER")
frameC:SetMovable(true)
frameC:EnableMouse(true)
frameC:RegisterForDrag("LeftButton")
frameC:SetScript("OnDragStart", frame.StartMoving)
frameC:SetScript("OnDragStop", frame.StopMovingOrSizing)

local title = frame:CreateFontString(nil, "OVERLAY")
title:SetFontObject("GameFontHighlight")
title:SetPoint("CENTER", frameC.TitleBg, "CENTER", 15, 0)
title:SetText("Treant Speak+: Language Creator")

local scrollFrame = CreateFrame("ScrollFrame", nil, frameC, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -30)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(270, 800) -- Assuming content height is greater than frame height
scrollFrame:SetScrollChild(content)


local customLanguageAmount = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
customLanguageAmount:SetWordWrap(true)
customLanguageAmount:SetPoint("TOPLEFT", 75, 0)

local function OnAddonLoaded(event, addonName, ...)
    -- Check if the loaded addon is your addon
	local str=...
	print(str)
	if str =="Treant_Speak" then
		customLanguageAmount:SetText("Custom Languages Known: "..#treantSettings["customLanguages"])
		
		
	end
end

local onLoad = CreateFrame("Frame")
onLoad:RegisterEvent("ADDON_LOADED")
onLoad:SetScript("OnEvent", OnAddonLoaded)
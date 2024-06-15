local TreeComm = LibStub("AceComm-3.0")
local serial = LibStub("AceSerializer-3.0")


local lastDecryptedMessage =""

-------------------------------
--- COLORS --
local Class_Colors = {
    ["DEATHKNIGHT"] = { r = 0.77, g = 0.12, b = 0.23 },
    ["DEMONHUNTER"] = { r = 0.64, g = 0.19, b = 0.79 },
    ["DRUID"] = { r = 1.00, g = 0.49, b = 0.04 },
    ["EVOKER"] = { r = 0.20, g = 0.58, b = 0.50 },
    ["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },
    ["MAGE"] = { r = 0.41, g = 0.80, b = 0.94 },
    ["MONK"] = { r = 0.00, g = 1.00, b = 0.59 },
    ["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },
    ["PRIEST"] = { r = 1.00, g = 1.00, b = 1.00 },
    ["ROGUE"] = { r = 1.00, g = 0.96, b = 0.41 },
    ["SHAMAN"] = { r = 0.00, g = 0.44, b = 0.87 },
    ["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },
    ["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 }
}



local RED = "|cFFFF0000"
local GREEN = "|cFF00FF00"
local BLUE = "|cFFADD8E6"
local YELLOW = "|cFFFFFF00"
local ORANGE = "|cFFFFA500"
local PURPLE = "|cFF800080"
local CYAN = "|cFF00FFFF"
local MAGENTA = "|cFFFF00FF"
local WHITE = "|cFFFFFFFF"
local BLACK = "|cFF000000"
local GRAY = "|cFF808080"






----------------------------
currentLanguage = languages[1];

isBroken = false;

local translateToParty=false
local fixedTarget=nil


function capitalizeFirstLetter(str)
    if str == nil or str == "" then
        return str
    end
    local firstLetter = string.sub(str, 1, 1)
    local restOfString = string.sub(str, 2)
    return string.upper(firstLetter) .. restOfString
end



function contains(hashTable, value)

	for i, val in ipairs(hashTable) do
		if val == value then
			return true
		end
	end
	return false

end


local function playerHasBuff(buffTable)
    for i = 1, 40 do
        local name = UnitBuff("player", i)
        if name and contains(buffTable,name) then
            return true
        end
    end
    return false
end


local function isEligibleToSpeakOrTranslate(lan)
	lan = string.upper(lan)
	if lan~='FELINE' and lan~='BEAR' and lan~='TREANT' then
		return true
	end
	
	validBuffs = {"Mark of the Wild", "Marca de lo Salvaje"}
	if lan == languages[2] then
		table.insert(validBuffs,"Treant Form")	
	elseif lan== languages[4] then
		table.insert(validBuffs,"Cat Form")
	elseif lan==languages[5] then
		table.insert(validBuffs,"Bear Form")
	end
	
	return playerHasBuff(validBuffs)
end


function setTranslation(isParty, target)

	if currentLanguage==languages[1] then
		translateToParty=false
		fixedTarget=nil
		title:SetText("Treant Speak+: Translator")
		partyModeb:SetText("Party Mode: Off")
		UIDropDownMenu_SetText(dropdown, "Pick language")
		isBroken=false
		return
	end
	brokenNess=''
	if isBroken then
		brokenNess="Broken "
	end
	if not isParty and target==nil then
		translateToParty=false
		fixedTarget=nil
		partyModeb:SetText("Party Mode: Off")
		title:SetText(GREEN.."Speaking: "..brokenNess..currentLanguage)
		UIDropDownMenu_SetText(dropdown, "Pick language")
	elseif isParty then
		fixedTarget=nil
		if translateToParty or not IsInGroup() then
			translateToParty=false
			partyModeb:SetText("Party Mode: Off")
		else
			translateToParty=true
			partyModeb:SetText("Party Mode: On")
		end
	elseif target~=nil then
		fixedTarget=target
		local classToken = GetPlayerInfoByGUID(UnitGUID('target'))

		local classColor = Class_Colors[string.upper(classToken):gsub("%s+", "")]
			local nameColor = string.format("|cff%02x%02x%02x",
				classColor.r * 255, classColor.g * 255, classColor.b * 255)
		
		title:SetText(GREEN.."Translating "..currentLanguage..": "..nameColor..fixedTarget)
		translateToParty=false
		partyModeb:SetText("Party Mode: Off")
	else
		translateToParty=false
		fixedTarget=nil
		partyModeb:SetText("Party Mode: Off")
		title:SetText(GREEN.."Speaking: "..brokenNess..currentLanguage)
		UIDropDownMenu_SetText(dropdown, "Pick language")
	end

end

-----------------------------------------------------------
---Slash Commands



function applyLanguage(str)


	if string.lower(str)=='tree' then
		str='TREANT'
	elseif string.lower(str)=='cat' then
		str='FELINE'
	end
	
	if str=="" or currentLanguage==string.upper(str) or string.upper(str)=="NONE" then
		
		if currentLanguage ~= languages[1] then
			print(RED.."You are no longer speaking a language.")
		end
		currentLanguage=languages[1]
		setTranslation(false,nil)
		return
	end
	
	
	if contains(languages, string.upper(str)) and isEligibleToSpeakOrTranslate(string.upper(str)) then
		brokenNess=''
		if isBroken then
			brokenNess="Broken "
		end
		currentLanguage=string.upper(str)
		title:SetText(GREEN.."Speaking: "..brokenNess..currentLanguage)
		UIDropDownMenu_SetText(dropdown, capitalizeFirstLetter(string.lower(str)))
		if not frame:IsVisible() then
			print(GREEN.."You are now speaking "..brokenNess.. capitalizeFirstLetter(string.lower(str)))
		end
	elseif contains(languages, string.upper(str)) then
		if currentLanguage==languages[1] and treantSettings['showErrorMsgs'] then
			print(RED.."You cannot speak " .. capitalizeFirstLetter(string.lower(str)) .. "!")
		else
			applyLanguage("NONE")
		end
		setTranslation(false,nil)
	else 
		print(BLUE.."This language does not exist.")
		setTranslation(false,nil)
	end
	
	

end

local function TreantSpeak()
	applyLanguage("TREANT")
end

local function makeBroken()
	if isBroken then
		isBroken=false
		title:SetText(GREEN.."Speaking: "..currentLanguage)
	else
		title:SetText(GREEN.."Speaking: Broken "..currentLanguage)
		isBroken=true
	end

end

local function treeHelp(str)

	if string.lower(str)=="help" then
		print(CYAN.."~--TREANT HELP DESK--~")
		print(BLUE.."/tree to speak in treant")
		print(BLUE.."/lan {language} to speak in a desired language.")
		print(MAGENTA.."=> (Example: /lan tree to speak in treant")
		print(BLUE.."/treant ts to see translation commands")
		print(BLUE.."/treant lan to see language commands.")
	elseif string.lower(str)=="lan" then
		print(CYAN.."~--TREANT LANGUAGE DESK--~")
		print(ORANGE.."/broken to speak in a broken version of your current language. Not available for all languages.")
		print(RED.."~=Available Languages=~")
		print(BLUE.."~> Treant".. ORANGE.." (broken available)")
		print(BLUE.."~> Zombie")
		print(BLUE.."~> Cat")
		print(BLUE.."~> Bear")
	elseif string.lower(str)=="ts" then
		print(CYAN.."~--TREANT TRANSLATION DESK--~")
		print(BLUE.."/ts with a target to whisper a translation to the target.")
		print(BLUE.."/ts without a target to stop whisper translating.")
		print(BLUE.."/ts p or /ts party to translate to your party.")
	else
		frame:Show()
	end
	

end


local function translationFun(str)
	if str=="" then
		if UnitIsPlayer('target') then
			setTranslation(false, UnitName('target'))
		else
			setTranslation(false,nil)
		end
	elseif string.lower(str)=='p' or string.lower(str)=='party' then
		setTranslation(true,nil)
	end

end

SLASH_treantSpeak1 = '/tree'
SlashCmdList.treantSpeak = TreantSpeak;

SLASH_language1='/lan'
SlashCmdList.language=applyLanguage;

SLASH_treantHelp1='/treant'
SlashCmdList.treantHelp = treeHelp;

SLASH_brokenCommon1='/broken'
SlashCmdList.brokenCommon = makeBroken;

SLASH_translate1 = '/ts'
SlashCmdList.translate = translationFun;










-----------------------------------------------------------------
-- Register the communication prefix
TreeComm:RegisterComm("treeTalk", function(prefix, message, distribution, sender)

    TreeComm:TreeReceiveMsg(prefix, message, distribution, sender)
end)

--Send a message over the addon channel
function TreeComm:TreeSendMsg(channel, player, ...)
    local message = serial:Serialize({...})
    self:SendCommMessage("treeTalk", message, channel, player)
end

--Send a prioritized message over the addon channel
function TreeComm:TreeSendPriority(prio, channel, player, ...)
    local message = serial:Serialize({...})
    self:SendCommMessage("treeTalk", message, channel, player, prio)
end

--Receive a message over the addon channel
function TreeComm:TreeReceiveMsg(prefix, message, distribution, sender)

		local didWin, t = serial:Deserialize(message)
		--Unpack the message (so we can read it)
		txt = unpack(t)

		if txt == "RQTRANSLATE" then --"RQTRANSLATE"=Request Translate
			TreeComm:TreeSendMsg("WHISPER",sender,lastDecryptedMessage) --Send the real message over the addon channel
		else
		--If we aren't request to translate, then we have received a real message.
			if treantSettings["displayTranslated"] then
				print(txt) 
			end
			newTranslation(txt)
		
		end
	

end


function askForTranslation(senderName,lang)
		if senderName ~= UnitName("player") and isEligibleToSpeakOrTranslate(lang) then

			TreeComm:TreeSendMsg("WHISPER",senderName, "RQTRANSLATE") 
			if treantSettings["displayUntranslatedMessages"] then
				return false --displays the message
			else
				return true --suppresses the message
			end
	
			return false
		end


		if isEligibleToSpeakOrTranslate(lang) and treantSettings["displayUntranslatedMessages"] then
			return false
		elseif isEligibleToSpeakOrTranslate(lang) and treantSettings["displayUntranslatedMessages"] == false then
			return true
		else
			return false
		end

end

function onChatMessage(self, event, message, sender, ...)
	local senderName = strsplit("-", sender)
	local words = nil
	for str in message:gmatch("%S+") do
		words = str
		break
	end
	
	if contains(languages, string.upper(words:gsub("[%[%]]", ""))) then
		return askForTranslation(senderName,string.upper(words:gsub("[%[%]]", "")))
	end
	

end 






ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", onChatMessage)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", onChatMessage)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", onChatMessage)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", onChatMessage)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", onChatMessage)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", onChatMessage)




local originalSendChatMessage = SendChatMessage

-- Function to replace the player's message
local function modifiedSendChatMessage(message, chatType, language, channel)
    -- Modify the message here as desired
	

	
	
	
	
	
	
	if currentLanguage~=languages[1] then
		
		if not isEligibleToSpeakOrTranslate(currentLanguage) then
			isTranslating=false
			print("You can no longer speak that language.")
			setTranslation(false,nil)
			currentLanguage=languages[1]
			originalSendChatMessage(message, chatType, language, channel)
			return false
		end
	
	
		if chatType == "SAY" or chatType == "YELL" or chatType == "PARTY" then
	
			if chatType == "PARTY" and treantSettings["speakLanguageInParty"]==false then
				originalSendChatMessage(message, chatType, language, channel)
				return
			end
			
			
			local localizedClass, classFileName, classID = UnitClass("player")
			local classColor = Class_Colors[classFileName]
			local nameColor = string.format("|cff%02x%02x%02x",
				classColor.r * 255, classColor.g * 255, classColor.b * 255)
			
			local chatR, chatG, chatB = GetMessageTypeColor(chatType)
			if chatType == "PARTY" and UnitIsGroupLeader("player") then
				chatR, chatG, chatB = GetMessageTypeColor("PARTY_LEADER")
			end
			
			
			local colour = string.format("|cff%02x%02x%02x",
				chatR * 255, chatG * 255, chatB * 255)
	
			local str1= colour.."["
			local str2 = nameColor..UnitName("player")
			local str3 = colour.."]: " .. message
			
			if chatType == "PARTY" then
				local tempStr = ""
				if UnitIsGroupLeader("player") then
					tempStr = " Leader"
				end
				str1 = colour .. "[" ..string.lower(chatType):gsub("^%l", string.upper).. tempStr.."] " .. " ["
			else
				local tempS = string.lower(chatType)
				str3 = colour.."] "..tempS.."s: "..message
			end
			
			lastDecryptedMessage = str1..str2..str3
			
			--Only show the translation if the player has that setting enabled
			if treantSettings["displayTranslated"] then
				print(lastDecryptedMessage)
			end
			
			newTranslation(lastDecryptedMessage)
			
			local newMsg = "["..capitalizeFirstLetter(string.lower(currentLanguage)).."] "..encryptMsg(message, currentLanguage)
			
			if translateToParty then
				originalSendChatMessage("[Translation-"..capitalizeFirstLetter(string.lower(currentLanguage)).."] "..message, "PARTY", language, channel)
			elseif fixedTarget ~= nil then
				originalSendChatMessage("[Translation-"..capitalizeFirstLetter(string.lower(currentLanguage)).."] "..message, "WHISPER", nil, fixedTarget)
			end
	-- Call the original SendChatMessage function with the modified message
			originalSendChatMessage(newMsg, chatType, language, channel)
		else
			originalSendChatMessage(message, chatType, language, channel)
		end
	else
		originalSendChatMessage(message, chatType, language, channel)
	end

end

SendChatMessage = modifiedSendChatMessage


-- Additional debugging: Confirm addon is loaded
print(BLUE.. "Treant Speak is here, ".. UnitName("player")..". Type /treant help for commands.")


--Tree: Actually deals with message sending, calling translation functions, etc.
local TreeComm = LibStub("AceComm-3.0")
local serial = LibStub("AceSerializer-3.0")

--> Register the communication prefix
	TreeComm:RegisterComm("treeTalk", function(prefix, message, distribution, sender)

		TreeComm:TreeReceiveMsg(prefix, message, distribution, sender)
	end)

	--Send a message over the addon channel
	function TreeComm:TreeSendMsg(channel, player, ...)
		local message = serial:Serialize({...})
		self:SendCommMessage("treeTalk", message, channel, player)
	end

	--Receive a message over the addon channel
	function TreeComm:TreeReceiveMsg(prefix, message, distribution, sender)

		local success, t = serial:Deserialize(message)
		--Unpack the message (so we can read it)
		txt = unpack(t)

		--"RQTRANSLATE"=Request Translate
		if txt == "RQTRANSLATE" then 
			TreeComm:TreeSendMsg("WHISPER",sender,XORCipher(lastDecryptedMessage)) --Send the real message over the addon channel
		else
		--If we aren't request to translate, then we have received a real message.
			if treantSettings["displayTranslated"] then
				print(XORCipher(txt)) 
			end
			newTranslation(XORCipher(txt))	
		end
	end
	
--> Communication Functions

	function askForTranslation(senderName,lang)
		if senderName ~= UnitName("player") and canSpeakOrUnderstand(lang) then

			TreeComm:TreeSendMsg("WHISPER",senderName, "RQTRANSLATE") 
			if treantSettings["displayUntranslatedMessages"] then
				return false --displays the message
			else
				return true --suppresses the message
			end
	
			return false
		end


		if canSpeakOrUnderstand(lang) and treantSettings["displayUntranslatedMessages"] then
			return false
		elseif canSpeakOrUnderstand(lang) and not treantSettings["displayUntranslatedMessages"] then
			return true
		else
			return false
		end

	end
	

	function setTranslation(isParty, characterToWhisperTo)
		
		if(currentLanguage == "NONE") then
		
			partyMode=false
			fixedTarget=nil
			title:SetText("Treant Speak+: Translator")
			partyModeb:SetText("Party Mode: Off")
			UIDropDownMenu_SetText(dropdown, "Pick language")
			return
		end
		
		
		if(isParty) then
			partyMode = true
			characterToTranslateTo = nil
			partyModeb:SetText("Party Mode: On")
			title:SetText(GREEN.."Speaking: "..currentLanguage)
		elseif(not isParty and characterToWhisperTo ~= nil) then
			partyMode = false
			characterToTranslateTo = characterToWhisperTo
			local classToken = GetPlayerInfoByGUID(UnitGUID('target'))

			local classColor = Class_Colors[string.upper(classToken):gsub("%s+", "")]
				local nameColor = string.format("|cff%02x%02x%02x",
				classColor.r * 255, classColor.g * 255, classColor.b * 255)
		
			title:SetText(GREEN.."Translating "..currentLanguage..": "..nameColor..characterToWhisperTo)
			translateToParty=false
			partyModeb:SetText("Party Mode: Off")
		else
			partyMode = false
			characterToTranslateTo = nil
			partyModeb:SetText("Party Mode: Off")
			title:SetText(GREEN.."Speaking: "..currentLanguage)
		end
	end

--> Chat Frame Event
	function onChatMessage(self, event, message, sender, ...)
		local senderName = strsplit("-", sender)
		local words = nil
		for str in message:gmatch("%S+") do
			words = str
			break
		end
	
		if languages[string.upper(words:gsub("[%[%]]", ""))] ~= nil then
			return askForTranslation(senderName,string.upper(words:gsub("[%[%]]", "")))
		end
	end 

	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", onChatMessage)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", onChatMessage)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", onChatMessage)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", onChatMessage)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", onChatMessage)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", onChatMessage)


--> On Message Send
	local originalSendChatMessage = SendChatMessage
	SendChatMessage = modifiedSendChatMessage
	
	local function modifiedSendChatMessage(message, chatType, language, channel)
		--Do we actually have a language on?
		if currentLanguage ~= "NONE" then
			

			if (chatType=="PARTY" and treantSettings['speakLanguageInParty']) or chatType=="SAY" or chatType == "YELL" then
				
				--We are constructing what our message should look in the normal chatbar
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
				
				--Add this to our translation box
				newTranslation(lastDecryptedMessage)
				
				spokenLanguage = "["..capitalizeFirstLetter(string.lower(currentLanguage)).."] "
				if(languages[currentLanguage].isRealLanguage == false) then
					spokenLanguage=""
				end
				
				local newMsg = spokenLanguage..encryptMsg(message)
				
				if partyMode then
					originalSendChatMessage("[Translation-"..capitalizeFirstLetter(string.lower(currentLanguage)).."] "..message, "PARTY", language, channel)
				elseif characterToTranslateTo~= nil then
					originalSendChatMessage("[Translation-"..capitalizeFirstLetter(string.lower(currentLanguage)).."] "..message, "WHISPER", nil, characterToTranslateTo)
				end
				--Call the original send chat message with our new message
				originalSendChatMessage(newMsg, chatType, language, channel)
				
			else
				--We are not speaking in the correct channel (SAY,PARTY,YELL)
				originalSendChatMessage(message,chatType,language,channel)
				return
			end
		else
			originalSendChatMessage(message,chatType,language,channel)
		end
		
	end

SendChatMessage = modifiedSendChatMessage


--- SLASH commands ---
local function TreantSpeak()
	applyLanguage("TREANT")
end

local function treantBoxToggle()
	frame:Show()
end

local function toggleBrokenFunc()
	if(isBroken) then
		isBroken=false;
	else
		isBroken=true;
	end

	setTranslation(partyMode, characterToTranslateTo)
end

--Slash commands definitions
SLASH_TreantSpeak1 = '/tree'
SlashCmdList.TreantSpeak = TreantSpeak;

SLASH_language1='/lan'
SlashCmdList.language=applyLanguage;

SLASH_treantBox1 = "/treant"
SlashCmdList.treantBox = treantBoxToggle;

SLASH_toggleBroken1 = "/broken"
SlashCmdList.toggleBroken = toggleBrokenFunc;



--Welcome our friendly user...
print(BLUE.. "Treant Speak is here, ".. UnitName("player")..". Type /treant help for commands.")
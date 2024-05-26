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
local treeSpeak=false --We are speaking in tree





------------------------------------
function setTranslation(partyMode, whisperTo)
	if not treeSpeak then
		fixedTarget=nil
		translateToParty=false
		partyModeb:SetText("Party Mode: Off")
		title:SetText("Treant Speak - Translator")
	elseif partyMode then
		fixedTarget=nil
		translateToParty=true
		partyModeb:SetText("Party Mode: On")
		title:SetText(GREEN.."Treant Speak - Translator")
	elseif whisperTo~= nil then
		fixedTarget=whisperTo
		translateToParty=false
		
		 local targetGUID = UnitGUID("target")
        if targetGUID then
            local playerLocation = PlayerLocation:CreateFromGUID(targetGUID)
            local className, classFileName, classID = C_PlayerInfo.GetClass(playerLocation)
            if classFileName then
                local cColor = Class_Colors[classFileName]
                local nameColor = string.format("|cff%02x%02x%02x",
                cColor.r * 255, cColor.g * 255, cColor.b * 255)
                
                title:SetText(GREEN.."Translating to ".. nameColor .. fixedTarget)
            else
                title:SetText(GREEN.."Translating to ".. fixedTarget)
            end
        else
            title:SetText(GREEN.."Translating to ".. fixedTarget)
        end
	else
		fixedTarget=nil
		translateToParty=false
		partyModeb:SetText("Party Mode: Off")
		title:SetText(GREEN.."Treant Speak - Translator")
	end

end





local function hasBuff(buffName)
    -- Iterate through the player's buffs
    for i = 1, 20 do -- If they have moer than this then they lose i guess
        local name, _, _, _, _, _, _, _, _, spellId = UnitBuff("player", i)
        if name and name == buffName then
            -- Buff found
            return true
        end
    end
    -- Buff not found
    return false
end


local function isEligibleToSpeakOrTranslate()
	if hasBuff("Mark of the Wild") or hasBuff("Treant Form") or hasBuff("Marca de lo Salvaje") or hasBuff("Don de lo salvaje") then
		return true
	end
	return false

end
---------------------------------------
-----Slash Commands ------------------
local function treantSpeak(str)
		if isEligibleToSpeakOrTranslate() ==false then
			treeSpeak=false
			isTranslating=false
			print("You cannot speak in tree!")
			setTranslation(false,nil)
		else
			if treeSpeak == true then
				print("You are no longer speaking in treant.")
				lastDecryptedMessage=""
				treeSpeak=false
				isTranslating=false
				title:SetText("Treant Speak - Translator")
				setTranslation(false,nil)
			else
				print("You are now speaking in treant.")
				treeSpeak=true
				isTranslating=false
				title:SetText(GREEN.."Treant Speak - Translator")
			end
		end
end

SLASH_TreantSpeak1 = "/tree";
SlashCmdList.TreantSpeak = treantSpeak;

local function translationGame(str)
	
	if not treeSpeak then
		setTranslation(false, nil)
	elseif str=="p" then
		setTranslation(true, nil)
	else
		if UnitIsPlayer("target") then
			setTranslation(false, UnitName("target"))
		else
			setTranslation(false,nil)
		end
	end

end

SLASH_translateTo1 = "/ts"
SlashCmdList.translateTo = translationGame;

local function treantHelp(str)
	str=string.lower(str)
	if str=="help" then
		print(RED.."~---TREANT HELP DESK---~")
		print("Do /tree to toggle on Treant Language.")
		print(BLUE.."Do /treant to open up the translation window")
		print(BLUE.."Do /ts with a target to select a whisper target")
		print(BLUE.."Do /ts p to translate to your party (Party Mode)")
		print(BLUE.."Do /ts without a target to stop all translation methods.")
		print(RED.."~----------------------~")
	else
		frame:Show()
	end
end

SLASH_treant1 = "/treant"
SlashCmdList.treant = treantHelp

-----------------------------------------------------------

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




function onChatMessage(self, event, message, sender, ...)


	local senderName = strsplit("-", sender)
	local words = nil
	for str in message:gmatch("%S+") do
		words = str
		break
	end
	--Check to see who the sender is. 
	if words=="[Treant]" then

		if senderName ~= UnitName("player") and isEligibleToSpeakOrTranslate() then

			TreeComm:TreeSendMsg("WHISPER",senderName, "RQTRANSLATE") 
			if treantSettings["displayUntranslatedMessages"] then
				return false --displays the message
			else
				return true --suppresses the message
			end
	
			return false
		end


		if treeSpeak and treantSettings["displayUntranslatedMessages"] then
			return false
		elseif treeSpeak and treantSettings["displayUntranslatedMessages"] == false then
			return true
		else
			return false
		end
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
	if treeSpeak then
		
		if not isEligibleToSpeakOrTranslate() then
			treeSpeak=false
			isTranslating=false
			print("You can no longer speak in tree.")
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
			
			local newMsg = '[Treant] '..encryptMsg(message)
			
			if translateToParty then
				originalSendChatMessage(message, "PARTY", language, channel)
			elseif fixedTarget ~= nil then
				originalSendChatMessage(message, "WHISPER", nil, fixedTarget)
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
print(BLUE.. "Treant Speak is here, ".. UnitName("player"))


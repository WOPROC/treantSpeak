--Brain: Holds important data, functions, etc.


------- BEGIN WITH VARIABLE DECLARATIONS ---------

--~ Global ~--
savedKeys = {"speakLanguageInParty","displayUntranslatedMessages", "displayTranslated", "showErrorMsgs"}


--Keep track of our current language
currentLanguage="NONE"
isBroken = false

partyMode = false
characterToTranslateTo = nil


--Utility variables
	Class_Colors = {
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

	RED = "|cFFFF0000"
	GREEN = "|cFF00FF00"
	BLUE = "|cFFADD8E6"
	YELLOW = "|cFFFFFF00"
	ORANGE = "|cFFFFA500"
	PURPLE = "|cFF800080"
	CYAN = "|cFF00FFFF"
	MAGENTA = "|cFFFF00FF"
	WHITE = "|cFFFFFFFF"
	BLACK = "|cFF000000"
	GRAY = "|cFF808080"


----~~~~ LANGUAGE TRANSLATION TABLES ~~~~----
local englishToTreant = {
    { "the", "anzu" },
    { "you", "nua" },
    { "he", "nua" },
    { "i", "nua" },
    { "she", "nua" },
    { "they", "nua" },
    { "them", "nua" },
    { "can", "auchi" },
    { "ca", "ki" },
    { "why", "auchi" },
    { "nth", "ki" },
    { "sch", "ki" },
    { "cl", "pi" },
    { "scr", "pu" },
    { "spl", "sria" },
    { "thr", "mux" },
    { "bl", "luia" },
    { "br", "vz" },
    { "qu", "abi" },
    { "in", "zu" },
    { "en", "vu" },
    { "ch", "pi" },
    { "sh", "zk" },
    { "ti", "yz" },
    { "be", "yurtz" },
    { "am", "via" },
    { "have", "ex" },
    { "not", "vu" },
    { "yes", "ual" },
    { "no", "yue" },
    { "would", "vuu" },
    { "s", "pipi" },
    { "e", "pipie" },
    { "o", "lu" },
    { "r", "ku" },
    { "l", "ziula" },
    { "t", "vii" },
    { "d", "m" },
    { "b", "ki" },
    { "c", "pi" },
    { "f", "p" },
    { "g", "i" },
    { "j", "u" },
    { "m", "pipo" },
    { "q", "ak" },
    { "v", "i" },
    { "w", "ke" },
    { "x", "ko" },
    { "y", "i" },
    { "za", "pi" },
    { "h", "ooa" }
}

local felineTranslations = {
"meow", "Meow", "MEOW", "purrr", "purr", "purrrr~", "meow", "meoowwww"
}

local bearTranslations = {
"bear", "Bear", "...bear!", "BEAR", "bear bear", "bear, bear... bear?"
}

local zombieTranslations = {
'ughhh', 'brainss', 'brainzz', 'brainz', 'brains', 'brainnssss', 'ughhh,', 'erghh', 'brains?', 'gah'
}

local snowmanTranslations = 
{
"snow", "Snow", "snow!", "Snow, snow. Snow!"
}


--~ Local ~--
local defaultSaved = {
	["speakLanguageInParty"] = false,
	["displayUntranslatedMessages"] = true,
	["displayTranslated"] = true,
	["showErrorMsgs"]=true,
	--Known languages
	['languages']={"NONE", "TREANT", "FELINE", 'BEAR'}
}



------- FUNCTION DECLARATIONS ------------------



--> Language Editing
	function learnNewLanguage(languageTolearn)

		--Insert a new language into 
		if(languages[languageTolearn]) then
			table.insert(treantSettings["languages"], languageTolearn)
		end
	
		--Update our dropdown box
		table.insert(dropdown_items, {text=languageTolearn, func= function() changeLanguage(languageTolearn) end })

	end

	function forgetLanguage(languageToForget)
		for i,v in ipairs(treantSettings['languages']) do
			if treantSettings['languages'][i] == languageToForget then
				table.remove(treantSettings['languages'], i)
			end
		end
	
		for i, val in ipairs(dropdown_items) do
			if val.text == languageToForget then
				table.remove(dropdown_items, i)
			end
		end	
	end

	--This adds languages that are not supported in the standard addon. This must be called when Treant Speak is loaded.
	function addNewLanguage(lang, languageInfo)
		languages[lang] = languageInfo
	end

	function applyLanguage(str)
		
		if string.lower(str)=='tree' then
			str='TREANT'
		elseif string.lower(str)=='cat' then
			str='FELINE'
		end
	
		if str=="" or currentLanguage==string.upper(str) or string.upper(str)=="NONE" then
		
			if currentLanguage ~= languages['NONE'] then
				print(RED.."You are no longer speaking a language.")
			end
			currentLanguage='NONE'
			setTranslation(false,nil)
			title:SetText("Treant Speak+ Translator")
			return
		end
	
	
	
		if languages[string.upper(str)] ~= nil and canSpeakOrUnderstand(string.upper(str)) then
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
		elseif languages[string.upper(str)] ~= nil then
			if currentLanguage=='NONE' and treantSettings['showErrorMsgs'] then
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

--> Encryption Methods

	--These first few functions are meant to only be called from the global functions.
	local function capitalizeRandomly(char,proficiency)
		if proficiency > 5 then
			return char:upper()
		end
	
		local rand = math.random(4*proficiency) -- Generate random number: 1, 2, 3, or 4
		if rand == 1 then
			return char:upper() .. char -- Capitalize before and after
		elseif rand == 2 then
			return char .. char:upper() -- Capitalize after and before
		else
			return char:upper() -- Add an uppercase letter
		end
	end
	
	local function breakWord(word)
		local brokenWord = ""
		for i = 1, #word do
			brokenWord = brokenWord .. capitalizeRandomly(word:sub(i, i),2)
		end
		
		return brokenWord	
	end
	
	--The following functions are the actual encryption methods.
	function encryptLetters(word)
		if isBroken then
			word=breakWord(word)
		end

		for _, pair in ipairs(languages[currentLanguage].translationTable) do
			if isBroken then 
				word=word:gsub(pair[1],pair[2])
			else
				--Check to see if we should use upper or lowercase.
				if word:gsub(string.upper(pair[1]), string.upper(pair[2])) ~= word then
					word=word:gsub(string.upper(pair[1]), string.upper(pair[2]))
				else
					word = word:gsub(pair[1],pair[2])
				end
			end
		end

    -- Return the original word if no translation found
		return word
	end

	function encryptWords(msg)
		local words = {}


		-- Using string.gmatch to iterate over words separated by spaces
		for word in msg:gmatch("[%w]+") do
			table.insert(words, word)
		end

		local translatedWords={}
		for i, word in ipairs(words) do
			translation = languages[currentLanguage].translationTable[math.random(#languages[currentLanguage].translationTable)]
			table.insert(translatedWords, translation)
		end	
	
		--finalC = final character
		finalC=""
		if string.find(msg:sub(#msg, #msg), '%p') then
			finalC = msg:sub(#msg,#msg)
		end
	
	
		return table.concat(translatedWords, " ")..finalC
	
	end

	
	--Actual function called to encrypt messages
	function encryptMsg(msg)
		transFunction = languages[currentLanguage].translationFunction
		
		
		return transFunction(msg)
		
		
		
	end

	function XORCipher(message)
		key = "hellotreantspeakisawesomeandsoiskoalaandsparaandcoppertheyarewickedcoolthoseguys"
		local encrypted = {}
		local keyLength = #key
		for i = 1, #message do
			local keyByte = key:byte((i - 1) % keyLength + 1)
			local messageByte = message:byte(i)
			encrypted[i] = string.char(bit.bxor(messageByte, keyByte))
		end
		return table.concat(encrypted)
	end

	function encryptAddonMessage(msg, key)
		local encrypted = {}
		for i=1, #message do
			local keyVal = key:byte((i-1)%#key + 1)
			local messageChar = message:byte(i)
			encrypted[i] = string.char(bit32.bxor(messageChar, keyVal))
		end
		return table.concat(encrypted)
	end


--> Utility functions
	function capitalizeFirstLetter(str)
		if str == nil or str == "" then
			return str
		end
		local firstLetter = string.sub(str, 1, 1)
		local restOfString = string.sub(str, 2)
		return string.upper(firstLetter) .. restOfString
	end


	function contains(inTable, value)

		for i, val in ipairs(inTable) do
			if val == value then
				return true
			end
		end
		return false
	end


	function playerHasBuff(buffTable)
		for i = 1, 40 do
			local buff = C_UnitAuras.GetBuffDataByIndex("player", i)
			if not buff then
				break  -- Exit the loop if there are no more buffs
			end
			if contains(buffTable, buff.name) then
				return true  -- Buff found
			end
		end
		return false  -- Buff not found
	end

	function canSpeakOrUnderstand(lan)
		lan = string.upper(lan)
		
		--Do we know this language? If not, return false
		if contains(treantSettings['languages'], lan) == false then
			return false
		end

		--If there are no buff requirements, return true
		if languages[lan].buffRequirements == nil then
			return true
		end

		--If we know this language, see if we have any of the buffs.
		validBuffs = languages[lan].buffRequirements
	
		return playerHasBuff(validBuffs)
	end




--~ 


--> Addon Loaded
	local function OnAddonLoaded(event, addonName, ...)
		-- Check if the loaded addon is your addon
		local str=...
		if str =="Treant_Speak" then
			loadSavedVariable()
			
			for key, value in pairs(treantSettings["languages"]) do
				table.insert(dropdown_items, {text=value, func= function() changeLanguage(value) end })
			end
		
		
		end
	end

	function loadSavedVariable()
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

--> Buffs Updated
	local function buffsUpdated(self, event, unit)
		if unit=="PLAYER" then
			if currentLanguage~="NONE" and not canSpeakOrUnderstand(currentLanguage) then
				print("You can no longer speak that language.")
				currentLanguage='NONE'
			end
		end
	end

------- EVENT DECLARATIONS --------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnAddonLoaded)

local auraFrame = CreateFrame("Frame")
auraFrame:RegisterEvent("UNIT_AURA")
auraFrame:SetScript("OnEvent", buffsUpdated)



languages = {
	["NONE"] = {
		buffRequirements = nil, 
		isRealLanguage=false, 
		translationFunction = nil, 
		translationTable=nil
	},
	['TREANT'] = {
		buffRequirements = {"Mark of the Wild", "Treant Form", "Marca de lo Salvaje"}, 
		isRealLanguage=true, 
		translationFunction=encryptLetters, 
		translationTable=englishToTreant
	},
	['FELINE'] = {
		buffRequirements = {"Mark of the Wild", "Cat Form", "Marca de lo Salvaje"}, 
		isRealLanguage=true, 
		translationFunction=encryptWords, 
		translationTable=felineTranslations
	},
	['BEAR'] = {
		buffRequirements = {"Mark of the Wild", "Bear Form", "Marca de lo Salvaje"}, 
		isRealLanguage=true, 
		translationFunction=encryptWords, 
		translationTable=bearTranslations
	},
	['SNOWMAN'] = {
		buffRequirements = nil, 
		isRealLanguage=true, 
		translationFunction=encryptWords, 
		translationTable=snowmanTranslations
	},
	['ZOMBIE'] = {
		buffRequirements = nil, 
		isRealLanguage=true, 
		translationFunction=encryptWords, 
		translationTable=zombieTranslations
	}
}
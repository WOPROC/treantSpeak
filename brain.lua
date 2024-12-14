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

local snowmanTranslations = {
"snow", "Snow", "snow!", "Snow, snow. Snow!"
}

local duckTranslations = {
"Quack", "Quackity quack", "Quack quack?", "Quack!", "...", "Quack!!", "quack quack quack"
}

local canineTranslations = {
"Woof", "WOOF", "Woof woof woof", "Bark bark", "bark", "BARK...? Woof woof!", "woof, woof woof... woof!", "woof woof", "woof"
}

local demonicTranslations = {
    ["A"] = "",
	["E"] = "",
	["I"] = "",
	["O"] = "",
	["U"] = "",
	["X"] = "",
	["Y"] = "",
	["Az"] = "",
	["Il"] = "",
	["Me"] = "",
	["Re"] = "",
	["Te"] = "",
	["Ul"] = "",
	["Ur"] = "",
	["Xi"] = "",
	["Za"] = "",
	["Ze"] = "",
	["Asj"] ="", 
	["Daz"] = "",
	["Gul"]="",
	["Kar"] = "",
	["Laz"] = "",
	["Lek"] = "",
	["Lok"] = "",
	["Maz"] = "",
	["Ril"] = "",
	["Ruk"] = "",
	["Shi"] = "",
	["Tor"] = "",
	["Zar"] = "",
	["Alar"] = "",
	["Aman"] = "",
	["Amir"] = "",
	["Ante"] = "", 
	["Ashj"] = "",
	["Kiel"] = "", 
	["Maev"] = "", 
	["Maez"] = "", 
	["Orah"] = "", 
	["Parn"] = "", 
	["Raka"] = "", 
	["Rikk"] = "", 
	["Veni"] = "", 
	["Zenn"] = "", 
	["Zila"] = "",
	["Adare"] = "", 
	["Belan"] = "", 
	["Buras"] = "", 
	["Enkil"] = "", 
	["Golad"] = "", 
	["Gular"]="",
	["Kamil"] = "", 
	["Melar"] = "", 
	["Modas"] = "",
	["Nagas"] = "", 
	["Rakir"] = "", 
	["Refir"] = "", 
	["Revos"] = "", 
	["Soran"] = "", 
	["Tiros"] = "", 
	["Zekul"] = "",
   ["Arakal"] = "",
    ["Archim"] = "",
    ["Azgala"] = "",
    ["Karkun"] = "",
    ["Kazile"] = "",
    ["Mannor"] = "",
    ["Mishun"] = "",
    ["Rakkan"] = "",
    ["Rakkas"] = "",
    ["Rethul"] = "",
    ["Revola"] = "",
    ["Thorje"] = "",
    ["Tichar"] = "",
    ["Amanare"] = "",
    ["Belaros"] = "",
    ["Danashj"] = "",
    ["Faramos"] = "",
    ["Gulamir"] = "",
    ["Karaman"] = "",
    ["Kieldaz"] = "",
    ["Rethule"] = "",
    ["Tiriosh"] = "",
    ["Toralar"] = "",
    ["Zennshi"] = "",
    ["Amanalar"] = "",
    ["Ashjraka"] = "",
    ["Azgalada"] = "",
    ["Azrathud"] = "",
    ["Belankar"] = "",
    ["Enkilzar"] = "",
    ["Kirasath"] = "",
    ["Maladath"] = "",
    ["Mordanas"] = "",
    ["Romathis"] = "",
    ["Rukadare"] = "",
    ["Sorankar"] = "",
    ["Theramas"] = "",
    ["Arakalada"] = "",
    ["Kanrethad"] = "",
    ["Melarorah"] = "",
    ["Nagasraka"] = "",
    ["Naztheros"] = "",
    ["Soranaman"] = "",
    ["Teamanare"] = "",
    ["Zilthuras"] = "",
    ["Amanemodas"] = "",
    ["Ashjrethul"] = "",
    ["Benthadoom"] = "",
    ["Burasadare"] = "",
    ["Enkilgular"] = "",
    ["Kamilgolad"] = "",
    ["Matheredor"] = "",
    ["Melarnagas"] = "",
    ["Pathrebosh"] = "",
    ["Ticharamir"] = "",
    ["Zennrakkan"] = "",
    ["Archimtiros"] = "",
    ["Ashjrakamas"] = "",
    ["Kamilgolad"] = "",
    ["Mannorgulan"] = "",
    ["Mishunadare"] = "",
    ["Zekulrakkas"] = "",
    ["Zennshinaga"] = "",	
	['Archimonde'] = 'archimonde',
	["Kil"] = "kil",
	["jaeden"] = 'jaeden',
	['Sargeras'] = 'sargeras',
	['Draenei'] = 'draenei',
	['Ei'] = 'one',
	['Eis'] = 'ones',
	['Or'] = 'refuge',
	['Draenor'] = 'draenor',
	['Anach kyree'] = 'insect',
	['A-rul shach kigon'] = 'i will eat your heart',
	["Man'ari"] = 'unnatural',
	['Krosnis'] = 'furnace',
	['Katra'] = 'suffer',
	['zil'] = 'and',
	['Shukil'] = 'perish',
	['Rakeesh'] = 'butcher',
	["Shaza-kiel!"] = 'surrender',
	['Shat'] = 'light',
	['Shattrath'] = 'dwelling of light',
	['Ruin'] = 'guard',
	["Ered'ruin"] = 'doomguard'
}

local horseTranslations = {
	"Neigh", "Neigh~!", "Neigh", "Neigh neigh", "Neigh!", "Neigh...", "neigh", "neigh", "neigh", "Neigh neigh neigh", "neigh", "neigh"
}


--~ Local ~--
local defaultValues = {
	["speakLanguageInParty"] = false,
	["displayUntranslatedMessages"] = true,
	["displayTranslated"] = true,
	["showErrorMsgs"]=true,
	--Known languages
	['languages']={"NONE", "TREANT", "FELINE", 'BEAR'},
	--Custom languages
	['customLanguages'] = {}
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
			if not treeFrame:IsVisible() then
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

--> Translator Methods

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

	--Given a word, encrypt it to a new word.
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
	
	
	
	--If an english word appears in the table, translate it to the corresponding translation.
	--If not, randomly select a word with no english equivalent, with a higher probability if the word
	--is close in length
	--ex: A 4 letter word with no translation would have the highest probabilty to be translated to a 3,4, or 5 letter word.
	function complexEncryptWords(msg)
		t_translationTable = languages[currentLanguage].translationTable
		--STEP 1: Translate words & phrases that have meaning
		t_phraseList= {}
		t_ignore = {}
		t_masterTranslatorTable = { {}, {}, {}, {}, {}, {}, {} }
		for translatedWord, englishWord in pairs(t_translationTable) do
			if englishWord ~= "" then
				t_phraseList[englishWord] = translatedWord
				appendPhraseToTable(t_ignore, translatedWord)
				appendPhraseToTable(t_ignore, string.upper(translatedWord))
			else
				local count = #translatedWord
				--If our word is longer than 7 characters, we instead just say its 7 characters.
				--This is because creating more lists for words greater than 7 characters is purely
				--wasteful, and adds more variety to potential translations (instead of restricting them
				--to obscenely long messages)
				if count > 7 then
					count=7
				end
				
				table.insert(t_masterTranslatorTable[count], translatedWord)
			end
		end
		
		local newMsgA= swapKeysToValues(t_phraseList, msg)
		local newSentence = {}
		
		for word, punctuation in newMsgA:gmatch("(%w+)(%p*)") do
			if not contains(t_ignore, word) then
				local chances = {1,2,3,4,5,6,7}
				local chance1 = #word - 1
				local chance2 = #word
				local chance3 = #word+1
						
				if chance1 == 0 then
					chance1 = #word
				elseif chance3 == 8 then
					chance3 = #word
				end
						
				for i=1,7 do
							if i<2 then
								table.insert(chances,chance1)
							elseif i<5 then
								table.insert(chances, chance2)
							else
								table.insert(chances,chance3)
							end
						end
				
				local desiredIndex = math.random(#chances)
				local desiredTable = t_masterTranslatorTable[chances[desiredIndex]]

				
				if desiredTable and #desiredTable > 0 then
					local desiredTranslationIndex = math.random(#desiredTable)
					local fVal = desiredTable[desiredTranslationIndex]
					if(string.upper(word) == word) then
						temp = string.upper(fVal)
						fVal = temp
					end
					table.insert(newSentence, fVal..punctuation)
				end

						
			
			else
				table.insert(newSentence, word)
			end
		end

	
		local finalSentence = table.concat(newSentence, " ")
		return capitalizeFirstLetter(finalSentence) 
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
	
	function contains_lookAtValue(inTable, value)
		for key, val in pairs(inTable) do
			if val==value then
				return true
			end
		end
		return false
	end

    function replaceValueWithKey(t_table, s_value)
		-- Look up the value in our translation table and return the corresponding key
		for key, val in pairs(t_table) do
			if val == s_value then
				return key  -- Return the key if the value matches
			end
		end
		return s_value  -- Return the original value if no match is found
	end
	
function swapKeysToValues(t_table, s_sentence)
    -- Create a sorted list of keys, sorted by length in descending order
    local sortedKeys = {}
    for key in pairs(t_table) do
        table.insert(sortedKeys, key)
    end
    table.sort(sortedKeys, function(a, b) return #a > #b end)

    -- Iterate through the sentence word by word
    local result = s_sentence:gsub("(%f[%w]%w+%f[%W])", function(match)
        -- Search for the match in the keys, case-insensitively
	    for _, key in ipairs(sortedKeys) do
            if string.lower(match) == string.lower(key) then
                local replacement = t_table[key]

                -- Match case of replacement to match
                if (string.upper(match) == match) or (countUppercase(match) > (#match/2) -1) then
                    return string.upper(replacement)
				else
                    return replacement
                end
            end
        end

        -- If no match, return the original word
        return match
    end)

    return result
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

	function appendPhraseToTable(t_table, s_phrase)
		for word in s_phrase:gmatch("%w+") do
			table.insert(t_table, word)
		end
	end

	function countUppercase(str)
		local count = 0
		for i = 1, #str do
			local char = str:sub(i, i)
			if char:match("%u") then
				count = count + 1
			end
		end
		return count
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
				setTranslation(false,nil)
			end
		end
	end

------- EVENT DECLARATIONS --------------------

local onLoadFrame = CreateFrame("Frame")
onLoadFrame:RegisterEvent("ADDON_LOADED")
onLoadFrame:SetScript("OnEvent", OnAddonLoaded)

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
	},
	['DUCK'] = 
	{
		buffRequirements=nil,
		isRealLanguage=true,
		translationFunction=encryptWords,
		translationTable=duckTranslations
	},
	['CANINE'] = 
	{
		buffRequirements=nil,
		isRealLanguage=true,
		translationFunction=encryptWords,
		translationTable=canineTranslations
	},
	['DEMONIC'] = 
	{
		buffRequirements = nil,
		isRealLanguage=true,
		translationFunction=complexEncryptWords,
		translationTable = demonicTranslations
	},
	['HORSE'] = 
	{
		buffRequirements = nil,
		isRealLanguage=true,
		translationFunction=encryptWords,
		translationTable = horseTranslations
	}
}
local englishToTreant = {
    { "the", "anzu" },
    { "THE", "ANZU" },
    { "you", "nua" },
    { "YOU", "NUA" },
    { "he", "nua" },
    { "HE", "NUA" },
    { "i", "nua" },
    { "I", "NUA" },
    { "she", "nua" },
    { "SHE", "NUA" },
    { "they", "nua" },
    { "THEY", "NUA" },
    { "them", "nua" },
    { "THEM", "NUA" },
    { "can", "auchi" },
    { "CAN", "AUCHI" },
    { "ca", "ki" },
    { "CA", "KI" },
    { "why", "auchi" },
    { "WHY", "AUCHI" },
    { "nth", "ki" },
    { "NTH", "KI" },
    { "sch", "ki" },
    { "SCH", "KI" },
    { "cl", "pi" },
    { "CL", "PI" },
    { "scr", "pu" },
    { "SCR", "PU" },
    { "spl", "sria" },
    { "SPL", "SRIA" },
    { "thr", "mux" },
    { "THR", "MUX" },
    { "bl", "luia" },
    { "BL", "LUIA" },
    { "br", "vz" },
    { "BR", "VZ" },
    { "qu", "abi" },
    { "QU", "ABI" },
    { "in", "zu" },
    { "IN", "ZU" },
    { "en", "vu" },
    { "EN", "VU" },
    { "ch", "pi" },
    { "CH", "PI" },
    { "sh", "zk" },
    { "SH", "ZK" },
    { "ti", "yz" },
    { "TI", "YZ" },
    { "be", "yurtz" },
    { "BE", "YURTZ" },
    { "am", "via" },
    { "AM", "VIA" },
    { "have", "ex" },
    { "HAVE", "EX" },
    { "not", "vu" },
    { "NOT", "VU" },
    { "yes", "ual" },
    { "YES", "UAL" },
    { "no", "yue" },
    { "NO", "YUE" },
    { "would", "vuu" },
    { "WOULD", "VUU" },
    { "s", "pipi" },
    { "S", "PIPI" },
    { "e", "pipie" },
    { "E", "PIPIE" },
    { "o", "lu" },
    { "O", "LU" },
    { "r", "ku" },
    { "R", "KU" },
    { "l", "ziula" },
    { "L", "ZIULA" },
    { "t", "vii" },
    { "T", "VII" },
    { "d", "m" },
    { "D", "M" },
    { "b", "ki" },
    { "B", "KI" },
    { "c", "pi" },
    { "C", "PI" },
    { "f", "p" },
    { "F", "P" },
    { "g", "i" },
    { "G", "I" },
    { "j", "u" },
    { "J", "U" },
    { "m", "pipo" },
    { "M", "PIPO" },
    { "q", "ak" },
    { "Q", "AK" },
    { "v", "i" },
    { "V", "I" },
    { "w", "ke" },
    { "W", "KE" },
    { "x", "ko" },
    { "X", "KO" },
    { "y", "i" },
    { "Y", "I" },
    { "za", "pi" },
    { "ZA", "PI" },
    { "h", "ooa" },
    { "H", "OOA" }
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
"snow", "Snow", "snow!"
}

local byLetter={'TREANT'}


local translationTables = {
['TREANT']=englishToTreant,
['FELINE']=felineTranslations,
['BEAR']=bearTranslations,
['ZOMBIE']=zombieTranslations,
['SNOWMAN']=snowmanTranslations
}

local function capitalizeRandomly(char)
    local rand = math.random(4) -- Generate random number: 1, 2, 3, or 4
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
        brokenWord = brokenWord .. capitalizeRandomly(word:sub(i, i))
    end
    return brokenWord
end


function encryptLetters(word, tTable)
	if isBroken then
		word=breakWord(word)
	end
	for _, pair in ipairs(tTable) do
		if not isBroken or (isBroken and string.lower(pair[1]) == pair[1]) then 
			word=word:gsub(pair[1],pair[2])
		end
	end

    -- Return the original word if no translation found
    return word
end

function encryptWords(msg, tTable)
	local words = {}

	-- Using string.gmatch to iterate over words separated by spaces
	for word in msg:gmatch("[%w]+") do
		table.insert(words, word)
	end

	local translatedWords={}
	for i, word in ipairs(words) do
		translation = tTable[math.random(#tTable)]
		table.insert(translatedWords, translation)
	end	
	
	finalC=str:sub(#str, #str)
	lastCharacter=""
	if finalC=="?" or finalC=="!" or finalC=="." then
		lastCharacter=finalC
	end
	
	
	return table.concat(translatedWords, " ")..lastCharacter
end


function encryptMsg(message, language)
	str = message
	if contains(byLetter,language) then
		return encryptLetters(str,translationTables[language])
	else
		return encryptWords(message,translationTables[language])
	end
	return str

end



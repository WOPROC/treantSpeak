local englishToTreant = {
	["the "] = "anzu ",
    ["you "] = "NUA ",
    ["he"] = "nua ",
    ["i "] = "nua ",
    ["she"] = "nua ",
    ["they"] = "nua",
    ["them"] = "nua",
    ["why"] = "auchi",
    ["nth"] = "ki",
    ["sch"] = "ki",
    ["cl"] = "pi",
    ["scr"] = "pu",
    ["spl"] = "sria",
    ["thr"] = "mux",
    ["bl"] = "luia",
    ["br"] = "vz",
    ["qu"] = "abi",
    ["in"] = "zu",
    ["en"] = "vu",
    ["ch"] = "pi",
    ["sh"] = "zk",
    ["ti"] = "yz",
    ["be"] = "yurtz",
    ["am"] = "via",
    ["have"] = "ex",
    ["not"] = "vu",
    ["yes"] = "ual",
    ["no"] = "yue",
    ["would"] = "vuu",
    ["s"] = "pipi",
    ["e"] = "z",
    ["o"] = "lu",
    ["r"] = "ku",
    ["i"] = "ki",
    ["l"] = "zi",
    ["t"] = "vii",
    ["d"] = "muu",
    ["b"] = "ki",
    ["c"] = "pi",
    ["f"] = "p",
    ["g"] = "i",
    ["j"] = "u",
    ["m"] = "pipo",
    ["p"] = "k",
    ["q"] = "i",
    ["v"] = "i",
    ["w"] = "ke",
    ["x"] = "ko",
    ["y"] = "i",
    ["z"] = "pi",
	['h']='ooa'
}


function encryptMsg(message)
	str = message
	for k,v in pairs(englishToTreant) do
		str=str:gsub(k,v)
	end
	return str

end
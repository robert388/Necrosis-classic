--[[
    Necrosis LdC
    Copyright (C) - copyright file included in this release
--]]
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

local new, del
do
	local cache = setmetatable({}, {__mode='k'})
	function new(populate, ...)
		local tbl
		local t = next(cache)
		if ( t ) then
			cache[t] = nil
			tbl = t
		else
			tbl = {}
		end
		if ( populate ) then
			local num = select("#", ...)
			if ( populate == "hash" ) then
				assert(math.fmod(num, 2) == 0)
				local key
				for i = 1, num do
					local v = select(i, ...)
					if not ( math.fmod(i, 2) == 0 ) then
						key = v
					else
						tbl[key] = v
						key = nil
					end
				end
			elseif ( populate == "array" ) then
				for i = 1, num do
					local v = select(i, ...)
					table.insert(tbl, i, v)
				end
			end
		end
		return tbl
	end
	function del(t)
		for k in next, t do
			t[k] = nil
		end
		cache[t] = true
	end
end

--[[
 This table lists the spells used with rank.
 The API to return spell info does NOT return the rank which sucks BIG time so this table will 
 hard code them.
 This is the overall list, the player spell book will also be parsed.
 
Notes:
- Created stones are looked for by localized name. The name does NOT include the rank / quality of the stone.
  The stone ids & links are provided but may not be used in the code
 
- Type of timer
		-- Type 0 = Pas de Timer || no timer
		-- Type 1 = Timer permanent principal || Standing main timer
		-- Type 2 = Timer permanent || main timer
		-- Type 3 = Timer de cooldown || cooldown timer
		-- Type 4 = Timer de malédiction || curse timer
		-- Type 5 = Timer de corruption || corruption timer
		-- Type 6 = Timer de combat || combat timer

--]]
Necrosis.Warlock_Spells = {
	-- ::: Summon something
	[5784]	= {UsageRank = 0, SpellRank = 0, Type = 0, Usage = ""}, -- Felsteed  mount
	[23161]	= {UsageRank = 0, SpellRank = 0, Type = 0, Usage = ""}, -- Dreadsteed mount
	[688]	= {UsageRank = 0, SpellRank = 0, Type = 0, Usage = "imp"}, -- Imp || Diablotin
	[697]	= {UsageRank = 0, SpellRank = 0, Type = 0, Usage = "voidwalker"}, -- Voidwalker || Marcheur
	[712]	= {UsageRank = 0, SpellRank = 0, Type = 0, Usage = "succubus"}, -- Succubus || Succube
	[691]	= {UsageRank = 0, SpellRank = 0, Type = 0, Usage = "felhunter"}, -- Felhunter
	[1122]	= {UsageRank = 0, SpellRank = 0, Type = 3, Usage = ""}, -- Inferno || https://classicdb.ch/?spell=1122

	[18540] = {UsageRank = 0, SpellRank = 0, Type = 3, Usage = ""}, -- Ritual of Doom || Rituel funeste || https://classicdb.ch/?spell=18540
	
	-- ::: Stones
	-- Create Soulstone minor || Création pierre d'âme
	[693]   = {UsageRank = 1, SpellRank = 1, Type = 0, Usage = "soulstone"}, -- minor 18|| https://classicdb.ch/?spell=693 || https://classicdb.ch/?item=5232
	[20752] = {UsageRank = 2, SpellRank = 2, Type = 0, Usage = "soulstone"}, -- lesser 30|| https://classicdb.ch/?spell=20752 || https://classicdb.ch/?item=16892
	[20755] = {UsageRank = 3, SpellRank = 3, Type = 0, Usage = "soulstone"}, -- 40 || https://classicdb.ch/?spell=20755 || https://classicdb.ch/?item=16893
	[20756] = {UsageRank = 4, SpellRank = 4, Type = 0, Usage = "soulstone"}, -- greater 50|| https://classicdb.ch/?spell=20756 || https://classicdb.ch/?item=16895
	[20757] = {UsageRank = 5, SpellRank = 5, Type = 0, Usage = "soulstone"}, -- major 60|| https://classicdb.ch/?spell=20757 || https://classicdb.ch/?item=16896
	-- Create Healthstone minor || Création pierre de soin
	[6201]	= {UsageRank = 1, SpellRank = 1, Type = 0, Usage = "healthstone"}, -- minor 10 || https://classicdb.ch/?spell=6201 ||
	[6202]	= {UsageRank = 2, SpellRank = 2, Type = 0, Usage = "healthstone"}, -- lesser 22 || https://classicdb.ch/?spell=6202 ||
	[5699]	= {UsageRank = 3, SpellRank = 3, Type = 0, Usage = "healthstone"}, -- 34 || https://classicdb.ch/?spell=5699 ||
	[11729]	= {UsageRank = 4, SpellRank = 4, Type = 0, Usage = "healthstone"}, -- greater 46 || https://classicdb.ch/?spell=11729||
	[11730]	= {UsageRank = 5, SpellRank = 5, Type = 0, Usage = "healthstone"}, -- major 58 || https://classicdb.ch/?spell=11730 ||
	-- Create Spellstone || Création pierre de sort
	[2362]	= {UsageRank = 1, SpellRank = 1, Type = 0, Usage = "spellstone"}, -- 36 || https://classicdb.ch/?spell=2362 || https://classicdb.ch/?item=5522
	[17727]	= {UsageRank = 2, SpellRank = 2, Type = 0, Usage = "spellstone"}, -- 48 || https://classicdb.ch/?spell=17727 || https://classicdb.ch/?item=13602
	[17728]	= {UsageRank = 3, SpellRank = 3, Type = 0, Usage = "spellstone"}, -- 60 || https://classicdb.ch/?spell=17728 || https://classicdb.ch/?item=13603
	-- Create Firestone || Création pierre de feu
	[6366]  = {UsageRank = 1, SpellRank = 1, Type = 0, Usage = "firestone"}, -- 28 || https://classicdb.ch/?spell=6366 || http://classicdb.ch/?item=1254
	[17951] = {UsageRank = 2, SpellRank = 2, Type = 0, Usage = "firestone"}, -- 36 || https://classicdb.ch/?spell=17951 || https://classicdb.ch/?item=13699
	[17952] = {UsageRank = 3, SpellRank = 3, Type = 0, Usage = "firestone"}, -- 46 || https://classicdb.ch/?spell=17952 || https://classicdb.ch/?item=13700
	[17953] = {UsageRank = 4, SpellRank = 4, Type = 0, Usage = "firestone"}, -- 56 || https://classicdb.ch/?spell=17953 || https://classicdb.ch/?item=13701

	-- ::: Buffs
	[706]	= {UsageRank = 3, SpellRank = 1, Type = 0, Usage = "armor"}, -- Demon Armor || Armure démoniaque
	[1086]	= {UsageRank = 4, SpellRank = 2, Type = 0, Usage = "armor"}, -- 
	[11733] = {UsageRank = 5, SpellRank = 3, Type = 0, Usage = "armor"}, -- 
	[11734] = {UsageRank = 6, SpellRank = 4, Type = 0, Usage = "armor"}, -- 
	[11735] = {UsageRank = 7, SpellRank = 5, Type = 0, Usage = "armor"}, -- 
	[5697]	= {UsageRank = 1, SpellRank = 0, Type = 0, Usage = "breath"}, -- Unending Breath || Respiration interminable
	[698]	= {UsageRank = 1, SpellRank = 0, Type = 3, Usage = "summon"}, -- Ritual of Summoning || Rituel d'invocation
	[19028] = {UsageRank = 1, SpellRank = 0, Type = 0, Usage = "link"}, -- Soul Link || Lien spirituel

	[6229]	= {UsageRank = 1, SpellRank = 1, Type = 0, Usage = "ward"}, -- Shadow Ward || Gardien de l'ombre
	[11739] = {UsageRank = 2, SpellRank = 2, Type = 0, Usage = "ward"}, -- 
	[11740] = {UsageRank = 3, SpellRank = 3, Type = 0, Usage = "ward"}, -- 
	[28610] = {UsageRank = 4, SpellRank = 4, Type = 0, Usage = "ward"}, -- 

	[1098] 	= {UsageRank = 1, SpellRank = 1, Type = 2, Usage = "enslave"}, -- Enslave Demon
	[11725] = {UsageRank = 2, SpellRank = 2, Type = 2, Usage = "enslave"}, -- 
	[11726] = {UsageRank = 3, SpellRank = 3, Type = 2, Usage = "enslave"}, --  

	[710]	= {UsageRank = 1, SpellRank = 1, Type = 2, Usage = "banish"}, -- Banish 
	[18647] = {UsageRank = 2, SpellRank = 2, Type = 2, Usage = "banish"}, --  

	-- Detect Invisibility || Détection de l'invisibilité
	[132]	= {UsageRank = 1, SpellRank = 1, Type = 0, Usage = "invisible"}, -- 26 || https://classicdb.ch/?spell=132
	[2970]	= {UsageRank = 2, SpellRank = 2, Type = 0, Usage = "invisible"}, -- 38 || https://classicdb.ch/?spell=2970
	[11743]	= {UsageRank = 3, SpellRank = 3, Type = 0, Usage = "invisible"}, -- 50 || https://classicdb.ch/?spell=11743
	
	-- ::: Curses
	[702]	= {UsageRank = 1, SpellRank = 1, Type = 4, Usage = "weakness"}, -- Curse of Weakness || Malédiction Faiblesse 
	[1108]	= {UsageRank = 2, SpellRank = 2, Type = 4, Usage = "weakness"}, --  
	[6205]	= {UsageRank = 3, SpellRank = 3, Type = 4, Usage = "weakness"}, --  
	[7646]	= {UsageRank = 4, SpellRank = 4, Type = 4, Usage = "weakness"}, --  
	[11707] = {UsageRank = 5, SpellRank = 5, Type = 4, Usage = "weakness"}, --  
	[11708] = {UsageRank = 6, SpellRank = 6, Type = 4, Usage = "weakness"}, --  

	[980]	= {UsageRank = 1, SpellRank = 1, Type = 4, Usage = "agony"}, -- Curse of Agony || Malédiction Agonie 
	[1014]	= {UsageRank = 2, SpellRank = 2, Type = 4, Usage = "agony"}, --  
	[6217]	= {UsageRank = 3, SpellRank = 3, Type = 4, Usage = "agony"}, --  
	[11711] = {UsageRank = 4, SpellRank = 4, Type = 4, Usage = "agony"}, --  
	[11712] = {UsageRank = 5, SpellRank = 5, Type = 4, Usage = "agony"}, --  
	[11713] = {UsageRank = 6, SpellRank = 6, Type = 4, Usage = "agony"}, --  

	[1714]	= {UsageRank = 1, SpellRank = 1, Type = 4, Usage = "tongues"}, -- Curse of Tongues || Malédiction Langage 
	[11719] = {UsageRank = 2, SpellRank = 2, Type = 4, Usage = "tongues"}, --  

	[18223] = {UsageRank = 1, SpellRank = 0, Type = 4, Usage = "exhaustion"}, -- Curse of Exhaustion || Malédiction de fatigue

	[1490]	= {UsageRank = 1, SpellRank = 1, Type = 4, Usage = "elements"}, -- Curse of the Elements || Malédiction Eléments 
	[11721] = {UsageRank = 2, SpellRank = 2, Type = 4, Usage = "elements"}, --  
	[11722] = {UsageRank = 3, SpellRank = 3, Type = 4, Usage = "elements"}, --  

	[603]	= {UsageRank = 1, SpellRank = 0, Type = 3, Usage = "doom"}, -- Curse of Doom || Malédiction funeste 

	[172]	= {UsageRank = 1, SpellRank = 1, Type = 5, Usage = "corruption"}, -- Corruption 
	[6222]	= {UsageRank = 2, SpellRank = 2, Type = 5, Usage = "corruption"}, --  
	[6223]	= {UsageRank = 3, SpellRank = 3, Type = 5, Usage = "corruption"}, --  
	[7648]	= {UsageRank = 4, SpellRank = 4, Type = 5, Usage = "corruption"}, --  
	[11671] = {UsageRank = 5, SpellRank = 5, Type = 5, Usage = "corruption"}, --  
	[11672] = {UsageRank = 6, SpellRank = 6, Type = 5, Usage = "corruption"}, --  
	[25311] = {UsageRank = 7, SpellRank = 7, Type = 5, Usage = "corruption"}, --  

	-- ::: Spells
	[20707] = {UsageRank = 0, SpellRank = 1, Type = 1, Usage = ""}, -- Soulstone Resurrection || Résurrection de pierre d'ame
	[20762] = {UsageRank = 0, SpellRank = 2, Type = 1, Usage = ""}, -- 
	[20763] = {UsageRank = 0, SpellRank = 3, Type = 1, Usage = ""}, -- 
	[20764] = {UsageRank = 0, SpellRank = 4, Type = 1, Usage = ""}, -- 
	[20765] = {UsageRank = 0, SpellRank = 5, Type = 1, Usage = ""}, -- 
	[348]	= {UsageRank = 0, SpellRank = 1, Type = 6, Usage = ""}, -- Immolate 
	[707]	= {UsageRank = 0, SpellRank = 2, Type = 6, Usage = ""}, --  
	[1094]	= {UsageRank = 0, SpellRank = 3, Type = 6, Usage = ""}, --  
	[2941]	= {UsageRank = 0, SpellRank = 4, Type = 6, Usage = ""}, --  
	[11665] = {UsageRank = 0, SpellRank = 5, Type = 6, Usage = ""}, --  
	[11667] = {UsageRank = 0, SpellRank = 6, Type = 6, Usage = ""}, --  
	[11668] = {UsageRank = 0, SpellRank = 7, Type = 6, Usage = ""}, --  
	[25309] = {UsageRank = 0, SpellRank = 8, Type = 6, Usage = ""}, --  
	[5782]	= {UsageRank = 0, SpellRank = 1, Type = 6, Usage = ""}, -- Fear 
	[6213]	= {UsageRank = 0, SpellRank = 2, Type = 6, Usage = ""}, --  
	[6215]	= {UsageRank = 0, SpellRank = 3, Type = 6, Usage = ""}, --  
	[18708] = {UsageRank = 1, SpellRank = 0, Type = 3, Usage = "domination"}, -- Fel Domination || Domination corrompue 
	[6353]	= {UsageRank = 0, SpellRank = 1, Type = 3, Usage = ""}, -- Soul Fire || Feu de l'âme 
	[17924] = {UsageRank = 0, SpellRank = 2, Type = 3, Usage = ""}, --  
	[6789]	= {UsageRank = 0, SpellRank = 1, Type = 3, Usage = ""}, -- Death Coil || Voile mortel 
	[17925] = {UsageRank = 0, SpellRank = 2, Type = 3, Usage = ""}, --  
	[17926] = {UsageRank = 0, SpellRank = 3, Type = 3, Usage = ""}, --  
	[17877] = {UsageRank = 0, SpellRank = 1, Type = 3, Usage = ""}, -- Shadowburn || Brûlure de l'ombre 
	[18867] = {UsageRank = 0, SpellRank = 2, Type = 3, Usage = ""}, --  
	[18868] = {UsageRank = 0, SpellRank = 3, Type = 3, Usage = ""}, --  
	[18869] = {UsageRank = 0, SpellRank = 4, Type = 3, Usage = ""}, --  
	[18870] = {UsageRank = 0, SpellRank = 5, Type = 3, Usage = ""}, --  
	[18871] = {UsageRank = 0, SpellRank = 6, Type = 3, Usage = ""}, --  
	[17962] = {UsageRank = 0, SpellRank = 1, Type = 3, Usage = ""}, -- Conflagration 
	[18930] = {UsageRank = 0, SpellRank = 2, Type = 3, Usage = ""}, --  
	[18931] = {UsageRank = 0, SpellRank = 3, Type = 3, Usage = ""}, --  
	[18932] = {UsageRank = 0, SpellRank = 4, Type = 3, Usage = ""}, --  
	[704]	= {UsageRank = 0, SpellRank = 0 , Type = 0, Usage = ""}, -- Curse of Recklessness - removed in patch 3.1 || Malédiction Témérité || 
	[7658]	= {UsageRank = 0, SpellRank = 0 , Type = 0, Usage = ""}, --  
	[7659]	= {UsageRank = 0, SpellRank = 0 , Type = 0, Usage = ""}, -- 
	[11717] = {UsageRank = 0, SpellRank = 0 , Type = 0, Usage = ""}, -- 
	[18265] = {UsageRank = 0, SpellRank = 1, Type = 6, Usage = ""}, -- Siphon Life || Syphon de vie 
	[18879] = {UsageRank = 0, SpellRank = 2, Type = 6, Usage = ""}, --  
	[18880] = {UsageRank = 0, SpellRank = 3, Type = 6, Usage = ""}, --  
	[18881] = {UsageRank = 0, SpellRank = 4, Type = 6, Usage = ""}, --  
	[5484]	= {UsageRank = 0, SpellRank = 1, Type = 3, Usage = ""}, -- Howl of Terror || Hurlement de terreur 
	[17928] = {UsageRank = 0, SpellRank = 2, Type = 3, Usage = ""}, --  
	[126]	= {UsageRank = 1, SpellRank = 0, Type = 0, Usage = "eye"}, -- Eye of Kilrogg
	[687]	= {UsageRank = 1, SpellRank = 1, Type = 0, Usage = "armor"}, -- Demon Skin || Peau de démon 
	[696]	= {UsageRank = 2, SpellRank = 2, Type = 0, Usage = "armor"}, --  
	[1454]	= {UsageRank = 0, SpellRank = 1, Type = 0, Usage = ""}, -- Life Tap || Connexion
	[1455]	= {UsageRank = 0, SpellRank = 2, Type = 0, Usage = ""}, -- 
	[1456]	= {UsageRank = 0, SpellRank = 3, Type = 0, Usage = ""}, -- 
	[11687] = {UsageRank = 0, SpellRank = 4, Type = 0, Usage = ""}, -- 
	[11688] = {UsageRank = 0, SpellRank = 5, Type = 0, Usage = ""}, -- 
	[11689] = {UsageRank = 0, SpellRank = 6, Type = 0, Usage = ""}, -- 
	[7812]	= {UsageRank = 0, SpellRank = 1, Type = 3, Usage = "sacrifice"}, -- Sacrifice || Sacrifice démoniaque 
	[19438] = {UsageRank = 0, SpellRank = 2, Type = 3, Usage = "sacrifice"}, --  
	[19440] = {UsageRank = 0, SpellRank = 3, Type = 3, Usage = "sacrifice"}, --  
	[19441] = {UsageRank = 0, SpellRank = 4, Type = 3, Usage = "sacrifice"}, --  
	[19442] = {UsageRank = 0, SpellRank = 5, Type = 3, Usage = "sacrifice"}, --  
	[19443] = {UsageRank = 0, SpellRank = 6, Type = 3, Usage = "sacrifice"}, --  
	[686]	= {UsageRank = 0, SpellRank = 1, Type = 0, Usage = ""}, -- Shadow Bolt
	[695]	= {UsageRank = 0, SpellRank = 2, Type = 0, Usage = ""}, -- 
	[705]	= {UsageRank = 0, SpellRank = 3, Type = 0, Usage = ""}, -- 
	[1088]	= {UsageRank = 0, SpellRank = 4, Type = 0, Usage = ""}, -- 
	[1106]	= {UsageRank = 0, SpellRank = 5, Type = 0, Usage = ""}, -- 
	[7641]	= {UsageRank = 0, SpellRank = 6, Type = 0, Usage = ""}, -- 
	[11659] = {UsageRank = 0, SpellRank = 7, Type = 0, Usage = ""}, -- 
	[11660] = {UsageRank = 0, SpellRank = 8, Type = 0, Usage = ""}, -- 
	[11661] = {UsageRank = 0, SpellRank = 9, Type = 0, Usage = ""}, -- 
	[25307] = {UsageRank = 0, SpellRank = 10, Type = 0, Usage = ""}, -- 
	[18220] = {UsageRank = 0, SpellRank = 1, Type = 0, Usage = ""}, -- Dark Pact || Pacte noir
	[18937] = {UsageRank = 0, SpellRank = 2, Type = 0, Usage = ""}, 
	[18938] = {UsageRank = 0, SpellRank = 3, Type = 0, Usage = ""}, 
	
	}
--[[
--]]
local pre  = Necrosis.Frame_Prefix
local post = Necrosis.Frame_Postfix
local pet_pre = Necrosis.Frame_Prefix_Pet

Necrosis.Warlock_Buttons = {
	-- Index is used as part of the button name
	["on_sphere"] = {
		[1] = {frame = pre.."Firestone"..post, 	btype = "", },
		[2] = {frame = pre.."Spellstone"..post,	btype = "", },
		[3] = {frame = pre.."Health"..post, 	btype = "", },
		[4] = {frame = pre.."Soul"..post, 		btype = "", },
		[5] = {frame = pre.."BuffMenu"..post,	btype = "menu", menu = "buffs", },
		[6] = {frame = pre.."Mount"..post, 		btype = "", },
		[7] = {frame = pre.."PetMenu"..post,	btype = "menu", menu = "pets", },
		[8] = {frame = pre.."CurseMenu"..post,	btype = "menu", menu = "curses", },
	},
	["buffs"] = {
		[1] = {frame = pre.."1", high_of = "armor", },
		[2] = {frame = pre.."2", high_of = "breath", },
		[3] = {frame = pre.."3", high_of = "invisible", },
		[4] = {frame = pre.."4", high_of = "eye", },
		[5] = {frame = pre.."5", high_of = "summoning", },
		[6] = {frame = pre.."6", high_of = "link", },
		[7] = {frame = pre.."7", high_of = "ward", },
		[8] = {frame = pre.."8", high_of = "banish", },
	},
	["pets"] = {
		[1] = {frame = pet_pre.."1", high_of = "domination", },
		[2] = {frame = pet_pre.."2", high_of = "imp", },
		[3] = {frame = pet_pre.."3", high_of = "voidwalker", },
		[4] = {frame = pet_pre.."4", high_of = "succubus", },
		[5] = {frame = pet_pre.."5", high_of = "felhunter", },
		[6] = {frame = pet_pre.."6", high_of = "ritual_doom", },
		[7] = {frame = pet_pre.."7", high_of = "enslave", },
		[8] = {frame = pet_pre.."8", high_of = "sacrifice", },
	},
	["curses"] = {
		[1] = {frame = pre.."1", high_of = "weakness", },
		[2] = {frame = pre.."2", high_of = "agony", },
		[3] = {frame = pre.."3", high_of = "tongues", },
		[4] = {frame = pre.."4", high_of = "exhaustion", },
		[5] = {frame = pre.."5", high_of = "elements", },
		[6] = {frame = pre.."6", high_of = "doom", },
		[7] = {frame = pre.."7", high_of = "corruption", },
	},
}
--]]
local function getManaCost(spellID) -- assume only the first mana cost found is needed for now
    if not spellID then return end
	local cost = 0
	local costTable = GetSpellPowerCost(spellID);
	if costTable == nil then
		return false
	end
	return table.foreach(costTable, function(k,v)  
		if v.name  == "MANA" then
			return v.cost;
		end 
	end )

end

function Necrosis:CreateSpellList()
--_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis- CreateSpellList")
	-- Add other attributes - Name, Length (Duratation / Cooldown), Mana cost, InSpellBook
	local sb = Necrosis.Warlock_Spells
	for id, v in pairs(sb) do
		sb[id].Name = GetSpellInfo(id) -- localized, rank is BROKEN (always nil)
		
--		local start, duration, enabled = GetSpellCooldown(id)
		-- For timers, the API appears to return 'valid' values once cast
		sb[id].Length = 0 -- For timers, although the API appears to return values once cast
		
		local cost = getManaCost(id) or 0 -- populate the warlock spells we are interested in
		sb[id].Mana = cost
		
		sb[id].InSpellBook = false -- later routine will fill this
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>"
.." "..id.."'"
.." N:'"..sb[id].Name.."'"
.." d:'"..sb[id].Length.."'"
.." m:'"..sb[id].Mana.."'"
)
--]]
	end
end


-- Fonction pour relocaliser  automatiquemlent des éléments en fonction du client
function Necrosis:SpellLocalize(tooltip) 
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Relocalisation des Sorts
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if not tooltip then
		self.Spell = {
			[1] = {Name = GetSpellInfo(5784), 	Mana = 50,			    Length = 0,	 Type = 0}, -- Felsteed  mount
			[2] = {Name = GetSpellInfo(23161), 	Mana = 50,			 	Length = 0,	 Type = 0}, -- Dreadsteed mount
			[3] = {Name = GetSpellInfo(688), 	Mana = 50,				Length = 0,	 Type = 0}, -- Imp || Diablotin pet
			[4] = {Name = GetSpellInfo(697),	Mana = 50,				Length = 0,	 Type = 0}, -- Voidwalker || Marcheur pet
			[5] = {Name = GetSpellInfo(712),	Mana = 50,				Length = 0,	 Type = 0}, -- Succubus || Succube pet
			[6] = {Name = GetSpellInfo(691),	Mana = 50,				Length = 0,	 Type = 0}, -- Fellhunter pet
			[7] = {Name = GetSpellInfo(691),	Mana = 50,				Length = 0,	 Type = 0}, -- Felguard -- Fellhunter now pet
			[8] = {Name = GetSpellInfo(1122),	Mana = 50,				Length = 600, Type = 3}, -- Infernal -- pet buff
			[9] = {Name = GetSpellInfo(18647),	Mana = 50,				Length = 30, Type = 2}, -- Banish buff?
			[10] = {Name = GetSpellInfo(1098),	Mana = 50,				Length = 300, Type = 2}, -- Enslave 
			[11] = {Name = GetSpellInfo(20707),	Mana = 50,				Length = 1800, Type = 1}, -- Soulstone Resurrection || Résurrection de pierre d'ame
			[12] = {Name = GetSpellInfo(707),	Mana = 50,				Length = 15, Type = 6}, -- Immolate dmg
			[13] = {Name = GetSpellInfo(6215),	Mana = 50,				Length = 15, Type = 6}, -- Fear dmg
			[14] = {Name = GetSpellInfo(6222),	Mana = 50,				Length = 18, Type = 5}, -- Corruption dmg / curse
			[15] = {Name = GetSpellInfo(18708),	Mana = 50,				Length = 180, Type = 3}, -- Fel Domination || Domination corrompue pet buff
			[16] = {Name = GetSpellInfo(603),	Mana = 50,				Length = 60, Type = 3}, -- Curse of Doom || Malédiction funeste curse
			[17] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 20, Type = 3}, -- NOPE NOT IN Classic Shadowfury || Furie de l'ombre
			[18] = {Name = GetSpellInfo(17924),	Mana = 50,				Length = 60, Type = 3}, -- Soul Fire || Feu de l'âme dmg
			[19] = {Name = GetSpellInfo(17926),	Mana = 50,				Length = 120, Type = 3}, -- Death Coil || Voile mortel dmg
			[20] = {Name = GetSpellInfo(18871),	Mana = 50,				Length = 15, Type = 3}, -- Shadowburn || Brûlure de l'ombre dmg
			[21] = {Name = GetSpellInfo(18932),	Mana = 50,				Length = 10, Type = 3}, -- Conflagration dps
			[22] = {Name = GetSpellInfo(11713),	Mana = 50,				Length = 24, Type = 4}, -- Curse of Agony || Malédiction Agonie curse
			[23] = {Name = GetSpellInfo(11708),	Mana = 50,				Length = 120, Type = 4}, -- Curse of Weakness || Malédiction Faiblesse curse
			[24] = {Name = GetSpellInfo(11717),	Mana = 0 ,              Length = 0,	    Type = 0}, -- Curse of Recklessness - removed in patch 3.1 || Malédiction Témérité || 
			[25] = {Name = GetSpellInfo(11719),	Mana = 50,				Length = 30, Type = 4}, -- Curse of Tongues || Malédiction Langage curse
			[26] = {Name = GetSpellInfo(11722),	Mana = 50,				Length = 300, Type = 4}, -- Curse of the Elements || Malédiction Eléments curse
			[27] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 180, Type = 3}, -- NOPE NOT IN Classic  Metamorphosis || Metamorphose
			[28] = {Name = GetSpellInfo(18881),	Mana = 50,				Length = 30, Type = 6}, -- Siphon Life || Syphon de vie dps
			[29] = {Name = GetSpellInfo(17928),	Mana = 50,				Length = 40, Type = 3}, -- Howl of Terror || Hurlement de terreur dps / fear
			[30] = {Name = GetSpellInfo(18540),	Mana = 50,				Length = 1800, Type = 3}, -- Ritual of Doom || Rituel funeste pet
			[31] = {Name = GetSpellInfo(11735),	Mana = 50,				Length = 0,	 Type = 0}, -- Demon Armor || Armure démoniaque
			[32] = {Name = GetSpellInfo(5697),	Mana = 50,				Length = 600,	 Type = 0}, -- Unending Breath || Respiration interminable
			[33] = {Name = GetSpellInfo(132),	Mana = 50,				Length = 0,	 Type = 0}, -- Detect Invisibility || Détection de l'invisibilité
			[34] = {Name = GetSpellInfo(126),	Mana = 50,				Length = 0,	 Type = 0}, -- Eye of Kilrogg
			[35] = {Name = GetSpellInfo(1098),	Mana = 50,				Length = 0,	 Type = 0}, -- Enslave Demon
			[36] = {Name = GetSpellInfo(696),	Mana = 50,				Length = 0,	 Type = 0}, -- Demon Skin || Peau de démon 
			[37] = {Name = GetSpellInfo(698),	Mana = 50,				Length = 120,	 Type = 3}, -- Ritual of Summoning || Rituel d'invocation
			[38] = {Name = GetSpellInfo(19028),	Mana = 50,				Length = 0,	 Type = 0}, -- Soul Link || Lien spirituel
			[39] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 45,	 Type = 3}, -- NOPE NOT IN Classic  Demon Charge || Charge démoniaque
			[40] = {Name = GetSpellInfo(18223),	Mana = 50,				Length = 12, Type = 4}, -- Curse of Exhaustion || Malédiction de fatigue
			[41] = {Name = GetSpellInfo(11689),	Mana = 50,				Length = 0,	     Type = 0}, -- Life Tap || Connexion
			[42] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 12, Type = 2}, -- NOPE NOT IN Classic  Haunt || Hanter
			[43] = {Name = GetSpellInfo(28610),	Mana = 50,				Length = 30, Type = 0}, -- Shadow Ward || Gardien de l'ombre
			[44] = {Name = GetSpellInfo(19443),	Mana = 50,				Length = 60, Type = 3}, -- Sacrifice || Sacrifice démoniaque 
			[45] = {Name = GetSpellInfo(11661),	Mana = 50,				Length = 0,	 Type = 0}, -- Shadow Bolt
			[46] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 18, Type = 6}, -- NOPE NOT IN Classic  Unstable Affliction || Affliction instable
			[47] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 0,	 Type = 0}, -- NOPE NOT IN Classic  Fel Armor || Gangrarmure
			[48] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 18, Type = 5}, -- NOPE NOT IN Classic  Seed of Corruption || Graine de Corruption
			[49] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 180, Type = 3}, -- NOPE NOT IN Classic SoulShatter || Brise âme
			[50] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 300, Type = 3}, -- NOPE NOT IN Classic Ritual of Souls || Rituel des âmes
			[51] = {Name = GetSpellInfo(20755),	Mana = 50,				Length = 0,	 Type = 0}, -- Create Soulstone || Création pierre d'âme
			[52] = {Name = GetSpellInfo(5699),	Mana = 50,				Length = 0,	 Type = 0}, -- Create Healthstone || Création pierre de soin
			[53] = {Name = GetSpellInfo(2362),	Mana = 50,				Length = 0,	 Type = 0}, -- Create Spellstone || Création pierre de sort
			[54] = {Name = GetSpellInfo(17951),	Mana = 50,				Length = 0,	 Type = 0}, -- Create Firestone || Création pierre de feu
			[55] = {Name = GetSpellInfo(18938),	Mana = 50,				Length = 0,	 Type = 0}, -- Dark Pact || Pacte noir
			[56] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 0,	 Type = 0}, -- NOPE NOT IN Classic  Shadow Cleave || Enchainement d'ombre
			[57] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 30, Type = 3}, -- NOPE NOT IN Classic  Immolation Aura || Aura d'immolation
			[58] = {Name = GetSpellInfo(133),	Mana = 50,				Length = 15, Type = 3}, --  NOPE NOT IN Classic Challenging Howl || Hurlement de défi
			[59] = {Name = GetSpellInfo(133),	Mana = 50,			    Length = 60, Type = 3} --NOPE NOT IN Classic   Demonic Empowerment || Renforcement démoniaque
		}
		-- Type 0 = Pas de Timer || no timer
		-- Type 1 = Timer permanent principal || Standing main timer
		-- Type 2 = Timer permanent || main timer
		-- Type 3 = Timer de cooldown || cooldown timer
		-- Type 4 = Timer de malédiction || curse timer
		-- Type 5 = Timer de corruption || corruption timer
		-- Type 6 = Timer de combat || combat timer

		for i in ipairs(self.Spell) do
			self.Spell[i].Rank = " "
			-- print (i .. '  '..self.Spell[i].Name)
		end
	end
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Relocalisation des Tooltips
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	-- stones || Pierres
	local buttonTooltip = new("array",
		"Soulstone",
		"Healthstone",
		"Spellstone",
		"Firestone"
	)
	local colorCode = new("array",
		"|c00FF99FF", "|c0066FF33", "|c0099CCFF", "|c00FF4444"
	)
	for i, button in ipairs(buttonTooltip) do
		if not self.TooltipData[button] then
			self.TooltipData[button] = {}
		end
		self.TooltipData[button].Label = colorCode[i]..self.Translation.Item[button].."|r"
	end
	del(buttonTooltip)
	del(colorCode)
	
	-- Buffs
	local buttonTooltip = new("array",
		"Domination",
		"Enslave",
		"Armor",
		"FelArmor",
		"Invisible",
		"Aqua",
		"Kilrogg",
		"Banish",
		"TP",
		"RoS",
		"SoulLink",
		"ShadowProtection",
		"Renforcement"
	)
	local buttonName = new("array",
		15, 35, 31, 47, 33, 32, 34, 9, 37, 50, 38, 43, 59
	)
	for i, button in ipairs(buttonTooltip) do
		if not self.TooltipData[button] then
			self.TooltipData[button] = {}
		end
		self.TooltipData[button].Label = "|c00FFFFFF"..self.Spell[buttonName[i]].Name.."|r"
	end
	del(buttonTooltip)
	del(colorCode)
	del(buttonName)

	-- Demons
	local buttonTooltip = new("array",
		"Sacrifice",
		"Charge",
		"Enchainement",
		"Immolation",
		"Defi",
		"Renforcement",
		"Enslave"
	)
	local buttonName = new("array",
		44, 39, 56, 57, 58, 59, 35
	)
	for i, button in ipairs(buttonTooltip) do
		if not self.TooltipData[button] then
			self.TooltipData[button] = {}
		end
		self.TooltipData[button].Label = "|c00FFFFFF"..self.Spell[buttonName[i]].Name.."|r"
	end
	del(buttonTooltip)
	del(colorCode)
	del(buttonName)
	
	-- Curses || Malédiction
	local buttonTooltip = new("array",
		"Weakness",
		"Agony",
		"Tongues",
		"Exhaust",
		"Elements",
		"Doom",
		"Corruption"
	)
	local buttonName = new("array",
		23, 22, 25, 40, 26, 16, 14
	)
	for i, button in ipairs(buttonTooltip) do
		if not self.TooltipData[button] then
			self.TooltipData[button] = {}
		end
		self.TooltipData[button].Label = "|c00FFFFFF"..self.Spell[buttonName[i]].Name.."|r"

	end
	del(buttonTooltip)
	del(colorCode)
	del(buttonName)
end

function Necrosis:ManaCostLocalize(spellIndex)
	if GetLocale() == "ruRU" then
		GameTooltip:AddLine(L["MANA"]..": "..self.Spell[spellIndex].Mana)
	else
		GameTooltip:AddLine(self.Spell[spellIndex].Mana.." "..L["MANA"])
	end

end

--[[
::: API GetSpellCooldown :::
Retrieves the cooldown data of the spell specified.
start, duration, enabled = GetSpellCooldown(spellName or spellID or slotID, "bookType");

Arguments
spellName 
String - name of the spell to retrieve cooldown data for.
spellID 
Number - ID of the spell in the database
slotID 
Number - Valid values are 1 through total number of spells in the spellbook on all pages and all tabs, ignoring empty slots.
bookType 
String - BOOKTYPE_SPELL or "spell", or BOOKTYPE_PET or "pet" depending on whether you wish to query the player or pet spellbook.

Returns
startTime 
Number - The time when the cooldown started (as returned by GetTime()); zero if no cooldown; current time if (enabled == 0).
duration 
Number - Cooldown duration in seconds, 0 if spell is ready to be cast.
enabled 
Number - 0 if the spell is active (Stealth, Shadowmeld, Presence of Mind, etc) and the cooldown will begin as soon as the spell is used/cancelled; 1 otherwise.
--]]
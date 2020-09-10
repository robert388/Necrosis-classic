--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

function Necrosis:Localization_Speech_En()

	self.Speech.TP = {
		[0] = {
			"<after>Summoning <target> - please click on the portal",
		},
		[1] = {
			"<after>Arcanum Taxi Cab! Please click on the portal so we can get this show on the road.",
		},
		[2] = {
			"<after>Welcome aboard ~Succubus Air Lines~...",
			"<after>Air Hostesses and their lashes are at your service during your trip!",
		},
		[3] = {
			"<after>If you click on the portal, we might get this party started a lot quicker!",
		},
		[4] = {
			"<after>Fools! Dont just stand there looking at the portal - click on it so we can summon those scrubs!",
		},
		[5] =  {
			"<after>Healthstones=10g, Soulstones=20g, Summons(cos you're too lazy to fly here)=10000g!",
		},
		[6] =  {
			"<after>WTB people that click on the portal instead of looking at it :/",
		},
	}

	self.Speech.Rez = {
		[0] = {
			"<after>--> <target> is soulstoned! <--",
		},
		[1] = {
			"<after>If you cherish the idea of a mass suicide, <target> can now self-resurrect, so all should be fine. Go ahead.",
		},
		[2]= {
			"<after><target> can go afk to drink a cup of coffee or something, soulstone is in place to allow for the wipe...",
		},
		[3]= {
			"<after>Hmmm... <target> is soulstoned... full of confidence tonight aren't we!!",
		},
		[4]= {
			"<after><target> is Stoned... duuuude heavy!",
		},
		[5]= {
			"<after>Why does <target> always go afk when they are soulstoned?!!!",
		},
	}

	self.Speech.RoS = {
		[1] = {
			"Let us use the souls of our fallen enemies to give us vitality",
		},
		[2] = {
			"My soul, their soul, doesn't matter, just take one",
		},
		[3] = {
			"WTS healthstones 10g each!! Cheaper than AH!",
		},
		[4] = {
			"This healthstone probably wont save your life, but take one anyway!",
		},
		[5] = {
			"If you dont pull aggro, then you wont need a healthstone!",
		},
	}

	self.Speech.ShortMessage = {
		{{"<after>--> <target> is soulstoned! <--"}},
		{{"<after><TP> Summoning <target> - please click on the portal <TP>"}},
		{{"Casting Ritual of Souls"}},
	}

	self.Speech.Demon = {
		-- Imp
		[1] = {
--[[
			[1] = {
				"<player> is concentrating hard on Demoniac knowledge...",
				"<yell> You crappy nasty little Imp...",
				"<pet>! HEEL! NOW!",
				"<after>Obey now, <pet>!",
			},
--]]
			[1] = {
				"You crappy nasty little Imp, stop sulking and get over here to help! AND THAT'S AN ORDER!",
			},
			[2] = {
				"<pet>! HEEL! NOW!",
			},
			[3] = {
				"I was tying to cook something from scratch... honest!",
			},
		},
		-- Voidwalker
		[2] = {
			[1] = {
				"Oops, I'll probably need an idiot to be knocked for me...",
				"<pet>, please help!",
			},
			[2] = {
				"<pet>, some creatures must become bits!",
			},
			[3] = {
				"Well, here comes the consequences of my own actions...",
			},
		},
		-- Succubus
		[3] = {
			[1] = {
				"<pet> baby, please help me sweetheart!",
			},
		},
		-- Felhunter
		[4] = {
			[1] = {
				"<pet> ! <pet>! Come on boy, come here! <pet>!",
			},
		},
		-- Felguard
		[5] = {
			[1] = {
				"<player> is concentrating hard on Demoniac knowledge...",
				"I'll give you a soul if you come to me, Felguard! Please hear my command!",
				"<after>Obey now, <pet>!",
				"<after><player> looks in a bag, then throws a mysterious shard at <pet>",
				"<sacrifice>Please return in the Limbs you are from, Demon, and give me your power in exchange!"
			},
		},
		-- Sentences for the first summon : When Necrosis do not know the name of your demons yet
		[6] = {
			[1] = {
				"Fishing? Yes I love fishing... Look!",
				"I close my eyes, I move my fingers like that...",
				"<after>And voila! Yes, yes, it is a fish, I swear to you!",
			},
			[2] = {
				"Anyway I hate you all! I don't need you, I have friends.... powerful friends!",
				"COME TO ME, CREATURE OF HELL AND NIGHTMARE!",
			},
		},
		-- Sentences for the stead summon
		[7] = {
			[1] = {
				"Hey, I'm late! Let's find a horse that roxes!",
			},
			[2] = {
				"<player> is giggling gloomily...",
				"<yell>I am summoning a steed from nightmare!",
			},
			[3] = {
				"I call forth the flames of feet to make my travels swift!",
			},
		}
	}
end
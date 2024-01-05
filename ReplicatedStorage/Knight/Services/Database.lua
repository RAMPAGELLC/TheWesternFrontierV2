local Service = {
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service."
	}
}

local Default = Color3.fromRGB(188, 194, 200)

Service.Content = {
	["Tags"] = {
		["Ranks"] = {
			["Twitch"] = {
				GroupRankId = 243,
				ChatColor = Default,
				TagText = {
					TagText = "Twitch", 
					TagColor = Color3.fromRGB(76, 49, 126)
				}
			},
			["YouTube"] = {
				GroupRankId = 243,
				ChatColor = Default,
				TagText = {
					TagText = "YouTube", 
					TagColor = Color3.fromRGB(193, 9, 9)
				}
			},
			["Contributor"] = {
				GroupRankId = 244,
				ChatColor = Default,
				TagText = {
					TagText = "Contributor", 
					TagColor = Color3.fromRGB(49, 133, 118)
				}
			},
			["RAMPAGE Employee"] = {
				GroupRankId = 245,
				ChatColor = Color3.fromRGB(27, 74, 204),
				TagText = {
					TagText = "RAMPAGE Employee", 
					TagColor = Color3.fromRGB(27, 74, 204)
				}
			},
			["Moderator"] = {
				GroupRankId = 248,
				ChatColor = Color3.fromRGB(255, 215, 0),
				TagText = {
					TagText = "Moderator",
					TagColor = Color3.fromRGB(255, 215, 0)
				}
			},
			["Developer"] = {
				GroupRankId = 249,
				ChatColor = Color3.fromRGB(255, 215, 0),
				TagText = {
					TagText = "Executive",
					TagColor = Color3.fromRGB(255, 215, 0)
				}
			},
			["Admin"] = {
				GroupRankId = 250,
				ChatColor = Color3.fromRGB(255, 64, 64),
				TagText = {
					TagText = "Admin",
					TagColor = Color3.fromRGB(255, 64, 64)
				}
			},
			["Senior Admin"] = {
				GroupRankId = 254,
				ChatColor = Color3.fromRGB(255, 64, 64),
				TagText = {
					TagText = "Senior Admin",
					TagColor = Color3.fromRGB(255, 64, 64)
				}
			},
		},

		["JobTitles"] = {
			{
				Team = game.Teams.Sheriff,
				TagText = {
					TagText = "Sheriff", 
					TagColor = Color3.new(0.105882, 0.533333, 0.819608)
				}
			},
			{
				Team = game.Teams.Doctor,
				TagText = {
					TagText = "Doctor", 
					TagColor = Color3.new(0.819608, 0.819608, 0.819608)
				}
			},
			{
				Team = game.Teams.Mayor,
				TagText = {
					TagText = "Mayor", 
					TagColor = Color3.new(0.819608, 0.690196, 0.0313725)
				}
			},
			{
				Team = game.Teams.Barkeep,
				TagText = {
					TagText = "Barkeep", 
					TagColor = Color3.new(1, 0.560784, 0.117647)
				}
			},
			{
				Team = game.Teams.Outlaw,
				TagText = {
					TagText = "Outlaw", 
					TagColor = Color3.new(1, 0, 0)
				}
			},
			{
				Team = game.Teams.Hitman,
				TagText = {
					TagText = "Hitman", 
					TagColor = Color3.new(1, 0, 0)
				}
			},
			{
				Team = game.Teams.Citizen,
				TagText = {
					TagText = "Citizen", 
					TagColor = Color3.new(0.313725, 0.313725, 0.313725)
				}
			},
			{
				Team = game.Teams.Pirate,
				TagText = {
					TagText = "Pirate", 
					TagColor = Color3.new(0, 0, 0)
				}
			},
			{
				Team = game.Teams["Bounty Hunter"],
				TagText = {
					TagText = "Bounty Hunter", 
					TagColor = Color3.new(0.203922, 0.0862745, 0.0862745)
				}
			},
			{
				Team = game.Teams.Governor,
				TagText = {
					TagText = "Governor", 
					TagColor = Color3.new(1, 0.917647, 0)
				}
			},
			{
				Team = game.Teams["RAMPAGE Rangers"],
				TagText = {
					TagText = "RAMPAGE Rangers", 
					TagColor = Color3.new(0.168627, 0.309804, 0.584314)
				}
			},
			{
				Team = game.Teams.Marshall,
				TagText = {
					TagText = "Deputy Marshal", 
					TagColor = Color3.new(0.168627, 0.309804, 0.584314)
				}
			},
		},

		["Titles"] = {
			["Developer"] = {
				ChatColor = Color3.fromRGB(69, 174, 255),
				TagText = {
					TagText = "Developer", 
					TagColor = Color3.new(0.270588, 0.682353, 1)
				}
			},
			["Senior Admin"] = {
				ChatColor = Color3.fromRGB(69, 174, 255),
				TagText = {
					TagText = "Senior Admin", 
					TagColor = Color3.new(0.270588, 0.682353, 1)
				}
			},
			["Admin"] = {
				ChatColor = Color3.fromRGB(27, 74, 204),
				TagText = {
					TagText = "Admin", 
					TagColor = Color3.new(0.105882, 0.290196, 0.8)
				}
			},
			["Moderator"] = {
				ChatColor = Color3.fromRGB(204, 59, 59),
				TagText = {
					TagText = "Moderator", 
					TagColor = Color3.new(0.8, 0.231373, 0.231373)
				}
			},
			["Governor"] = {
				TagText = {
					TagText = "Governor", 
					TagColor = Color3.new(0.8, 0.443137, 0.0392157)
				}
			},
			["RAMPAGE Employee"] = {
				ChatColor = Color3.fromRGB(27, 74, 204),
				TagText = {
					TagText = "RAMPAGE Employee", 
					TagColor = Color3.new(0.105882, 0.290196, 0.8)
				}
			},
			["VIP"] = {
				TagText = {
					TagText = "VIP", 
					TagColor = Color3.new(0.792157, 0.756863, 0.262745)
				}
			},
			["Veteran"] = {
				TagText = {
					TagText = "Veteran", 
					TagColor = Color3.new(0.811765, 0.356863, 0.356863)
				}
			},
			["Wealthy"] = {
				TagText = {
					TagText = "Wealthy", 
					TagColor = Color3.new(0.560784, 0.937255, 0.552941)
				}
			},
			["Contributor"] = {
				TagText = {
					TagText = "Contributor", 
					TagColor = Color3.new(0.192157, 0.521569, 0.462745)
				}
			},
			["QA Tester"] = {
				TagText = {
					TagText = "QA Tester", 
					TagColor = Color3.new(0.764706, 0.0156863, 0.831373)
				}
			},
			["YouTube"] = {
				ChatColor = Color3.fromRGB(193, 9, 9),
				TagText = {
					TagText = "YouTube", 
					TagColor = Color3.new(0.756863, 0.0352941, 0.0352941)
				}
			},
			["Twitch"] = {
				ChatColor = Color3.fromRGB(76, 49, 126),
				TagText = {
					TagText = "Twitch", 
					TagColor = Color3.new(0.298039, 0.192157, 0.494118)
				}
			},
			
			-- top bounty
			["Western Legend"] = {
				TagText = {
					TagText = "Western Legend", 
					TagColor = Color3.new(0.980392, 0.54902, 0.164706)
				}
			},
			
			-- top arrests
			["The Marshal"] = {
				TagText = {
					TagText = "The Marshal", 
					TagColor = Color3.new(0, 0.752941, 0.980392)
				}
			},
			
			-- top donator
			["The Investor"] = {
				TagText = {
					TagText = "The Investor", 
					TagColor = Color3.new(0.980392, 0.133333, 0.866667)
				}
			},
		},
	}
}

return Service
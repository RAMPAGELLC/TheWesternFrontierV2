local database = {}
local Teams = game:GetService("Teams")

function database.search(by, team, value)
	local f,d = false, {}

	for i,v in pairs(database.get()) do
		if v[by] == value and v.Team == team then
			f,d = true, v;
			break
		end
	end

	return f,d
end

function database.get()
	return {
		{
			Level = 1,
			Team = Teams.Outlaw,
			Rewards = {}
		},
		{
			Level = 2,
			Team = Teams.Outlaw,
			Rewards = {
				{
					RewardType = "Perk",
					ProgressionName = "LockpickSpeed",
					ProgressionAmount = 2
				},
			}
		},
		{
			Level = 3,
			Team = Teams.Outlaw,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 500
				},
			}
		},
		{
			Level = 4,
			Team = Teams.Outlaw,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},
				{
					RewardType = "Item",
					RewardItemId = 115,
					RewardAmount = 1,
				},
			}
		},

		{
			Level = 5,
			Team = Teams.Outlaw,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 2500
				},
			}
		},

		{
			Level = 6,
			Team = Teams.Outlaw,
			Rewards = {
				{
					RewardType = "Perk",
					ProgressionName = "RobberyCashMultiplier",
					ProgressionAmount = 1
				},
			}
		},
		{
			Level = 7,
			Team = Teams.Outlaw,
			Rewards = {
				{
					RewardType = "Perk",
					ProgressionName = "RobberyCashMultiplier",
					ProgressionAmount = 1
				},
			}
		},
		{
			Level = 8,
			Team = Teams.Outlaw,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 4500
				},
				{
					RewardType = "Item",
					RewardItemId = 101,
					RewardAmount = 1,
				},
				{
					RewardType = "Item",
					RewardItemId = 99,
					RewardAmount = 1,
				},
			}
		},

		{
			Level = 9,
			Team = Teams.Outlaw,
			Rewards = {
				{
					RewardType = "Perk",
					ProgressionName = "RobberyCashMultiplier",
					ProgressionAmount = 1
				},
			}
		},
		{
			Level = 10,
			Team = Teams.Outlaw,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 10500
				},
				{
					RewardType = "Item",
					RewardItemId = 108,
					RewardAmount = 1,
				},
			}
		},


		
		{
			Level = 1,
			Team = Teams.Citizen,
			Rewards = {}
		},
		{
			Level = 2,
			Team = Teams.Citizen,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 500
				},
				{
					RewardType = "Item",
					RewardItemId = 117,
					RewardAmount = 1,
				},
			}
		},
		{
			Level = 3,
			Team = Teams.Citizen,
			Rewards = {
				{
					RewardType = "Perk",
					ProgressionName = "MiningDamage",
					ProgressionAmount = 2
				},
				{
					RewardType = "Perk",
					ProgressionName = "TreeDamage",
					ProgressionAmount = 2
				},
			}
		},
		{
			Level = 4,
			Team = Teams.Citizen,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 500
				},
				{
					RewardType = "Perk",
					ProgressionName = "MiningDamage",
					ProgressionAmount = 5
				},
			}
		},
		{
			Level = 5,
			Team = Teams.Citizen,
			Rewards = {
				{
					RewardType = "Perk",
					ProgressionName = "TreeDamage",
					ProgressionAmount = 5
				},
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},
			}
		},
		{
			Level = 6,
			Team = Teams.Citizen,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},
			}
		},
		{
			Level = 7,
			Team = Teams.Citizen,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},
			}
		},
		{
			Level = 8,
			Team = Teams.Citizen,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},
			}
		},
		{
			Level = 9,
			Team = Teams.Citizen,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},
			}
		},
		{
			Level = 10,
			Team = Teams.Citizen,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},
				{
					RewardType = "Item",
					RewardItemId = 110,
					RewardAmount = 1,
				},
			}
		},
		

		{
			Level = 1,
			Team = Teams.Sheriff,
			Rewards = {}
		},
		{
			Level = 2,
			Team = Teams.Sheriff,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 500
				},
			}
		},
		{
			Level = 3,
			Team = Teams.Sheriff,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},}
		},
		{
			Level = 4,
			Team = Teams.Sheriff,
			Rewards = {
				{
					RewardType = "Item",
					RewardItemId = 102,
					RewardAmount = 1,
				},
				{
					RewardType = "Item",
					RewardItemId = 100,
					RewardAmount = 1,
				},}
		},
		{
			Level = 5,
			Team = Teams.Sheriff,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 2500
				},
			}
		},


		{
			Level = 1,
			Team = Teams.Mayor,
			Rewards = {}
		},
		{
			Level = 2,
			Team = Teams.Mayor,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 500
				},
			}
		},
		{
			Level = 3,
			Team = Teams.Mayor,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},}
		},
		{
			Level = 4,
			Team = Teams.Mayor,
			Rewards = {}
		},
		{
			Level = 5,
			Team = Teams.Mayor,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 2500
				},
			}
		},
		
		{
			Level = 1,
			Team = Teams.Hitman,
			Rewards = {}
		},
		{
			Level = 2,
			Team = Teams.Hitman,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 500
				},
			}
		},
		{
			Level = 3,
			Team = Teams.Hitman,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},}
		},
		{
			Level = 4,
			Team = Teams.Hitman,
			Rewards = {}
		},
		{
			Level = 5,
			Team = Teams.Hitman,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 2500
				},
			}
		},
		

		{
			Level = 1,
			Team = Teams["Bounty Hunter"],
			Rewards = {}
		},
		{
			Level = 2,
			Team = Teams["Bounty Hunter"],
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 500
				},
			}
		},
		{
			Level = 3,
			Team = Teams["Bounty Hunter"],
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},}
		},
		{
			Level = 4,
			Team = Teams["Bounty Hunter"],
			Rewards = {}
		},
		{
			Level = 5,
			Team = Teams["Bounty Hunter"],
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 2500
				},
			}
		},
		


		{
			Level = 1,
			Team = Teams.Barkeep,
			Rewards = {}
		},
		{
			Level = 2,
			Team = Teams.Barkeep,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 500
				},
			}
		},
		{
			Level = 3,
			Team = Teams.Barkeep,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 1500
				},}
		},
		{
			Level = 4,
			Team = Teams.Barkeep,
			Rewards = {}
		},
		{
			Level = 5,
			Team = Teams.Barkeep,
			Rewards = {
				{
					RewardType = "Cash",
					RewardAmount = 4500
				},
			}
		},
	}
end

return database
-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		Settings = false,
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

function Knight.AddXP(Player, Amount)
	Knight.Services.CharacterManager.UpdateExpBoosterStatus(Player)
	if _G.PlayerData[Player.Name].ExpBooster then Amount = Amount * 4 end
	
	if Amount > 0 then
		_G.PlayerData[Player.Name].TeamProgression[Player.Team.Name].XP += Amount;
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "+" .. tostring(Amount) .. " xp", Color3.fromRGB(85, 170, 127))
	end

	Knight.SendUpdate(Player)
end

_G.AddXP = Knight.AddXP

function Knight.RemoveXP(Player, Amount)
	Knight.Services.CharacterManager.UpdateExpBoosterStatus(Player)
	
	if Amount > 0 then
		_G.PlayerData[Player.Name].TeamProgression[Player.Team.Name].XP -= Amount;
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "-" .. tostring(Amount) .. " xp", Color3.fromRGB(255, 53, 53))
	end

	Knight.SendUpdate(Player)
end

_G.RemoveXP = Knight.RemoveXP

function Knight.XPChanged(Player)
	local Level = _G.PlayerData[Player.Name].TeamProgression[Player.Team.Name].Level
	local XP = _G.PlayerData[Player.Name].TeamProgression[Player.Team.Name].XP
	local RequiredXP = Level * 800

	if XP >= RequiredXP then
		XP -= RequiredXP
		Level += 1
		RequiredXP = Level * 800
	end

	_G.PlayerData[Player.Name].TeamProgression[Player.Team.Name].XP = XP
	_G.PlayerData[Player.Name].TeamProgression[Player.Team.Name].Level = Level

	return Level, XP, RequiredXP
end

function Knight.SendUpdate(Player)
	local Level, XP, RequiredXP = Knight.XPChanged(Player)

	Knight.Shared.Services.Remotes:Fire("PlayerProgressionUpdate", Player, {
		Level = Level,
		XP = XP,
		RequiredXP = RequiredXP,
	})
end

function Knight.Init()
	Knight.Shared.Services.Remotes:Register("PlayerProgressionUpdate", "RemoteEvent")
	Knight.Shared.Services.Remotes:Register("ClientProgression", "RemoteFunction", function(Player, ...)
		local args = {...};
		local MyData = {
			level_rewards = Knight.Database.ProgressionUnlocks.get(),
			progression_stats = _G.PlayerData[Player.Name].Progression,
			data = _G.PlayerData[Player.Name].TeamProgression[Player.Team.Name],
			unlocked = _G.PlayerData[Player.Name].ProgressionClaims[Player.Team.Name]
		}

		if args[1] == "GET" then
			return MyData
		elseif args[1] == "Claim" then
			local Level = args[2]

			if table.find(MyData.unlocked, tostring(Level)) then
				return false, "You already claimed this silly."
			end

			if Level > MyData.data.Level then
				return false, "This is above your max level, you cannot claim this."
			end
			
			local m = "Failed to generate string."
			
			for _, level_reward_data in pairs(MyData.level_rewards) do
				if level_reward_data.Team == Player.Team and level_reward_data.Level == Level then
					if #level_reward_data.Rewards == 0 then
						m = "This tier has no rewards."
						break;
					end

					m = "Reward(s) claimed!"
					
					for _, reward in pairs(level_reward_data.Rewards) do
						if reward.RewardType == "Cash" then
							Knight.Services.CharacterManager.AddCash(Player, reward.RewardAmount)
						end

						if reward.RewardType == "Perk" then
							_G.PlayerData[Player.Name].Progression[reward.ProgressionName] += reward.ProgressionAmount
						end

						if reward.RewardType == "Item" then
							local success, insert_id = _G.GiveItem(Player, reward.RewardItemId)

							if reward.RewardAmount > 1 then
								_G.PlayerData[Player.Name].Backpack[insert_id].Stack = reward.RewardAmount
								_G.RefreshInventory(Player)
							end
						end
					end
					
					break
				end
			end
			table.insert(_G.PlayerData[Player.Name].ProgressionClaims[Player.Team.Name], tostring(Level))

			return true, m
		end
	end)
end

return Knight
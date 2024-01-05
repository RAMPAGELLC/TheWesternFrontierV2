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

local Roles = {
	{
		Team = game.Teams.Citizen,
		Default = true,
		LoseRoleOnDeath = false,
		Max = 0,
		Loadout = {},
		Clothing = false,
		Func = function(Player, IsResign)
			return true, ""
		end,
	},
	{
		Team = game.Teams.Pirate,
		Default = false,
		LoseRoleOnDeath = true,
		Max = 0,
		Loadout = {},
		Clothing = {
		},
		Func = function(Player, IsResign)
			return true, ""
		end,
	},
	{
		Team = game.Teams.Hitman,
		Default = false,
		LoseRoleOnDeath = true,
		Max = 2,
		Loadout = {},
		Clothing = {
		},
		Func = function(Player, IsResign)
			return true, ""
		end,
	},
	{
		Team = game.Teams.Governor,
		Default = false,
		LoseRoleOnDeath = false,
		Max = 0,
		Clothing = {
		},
		Loadout = {32,33},
		Func = function(Player, IsResign)
			return true, ""
		end,
	},
	{
		Team = game.Teams.Marshall,
		Default = false,
		LoseRoleOnDeath = false,
		Max = 0,
		Clothing = {
		},
		Loadout = {32,33},
		Func = function(Player, IsResign)
			return true, ""
		end,
	},
	{
		Team = game.Teams["RAMPAGE Rangers"],
		Default = false,
		LoseRoleOnDeath = false,
		Max = 0,
		Clothing = {
		},
		Loadout = {32,33},
		Func = function(Player, IsResign)
			return true, ""
		end,
	},
	{
		Team = game.Teams["Bounty Hunter"],
		Default = false,
		LoseRoleOnDeath = true,
		Max = 4,
		Clothing = {
		},
		Loadout = {},
		Func = function(Player, IsResign)
			return true, ""
		end,
	},
	{
		Team = game.Teams.Barkeep,
		Default = false,
		LoseRoleOnDeath = true,
		Max = 2,
		Clothing = {
		},
		Loadout = {19, 148},
		Func = function(Player, IsResign)
			if IsResign then
				Player.PlayerGui:WaitForChild("Core").Framework.Game.Barkeep.Visible = false
			end
			
			return true, ""
		end,
	},
	{
		Team = game.Teams.Sheriff,
		Default = false,
		LoseRoleOnDeath = true,
		Max = 4,
		Clothing = {
		},
		Loadout = {32, 33},
		Func = function(Player, IsResign)
			if IsResign then
				if Player.Character:FindFirstChild("Badge") then
					Player.Character:FindFirstChild("Badge"):Destroy()
				end
			else
				Knight.Services.CharacterManager.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Morphs.Badge, "Badge")
			end

			return true, ""
		end,
	},
	{
		Team = game.Teams.Doctor,
		Default = false,
		LoseRoleOnDeath = true,
		Max = 2,
		Clothing = {
		},
		Loadout = {},
		Func = function(Player, IsResign)
			return true, ""
		end,
	},
	{
		Team = game.Teams.Mayor,
		Default = false,
		LoseRoleOnDeath = true,
		Max = 2,
		Clothing = {
		},
		Loadout = {},
		Func = function(Player, IsResign)
			if IsResign then
				for i,v in pairs(workspace.CityInfo:GetChildren()) do
					if v.Mayor.Surface_Text.SurfaceGui.TextLabel.Text == "MAYOR: " .. string.upper(Player.Name) then
						v.Mayor.Surface_Text.SurfaceGui.TextLabel.Text = "MAYOR: N/A"
					end
				end

				return true, ""
			end
			
			local Count = #game.Teams.Mayor:GetPlayers()
			local WantedMayor = false

			for _, user in pairs(game.Teams.Mayor:GetPlayers()) do
				if user ~= Player and _G.PlayerData[user.Name].Wanted then
					WantedMayor = true
				end
			end

			if _G.PlayerData[Player.Name].Wanted and WantedMayor then
				return false, "You are unable to take this role, as someone else is already the bearclaw mayor."
			end

			if _G.PlayerData[Player.Name].Wanted and not WantedMayor then
				for i,v in pairs(workspace.CityInfo:GetChildren()) do
					if v.Name == "Bearclaw" then
						v.Mayor.Surface_Text.SurfaceGui.TextLabel.Text = "MAYOR: " .. string.upper(Player.Name)
					end
				end
				return true, "You are now the Bearclaw Mayor!"
			end

			if not _G.PlayerData[Player.Name].Wanted then
				for i,v in pairs(workspace.CityInfo:GetChildren()) do
					if v.Name == "Blackwater" then
						v.Mayor.Surface_Text.SurfaceGui.TextLabel.Text = "MAYOR: " .. string.upper(Player.Name)
					end
				end
				return true, "You are now the Blackwater Mayor!"
			end
		end,
	},
	{
		Team = game.Teams.Outlaw,
		Default = false,
		LoseRoleOnDeath = false,
		Max = 0,
		Clothing = false,
		Loadout = {},
		Func = function(Player, IsResign)
			return true, ""
		end,
	},
}

function Knight.GetRole(Team)
	local Data = nil

	for i,v in pairs(Roles) do
		if v.Team == Team then
			Data = v;
			break;
		end
	end

	return Data;
end

function Knight.Start()
	Knight.Shared.Roblox.Players.PlayerAdded:Connect(function(Player)
		Player.CharacterAdded:Connect(function(c)
			local Character = Player.Character or Player.CharacterAdded:Wait()
			
			Character:WaitForChild("Humanoid").Died:Connect(function()
				local Role = Knight.GetRole(Player.Team)
				
				if Role and Role.LoseRoleOnDeath then
					Knight.Assign(Player, Knight.Shared.Roblox.Team.Citizen)
				end
			end)
		end)
	end)
end

function Knight.Assign(Player, Team)
	local PreviousRole = Knight.GetRole(Player.Team)
	local Role = Knight.GetRole(Team)

	if PreviousRole and Team ~= Knight.Shared.Roblox.Teams.Citizen then
		local succeed, message = PreviousRole.Func(Player, true)
		
		if not succeed then
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Alert", "Role Resign", message ~= "" and message or "No error reason specified.")
			return
		end
		
		Knight.Assign(Player, Knight.Shared.Roblox.Teams.Citizen)
		Knight.Services.CharacterManager.ReloadPlayerCosmetics(Player)

		if PreviousRole.Team == Team then
			return
		end
	end
	
	if Team == Knight.Shared.Roblox.Teams.Citizen then
		Knight.Services.CharacterManager.ReloadPlayerCosmetics(Player)
	end
	
	if Team == Knight.Shared.Roblox.Teams.Citizen and _G.PlayerData[Player.Name].Wanted then
		Role = Knight.GetRole(Knight.Shared.Roblox.Teams.Outlaw)
	end
	
	if Role then
		if #Role.Team:GetPlayers() >= Role.Max and Role.Max > 0 then
			return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Alert", "Role is Full", "This role is currently full, you cannot become it right now.")
		end

		local succeed, message = Role.Func(Player, false)

		if not succeed then
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Alert", "Role Change Failed", message ~= "" and message or "No error reason specified.")
			return
		end

		if Role.Clothing then
			Player.Character.Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=" .. tostring(Role.Clothing[1])
			Player.Character.Pants.PantsTemplate = "http://www.roblox.com/asset/?id=" .. tostring(Role.Clothing[2])
		end

		Player.Team = Team
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Alert", "Role Changed", message ~= "" and message or "Your role is now "..Team.Name.."!")
		Knight.Shared.Roblox.ReplicatedStorage.Events.Titles:Fire(Player, "Refresh")
		Knight.Services.CharacterManager.UpdateNametag(Player)
		Knight.Services.ProgressionManager.AddXP(Player, 0)
		Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "TeamChanged")

		if _G.PlayerData[Player.Name] ~= nil then
			Knight.Services.ItemsManager.RemoveJobItems(Player)

			for _, ToolId in pairs(Role.Loadout) do
				Knight.Services.ItemsManager.GiveItem(Player, ToolId, false, true)
			end

			Knight.Services.InventoryManager.RefreshInventory(Player)
		end
	end
end

function Knight.GetRoles()
	return Roles
end

return Knight
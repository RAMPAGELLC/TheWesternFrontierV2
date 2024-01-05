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

function Knight.Arrest(Sheriff, Suspect, CustomTime)
	Suspect.PlayerGui:WaitForChild("Core").Framework.Game.Robbery.Visible = false
	Suspect.PlayerGui:WaitForChild("Core").Framework.Game.BagAmount.Visible = false
	local Bounty = _G.PlayerData[Suspect.Name].Bounty

	if Sheriff == Suspect then Sheriff = false end

	_G.PlayerData[Suspect.Name].PlayerStats.TotalPersonalArrests += 1
	Knight.Services.CharacterManager.RemoveCash(Suspect, Bounty)
	Knight.Services.RolesManager.Assign(Suspect, Knight.Shared.Roblox.Teams.Citizen)

	_G.PlayerData[Suspect.Name].InJail = true
	_G.PlayerData[Suspect.Name].MoneyBagValue = 0

	if Suspect.Character:FindFirstChild("Bag") then
		Suspect.Character:FindFirstChild("Bag"):Destroy()
	end
	
	if Sheriff then
		Knight.Services.ProgressionManager.AddXP(Sheriff, 69)
	end

	Knight.Services.ItemsManager.RemoveIllegalItems(Suspect)
	Knight.Services.ItemsManager.RemoveDropOnDeath(Suspect)
	Suspect.PlayerGui.Core.Framework.Game.Jail.Visible = true

	if tonumber(CustomTime) ~= nil and tonumber(CustomTime) > 0 then
		_G.PlayerData[Suspect.Name].JailTime = CustomTime
	else
		if _G.PlayerData[Suspect.Name].Bounty > 0 then
			local Time = Bounty * 0.50
			if Time <= 0 then Time = 60 end
			_G.PlayerData[Suspect.Name].JailTime = Time
		else
			_G.PlayerData[Suspect.Name].JailTime = 60
		end

		if Sheriff ~= false then
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Chat", Sheriff.Name.." claimed ".. Suspect.Name .." ALIVE $"..Bounty.." bounty!")
			Knight.Services.CharacterManager.AddCash(Sheriff, Bounty)
			_G.PlayerData[Sheriff.Name].PlayerStats.TotalClaimedBountys += Bounty
			_G.PlayerData[Sheriff.Name].PlayerStats.TotalArrests += 1
		else
			local Amount = math.floor(Bounty / 1.5)
			if Amount <= 0 then Amount = 5 end

			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Chat", "+"..Amount.." ".. Suspect.Name .." turned themself in!")

			for i,v in pairs(Knight.Shared.Roblox.Players:GetPlayers()) do
				Knight.Services.CharacterManager.AddCash(v, Amount)
			end
		end
	end

	Knight.Services.ItemsManager.RemoveJobItems(Suspect)
	task.wait(.1)

	if _G.PlayerData[Suspect.Name].JailTime >= 120 then
		Suspect:RequestStreamAroundAsync(workspace.Spawns.PrisonMine.Position)
		task.wait()
		Suspect.Character:SetPrimaryPartCFrame(workspace.Spawns.PrisonMine.CFrame)
		Suspect.PlayerGui.Core.Framework.Game.Jail.InMine.Visible = true
		Knight.Services.ItemsManager.GiveItem(Suspect, 31, true, true, false, "Jail time.", true, {
			OrginatedFrom = Suspect.UserId,
			LastOwner = Suspect.UserId,
			TradeReferenceId = 0
		})
		
		if _G.PlayerData[Suspect.Name].JailTime > 300 then
			_G.PlayerData[Suspect.Name].JailTime = 300
		end
		
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Chat", Suspect.Name .." has been sent to the prison mining camp.")
	else
		local Pads = workspace.Spawns.Jail:GetChildren()
		local Pad = Pads[math.random(1, #Pads)]
		Suspect:RequestStreamAroundAsync(Pad.Position)
		task.wait()
		Suspect.Character:SetPrimaryPartCFrame(Pad.CFrame)
		Suspect.PlayerGui.Core.Framework.Game.Jail.InMine.Visible = false
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Chat", Suspect.Name .." has been sent to jail.")
	end

	Knight.RemoveBounty(Suspect, Bounty)
	Knight.Services.InventoryManager.RefreshInventory(Suspect)

	task.spawn(function()
		task.wait(1)
		repeat
			task.wait(1)
		until Suspect and _G.PlayerData[Suspect.Name] ~= nil and _G.PlayerData[Suspect.Name].JailTime <= 0
			or not _G.PlayerData[Suspect.Name].InJail
			or Suspect == nil
			or _G.PlayerData[Suspect.Name] == nil;

		if _G.PlayerData[Suspect.Name].JailTime <= 0 then
			_G.PlayerData[Suspect.Name].InJail = false
			_G.PlayerData[Suspect.Name].Wanted = false
			_G.PlayerData[Suspect.Name].Bounty = 0
			Suspect:RequestStreamAroundAsync(workspace.Spawns.JailRelease.Position)
			task.wait()
			Suspect.Character:SetPrimaryPartCFrame(workspace.Spawns.JailRelease.CFrame)
			Suspect.PlayerGui.Core.Framework.Game.Jail.Visible = false

			if Knight.Services.ItemsManager.HasItem(Suspect, 31) then
				Knight.Services.ItemsManager.RemoveJobItems(Suspect)
			end

			Knight.Services.RolesManager.Assign(Suspect, Knight.Shared.Roblox.Teams.Citizen)
		end
	end)
end

_G.Arrest = Knight.Arrest

function Knight.AddBounty(Player, Amount)
	_G.PlayerData[Player.Name].Bounty += Amount;
	_G.PlayerData[Player.Name].PlayerStats.TotalBounty += Amount;

	if _G.PlayerData[Player.Name].Bounty > 0 then
		_G.PlayerData[Player.Name].Wanted = true
		_G.PlayerData[Player.Name].Hostile = true
	end

	local PlayerTeamLogic = _G.TeamsDamageLogic[Player.Team]

	if Amount > 0 then
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "+" .. tostring(Amount) .. " bounty", Color3.fromRGB(255, 149, 43))
	end

	if PlayerTeamLogic.Civil and Amount > 0 then
		Knight.Services.RolesManager.Assign(Player, game.Teams.Outlaw)
	end
	
	if Amount >= 15 then
		local Report = script.CrimeReport:Clone()
		Report.Parent = workspace.Ignore
		Report.CFrame = Player.Character.Head.CFrame
		
		task.delay(120, function()
			Report:Destroy()
		end)
	end
	
	Knight.Services.ProgressionManager.AddXP(Player, math.round(Amount * 0.5))

	Knight.Shared.Services.Remotes:Fire("PlayerBountyUpdate", Player, _G.PlayerData[Player.Name].Bounty)
end

function Knight.RemoveBounty(Player, Amount)
	_G.PlayerData[Player.Name].Bounty -= Amount;

	if _G.PlayerData[Player.Name].Bounty <= 0 then
		_G.PlayerData[Player.Name].Wanted = false
		_G.PlayerData[Player.Name].Hostile = false
		Knight.Services.RolesManager.Assign(Player, game.Teams.Citizen)
	end

	if Amount > 0 then
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "-" .. tostring(Amount) .. " bounty", Color3.fromRGB(85, 170, 127))
	end

	Knight.Shared.Services.Remotes:Fire("PlayerBountyUpdate", Player, _G.PlayerData[Player.Name].Bounty)
end

function Knight.Start()
	task.spawn(function()
		for _, board in pairs(workspace.BountyBoards:GetChildren()) do
			for i = 1, 6, 1 do
				board[i].P.Decal.Transparency = 1
				board[i].A.SurfaceGui.TextLabel.TextTransparency = 1
				board[i].N.SurfaceGui.TextLabel.TextTransparency = 1
				board[i].A.SurfaceGui.TextLabel.TextStrokeTransparency = 1
				board[i].N.SurfaceGui.TextLabel.TextStrokeTransparency = 1
				board[i].Part.Transparency = 1
			end
		end
		
		while true and task.wait(30) do
			local WantedPlayers = {}

			for _, board in pairs(workspace.BountyBoards:GetChildren()) do
				for i = 1, 6, 1 do
					board[i].P.Decal.Transparency = 1
					board[i].A.SurfaceGui.TextLabel.TextTransparency = 1
					board[i].N.SurfaceGui.TextLabel.TextTransparency = 1
					board[i].A.SurfaceGui.TextLabel.TextStrokeTransparency = 1
					board[i].N.SurfaceGui.TextLabel.TextStrokeTransparency = 1
					board[i].Part.Transparency = 1
				end
			end
			
			for index, player_data in pairs(_G.PlayerData) do
				local Suspect = Knight.Shared.Roblox.Players:FindFirstChild(index)
				if Suspect and player_data.Wanted then
					if #WantedPlayers < 6 then
						table.insert(WantedPlayers, {
							p = Suspect,
							d = player_data
						})
					end
				end
			end
			
			for index, data in pairs(WantedPlayers) do
				for _, board in pairs(workspace.BountyBoards:GetChildren()) do
					board[index].Part.Transparency = 0
					board[index].P.Decal.Transparency = 0
					board[index].A.SurfaceGui.TextLabel.TextTransparency = 0
					board[index].N.SurfaceGui.TextLabel.TextTransparency = 0
					board[index].A.SurfaceGui.TextLabel.TextStrokeTransparency = 0
					board[index].N.SurfaceGui.TextLabel.TextStrokeTransparency = 0
					board[index].A.SurfaceGui.TextLabel.Text = "$" .. tostring(data.d.Bounty)
					board[index].N.SurfaceGui.TextLabel.Text = string.upper(data.p.Name)
					local content, isReady = Knight.Shared.Roblox.Players:GetUserThumbnailAsync(data.p.UserId, Enum.ThumbnailType.HeadShot,  Enum.ThumbnailSize.Size420x420)
					board[index].P.Decal.Texture = isReady and content or "rbxassetid://10480493542"
				end
			end
		end
	end)
	
	task.spawn(function()
		while true and task.wait(1) do
			for index, player_data in pairs(_G.PlayerData) do
				local Suspect = Knight.Shared.Roblox.Players:FindFirstChild(index)
				if player_data.JailTime > 0 and Suspect then
					_G.PlayerData[index].JailTime -= 1;
					Suspect.PlayerGui.Core.Framework.Game.Jail.Timer.Text = Knight.Shared.External.TimeModule:ConvertToTime(_G.PlayerData[Suspect.Name].JailTime, "MS")
				end
			end
		end
	end)
end

return Knight
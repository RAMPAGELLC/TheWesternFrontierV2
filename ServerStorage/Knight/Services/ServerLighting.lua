-- Knight Init Service
local Knight = {};
local Service = {
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Lighting system"
	}
}


for i,v in pairs(Service) do
	Knight[i] = v;
end

function Knight.Init()
	Knight.Shared.Services.Remotes:Register("LightingSocket", "RemoteEvent", false)
	Knight.Shared.Services.Remotes:Register("MusicSocket", "RemoteEvent", false)
end

function Knight.Start()
	local ZoneService = Knight.Shared.External.Zone;
	game.ReplicatedStorage.BuildingMusic:Clone().Parent = workspace.Ignore
	
	for _, container in pairs(workspace.Ignore:WaitForChild("BuildingMusic"):GetChildren()) do
		local zone = ZoneService.new(container.Parts)
		zone:bindToGroup("EnterOnlyOneZoneAtATime")
		task.wait(.4)
		zone:relocate()

		zone.playerEntered:Connect(function(Player)
			local BA = Player.PlayerGui:WaitForChild("Sounds"):WaitForChild("BuildingAudio")
			local Sound = BA:FindFirstChild(container.Name)
			
			if Sound == nil then
				Sound = container.Sound:Clone()
				Sound.Name = container.Name
				Sound.Parent = BA
			end
			
			Knight.Shared.Services.Remotes:Fire("MusicSocket", Player, "Enter", Sound)
		end)

		zone.playerExited:Connect(function(Player)
			if Player:FindFirstChild("PlayerGui") == nil then return end
			if Player:FindFirstChild("PlayerGui"):FindFirstChild("Sounds") == nil then return end
			
			local BA = Player.PlayerGui:WaitForChild("Sounds"):WaitForChild("BuildingAudio")
			local Sound = BA:FindFirstChild(container.Name)

			if Sound == nil then
				return
			end
			
			Knight.Shared.Services.Remotes:Fire("MusicSocket", Player, "Exit", Sound)
		end)

		task.wait(.3)
		zone:relocate()
	end
	
	
	for _, container in pairs(workspace.Ignore:WaitForChild("Lighting"):GetChildren()) do
		local zone = ZoneService.new(container)
		zone:bindToGroup("EnterOnlyOneZoneAtATime")
		task.wait(.4)
		zone:relocate()

		zone.playerEntered:Connect(function(Player)
			Knight.Shared.Services.Remotes:Fire("LightingSocket", Player, "Enter", container.Name)
		end)

		zone.playerExited:Connect(function(Player)
			Knight.Shared.Services.Remotes:Fire("LightingSocket", Player, "Exit", container.Name)
		end)
	end
end

return Knight

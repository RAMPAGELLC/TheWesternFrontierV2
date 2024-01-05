-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		Wagons = {},
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

-- Script
function Knight.Start()
	game:GetService("Players").PlayerRemoving:Connect(function(Player)
		if Knight.Cache.Wagons[Player] then
			Knight.DespawnWagon(Player)
		end
	end)
end

function Knight.DespawnWagon(Player)
	if workspace.Wagons:FindFirstChild(Player.Name) then
		for _, Seat in pairs(workspace.Wagons:FindFirstChild(Player.Name).Seats:GetChildren()) do
			if Seat.Occupant then
				local Seater = game:GetService("Players"):GetPlayerFromCharacter(Seat.Occupant.Parent)

				if Seater then
					Seater.Character:WaitForChild("Humanoid").JumpPower = 50
					Knight.Shared.Services.Remotes:Fire("ClientHorse", Seater, "QuitHorse")
				end
			end
		end

		workspace.Wagons:FindFirstChild(Player.Name):Destroy()
	end

	Knight.Cache.Wagons[Player] = false
end

function Knight.new(Player, ItemData, InventoryData, InventoryKey)
	if Knight.Cache.Wagons[Player] then
		return Knight.DespawnWagon(Player)
	end

	if not workspace.Horses:FindFirstChild(Player.Name) then
		return
	end

	local Wagon = script.Wagon

	if ItemData.ItemId == 158 then
		Wagon = game.ReplicatedStorage.Assets.Items["1933 Duesenberg"]
	end

	Wagon:Clone()
	Wagon.Parent = workspace.Wagons
	Wagon.Name = Player.Name

	Wagon:PivotTo(Player.Character.Head.CFrame)
	task.wait(.2)

	if ItemData.ItemId ~= 158 then
		Wagon.Base.RopeConstraint.Attachment0 = workspace.Horses:FindFirstChild(Player.Name).WagonHook.HorseLead
	end

	for _, Seat in pairs(Wagon.Seats:GetChildren()) do
		Knight.Services.InteractionService.RegisterInteraction(Seat, "Ask", 0, function(Trigger)
			if Trigger == Player then return end

			if Seat.Occupant then
				return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "ERROR_SEAT_TAKEN", Color3.fromRGB(170, 0, 0))
			end

			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "Awaiting response from horse owner.", Color3.fromRGB(226, 149, 15))

			Knight.Services.CharacterManager.Question(Player, "Can " .. Trigger.Name .. " ride with you?", function(response)
				if response == "Yes" then
					if Seat.Occupant then
						return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "ERROR_SEAT_TAKEN", Color3.fromRGB(170, 0, 0))
					end

					Seat:Sit(Trigger.Character.Humanoid)
					Trigger.Character.Humanoid.JumpPower = 0
					Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "Horse owner approved.", Color3.fromRGB(0, 170, 127))
				elseif response == "No" then
					Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "Horse owner declined.", Color3.fromRGB(170, 0, 0))
				elseif response == "Timedout" then
					Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "Horse owner did not respond.", Color3.fromRGB(170, 0, 0))
				end
			end)
		end)
	end

	Knight.Cache.Wagons[Player] = true
end

return Knight
-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		IsLeadingHorse = {},
		HasHorseHitched = {},
		HorseHitchCache = {},
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

function Knight.Start()
	for _, model in pairs(workspace.Props.HorseHitches:GetChildren()) do
		for __, part in pairs(model:GetChildren()) do
			if part:FindFirstChild("Interaction") then
				Knight.Cache.HorseHitchCache[part] = {}
				
				local Attachment = Instance.new("Attachment", part)
				
				Knight.Services.InteractionService.RegisterInteraction(part, "Attach Horse", 0, function(Player)
					if not workspace.Horses:FindFirstChild(Player.Name) then
						return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "You don't have a horse silly.", Color3.fromRGB(255, 42, 42))
					end
					
					if Knight.Cache.HorseHitchCache[part][Player] == nil and Knight.Cache.HasHorseHitched[Player] ~= nil then
						return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "Your horse isnt here.", Color3.fromRGB(255, 42, 42))
					end

					local Horse = workspace.Horses:FindFirstChild(Player.Name)
					
					if Knight.Cache.HorseHitchCache[part][Player] then
						-- release
						Knight.Cache.IsLeadingHorse[Player] = true
						Knight.Cache.HasHorseHitched[Player] = false
						Knight.Cache.HorseHitchCache[part][Player] = nil
						
						local NewAttachment = Instance.new("Attachment", Player.Character.RightHand)
						NewAttachment.Name = "HorseLead"
						Horse.Detect.HorseLeadRope.Attachment0 = NewAttachment
						Horse.Detect.HorseLeadRope.Length = 5
						
						return
					end
					
					-- attach
					if not Knight.Cache.IsLeadingHorse[Player] then
						return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "You need to lead your horse here.", Color3.fromRGB(255, 42, 42))
					end

					if Player.Character.RightHand:FindFirstChild("HorseLead") then
						Player.Character.RightHand:FindFirstChild("HorseLead"):Destroy()
					end
					
					Horse.Detect.HorseLeadRope.Attachment0 = Attachment
					Knight.Cache.HasHorseHitched[Player] = true
					Knight.Cache.HorseHitchCache[part][Player] = true
					Knight.Cache.IsLeadingHorse[Player] = false
					Horse.Detect.HorseLeadRope.Length = 2
				end)
			end
		end
	end
end

function Knight.Init()
	Knight.Shared.Services.Remotes:Register("ClientHorse", "RemoteFunction", function(Player, ...)
		local args = {...};
		
		if args[1] == "Dismount" then
			Player.Character.Humanoid.Jump = true
			task.wait(.4)
			Player.Character.Humanoid.Jump = false
			return true;
		end
	end)
	
	Knight.Shared.Services.Remotes:Register("HorseSocket", "RemoteFunction", function(Player, ...)
		local args = {...};

		if args[1] == "PurchaseHorse" then
			Knight.Purchase(Player, args[2] or "Mule")
			return true;
		elseif args[1] == "SummonHorse" then
			if _G.PlayerData[Player.Name].Horses[args[2] or "Mule"] == nil then
				return false;
			end
			
			Knight.Summon(Player, args[2] or "Mule")
			return true;
		elseif args[1] == "GetMyHorses" then
			if _G.PlayerData[Player.Name] == nil then return {} end
			return _G.PlayerData[Player.Name].Horses;
		end
	end)
end

function Knight.Summon(Player, HorseName)
	if _G.PlayerData[Player.Name].InJail then
		return
	end
	
	if Knight.Cache.IsLeadingHorse[Player] or Knight.Cache.HasHorseHitched[Player] then
		return false
	end
	
	if workspace.Horses:FindFirstChild(Player.Name) then
		for _, Seat in pairs(workspace.Horses:GetChildren()) do
			if Seat:IsA("VehicleSeat") and Seat.Occupant or Seat:IsA("Seat") and Seat.Occupant then
				local Seater = game:GetService("Players"):GetPlayerFromCharacter(Seat.Occupant.Parent)

				if Seater then
					Seater.Character:WaitForChild("Humanoid").JumpPower = 50
					Knight.Shared.Services.Remotes:Fire("ClientHorse", Seater, "QuitHorse")
				end
			end
		end
		
		return workspace.Horses:FindFirstChild(Player.Name):Destroy()
	end
	
	task.wait(.2)
	
	local Horse = Knight.Shared.Roblox.ReplicatedStorage.Assets.Horses:FindFirstChild(HorseName)

	if Horse ~= nil then
		--local RidingScript = script.RidingScript:Clone()
		--RidingScript.HorseRealName.Value = Horse.Name
		
		Horse = Horse:Clone()
		Horse.Parent = workspace.Horses

		Horse.Name = Player.Name
		Horse.Player.Value = Player
		
		for _, part in pairs(Horse:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("MeshPart") then
				part.CollisionGroup = "Horses"
			end
		end
		
		--Horse:SetPrimaryPartCFrame(Player.Character:WaitForChild('HumanoidRootPart').CFrame*CFrame.new(20,0,0))
		Horse:SetPrimaryPartCFrame(Player.Character:WaitForChild('HumanoidRootPart').CFrame*CFrame.new(8,0,0))
		
	--	local RunAnimation = Instance.new("Animation", Horse)
	--	RunAnimation.AnimationId = "rbxassetid://12616989665" -- 8066135751
		
		--local Run = Horse:WaitForChild("Humanoid"):LoadAnimation(RunAnimation)
		--Run:AdjustSpeed(5)
		--Run:Play()
		
		--Horse.Humanoid:MoveTo(Player.Character:WaitForChild('HumanoidRootPart').Position + Vector3.new(8,0,0))
		
		task.spawn(function()
			--RidingScript.Parent = Horse
		--task.wait(3)
		--	Run:Stop()
		--	Run:Destroy()
		--	RunAnimation:Destroy()
			--RidingScript.Disabled = false
			Knight.Shared.Services.Remotes:Fire("ClientHorse", Player, "SetupHorse", _G.PlayerData[Player.Name].Horses[HorseName])
			task.wait()
			for _, v in ipairs(Horse:GetDescendants()) do
				if v:IsA('BasePart') then
					v:SetNetworkOwner(Player)
				end
			end
			
			if Horse:FindFirstChild("PassengerSeat") then
				Knight.Services.InteractionService.RegisterInteraction(Horse.PassengerSeat, "Ask", 0, function(Trigger)
					if Trigger == Player then return end
					
					if Horse.PassengerSeat.Occupant then
						return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "ERROR_SEAT_TAKEN", Color3.fromRGB(170, 0, 0))
					end
					
					Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "Awaiting response from horse owner.", Color3.fromRGB(226, 149, 15))
					
					Knight.Services.CharacterManager.Question(Player, "Can " .. Trigger.Name .. " ride with you?", function(response)
						if response == "Yes" then
							if Horse.PassengerSeat.Occupant then
								return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "ERROR_SEAT_TAKEN", Color3.fromRGB(170, 0, 0))
							end
							
							Horse.PassengerSeat:Sit(Trigger.Character.Humanoid)
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
			
			Knight.Services.InteractionService.RegisterInteraction(Horse.DriveSeat, "Ride Horse", 0, function(Trigger)
				if Trigger == Player then
					Horse.DriveSeat:Sit(Trigger.Character.Humanoid)
					Trigger.Character.Humanoid.JumpPower = 0
				else
					Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "You are not the horse owner.", Color3.fromRGB(170, 0, 0))
				end
			end)
			
			Knight.Cache.IsLeadingHorse[Player] = false
			
			Knight.Services.InteractionService.RegisterInteraction(Horse.Detect, "Lead Horse", 0, function(Trigger)
				if Trigger ~= Player then
					return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Trigger, "Chat", "You are not the horse owner.", Color3.fromRGB(170, 0, 0))
				end
				
				if Knight.Cache.IsLeadingHorse[Player] then
					Horse.Detect.HorseLeadRope:Destroy()
					
					if Player.Character.RightHand:FindFirstChild("HorseLead") then
						Player.Character.RightHand:FindFirstChild("HorseLead"):Destroy()
					end
					
					Knight.Cache.IsLeadingHorse[Player] = false
					return
				end
				
				Knight.Cache.IsLeadingHorse[Player] = true;
				
				local Attachment = Instance.new("Attachment", Player.Character.RightHand)
				Attachment.Name = "HorseLead"
				
				local Rope = script.HorseLeadRope:Clone()
				Rope.Parent = Horse.Detect
				Rope.Attachment1 = Horse.Detect.HorseLead
				Rope.Attachment0 = Attachment
				Rope.Length = 5
			end)
		end)
	else
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Alert", "Error", "Failed to load horse, try again later.")
	end
end

function Knight.Purchase(Player, Horse)
	local ItemFound, Item = Knight.Database.Horses.search("Name", Horse)
	if not ItemFound then return end	
	if not Item.ForSale then return end
	
	if _G.PlayerData[Player.Name].Cash >= Item.Price then
		Knight.Services.CharacterManager.RemoveCash(Player, Item.Price)
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Chat", "You have purchased "..Item.Name..", you can find this horse in your horse in my horses tab!", Color3.fromRGB(0, 170, 127))
		
		_G.PlayerData[Player.Name].PlayerStats.TotalSpentIncome += Item.Price
		_G.PlayerData[Player.Name].Horses[Item.Name] = {
			OwnSaddle = false,
			OwnBlanket = false,
			EyeColor = {
				R = "0",
				G = "0",
				B = "0"
			},
			CoatColor = {
				R = "0.47451",
				G = "0.352941",
				B = "0.231373"
			},
			BlanketColor = {
				R = "0",
				G = "0",
				B = "0"
			},
			SaddleColor = {
				R = "0",
				G = "0",
				B = "0"
			},
			OwnedKickUpgrades = {
				[1] = false,
				[2] = false,
				[3] = false,
				[4] = false,
				[5] = false,
				[6] = false,
			}
		}
	else
		local Cash = _G.PlayerData[Player.Name].Cash
		local Amount = Cash - Item.Price
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Chat", "You need $"..Amount.." more in-order to purchase "..Item.Name.."!", Color3.fromRGB(255, 56, 56))
	end
end

return Knight
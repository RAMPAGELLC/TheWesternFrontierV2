local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		Robbery = {
			["Bank"] = {
				BarStack = 5,
				PayoutMultiplier = {
					{
						Size = 10,
						BarMultiplier = 1,
						CashStack = 3,
					},
					{
						Size = 25,
						BarMultiplier = 5,
						CashStack = 5,
					},
					{
						Size = 35,
						BarMultiplier = 8,
						CashStack = 10,
					},
				},
				CashAmount = 200,
				ResetTime = 300,
				TimeLeft = 0,
			}
		}
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

local MoneyBagReturnZone = nil;
local CivilMoneyBagReturnZone = nil;

function Knight:SpawnItem(RobberyData, ItemName, Zone, Parent)
	local intersectionVector

	repeat
		local randomVector, touchingParts = Zone:getRandomPoint()
		local rayOrigin = randomVector + Vector3.new(0, 1, 0)
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = touchingParts
		raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
		local raycastResult = workspace:Raycast(rayOrigin, Vector3.new(0, -2, 0), raycastParams)
		intersectionVector = (raycastResult and raycastResult.Position)
		wait()
	until intersectionVector

	local Ore = Knight.Shared.Roblox.ReplicatedStorage.Assets.Ores:FindFirstChild(ItemName):Clone()
	Ore.Parent = Parent
	Ore:PivotTo(CFrame.new(intersectionVector + Vector3.new(0, 1, 0)))

	Ore.Primary.ProximityPrompt.Triggered:Connect(function(Player)
		Ore.Primary.ProximityPrompt.Enabled = false
		local Animation = script.PickupAnimation:Clone()

		local Track = Player.Character.Humanoid:LoadAnimation(Animation)
		Track:Play()

		Track.Stopped:Wait()
		Animation:Destroy()

		if Ore.Name == "GoldBar" then
			Ore:Destroy()
			Knight.Services.LawManager.AddBounty(Player, 15)
			Player.PlayerGui:WaitForChild("Core").Framework.Game.Robbery.Visible = false
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "+15 Bounty", Color3.fromRGB(249, 184, 54))

			local StackAmount = 3
			local ItemId = 35

			local Inventory = Knight.Services.InventoryManager.GetPlayerInventory(Player)
			local success, index = Knight.Services.ItemsManager.GiveItem(Player, ItemId, false, false, false, "Robbery")

			if success then
				_G.PlayerData[Player.Name].Backpack[index].Stack = StackAmount
				Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "+"..StackAmount.." Gold Bar", Color3.fromRGB(255, 163, 35))
			end
		elseif Ore.Name == "CashStack" then
			--if _G.PlayerData[Player.Name].MoneyBagValue >= 800 then
			-- return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "Bag is full, go to bearclaw to sell it", Color3.fromRGB(255, 37, 37))
			--end
			Ore:Destroy()

			if not Player.Character:FindFirstChild("Bag") then
				Knight.Services.CharacterManager.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Morphs.Bag, "Bag")
			end

			Knight.Services.LawManager.AddBounty(Player, 50)
			_G.PlayerData[Player.Name].MoneyBagValue += RobberyData.CashAmount
			Player.PlayerGui:WaitForChild("Core").Framework.Game.Robbery.Visible = false
			Player.PlayerGui:WaitForChild("Core").Framework.Game.BagAmount.Visible = true
			Player.PlayerGui:WaitForChild("Core").Framework.Game.BagAmount.Design.Amount.Text = "$".._G.PlayerData[Player.Name].MoneyBagValue --.."/$800"
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "+50 Bounty", Color3.fromRGB(249, 184, 54))
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "+" .. tostring(RobberyData.CashAmount) .. " Cash", Color3.fromRGB(85, 170, 127)) 

		end
	end)
end

function Knight.Init()
	MoneyBagReturnZone = Knight.Shared.External.Zone.new(workspace.Ignore.MoneyBagReturn)
	CivilMoneyBagReturnZone = Knight.Shared.External.Zone.new(workspace.Ignore.CivilMoneyBagReturn)
end

function Knight.Start()
	MoneyBagReturnZone:relocate()

	MoneyBagReturnZone.playerEntered:Connect(function(Player)
		if Player.Character:FindFirstChild("Bag") and not _G.PlayerData[Player.Name].MoneyBagIsCivil then
			Player.Character:FindFirstChild("Bag"):Destroy()
			Player.PlayerGui:WaitForChild("Core").Framework.Game.BagAmount.Visible = false

			if _G.PlayerData[Player.Name].Progression.RobberyCashMultiplier > 0 then
				_G.PlayerData[Player.Name].MoneyBagValue += (_G.PlayerData[Player.Name].Progression.RobberyCashMultiplier * 50)
			end

			Knight.Services.CharacterManager.AddCash(Player, _G.PlayerData[Player.Name].MoneyBagValue)
			_G.PlayerData[Player.Name].MoneyBagValue = 0
			_G.PlayerData[Player.Name].MoneyBagIsCivil = false
		end
	end)

	CivilMoneyBagReturnZone:relocate()

	CivilMoneyBagReturnZone.playerEntered:Connect(function(Player)
		if Player.Character:FindFirstChild("Bag") and _G.PlayerData[Player.Name].MoneyBagIsCivil then
			Player.Character:FindFirstChild("Bag"):Destroy()
			Player.PlayerGui:WaitForChild("Core").Framework.Game.BagAmount.Visible = false
			Knight.Services.CharacterManager.AddCash(Player, _G.PlayerData[Player.Name].MoneyBagValue)
			_G.PlayerData[Player.Name].MoneyBagValue = 0
			_G.PlayerData[Player.Name].MoneyBagIsCivil = false
		end
	end)

	for _, Safe in pairs(workspace.Ignore.Safes:GetChildren()) do
		local Register = nil
		local CFrameData = {
			Primary_1 = Safe.Door.Primary.CFrame,
			Nozzle1_1 = Safe.Door.Nozzle.Nozzle1.CFrame,
			Nozzle2_1 = false,

			Primary_2 = Safe.Door.Primary_Open.CFrame,
			Nozzle1_2 = Safe.Door.Nozzle_Move.Nozzle1.CFrame,
			Nozzle2_2 = false,
		}

		Safe.Door.Primary_Open:Destroy()

		if Safe.Name == "SafeLarge" then
			CFrameData.Nozzle2_1 = Safe.Door.Nozzle.Nozzle2.CFrame
			CFrameData.Nozzle2_2 = Safe.Door.Nozzle_Move.Nozzle2.CFrame

			Safe.Door.Nozzle_Move:Destroy()
		end

		Register = function()
			Knight.Services.InteractionService.RegisterInteraction(Safe.InteractionPart, "Picklock Safe", 0, function(Player)
				Knight.Services.InteractionService.DeleteInteraction(Safe.InteractionPart)

				Knight.Services.LockpickMaster.StartSession(Player, Safe.InteractionPart, Safe.Name == "SafeLarge" and 5 or 5, function(Success)
					if not Success then
						return Register()
					end
					--Knight.DropMoneyBag(math.random(370,4000), Safe.InteractionPart.CFrame)

					local DoorTime = 12
					local LockTime = 5

					-- animate unlock

					_G.tweenModel(Safe.Door.Nozzle.Nozzle1, CFrameData.Nozzle1_2, TweenInfo.new(LockTime))
					task.wait(LockTime)

					if CFrameData.Nozzle2_2 then
						_G.tweenModel(Safe.Door.Nozzle.Nozzle2, CFrameData.Nozzle2_2, TweenInfo.new(LockTime))
						task.wait(LockTime)
					end

					task.wait(1)

					-- animate door movement
					_G.tweenModel(Safe.Door, CFrameData.Primary_2, TweenInfo.new(DoorTime, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out))

					task.wait(DoorTime)

					-- Register steal stuff
					Knight.Services.InteractionService.RegisterInteraction(Safe.InteractionPart, "Steal Loot", 0, function(Player)
						Knight.Services.InteractionService.DeleteInteraction(Safe.InteractionPart)
						local Chance = math.random(1, 4)
						
						if Safe.Name == "SafeLarge" or Chance == 1 then
							local ItemAmount = Safe.Name == "SafeLarge" and math.random(2,7) or math.random(1,3)
							local Items = {}

							local Success, GeneratedItemData, i = Knight.Services.ItemsManager.CreateItem(Player, 35, false, "Chest", false)
							if Success then
								GeneratedItemData.Stack = ItemAmount
								Items[1] = GeneratedItemData
							end
							
							Knight.Services.StorageContainer.new(Player, {
								ContainerName = Safe.Name == "SafeLarge" and "LARGE SAFE" or "SMALL SAFE",
								SaveName = "MineChest",
								SaveStorage = false,
								SaveInStorageContainersArray = false,
								AllowTransfersToStorage = false,
								AllowTransferToInventory = true,
								Slots = 6,
								Items = Items
							})
							
							if Safe.Name == "SafeLarge" then
								Knight.DropMoneyBag(math.random(1570,5000), Safe.InteractionPart.CFrame)
							end
						else
							Knight.DropMoneyBag(math.random(300,1570), Safe.InteractionPart.CFrame)
						end
					end)

					task.delay(Safe.Name == "SafeLarge" and 300 or 130, function()
						Knight.Services.InteractionService.DeleteInteraction(Safe.InteractionPart)
						_G.tweenModel(Safe.Door, CFrameData.Primary_1, TweenInfo.new(DoorTime))
						task.wait(DoorTime)
						_G.tweenModel(Safe.Door.Nozzle.Nozzle1, CFrameData.Nozzle1_1, TweenInfo.new(LockTime))

						if CFrameData.Nozzle2_2 then
							_G.tweenModel(Safe.Door.Nozzle.Nozzle2, CFrameData.Nozzle2_1, TweenInfo.new(LockTime))
						end

						Register()
					end)
				end)
			end)
		end

		Register()
	end

	for _, Chest in pairs(workspace.Ignore.Chests:GetChildren()) do
		local RegisterLockpick = nil
		RegisterLockpick = function()
			if not Chest:FindFirstChild("InteractionPart") then
				return
			end

			Knight.Services.InteractionService.RegisterInteraction(Chest.InteractionPart, "Picklock Chest", 0, function(Player)
				Knight.Services.InteractionService.DeleteInteraction(Chest.InteractionPart)
				Knight.Services.LockpickMaster.StartSession(Player, Chest.InteractionPart, 10, function(Success)
					if Success then
						local chance = math.random(1,2)

						if chance == 1 then
							Knight.DropMoneyBag(math.random(370,4000), Chest.InteractionPart.CFrame)
						else
							local RandomItems = {
								{
									ItemId = 9,
									AmountRangeMin = 1,
									AmountRangeMax = 5
								},
								{
									ItemId = 12,
									AmountRangeMin = 1,
									AmountRangeMax = 3
								},
								{
									ItemId = 13,
									AmountRangeMin = 1,
									AmountRangeMax = 1
								},
								{
									ItemId = 14,
									AmountRangeMin = 3,
									AmountRangeMax = 5
								},
								{
									ItemId = 11,
									AmountRangeMin = 4,
									AmountRangeMax = 6
								},
							}

							local RandomItem = RandomItems[math.random(1, #RandomItems)]
							local RandomItem2 = RandomItems[math.random(1, #RandomItems)]

							local RandomItemAmount = math.random(RandomItem.AmountRangeMin, RandomItem.AmountRangeMax)
							local RandomItemAmount2 = math.random(RandomItem2.AmountRangeMin, RandomItem2.AmountRangeMax)

							local Items = {}

							local Success, GeneratedItemData, i = Knight.Services.ItemsManager.CreateItem(Player, RandomItem.ItemId, false, "Chest", false)
							if Success then
								GeneratedItemData.Stack = RandomItemAmount
								Items[1] = GeneratedItemData
							end

							local Success2, GeneratedItemData2, ii = Knight.Services.ItemsManager.CreateItem(Player, RandomItem2.ItemId, false, "Chest", false)
							if Success2 then
								GeneratedItemData2.Stack = RandomItemAmount2
								Items[Success and 2 or 1] = GeneratedItemData2
							end

							Knight.Services.StorageContainer.new(Player, {
								ContainerName = "MINEING CHEST",
								SaveName = "MineChest",
								SaveStorage = false,
								SaveInStorageContainersArray = false,
								AllowTransfersToStorage = false,
								AllowTransferToInventory = true,
								Slots = 6,
								Items = Items
							})
						end

						task.delay(300, function()
							RegisterLockpick()
						end)
					else
						RegisterLockpick()
					end
				end)
			end)
		end

		RegisterLockpick()
	end

	for Name, RobberyData in pairs(Knight.Cache.Robbery) do
		local Container = workspace.Robbery[Name]

		local GoldSpawn = nil
		if Container:FindFirstChild("GoldSpawn") then GoldSpawn = Knight.Shared.External.Zone.new(Container.GoldSpawn) end

		local CashSpawn = nil
		if Container:FindFirstChild("CashSpawn") then CashSpawn = Knight.Shared.External.Zone.new(Container.CashSpawn) end

		local TeleportZone = Knight.Shared.External.Zone.new(Container.Teleport)

		local function Start()
			Container.Alarm.Bell:Play()
			Knight.Shared.Roblox.ReplicatedStorage.Markers.Bank.Config.BurstType.Value = "Police"

			local BarStack = 1
			local CashStack = 1
			local HighestPayoutIndex = 0 
			local HighestPayoutData = nil

			for index, data in pairs(RobberyData.PayoutMultiplier) do
				if #Knight.Shared.Roblox.Players:GetPlayers() >= data.Size and index > HighestPayoutIndex then
					HighestPayoutIndex = index
					HighestPayoutData = data
				end
			end

			if HighestPayoutData then
				CashStack = HighestPayoutData.CashStack
				BarStack = RobberyData.BarStack * HighestPayoutData.BarMultiplier
			end

			if Container:FindFirstChild("GoldSpawn") then
				for i = 1, BarStack do
					Knight:SpawnItem(RobberyData, "GoldBar", GoldSpawn, Container.Spawned)
				end
			end

			if Container:FindFirstChild("CashSpawn") then
				for i = 1, CashStack do
					Knight:SpawnItem(RobberyData, "CashStack", CashSpawn, Container.Spawned)
				end
			end

			task.spawn(function()
				repeat task.wait(1) until RobberyData.TimeLeft == 280

				for i,v in pairs(Knight.Shared.Roblox.Players:GetPlayers()) do
					if v.Team == Knight.Shared.Roblox.Teams.Sheriff or v.Team == game.Teams.Mayor or v.Team == game.Teams["RAMPAGE Rangers"] or v.Team == game.Teams["Bounty Hunter"] then
						Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(v, "Notify", "The bank is being robbed!", Color3.fromRGB(255, 0, 0))
					end
				end

				repeat task.wait(1) until (RobberyData.TimeLeft <= 0)

				if RobberyData.TimeLeft <= 0 then
					for i,v in pairs(TeleportZone:getPlayers()) do
						v.PlayerGui:WaitForChild("Core").Framework.Game.Robbery.Visible = false
					end

					Container.Alarm.Bell:Stop()
					Knight.Shared.Roblox.ReplicatedStorage.Markers.Bank.Config.BurstType.Value = "None"

					for i,v in pairs(TeleportZone:getPlayers()) do
						v:RequestStreamAroundAsync(Container.Outside.Position)
						task.wait()
						v.Character:SetPrimaryPartCFrame(Container.Outside.CFrame)
					end

					Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Notify", "Bank has now closed", Color3.fromRGB(170, 26, 26))

					for i,v in pairs(Container.Spawned:GetChildren()) do
						v:Destroy()
					end

					for _, Door in pairs(Container.Doors:GetChildren()) do
						Door.AnchoredParts.Prompts.ProximityPrompt.Triggered:Connect(function(Player)
							Door.AnchoredParts.Prompts.ProximityPrompt.Enabled = false
							Door.AnchoredParts.Bell_Toucher.CanCollide = true
						end)
					end

					task.delay(RobberyData.ResetTime, function()
						for _, Door in pairs(Container.Doors:GetChildren()) do
							Door.AnchoredParts.Prompts.ProximityPrompt.Triggered:Connect(function(Player)
								Door.AnchoredParts.Prompts.ProximityPrompt.Enabled = true
								Door.AnchoredParts.Bell_Toucher.CanCollide = false
							end)
						end

						Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Notify", "Bank is now open!", Color3.fromRGB(0, 170, 127))
					end)
				end
			end)

			task.spawn(function()
				while RobberyData.TimeLeft > 0 do
					RobberyData.TimeLeft -= 1

					--for i,v in pairs(TeleportZone:getPlayers()) do
					--	v.PlayerGui:WaitForChild("Core").Framework.Game.Robbery.Design.Timer.Text = Knight.Shared.External.TimeModule:ConvertToTime(RobberyData.TimeLeft, "MS")
					--end

					task.wait(1)
				end
			end)
		end

		for _, Door in pairs(Container.Doors:GetChildren()) do
			Door.AnchoredParts.Prompts.ProximityPrompt.Triggered:Connect(function(Player)
				if Door:FindFirstChild("IsStart") and #Knight.Shared.Roblox.Players:GetPlayers() < 2 and not game:GetService("RunService"):IsStudio() then
					Knight.Services.NotifyService.Notify(Player, "Robbery failed", "2+ players must be online in-order to rob the bank.", false, 15)

					return
				end

				Door.AnchoredParts.Prompts.ProximityPrompt.Enabled = false
				Door.AnchoredParts.Bell_Toucher.CanCollide = false

				if Door:FindFirstChild("IsStart") then 
					Knight.Services.LawManager.AddBounty(Player, 75) 
					Start() 
				else
					Knight.Services.LawManager.AddBounty(Player, 35)
				end
			end)
		end

		task.delay(4, function()
			TeleportZone:relocate()
		end)
	end
end

function Knight.DropMoneyBag(Amount, CFrameLocation, AllowCivil)
	if AllowCivil == nil then AllowCivil = false end

	local ProximityPrompt = Knight.Shared.Roblox.ServerStorage.ProximityPrompt:Clone()
	local Configuration = require(ProximityPrompt:WaitForChild("Configuration"))
	local cash_type = AllowCivil and "" or "(Stolen Money)"

	Configuration.set({
		["Action"] = "Pickup",
		["Title"] = "Money Bag",
		["SubTitle"] = "$" .. tostring(Amount) .. cash_type,
		["Bottom"] = "",
		["Color"] = AllowCivil and Color3.fromRGB(85, 170, 127) or Color3.fromRGB(255, 8, 8)
	})

	local Bag = Knight.Shared.Roblox.ReplicatedStorage.Assets.Morphs.Bag:Clone()
	Bag.Parent = workspace
	Bag.LeftHand:Destroy()
	Bag.Bag.CFrame = CFrameLocation;
	Bag.Bag.CanCollide = true
	Bag.Bag.Anchored = false

	ProximityPrompt.Parent = Bag.Bag;
	ProximityPrompt.RequiresLineOfSight = false
	ProximityPrompt.Enabled = true
	ProximityPrompt.Triggered:Connect(function(Player)
		ProximityPrompt.Enabled = false
		Bag:Destroy()

		if Player.Team == Knight.Shared.Roblox.Teams.Outlaw or AllowCivil then
			_G.PlayerData[Player.Name].MoneyBagValue += Amount
			_G.PlayerData[Player.Name].MoneyBagIsCivil = AllowCivil

			if not Player.Character:FindFirstChild("Bag") then
				Knight.Services.CharacterManager.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Morphs.Bag, "Bag")
			end

			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Chat", AllowCivil and "Take bag to bank to claim." or "Take the bag to Bearclaw City.")
			Player.PlayerGui:WaitForChild("Core").Framework.Game.BagAmount.Visible = true
			Player.PlayerGui:WaitForChild("Core").Framework.Game.BagAmount.Design.Amount.Text = "$".._G.PlayerData[Player.Name].MoneyBagValue--.."/$800"
			if not AllowCivil then Knight.Services.LawManager.AddBounty(Player, 15) end
		else
			Knight.Services.CharacterManager.AddCash(Player, Amount * 0.50)
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Chat", "Thanks for returning the bag to the bank, heres a small reward.")
		end
	end)
end

return Knight
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

local tweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

local function tweenModel(model, CF, info)
	local CFrameValue = Instance.new("CFrameValue")
	CFrameValue.Value = model:GetPrimaryPartCFrame()

	CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
		model:SetPrimaryPartCFrame(CFrameValue.Value)
	end)

	local tween = tweenService:Create(CFrameValue, info, {Value = CF})
	tween:Play()

	tween.Completed:Connect(function()
		CFrameValue:Destroy()
	end)
end

function Knight.Start()
	for _, Location in pairs(workspace.Ignore.Treasure:GetChildren()) do
		local IsChest = Instance.new("BoolValue", Location)
		IsChest.Name = "IsChest"
		IsChest.Value = true
		
		local ChestRemote = Instance.new("BindableEvent", Location)
		ChestRemote.Name = "ChestRemote"
		
		local Stage = 0;
		local InStageTween = false
		local Unlocked = false
		
		local Chest = Knight.Shared.Assets.GameplayAssets.Chest:Clone()
		Chest:PivotTo(Location.TweenStages[1].CFrame)
		Chest.Parent = workspace.Ignore
		
		Location.Primary.Transparency = 1
		Location.Primary.CanCollide = false
		
		for _, part in pairs(Location.TweenStages:GetChildren()) do
			part.Transparency = 1
			part.CanCollide = false
		end
		
		local function ReleaseDaTreasure()
			for i,v in pairs(script.Effects:GetChildren()) do
				v.Parent = Location.TweenStages[4]
			end
			
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
					ItemId = 149,
					AmountRangeMin = 1,
					AmountRangeMax = 1
				},
				{
					ItemId = 146,
					AmountRangeMin = 4,
					AmountRangeMax = 25
				},
				{
					ItemId = 145,
					AmountRangeMin = 1,
					AmountRangeMax = 1
				},
			}
			
			Knight.Services.InteractionService.RegisterInteraction(Location.Primary, "Open Chest", 0, function(Player)
				CollectionService:RemoveTag(Location.Primary, "Interactable")
				Location.Primary:ClearAllChildren()
				local RandomItem = RandomItems[math.random(1, #RandomItems)]
				local RandomItem2 = RandomItems[math.random(1, #RandomItems)]
				
				local RandomItemAmount = math.random(RandomItem.AmountRangeMin, RandomItem.AmountRangeMax)
				local RandomItemAmount2 = math.random(RandomItem2.AmountRangeMin, RandomItem2.AmountRangeMax)
				
				local Items = {}
				
				local Success, GeneratedItemData, i = Knight.Services.ItemsManager.CreateItem(Player, RandomItem.ItemId, false, "Chest", true, {
					OrginatedFrom = Player.UserId,
					LastOwner = Player.UserId,
					TradeReferenceId = 0
				})
				
				if Success then
					GeneratedItemData.Stack = RandomItemAmount
					Items[1] = GeneratedItemData
				end

				local Success2, GeneratedItemData2, ii = Knight.Services.ItemsManager.CreateItem(Player, RandomItem2.ItemId, false, "Chest", true, {
					OrginatedFrom = Player.UserId,
					LastOwner = Player.UserId,
					TradeReferenceId = 0
				})
				if Success2 then
					GeneratedItemData2.Stack = RandomItemAmount2
					Items[Success and 2 or 1] = GeneratedItemData2
				end
				
				Knight.Services.StorageContainer.new(Player, {
					ContainerName = "TREASURE CHEST",
					SaveName = "TreasureChest",
					SaveStorage = false,
					SaveInStorageContainersArray = false,
					AllowTransfersToStorage = false,
					AllowTransferToInventory = true,
					Slots = 6,
					Items = Items
				})
				--Knight.Services.ItemsManager.AddToStackOrCreate(Player, RandomItem.ItemId, RandomItemAmount, false)
				--Knight.Services.ItemsManager.AddToStackOrCreate(Player, RandomItem2.ItemId, RandomItemAmount2, false)
			end)
			
			task.delay(30, function()
				Location.TweenStages[4]:ClearAllChildren()
				script.Splash:Clone().Parent = Location.Primary
				Unlocked = false
				tweenModel(Chest, Location.TweenStages[1].CFrame, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0))
				task.wait(4)
				Location.Primary.Splash:Destroy()
			end)
		end
		
		ChestRemote.Event:Connect(function(Player, NewStage)
			if NewStage == "NextStage" then
				if InStageTween then return end
				if Unlocked then return end
				
				InStageTween = true
				Stage = Stage + 1;
				if Stage > 4 then Stage = 4 end
				tweenModel(Chest, Location.TweenStages[Stage].CFrame, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0))
				task.delay(4, function()
					InStageTween = false
					
					if Stage == 4 then
						Unlocked = true
						ReleaseDaTreasure()
					end
				end)
			end
		end)
	end
end

return Knight
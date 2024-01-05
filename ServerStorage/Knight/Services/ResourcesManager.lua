-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		CraftSessions = {},
		Databases = {},
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

local OreItemIds = {
	["Ruby"] = 8,
	["Gold"] = 9,
	["Copper"] = 10,
	["Iron"] = 11,
	["Diamond"] = 12,
	["Emerald"] = 13,
	["Coal"] = 14,
	["Limestone"] = 129,
	["Fireite"] = 144,
}

local OreHealth = {
	["Ruby"] = 1500,
	["Gold"] = 2000,
	["Copper"] = 1000,
	["Iron"] = 1500,
	["Diamond"] = 2000,
	["Emerald"] = 2000,
	["Coal"] = 120,
	["Limestone"] = 2000,
	["Fireite"] = 1500,
}

local BuildingModels = {
	-- Model Name = Item Id
	["Diagonal Wall"] = 140,
	["Floor"] = 139,
	["Horizontal Half Wall"] = 138,
	["Pillar"] = 137,
	["Ramp"] = 136,
	["Ramp Corner 1"] = 134,
	["Ramp Corner 2"] = 135,
	["Stairs"] = 133,
	["Tall Pillar"] = 132,
	["Triangle Floor"] = 132,
	["Vertical Half Wall"] = 131,
	["Wall"] = 130,
	["Door & Wall"] = 141,
}

_G.DropPelt = function(AnimalName, Position, Count)

end

function Knight.GetItemCountFromInventory(Inventory)
	local item_count = {}

	for key, inventory_data in pairs(Inventory) do
		local Success, ItemData = _G.ItemIdToData(inventory_data.ItemId)

		if Success then
			if item_count[ItemData.Name] == nil then item_count[ItemData.Name] = 0 end
			item_count[ItemData.Name] += ((inventory_data.Stack ~= nil and inventory_data.Stack) or 1)
		end
	end

	task.wait()

	return item_count
end

function Knight.HasRequiredResources(Inventory, Required)
	local item_stacks = Knight.GetItemCountFromInventory(Inventory)
	local missing_items = {}

	task.wait()

	for _, data in pairs(Required) do
		local item_id, amount_required = data.ItemId, data.Amount;
		local Success, ItemData = _G.ItemIdToData(item_id)

		if Success then
			local Name = ItemData.Name
			local amount_have = item_stacks[Name] or 0

			if amount_have < amount_required then
				local amount_missing = amount_required - amount_have
				missing_items[Name] = amount_missing
				warn("Missing items, amount is", amount_missing)
			end
		end
	end

	task.wait()

	return missing_items, item_stacks
end

function Knight.Craft(Player, ItemId, CraftReferenceId)
	if Knight.Cache.CraftSessions[CraftReferenceId] == nil then
		return;
	end

	local payload_data = Knight.Cache.CraftSessions[CraftReferenceId][ItemId]

	if payload_data == nil then return end

	local RequiredResources, MyStack = Knight.HasRequiredResources(_G.PlayerData[Player.Name].Backpack, payload_data.RequiredToCraft)

	if Player:GetRankInGroup(9640975) >= 249 then
		RequiredResources = {}
		payload_data.RequiredToCraft = {}
	end

	if _G.get_length(RequiredResources) > 0 then 
		return print("dont have enough resources to make required item.")
	end

	for _, data in pairs(payload_data.RequiredToCraft) do
		local required_id, stack = data.ItemId, data.Amount;
		Knight.Services.ItemsManager.RemoveFromStack(Player, required_id, stack, false)
	end

	local success, index = Knight.Services.ItemsManager.GiveItem(Player, ItemId, true, false, false, "Crafted item.")
end

function Knight.CreateCraftSession(Player)
	return Player.UserId
end

function Knight.OpenBench(Player)
	local CraftReferenceId = Knight.CreateCraftSession(Player)
	local Payload = {}

	for index, item_data in pairs(Knight.Database.Items.get()) do
		if item_data.CanCraftBench ~= nil and item_data.CanCraftBench then
			local d = item_data
			d.CraftReferenceId = CraftReferenceId
			Payload[item_data.ItemId] = item_data
		end
	end

	Knight.Cache.CraftSessions[CraftReferenceId] = Payload
	Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "LaunchCrafting", Payload)
end

function Knight.OpenSaw(Player)
	local CraftReferenceId = Knight.CreateCraftSession(Player)
	local Payload = {}

	for index, item_data in pairs(Knight.Database.Items.get()) do
		if item_data.CanSaw ~= nil and item_data.CanSaw then
			local d = item_data
			d.CraftReferenceId = CraftReferenceId
			Payload[item_data.ItemId] = item_data
		end
	end

	Knight.Cache.CraftSessions[CraftReferenceId] = Payload
	Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "LaunchCrafting", Payload)
end

function Knight.OpenAnvil(Player)
	local CraftReferenceId = Knight.CreateCraftSession(Player)
	local Payload = {}

	for index, item_data in pairs(Knight.Database.Items.get()) do
		if item_data.CanAnvil ~= nil and item_data.CanAnvil then
			local d = item_data
			d.CraftReferenceId = CraftReferenceId
			Payload[item_data.ItemId] = item_data
		end
	end

	Knight.Cache.CraftSessions[CraftReferenceId] = Payload
	Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "LaunchCrafting", Payload)
end

function Knight.OpenSmelt(Player)
	local CraftReferenceId = Knight.CreateCraftSession(Player)
	local Payload = {}

	for index, item_data in pairs(Knight.Database.Items.get()) do
		if item_data.CanSmelt ~= nil and item_data.CanSmelt then
			local d = item_data
			d.CraftReferenceId = CraftReferenceId
			Payload[item_data.ItemId] = item_data
		end
	end

	Knight.Cache.CraftSessions[CraftReferenceId] = Payload
	Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "LaunchCrafting", Payload)
end

local function Serialize(prop) --prop will be the property's value type
	local type = typeof(prop) --the type of the value
	local r --the returned value afterwards
	if type == "BrickColor" then --if it's a brickcolor
		r = tostring(prop)
	elseif type == "CFrame" then --if it's a cframe
		r = {pos = Serialize(prop.Position), rX = Serialize(prop.rightVector), rY = Serialize(prop.upVector), rZ = Serialize(-prop.lookVector)}
	elseif type == "Vector3" then --if it was a vector3, this would apply for .Position or .Size property
		r = {X = prop.X, Y = prop.Y, Z = prop.Z}
	elseif type == "Color3" then --color3
		r = {Color3.toHSV(prop)}
	elseif type == "EnumItem" then --or an enum, like .Material or .Face property
		r = {string.split(tostring(prop), ".")[2], string.split(tostring(prop), ".")[3]} 
	else --if it's a normal property, like a string or a number, return it
		r = prop
	end
	return r 
end

local function Deserialize(prop, value)
	local r --this will be the returned deserialized property
	if prop == "Position" or prop == "Size" then
		r = Vector3.new(value.X, value.Y, value.Z)
	elseif prop == "CFrame" then
		r = CFrame.fromMatrix(Deserialize("Position", value.pos), Deserialize("Position", value.rX), Deserialize("Position", value.rY), Deserialize("Position", value.rZ))
	elseif prop == "BrickColor" then
		r = BrickColor.new(value)
	elseif prop == "Color" or prop == "Color3" then
		r = Color3.fromHSV(unpack(value))
	elseif prop == "Material" or prop == "Face" or prop == "Shape" then --you probably have to fill this one depending on the properties you're saving!
		r = Enum[value[1]][value[2]]
	else
		r = value --it gets here if the property 
	end
	return r --return it
end

function Knight.Init()
	local BuildingBlacklistZone = Knight.Shared.External.Zone.new(workspace.Ignore.BuildBlacklist)

	for _, model in pairs(Knight.Shared.Assets.BuildParts:GetChildren()) do
		model.Parent = Knight.Shared.Assets.Items
	end

	Knight.Shared.Services.Remotes:Register("BuildingSocket", "RemoteFunction", function(Player, ...)
		local args = {...};
		local action = args[1];
		local model = args[2] or false;

		if action == "ClearBuildSession" then
			_G.PlayerData[Player.Name].Building.Current = {}
		end
		
		if action == "Unload" then
			_G.PlayerData[Player.Name].Building.Current = {}

			for _, Model in pairs(workspace.Ignore.PlayerBuildings:GetChildren()) do
				if Model.Owner.Value == Player.Name then
					local model_id = BuildingModels[Model.Name]

					if model_id then
						local success = Knight.Services.ItemsManager.AddToStackOrCreate(Player, model_id, 1, false)
					end

					Model:Destroy()
				end
			end
		end

		if action == "Save" then
			table.insert(_G.PlayerData[Player.Name].Building.Saves, _G.PlayerData[Player.Name].Building.Current)
		end

		if action == "Delete" then
			for index, Model in pairs(_G.PlayerData[Player.Name].Building.Saves[args[2]]) do
				local model_id = BuildingModels[Model.Name]

				if model_id then
					local success = Knight.Services.ItemsManager.AddToStackOrCreate(Player, model_id, 1, false)

					for _, WorldModel in pairs(workspace.Ignore.PlayerBuildings:GetChildren()) do
						if WorldModel.Owner.Value == Player.Name then
							if WorldModel:GetAttribute("BuildSerialIndex") == index then
								WorldModel:Destroy()
								_G.PlayerData[Player.Name].Building.Current = {}
							end
						end
					end
				end
			end
			
			table.remove(_G.PlayerData[Player.Name].Building.Saves, args[2])
		end
		
		if action == "Load" then
			print(_G.PlayerData[Player.Name].Building.Saves)
			if _G.PlayerData[Player.Name].Building.Saves[args[2]] == nil then
				return
			end
			
			_G.PlayerData[Player.Name].Building.Current = {} --_G.PlayerData[Player.Name].Building.Saves[args[2]]
			task.wait()
			for _, Model in pairs(workspace.Ignore.PlayerBuildings:GetChildren()) do
				if Model.Owner.Value == Player.Name then
					local model_id = BuildingModels[Model.Name]

					if model_id then
						local success = Knight.Services.ItemsManager.AddToStackOrCreate(Player, model_id, 1, false)
					end

					Model:Destroy()
				end
			end
			
			task.wait()
			
			for index, model_data in pairs(_G.PlayerData[Player.Name].Building.Saves[args[2]]) do
				local model = Knight.Shared.Assets.Items[model_data[1]]
				
				if model then
					model = model:Clone()
					model:SetPrimaryPartCFrame(Deserialize(model_data[2]))
					model.Owner.Value = Player.Name
					model.Parent = workspace.Ignore.PlayerBuildings

					local insert_id = #_G.PlayerData[Player.Name].Building.Current+1;

					_G.PlayerData[Player.Name].Building.Current[insert_id] = model_data

					model:SetAttribute("BuildSerialIndex", insert_id)

					if model.Name == "Door & Wall" then
						model.Model.CounterDoor.Script.Enabled = true
						model.Model.CounterDoor.Base.Rotate.Enabled = true
						model.Model.CounterDoor.Base.Rotate2.Enabled = true
						model.Model.CounterDoor.Base.BodyGyro.D = 3
						model.Model.CounterDoor.Base.BodyGyro.P = 15
						model.Model.CounterDoor.Base.BodyGyro.MaxTorque = Vector3.new(15000, 15000, 15000)
					end
				end
			end
		end

		if action == "Build" then
			local cframe = args[3] or false;
			local model_id = BuildingModels[model]

			if not model_id then
				return false, "ERROR_INVALID_MODEL_ARG"
			end

			local model =  Knight.Shared.Assets.Items[model]

			local has, index, inventory_data, data = Knight.Services.ItemsManager.HasItem(Player, model_id, false)

			if not has then
				return false, "ERROR_NO_BUILDING_MODEL"
			end

			local isWithinZoneBool, touchingZoneParts = BuildingBlacklistZone:findPoint(cframe.Position)

			if isWithinZoneBool then
				return false, "You cannot build in a blacklisted zone."
			end

			local success = Knight.Services.ItemsManager.RemoveFromStack(Player, model_id, 1, false)

			if not success then
				return false, "Unknown error occured removing item from stack."
			end

			model = model:Clone()
			model:SetPrimaryPartCFrame(cframe)
			model.Owner.Value = Player.Name
			model.Parent = workspace.Ignore.PlayerBuildings
			
			local insert_id = #_G.PlayerData[Player.Name].Building.Current+1;
			
			_G.PlayerData[Player.Name].Building.Current[insert_id] = {
				model.Name, Serialize(cframe)
			}

			model:SetAttribute("BuildSerialIndex", insert_id)

			if model.Name == "Door & Wall" then
				model.Model.CounterDoor.Script.Enabled = true
				model.Model.CounterDoor.Base.Rotate.Enabled = true
				model.Model.CounterDoor.Base.Rotate2.Enabled = true
				model.Model.CounterDoor.Base.BodyGyro.D = 3
				model.Model.CounterDoor.Base.BodyGyro.P = 15
				model.Model.CounterDoor.Base.BodyGyro.MaxTorque = Vector3.new(15000, 15000, 15000)
			end

			return true, "Item has been built!"
		elseif action == "Destroy" then
			if model and model.Parent and model.Owner and model.Owner.Value == Player.Name then
				local model_id = BuildingModels[model.Name]

				if not model_id then
					return false, "Failed to refund build, cannot delete."
				end
				
				_G.PlayerData[Player.Name].Building.Current[model:GetAttribute("BuildSerialIndex")] = nil
				model:Destroy()

				local success = Knight.Services.ItemsManager.AddToStackOrCreate(Player, model_id, 1, false)

				if not success then
					return false, "Failed to refund build " .. tostring(model_id)
				end

				return true, "Item deleted!"
			else
				return false, "Invalid supplied model."
			end
		elseif action == "Refresh" then
			Knight.Shared.Services.Remotes:Fire("BuildingSocket", Player, "Refresh", _G.PlayerData[Player.Name])
			return true, "Success"
		end
	end)
	BuildingBlacklistZone:relocate()
end

function Knight.Start()
	for i,v in pairs(workspace.Ores:GetChildren()) do
		pcall(function()
			v.Humanoid.MaxHealth = OreHealth[v.Type.Value] or 120;
			v.Humanoid.Health = v.Humanoid.MaxHealth
		end)
	end

	for i,v in pairs(workspace.Ignore.Grass:GetChildren()) do
		game:GetService("CollectionService"):AddTag(v, "WindShake")
	end

	for i,v in pairs(workspace.Trees:GetChildren()) do
		if v.Name == "Tree" then
			v.Leaf.Anchored = false
			v.Leaf.CanCollide = false
			v.PrimaryPart = v.TrunkStill

			local Weld = Instance.new("WeldConstraint", v)
			Weld.Part0 = v.TrunkStill
			Weld.Part1 = v.Leaf

			game:GetService("CollectionService"):AddTag(v.Leaf, "WindShake")

			if v:FindFirstChild("SnowLeaf") then
				v.SnowLeaf.Anchored = false
				v.SnowLeaf.CanCollide = false

				local Weld2 = Instance.new("WeldConstraint", v)
				Weld2.Part0 = v.TrunkStill
				Weld2.Part1 = v.SnowLeaf

				game:GetService("CollectionService"):AddTag(v.SnowLeaf, "WindShake")
			end

			if v:FindFirstChild("TrunkFall") then 
				v.TrunkFall:Destroy()
			end

			v.TrunkStill:ClearAllChildren()
		end
	end

	for i,v in pairs(workspace.ThunderTrees:GetChildren()) do
		if v.Name == "Tree" then
			v.Leaf.Anchored = false
			v.Leaf.CanCollide = false
			v.PrimaryPart = v.TrunkStill
			v.Thunderstruck.Value = false

			local Weld = Instance.new("WeldConstraint", v)
			Weld.Part0 = v.TrunkStill
			Weld.Part1 = v.Leaf

			game:GetService("CollectionService"):AddTag(v.Leaf, "WindShake")

			if v:FindFirstChild("SnowLeaf") then
				v.SnowLeaf.Anchored = false
				v.SnowLeaf.CanCollide = false

				local Weld2 = Instance.new("WeldConstraint", v)
				Weld2.Part0 = v.TrunkStill
				Weld2.Part1 = v.SnowLeaf

				game:GetService("CollectionService"):AddTag(v.SnowLeaf, "WindShake")
			end

			if v:FindFirstChild("TrunkFall") then 
				v.TrunkFall:Destroy()
			end

			v.TrunkStill:ClearAllChildren()
		end
	end

	Knight.Shared.Roblox.Lighting.Raining.Changed:Connect(function()
		if Knight.Shared.Roblox.Lighting.Raining.Value then
			local ThunderChance = math.random(1,1)

			if ThunderChance == 1 or ThunderChance == 25 then
				Knight.SpawnThunderLog()
			end
		end
	end)

	Knight.Shared.Roblox.Players.PlayerRemoving:Connect(function(Player)
		for _, Model in pairs(workspace.Ignore.PlayerBuildings:GetChildren()) do
			if Model.Owner.Value == Player.Name then
				local model_id = BuildingModels[Model.Name]

				if model_id then
					local success = Knight.Services.ItemsManager.AddToStackOrCreate(Player, model_id, 1, false)
				end

				Model:Destroy()
			end
		end
	end)

	while true do
		local RainChance = math.random(1, 10)

		if RainChance == 1 or RainChance == 5 then
			if not Knight.Shared.Roblox.Lighting.Raining.Value then
				Knight.Shared.Roblox.Lighting.Raining.Value = true
				task.wait(300)
				Knight.Shared.Roblox.Lighting.Raining.Value = false
			end
		end

		task.wait(300)
	end
end

local TLogAttempts = 0

function Knight.SpawnThunderLog()
	local Trees = workspace.ThunderTrees:GetChildren()
	local Tree = Trees[math.random(1, #Trees)]

	if Tree.Down.Value then
		if TLogAttempts <= 4 then -- max retrys is 4
			TLogAttempts += 1
			return Knight.SpawnThunderLog()
		else
			return warn("Stackoverflow aborted")
		end
	end

	warn("Thunderstruck Tree Spawned.")

	TLogAttempts = 0
	Tree.Down.Value = false
	Tree.Thunder:Play()
	Tree.Thunderstruck.Value = true

	for i,v in pairs(Tree.TrunkStill:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end

	for i,v in pairs(Tree.Leaf:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end

	for i,v in pairs(Knight.Shared.Roblox.Players:GetPlayers()) do
		v:RequestStreamAroundAsync(Tree.A.Position)
		v:RequestStreamAroundAsync(Tree.B.Position)
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(v, "Arc", Tree.A, Tree.B)
	end

	Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Chat", "A thunder struck tree has spawned!", Color3.fromRGB(10, 195, 223))
	Tree.Leaf.Color = Color3.fromRGB(27, 42, 53)
	Tree.Humanoid.Health = Tree.Humanoid.MaxHealth

	local OriginalCFrame = Tree.TrunkStill.CFrame;

	task.delay(300, function()
		local Info2 = TweenInfo.new(
			1, 
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.In,
			0,
			false,
			0
		)

		if Tree.Down.Value == false then
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Chat", "The thunderstruck tree has despawned!", Color3.fromRGB(127, 17, 17))
		end

		Tree.TrunkStill.CFrame = OriginalCFrame
		Tree.Down.Value = false
		Tree.TrunkStill.CanCollide = true
		Tree.Humanoid.Health = Tree.Humanoid.MaxHealth
		Tree.Leaf.Color = Color3.fromRGB(48, 63, 53)

		if Tree:FindFirstChild("SnowLeaf") then
			Knight.Shared.Roblox.TweenService:Create(Tree.SnowLeaf, Info2, {Transparency = 0}):Play()
		end

		Knight.Shared.Roblox.TweenService:Create(Tree.Leaf, Info2, {Transparency = 0}):Play()
		Knight.Shared.Roblox.TweenService:Create(Tree.TrunkStill, Info2, {Transparency = 0}):Play()

		for i,v in pairs(Tree.TrunkStill:GetChildren()) do
			if v:IsA("ParticleEmitter") then
				v.Enabled = false
			end
		end

		for i,v in pairs(Tree.Leaf:GetChildren()) do
			if v:IsA("ParticleEmitter") then
				v.Enabled = false
			end
		end
	end)
end

_G.SpawnThunderLog = Knight.SpawnThunderLog

function Knight.DamageResource(Player, Model, Damage)
	local Type = "Player";

	if Model.Name == "Ore" then Type = "Ore" end
	if Model.Name == "Tree" then Type = "Tree" end

	if Type == "Tree" then
		if Model.Down.Value then return end

		local MineUI = Player.PlayerGui:WaitForChild("Core").Framework.Game.Mine;
		MineUI.TextLabel.Text = "<b>TREE</b>"
		MineUI.Visible = true

		local health = math.clamp(Model.Humanoid.Health / Model.Humanoid.MaxHealth, 0, 1)
		local info = TweenInfo.new(.1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,0) 
		Knight.Shared.Roblox.TweenService:Create(MineUI.Bar,info,{Size = UDim2.fromScale(health, 1)}):Play()

		if _G.PlayerData[Player.Name].Progression.TreeDamage > 0 then
			Damage -= (_G.PlayerData[Player.Name].Progression.TreeDamage * 15)
		end

		Model.Humanoid.Health -= Damage

		if Model.Humanoid.Health <= 0 then
			Model.Down.Value = true
			Model.Humanoid.Health = Model.Humanoid.MaxHealth
			MineUI.Visible = false

			local SoundsList = {
				"rbxassetid://5451436860",
				"rbxassetid://1911995155",
				"rbxassetid://199633606"
			}

			local OriginalCFrame = Model.TrunkStill.CFrame;

			local FallSound = Instance.new("Sound")
			FallSound.Volume = 1
			FallSound.SoundId = SoundsList[3] -- SoundsList[math.random(1, #SoundsList)]
			FallSound.RollOffMaxDistance = 200
			FallSound.RollOffMinDistance = 50
			FallSound.Parent = Model.TrunkStill
			FallSound:Play()

			task.wait(.2)

			local Info = TweenInfo.new(
				3, 
				Enum.EasingStyle.Cubic, -- quad
				Enum.EasingDirection.In,
				0,
				false,
				0
			)

			local Info2 = TweenInfo.new(
				1, 
				Enum.EasingStyle.Linear,
				Enum.EasingDirection.In,
				0,
				false,
				0
			)

			Model.TrunkStill.CanCollide = false

			Knight.Shared.Roblox.TweenService:Create(Model.TrunkStill, Info, {CFrame = Model:GetPrimaryPartCFrame() * CFrame.Angles(math.rad(90), 0, 0)}):Play()
			task.wait(2)
			Knight.Shared.Roblox.TweenService:Create(Model.TrunkStill, Info2, {Transparency = 1}):Play()
			Knight.Shared.Roblox.TweenService:Create(Model.Leaf, Info2, {Transparency = 1}):Play()

			if Model:FindFirstChild("SnowLeaf") then
				Knight.Shared.Roblox.TweenService:Create(Model.SnowLeaf, Info2, {Transparency = 1}):Play()
			end

			task.wait(1.1)
			Model:SetPrimaryPartCFrame(Model:GetPrimaryPartCFrame() * CFrame.Angles(-math.rad(90), 0, 0))

			--[[
			Model.TrunkStill.Anchored = false
			Model.TrunkStill.CanCollide = true
			Model.TrunkStill.Velocity = Vector3.new(10, 0, 10)
			]]

			wait(.6)
			FallSound:Destroy()

			if Model:FindFirstChild("Thunderstruck") and Model:FindFirstChild("Thunderstruck").Value == true then
				Knight.DropResource(37, 1, Player.Character.PrimaryPart.CFrame) --Model.TrunkStill.CFrame)
				for i,v in pairs(Model.TrunkStill:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v.Enabled = false
					end
				end

				for i,v in pairs(Model.Leaf:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v.Enabled = false
					end
				end
			else
				Knight.DropResource(6, math.random(2, 6),  Player.Character.PrimaryPart.CFrame) --Model.TrunkStill.CFrame)
			end

			task.spawn(function()
				task.wait(math.random(120,300))

				Model.TrunkStill.CFrame = OriginalCFrame
				Model.Down.Value = false
				Model.TrunkStill.CanCollide = true
				Model.Humanoid.Health = Model.Humanoid.MaxHealth
				--Model.TrunkStill.Velocity = Vector3.new(0, 0, 0)

				if Model:FindFirstChild("SnowLeaf") then
					Knight.Shared.Roblox.TweenService:Create(Model.SnowLeaf, Info2, {Transparency = 0}):Play()
				end

				Knight.Shared.Roblox.TweenService:Create(Model.Leaf, Info2, {Transparency = 0}):Play()
				Knight.Shared.Roblox.TweenService:Create(Model.TrunkStill, Info2, {Transparency = 0}):Play()
			end)
		end

		task.spawn(function()
			wait(15)
			if Player.PlayerGui:WaitForChild("Core").Framework.Game.Mine.Visible == true and _G.ServerCache[Player.UserId .. "_mineing"] == nil then
				Player.PlayerGui:WaitForChild("Core").Framework.Game.Mine.Visible = true
			end
		end)
	elseif Type == "Ore" then
		if Model.Down.Value == true then 
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Chat", "There's no more ore left, try again later", Color3.fromRGB(255, 48, 48))
			return 
		end

		if Model:FindFirstChild("JailOre") then
			if _G.PlayerData[Player.Name].InJail == false then 
				Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Chat", "This ore is for prisoners only", Color3.fromRGB(255, 48, 48))
				return
			end
		end

		Player.PlayerGui:WaitForChild("Core").Framework.Game.Mine.Visible = true
		Player.PlayerGui:WaitForChild("Core").Framework.Game.Mine.TextLabel.Text = "<b>"..string.upper(Model.Type.Value).."</b>"

		task.spawn(function()
			wait(15)
			if Player.PlayerGui:WaitForChild("Core").Framework.Game.Mine.Visible == true and _G.ServerCache[Player.UserId .. "_mineing"] == nil then
				Player.PlayerGui:WaitForChild("Core").Framework.Game.Mine.Visible = true
			end
		end)

		local health = math.clamp(Model.Humanoid.Health / Model.Humanoid.MaxHealth, 0, 1)
		local info = TweenInfo.new(Model.Humanoid.Health / Model.Humanoid.MaxHealth,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,0)

		Knight.Shared.Roblox.TweenService:Create(Player.PlayerGui:WaitForChild("Core").Framework.Game.Mine.Bar,info,{Size = UDim2.fromScale(health, 1)}):Play()
		Knight.Shared.Roblox.TweenService:Create(Model.Rock, TweenInfo.new(.02,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,1,true,0), {CFrame = Model.Rock.CFrame*CFrame.new(1,0,0)}):Play()

		if _G.PlayerData[Player.Name].Progression.MiningDamage > 0 then
			Damage -= (_G.PlayerData[Player.Name].Progression.MiningDamage * 15)
		end

		Model.Humanoid.Health -= Damage

		if Model.Humanoid.Health <= 0 then
			Player.PlayerGui:WaitForChild("Core").Framework.Game.Mine.Visible = false

			if Model:FindFirstChild("JailOre") then
				_G.PlayerData[Player.Name].JailTime -= 30
				Knight.Services.CharacterManager.AddCash(Player, 30)
				Model.Humanoid.Health = Model.Humanoid.MaxHealth
				return
			end

			Model.Down.Value = true
			Model.Humanoid.Health = Model.Humanoid.MaxHealth

			for i,v in pairs(Model:GetChildren()) do
				if v.Name == "OreColor" then
					v.Transparency = 1
				end
			end

			local amountGiven = math.random(1, 3)
			local rubyChance = math.random(1, 50)

			if rubyChance == 10 then
				Knight.DropResource(OreItemIds["Ruby"], 1, Model.Rock.CFrame)
			end

			local ItemId = OreItemIds[Model.Type.Value] or 14
			Knight.DropResource(ItemId, amountGiven, Player.Character.PrimaryPart.CFrame)-- Model.Rock.CFrame)

			task.spawn(function()
				task.wait(math.random(120,180))
				Model.Down.Value = false

				for i,v in pairs(Model:GetChildren()) do
					if v.Name == "OreColor" then
						v.Transparency = 0
					end
				end

				Model.Humanoid.Health = Model.Humanoid.MaxHealth
			end)
		end
	elseif Type == "Player" then
		Model.Character.Humanoid.Health -= Damage

		local creator = Instance.new("ObjectValue")
		creator.Name = "creator"
		creator.Parent = Model.Character.Humanoid
		creator.Value = Player

		game:GetService("Debris"):AddItem(creator, 2)
	end
end

function Knight.DropResource(ItemId, StackAmount, CFrameLocation, HookGiveFunction)
	if HookGiveFunction == nil then
		HookGiveFunction = false
	end

	Knight.Services.ItemsManager.DropItem(CFrameLocation, {
		ItemId = ItemId,
		Stack  = StackAmount,
		Serial = false,
	}, function(Player, InsertId, TradeId)
		if HookGiveFunction then HookGiveFunction(Player, InsertId, TradeId) end
		
	end)
end

_G.DropResource = Knight.DropResource
return Knight
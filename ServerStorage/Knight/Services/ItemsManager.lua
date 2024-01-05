-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		Databases = {},
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

-- Script
function Knight.Init()
	repeat
		task.wait(1)
	until Knight.Priority.Master ~= nil

	Knight.Cache.Databases = {
		ItemLogging = Knight.Priority.Master:GetDataStore("ItemLogging"),
	}
end


function Knight.GetDataFromItemId(ItemId)
	local f = nil

	for index, value in pairs(Knight.Database.Items.get()) do
		if value.ItemId == ItemId then
			f = value;
			break;
		end
	end

	return f
end

function Knight.GenerateNewSerial(DatastoreKey)
	local Serials = 0

	local s, data = pcall(function()
		return Knight.Priority.Master:GetDataStore("Master"):GetAsync(DatastoreKey)
	end)

	if data == nil or s == false then
		task.wait()
		Knight.Priority.Master:GetDataStore("Master"):SetAsync(DatastoreKey, 0)
		Serials = 0
	end

	if s and data ~= nil then
		Serials = tonumber(data)
	end

	local MySerial = 1
	MySerial += Serials

	task.wait()

	Knight.Priority.Master:GetDataStore("Master"):SetAsync(DatastoreKey, MySerial)

	return MySerial
end

function Knight.LogReference(player, from, itemid, refid, log, reason, iscreation)
	if iscreation then
		refid = Knight.GenerateNewSerial("trade_logs_serials")
		Knight.Priority.Master:GetDataStore("ItemLogging"):SetAsync(refid, {
			["info"] = {
				["created"] = os.time(),
				["logtype"] = log, -- Types: Trade, Drop
				["creation_reason"] = reason
			},
			["history"] = {
			}
		})

		task.wait()
	end

	task.wait()

	local s,data = pcall(function()
		return Knight.Priority.Master:GetDataStore("ItemLogging"):GetAsync(refid)
	end)

	task.wait()

	if data == nil then return false, warn("Unknown error occured creating " .. log .. " ref id & log.") end

	local log = {
		["date"] = os.time(),
		["from"] = type(from) == "table" and from.IsServer and "Server" or from.UserId,
		["isfromserver"] = type(from) == "table" and from.IsServer and true or false,
		["to"] = player.UserId,
		["reason"] = reason
	}

	table.insert(data.history, log)

	return refid, log
end

function Knight.HasItem(Player, ItemId, Serial, CheckBank)
	local Inventory = Knight.Services.InventoryManager.GetPlayerInventory(Player)
	local has, index, inventory_data, data = false, 0, {}, {}

	if Serial == nil then Serial = false end
	if CheckBank == nil then CheckBank = false end

	for key, value in pairs(Inventory) do
		local inventory_data = value[1]
		local item_data = value[2]

		if inventory_data.ItemId == ItemId then
			if not Serial then has = true break end
			if inventory_data.Serial == Serial then has, index, inventory_data, data = true, key, {inventory_data, item_data}, value break end
		end
	end

	if not has and CheckBank then
		for key, inventory_data in pairs(_G.PlayerData[Player.Name].Bank) do
			local item_data = Knight.GetDataFromItemId(inventory_data.ItemId)

			if inventory_data.ItemId == ItemId then
				if not Serial then has = true break end
				if inventory_data.Serial == Serial then has, index, data = true, key, {inventory_data, item_data} break end
			end
		end
	end

	return has, index, inventory_data, data
end

function Knight.DropOnDeath(Player, CFrameLocation)
	local Inventory = Knight.Services.InventoryManager.GetPlayerInventory(Player)
	local Removed_Item = false

	for key, value in pairs(Inventory) do
		local inventory_data = value[1]
		local item_data = value[2]

		if item_data.DropOnDeath ~= nil and item_data.DropOnDeath then
			if not Removed_Item then Removed_Item = true end
			Knight.DropItem(Player, inventory_data, false)
			--Knight.Services.ResourcesManager.DropResource(item_data.ItemId, inventory_data.Stack, CFrameLocation)
			Knight.RemoveItem(Player, inventory_data.ItemId, inventory_data.Serial, false)
		end
	end

	if Removed_Item then Knight.Services.InventoryManager.RefreshInventory(Player) end
end

function Knight.RemoveDropOnDeath(Player)
	local Inventory = Knight.Services.InventoryManager.GetPlayerInventory(Player)
	local Removed_Item = false

	for key, value in pairs(Inventory) do
		local inventory_data = value[1]
		local item_data = value[2]

		if inventory_data.DropOnDeath ~= nil and inventory_data.DropOnDeath then
			if not Removed_Item then Removed_Item = true end
			Knight.RemoveItem(Player, inventory_data.ItemId, inventory_data.Serial, false)
		end
	end

	if Removed_Item then Knight.Services.InventoryManager.RefreshInventory(Player) end
end

function Knight.RemoveIllegalItems(Player)
	local Inventory = Knight.Services.InventoryManager.GetPlayerInventory(Player)
	local Removed_Item = false

	for key, value in pairs(Inventory) do
		local inventory_data = value[1]
		local item_data = value[2]

		if inventory_data.IllegalItem ~= nil and inventory_data.IllegalItem then
			if not Removed_Item then Removed_Item = true end
			Knight.RemoveItem(Player, inventory_data.ItemId, inventory_data.Serial, false)
		end
	end

	if Removed_Item then Knight.Services.InventoryManager.RefreshInventory(Player) end
end

function Knight.RemoveJobItems(Player)
	local Inventory = Knight.Services.InventoryManager.GetPlayerInventory(Player)
	local Removed_Item = false

	for key, value in pairs(Inventory) do
		local inventory_data = value[1]
		local item_data = value[2]

		if inventory_data.JobItem ~= nil and inventory_data.JobItem then
			if not Removed_Item then Removed_Item = true end
			Knight.RemoveItem(Player, inventory_data.ItemId, inventory_data.Serial, false)
		end
	end

	if Removed_Item then Knight.Services.InventoryManager.RefreshInventory(Player) end
end

function Knight.RemoveItem(Player, ItemId, Serial, RefreshInventory, CustomLogReason, DoNotLog)
	if RefreshInventory == nil then RefreshInventory = true end
	if CustomLogReason == nil then CustomLogReason = "Server removed item." end
	if DoNotLog == nil then DoNotLog = false end

	--	print("Removing item " .. ItemId .. " for " .. CustomLogReason, debug.traceback())

	for key, value in pairs(_G.PlayerData[Player.Name].Backpack) do
		if value.ItemId == ItemId and value.Serial == Serial then
			local ItemData = Knight.Services.ItemsManager.GetDataFromItemId(value.ItemId)
			local TRID = false

			if not DoNotLog then 
				TRID = Knight.LogReference(Player, {IsServer = true, UserId = 1}, ItemId, value.TradeReferenceId, "Trade", CustomLogReason, false)
			end

			local s,e = pcall(function()
				if _G.ServerCache[Player.UserId .. "_equipped_item"] ~= nil then
					if _G.ServerCache[Player.UserId .. "_equipped_item"].AnimationTracks ~= nil then
						for _, animation in pairs(_G.ServerCache[Player.UserId .. "_equipped_item"].AnimationTracks) do
							animation:Stop()
						end
					end
				end

				if _G.ServerCache[Player.Name .. "_equipped"] ~= nil then
					if _G.ServerCache[Player.Name .. "_equipped"][ItemData.ItemId .. "_" .. value.Serial] ~= nil then
						local cache = _G.ServerCache[Player.Name .. "_equipped"][ItemData.ItemId .. "_" .. value.Serial];
						Knight.Services.ToolsManager.KillListen(Player)
						Player.Character.Humanoid:UnequipTools()

						if cache.RobloxTool ~= nil and cache.RobloxTool then
							cache.RobloxTool:Destroy()
						end

						_G.ServerCache[Player.Name .. "_equipped"][ItemData.ItemId .. "_" .. value.Serial] = nil;
						cache = nil;
					end
				end
			end)

			if not s then warn(e) end

			_G.PlayerData[Player.Name].Backpack[key] = nil;

			if RefreshInventory then
				Knight.Services.InventoryManager.RefreshInventory(Player)
			end

			break;
		end
	end
end

function _G.GiveItem(Player, ItemId, Amount)
	if Amount == nil then Amount = 1 end
	local s,i = Knight.GiveItem(Player, ItemId, true, false, true)
	if Amount == 1 then return s, i end
	_G.PlayerData[Player.Name].Backpack[i].Stack = Amount
	_G.RefreshInventory(Player)
	return s,i
end

function _G.RefreshInventory(Player)
	return Knight.Services.InventoryManager.RefreshInventory(Player)
end

function Knight.RenderItemPreview(ItemId)
	local ItemData = Knight.Services.ItemsManager.GetDataFromItemId(ItemId)
	
	if not ItemData then
		return Instance.new("Part")
	end
	
	local Model;
	
	if ItemData.Type == "StackResource" then
		-- For ores, trees, etc.
		if Knight.Shared.Roblox.ReplicatedStorage.Assets.Ores:FindFirstChild(ItemData.Name) then
			Model = Knight.Shared.Roblox.ReplicatedStorage.Assets.Ores:FindFirstChild(ItemData.Name)
		else
			Model = Knight.Shared.Roblox.ReplicatedStorage.Assets.Items:FindFirstChild(ItemData.Name)
		end
	elseif ItemData.Type == "Pelt" then
		-- Bear, gator, etc pelts.
		Model = Knight.Shared.Roblox.ReplicatedStorage.Assets.Pelts:FindFirstChild(ItemData.Name)
	else
		-- Drop the model. (for weapons, tools, tnt, etc)
		Model = Knight.Shared.Roblox.ReplicatedStorage.Assets.Items:FindFirstChild(ItemData.Name)
	end

	local requires_humanoid = false
	local Clothing = nil

	if ItemData.Type == "Hat" or ItemData.Type == "Mask" or ItemData.Type == "Glasses" then
		Model = Knight.Shared.Roblox.ReplicatedStorage.Assets.Cosmetics:FindFirstChild(ItemData.Name)
	end

	if ItemData.Type == "Shirt" then 
		Model = Knight.Shared.Roblox.ReplicatedStorage.Assets.Body
		Model.Clothing.ShirtTemplate = "http://www.roblox.com/asset/?id=" .. ItemData.AssetTexture
		Clothing = Model.Clothing:Clone()
		requires_humanoid = true
	elseif ItemData.Type == "Pants" then 
		Model = Knight.Shared.Roblox.ReplicatedStorage.Assets.Legs
		Model.Clothing.PantsTemplate = "http://www.roblox.com/asset/?id=" .. ItemData.AssetTexture
		Clothing = Model.Clothing:Clone()
		requires_humanoid = true
	end

	if not Model then 
		Model = Instance.new("Model")
		Instance.new("Part").Parent = Model
	end

	Model = Knight.Shared.Services.Module3D:GetModelFromInstance(Model)

	task.wait()

	for i,v in pairs(Model:GetDescendants()) do
		if v:IsA("WeldConstraint") or v:IsA("Weld") then
			if v.Name ~= "DROP_WELD" then
				v:Destroy()
			end
		end

		if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("Part") or v:IsA("UnionOperation") then
			if v ~= Model.PrimaryPart then
				local weld = Instance.new("WeldConstraint")
				weld.Part1 = v
				weld.Part0 = Model.PrimaryPart
				weld.Name = "DROP_WELD"
				weld.Parent = v
			end

			v.CanCollide = true
			v.Anchored = false
		end
	end

	Model.Name = "DroppedItem"

	if requires_humanoid then
		script["Body Colors"]:Clone().Parent = Model
		script.Humanoid:Clone().Parent = Model

		if Clothing then Clothing.Parent = Model end
	end
	
	return Model
end

function Knight.DropItem(Originator, OriginatorItemData, HookGiveFunction)
	if typeof(Originator) == "Player" and _G.PlayerData[Originator.Name] == nil then
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Originator, "Notify", "ERROR_NO_PLAYER_DATA_FOUND", Color3.fromRGB(255, 53, 53))
		return false
	end

	if typeof(Originator) == "CFrame" then
		Originator = {
			Name = "Server",
			Character = {
				UpperTorso = {
					CFrame = Originator
				}
			}
		}
	end

	if Originator.Name ~= "Server" then
		if OriginatorItemData.JobItem then
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Originator, "Notify", "ERROR_JOB_ITEM_BLACKLISTED", Color3.fromRGB(255, 53, 53))
			return false
		end

		if OriginatorItemData.HotbarPosition > 0 then
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Originator, "Notify", "ERROR_IN_HOTBAR", Color3.fromRGB(255, 53, 53))
			return false
		end

		if OriginatorItemData.IsBackpack ~= nil then
			if OriginatorItemData.AlreadyUsed then
				Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Originator, "Notify", "ERROR_BAG_EQUIPPED", Color3.fromRGB(255, 53, 53))
				return false
			end
		end
	end

	local ItemData = Knight.Services.ItemsManager.GetDataFromItemId(OriginatorItemData.ItemId)
	local ProximityPrompt = Knight.Shared.Roblox.ServerStorage.ProximityPrompt:Clone()
	local Configuration = require(ProximityPrompt:WaitForChild("Configuration"))

	if HookGiveFunction == nil then
		HookGiveFunction = false
	end

	local Stack = OriginatorItemData.Stack or 1
	local DisplaySerial = OriginatorItemData.Serial and " #" ..OriginatorItemData.Serial or ""

	Configuration.set({
		["Action"] = "Pickup",
		["Title"] = ItemData.Name .. DisplaySerial,
		["SubTitle"] = "x" .. tostring(Stack),
		["Bottom"] = "Dropped by " .. Originator.Name,
		["Color"] = Color3.fromRGB(148, 33, 147)
	})

	local Model = Knight.RenderItemPreview(OriginatorItemData.ItemId)
	Model.Parent = workspace
	Model:PivotTo(Originator.Character.UpperTorso.CFrame)

	if Originator.Name ~= "Server" then
		Knight.Services.CharacterManager.ReloadPlayerCosmetics(Originator)
	end

	ProximityPrompt.RequiresLineOfSight = false
	ProximityPrompt.Parent = Model.PrimaryPart;
	ProximityPrompt.Triggered:Connect(function(Player)
		if Player.Character and Player.Character:FindFirstChild("Humanoid") then
			if Player.Character:FindFirstChild("Humanoid").Health <= 0 then
				return false -- Dead, cannot grab own loot.
			end
		else
			return false -- No humaniod, cannot pass sanity check.
		end
		
		ProximityPrompt.Enabled = false
		Model.Parent =  Knight.Shared.Roblox.ServerStorage
		
		local Animation = script.PickupAnimation:Clone()

		--	_G.tweenModel(Model, Player.Character.HumanoidRootPart.CFrame, TweenInfo.new(1.2))

		local Track = Player.Character.Humanoid:LoadAnimation(Animation)
		Track:Play()

		Track.Stopped:Wait()
		Animation:Destroy()

		if _G.PlayerData[Player.Name] == nil then
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "ERROR_NO_PLAYER_DATA_FOUND", Color3.fromRGB(255, 53, 53))
			ProximityPrompt.Enabled = true
			Model.Parent = workspace
			return false
		end

		if ItemData.Illegal ~= nil and ItemData.Illegal then
			if _G.TeamsDamageLogic[Player.Team].Civil and not _G.PlayerData[Player.Name].Hostile then
				local Amount = ItemData.Sell
				if Amount == nil or Amount <= 0 then Amount = 100 end

				Knight.Services.CharacterManager.AddCash(Player, Amount * 0.30)
				return Model:Destroy()
			end

			Knight.Services.LawManager.AddBounty(Player, 5)
		end

		if #_G.PlayerData[Player.Name].Backpack >= _G.PlayerData[Player.Name].MaxInventory then
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "ERROR_INVENTORY_FULL", Color3.fromRGB(255, 53, 53))
			ProximityPrompt.Enabled = true
			Model.Parent = workspace
			return false
		end

		local Inventory = Knight.Services.InventoryManager.GetPlayerInventory(Player)
		local GaveItem = false
        
		ProximityPrompt.Enabled = false
		Model:Destroy()

		local TradeReferenceId = 1;
		local success, InsertIndex = false, 1;

		if OriginatorItemData.Serial then
			TradeReferenceId = Knight.LogReference(Player, Originator, OriginatorItemData.ItemId, OriginatorItemData.TradeReferenceId, "Trade", "Item was dropped and picked up.", true)
			success, InsertIndex = true, #_G.PlayerData[Player.Name].Backpack+1;
			_G.PlayerData[Player.Name].Backpack[InsertIndex] = {
				OrginatedFrom = OriginatorItemData.OrginatedFrom, -- creator
				LastOwner = Originator.UserId, -- last person to own
				Dropped = true, -- was it dropped
				Traded = false, -- was it traded
				LastUpdate = os.time(), -- date of item metadata changed
				TradeReferenceId = TradeReferenceId, -- trade reference for more in depth details on how they got the item
				ItemId = OriginatorItemData.ItemId, -- item id
				ItemInHotbar = false, -- is it equiped in hotbar
				JobItem = false,
				HotbarPosition = 0, -- hotbar slot
				Stack = Stack, -- stack count
				Serial = OriginatorItemData.Serial -- serial
			};
		else
			success, InsertIndex = Knight.GiveItem(Player, OriginatorItemData.ItemId, true, false, false, "Item drop by server", false)

			if success then
				TradeReferenceId = _G.PlayerData[Player.Name].Backpack[InsertIndex].TradeReferenceId
				_G.PlayerData[Player.Name].Backpack[InsertIndex].Stack = Stack
			end
		end

		Knight.Services.InventoryManager.RefreshInventory(Player)

		if HookGiveFunction then
			HookGiveFunction(Player, InsertIndex, TradeReferenceId)
		end
	end)

	return true
end

function _G.RemoveFromStack(Player, ItemId, StackAmount, Serial)
	return Knight.RemoveFromStack(Player, ItemId, StackAmount, Serial)
end

function Knight.RemoveFromStack(Player, ItemId, StackAmount, Serial)
	if Serial == nil then Serial = false end
	if _G.PlayerData[Player.Name] == nil then
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "ERROR_NO_PLAYER_DATA_FOUND", Color3.fromRGB(255, 53, 53))
		return false
	end

	--local Inventory = Knight.Services.InventoryManager.GetPlayerInventory(Player)

	for key, value in pairs(_G.PlayerData[Player.Name].Backpack) do
		local inventory_data = value
		local item_data = Knight.GetDataFromItemId(value.ItemId) --value[2]

		if item_data.ItemId == ItemId and not Serial or Serial and item_data.Serial == Serial and item_data.ItemId == ItemId then
			local max_stack = (item_data.MaxStack ~= nil and item_data.MaxStack) or 1;
			local add_amount = math.min((inventory_data.Stack - StackAmount), max_stack)

			if _G.PlayerData[Player.Name].Backpack[key] ~= nil then
				_G.PlayerData[Player.Name].Backpack[key].Stack = add_amount

				if _G.PlayerData[Player.Name].Backpack[key].Stack < 1 then
					_G.PlayerData[Player.Name].Backpack[key] = nil;
				end

				if _G.ServerCache[Player.Name .. "_equipped"] ~= nil then
					if _G.ServerCache[Player.Name .. "_equipped"][item_data.ItemId .. "_" .. inventory_data.Serial] ~= nil then
						local cache = _G.ServerCache[Player.Name .. "_equipped"][item_data.ItemId .. "_" .. inventory_data.Serial];

						Knight.Services.ToolsManager.KillListen(Player)
						Player.Character.Humanoid:UnequipTools()

						if cache.RobloxTool ~= nil and cache.RobloxTool then
							cache.RobloxTool:Destroy()
						end

						_G.ServerCache[Player.Name .. "_equipped"][item_data.ItemId .. "_" .. inventory_data.Serial] = nil;
					end
				end

				StackAmount -= add_amount
			end

			if StackAmount < 1 then break end
		end
	end

	Knight.Services.InventoryManager.RefreshInventory(Player)

	return true
end

function Knight.AddToStackOrCreate(Player, ItemId, StackAmount, Serial)
	if Serial == nil then Serial = false end
	if _G.PlayerData[Player.Name] == nil then
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "ERROR_NO_PLAYER_DATA_FOUND", Color3.fromRGB(255, 53, 53))
		return false
	end

	--local Inventory = Knight.Services.InventoryManager.GetPlayerInventory(Player)

	for key, value in pairs(_G.PlayerData[Player.Name].Backpack) do
		local inventory_data = value
		local item_data = Knight.GetDataFromItemId(value.ItemId) --value[2]

		if item_data.ItemId == ItemId and not Serial or Serial and item_data.Serial == Serial and item_data.ItemId == ItemId then
			local max_stack = (item_data.MaxStack ~= nil and item_data.MaxStack) or 1;
			local add_amount = math.min(inventory_data.Stack + StackAmount, max_stack)

			if _G.PlayerData[Player.Name].Backpack[key] ~= nil then
				_G.PlayerData[Player.Name].Backpack[key].Stack = add_amount

				StackAmount -= add_amount
			end

			if StackAmount < 1 then break end
		end
	end

	Knight.Services.InventoryManager.RefreshInventory(Player)

	if StackAmount > 0 then
		-- give item as all stacks are filled.

		if #_G.PlayerData[Player.Name].Backpack < _G.PlayerData[Player.Name].MaxInventory then
			local success, insert_id = Knight.GiveItem(Player, ItemId, true, false, false, "Item stacking by server.")

			task.wait()

			if not success then
				warn("Failed to issue item. Unknown error occured.")
				return false
			end

			if math.floor(StackAmount - 1) > 0 then
				return Knight.AddToStackOrCreate(Player, ItemId, StackAmount)
			else
				return true
			end
		else
			return false
		end
	else 
		-- done
		return true
	end
end

function Knight.CreateItem(Player, ItemId, IsJobItem, CustomLogReason, IsTrade, TradeData)
	if IsTrade ~= nil and typeof(IsTrade) == "boolean" and not IsTrade or IsTrade == nil then 
		local TRID = IsJobItem and 1 or Knight.LogReference(Player, {IsServer = true, UserId = 1}, ItemId, 1, "Trade", CustomLogReason, true)
		IsTrade = false
		TradeData = {
			OrginatedFrom = Player.UserId,
			LastOwner = Player.UserId,
			TradeReferenceId = TRID
		}
	end

	local ItemData = Knight.GetDataFromItemId(ItemId)
	local Serial = IsJobItem and Player.UserId or Knight.GenerateNewSerial(ItemId)

	if ItemData == nil then 
		warn("Item data does not exist for item id " .. ItemId)
		return false, {}, {} 
	end

	return true, {
		OrginatedFrom = TradeData.OrginatedFrom, -- creator
		LastOwner = TradeData.LastOwner, -- last person to own
		Dropped = false, -- was it dropped
		Traded = false, -- was it traded
		LastUpdate = os.time(), -- date of item metadata changed
		TradeReferenceId = TradeData.TradeReferenceId, -- trade reference for more in depth details on how they got the item
		ItemId = ItemId, -- item id
		ItemInHotbar = false, -- is it equiped in hotbar
		JobItem = IsJobItem,
		HotbarPosition = 0, -- hotbar slot
		Stack = 1, -- stack count
		Serial = Serial -- serial
	}, ItemData;
end

function Knight.GiveItem(Player, ItemId, RefreshInventory, IsJobItem, AdminIssued, CustomLogReason, IsTrade, TradeData)
	if _G.PlayerData[Player.Name] == nil then
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "ERROR_NO_PLAYER_DATA_FOUND", Color3.fromRGB(255, 53, 53))
		return false, 1
	end

	if #_G.PlayerData[Player.Name].Backpack >= _G.PlayerData[Player.Name].MaxInventory then
		Knight.Services.ResourcesManager.DropResource(ItemId, 1, Player.Character.HumanoidRootPart.CFrame)
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "ERROR_INVENTORY_FULL", Color3.fromRGB(255, 53, 53))
		return false, 1
	end

	if RefreshInventory == nil then RefreshInventory = true end
	if IsJobItem == nil then IsJobItem = false end
	if AdminIssued == nil then AdminIssued = false end
	if CustomLogReason == nil then CustomLogReason = "Server added item." end

	local Success, GeneratedItemData, ItemData = Knight.CreateItem(Player, ItemId, IsJobItem, CustomLogReason, IsTrade, TradeData)
	if not Success then return false, 1 end

	local InsertIndex = #_G.PlayerData[Player.Name].Backpack+1;
	_G.PlayerData[Player.Name].Backpack[InsertIndex] = GeneratedItemData

	if RefreshInventory then Knight.Services.InventoryManager.RefreshInventory(Player) end

	if not AdminIssued then return true, InsertIndex end

	local Log = ("Item ``"..ItemData.Name.."`` (Serial: ``".. GeneratedItemData.Serial .. "`` ItemID: ``".. ItemId .. "``) was **granted** to ``".. Player.Name.."`` (``".. Player.UserId .. "``)")

	Knight.Discord.InitWebhook.hook("Mod_Log").send(
	Knight.Discord.Embed()
	.setColor("#fffafa")

	.setAuthor('The Western Frontier', 'https://cdn.discordapp.com/attachments/912829124479946802/1069929026543685633/Png.png')
	.setTitle("General Logs")
	.setDescription(Log)

	.setThumbnail('https://cdn.discordapp.com/attachments/912829124479946802/1069929026543685633/Png.png')
	.setTimestamp(os.date("!*t"), true)
	.setFooter("The Western Frontier Administration")
	)

	return true, InsertIndex
end

return Knight
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

local CollectionService = game:GetService("CollectionService")

-- Script
function Knight.RefreshHolsters(Player)
	local R = Player.Character:FindFirstChild("RightHolster")
	local L = Player.Character:FindFirstChild("LeftHolster")
	local CHEST = Player.Character:FindFirstChild("RifleHolster")
	local ItemWelds = Player.Character:FindFirstChild("ItemWelds")

	--for i,v in pairs(Player.Character.UpperTorso:GetChildren()) do
	--	if v.Name == "Gun" then v:Destroy() end
	--end

	if R then R:Destroy() end
	if L then L:Destroy() end
	if CHEST then CHEST:Destroy() end
	if ItemWelds == nil then
		ItemWelds = Instance.new("Folder", Player.Character)
		ItemWelds.Name = "ItemWelds"
	end
	
	ItemWelds:ClearAllChildren()

    -- ik this is trash, cframes / attachments should of been used.
	R = Knight.Services.CharacterManager.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Morphs.RightHolster, "RightHolster")
	L = Knight.Services.CharacterManager.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Morphs.LeftHolster, "LeftHolster")
	CHEST = Knight.Services.CharacterManager.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Morphs.RifleHolster, "RifleHolster")

	local Points = {
		[1] = {
			PointModel = R,
			Taken = 0,
			Points = {"WeldHandle"},
			AllowedWeaponTypes = {"Pistol"},
			AllowedItemTypes = {"Firearm"}
		},
		[2] = {
			PointModel = L,
			Taken = 0,
			Points = {"WeldHandle"},
			AllowedWeaponTypes = {"Pistol"},
			AllowedItemTypes = {"Firearm"}
		},
		[3] = {
			PointModel = CHEST,
			Taken = 0,
			Points = {"Point1", "Point2", "Point3"},
			AllowedWeaponTypes = {"Rifle"},
			AllowedItemTypes = {"Firearm"}
		},
		[4] = {
			PointModel = CHEST,
			Taken = 0,
			Points = {"Point4", "Point5"},
			AllowedWeaponTypes = {},
			AllowedItemTypes = {"Tool"}
		},
		[6] = {
			PointModel = CHEST,
			Taken = 0,
			Points = {"Point6", "Point7", "Point8"},
			AllowedWeaponTypes = {},
			AllowedItemTypes = {"MiscTool"}
		},
	}

	local WM = Knight.Shared.Roblox.ReplicatedStorage.Assets.WeaponModules
	local M3D = Knight.Shared.Services.Module3D
	local ItemsModels = Knight.Shared.Roblox.ReplicatedStorage.Assets.Items

	local function FindPointItemCanAccess(ItemData)
		local s,d = false, {}

		local firearm_module = WM:FindFirstChild(ItemData.Name)

		if firearm_module then
			firearm_module = require(firearm_module)
		end

		for index, data in pairs(Points) do
			if s then break end
			
			-- Item validation permissions to weld to point.
			local can = true

			if not table.find(data.AllowedItemTypes, ItemData.Type) and #data.AllowedItemTypes > 0 then
				can = false
			end

			if #data.AllowedWeaponTypes > 0 then
				if not firearm_module then can = false end

				if can then
					local has = true

					for _, Type in pairs(data.AllowedWeaponTypes) do
						if firearm_module[Type] == nil then
							has = false
						end
					end

					if not has then can = false end
				end
			end

			-- Check if slots open
			if Points[index].Taken >= table.getn(data.Points) then
				can = false
			end
			
			local taken_id = Points[index].Taken + 1
			
			if data.Points[taken_id] == nil then
				can = false
			end

			if can == true then
				-- Set return data and my point
				s, d = true, {
					ItemName = ItemData.Name,
					MyPoint = data.Points[taken_id],
					--	firearm_module = firearm_module ~= nil and firearm_module or false,
					PointModel = data.PointModel
				}

				-- Update points to know I taken a spot
				Points[index].Taken = taken_id
			end
		end

		return s, d
	end
	
	for key, value in pairs(_G.PlayerData[Player.Name].Backpack) do
		if value.HotbarPosition > 0 then
			local Data = Knight.Services.ItemsManager.GetDataFromItemId(value.ItemId)
			local Success, Point = FindPointItemCanAccess(Data)

			if Success and Point ~= {} then
				local temp = nil
				
				if Data.OverrideToolModelWithModel ~= nil and Data.OverrideToolModelWithModel then
					temp = Knight.Shared.Roblox.ReplicatedStorage.Assets.Items:FindFirstChild(Data.OverrideToolModelWithModel):Clone()
				else
					temp = Knight.Shared.Roblox.ReplicatedStorage.Assets.Items:FindFirstChild(Data.Name):Clone()
				end
				
				if temp == nil then
					temp = Instance.new("Part")
				end
				
				temp.Parent = game.ServerStorage
				
				local model = Instance.new("Model", game.ServerStorage)
				
				if temp:IsA("BasePart") then
					local clone = temp:Clone()
					clone.Parent = model
					clone.Anchored = true
					model.PrimaryPart = clone
				else
					local primary
					if temp:IsA("Model") then
						primary = model.PrimaryPart
					elseif temp:IsA("Tool") then
						primary = temp:FindFirstChild("Handle")
					end

					for i, part in pairs(temp:GetDescendants()) do
						if part:IsA("BasePart") then
							if not primary then
								primary = part
							end

							local clone = part:Clone()
							clone.Parent = model
							clone.Anchored = true

							if part == primary then
								model.PrimaryPart = clone
							end
						end
					end
				end
				
				for _, part in pairs(model:GetDescendants()) do
					if part:IsA("Weld") or part:IsA("WeldConstraint") then
						part:Destroy()
					end
				end
				
				local Weld = Knight.Services.CharacterManager.Weld("Handle", Point.MyPoint, model, Point.PointModel)
				Weld.Parent = ItemWelds
				Weld.Name = value.ItemId

				for _, part in pairs(Weld:GetDescendants()) do
					if part:IsA("BasePart") then
						if part.Transparency == 1 then
							CollectionService:AddTag(part, "KeepInvisible")
						end
					end
				end
				
				temp:Destroy()
			end
		end
	end
end

function Knight.EquipBackpack(Player, ItemData, InventoryData, InventoryKey)
	_G.PlayerData[Player.Name].MaxInventory += ItemData.BackpackSlots
	Knight.RefreshInventory(Player)
end

function Knight.UnequipBackpack(Player, ItemData, InventoryData, InventoryKey)
	_G.PlayerData[Player.Name].MaxInventory -= ItemData.BackpackSlots

	if #_G.PlayerData[Player.Name].Backpack > _G.PlayerData[Player.Name].MaxInventory then
		for index, item in pairs(_G.PlayerData[Player.Name].Backpack) do
			Knight.Services.ItemsManager.DropItem(Player, item, false)

			if #_G.PlayerData[Player.Name].Backpack -1 <= _G.PlayerData[Player.Name].MaxInventory then
				break;
			end
		end
	end

	Knight.RefreshInventory(Player)
end

function Knight.Init()
	_G.RefreshHolsters = Knight.RefreshHolsters
	Knight.Shared.Services.Remotes:Register("InventorySocket", "RemoteFunction", function(Player, ...)
		local args = {...};
		Knight.RefreshHolsters(Player)

		if args[1] == "SendInventory" then
			Knight.RefreshInventory(Player)

			return;
		elseif args[1] == "UseItem" then
			local Inventory = _G.PlayerData[Player.Name].Backpack;
			local Found, Data = false, {}
			local ItemIndex = 1;
			local HoverItem = args[2];

			if HoverItem == nil then return print("No item found to use.") end

			for key, value in pairs(Inventory) do
				if value.ItemId == HoverItem.ItemId and value.Serial == HoverItem.Serial then
					ItemIndex = key;
					Found, Data = true, value;
					break
				end
			end

			if not Found then return end

			if Data.HotbarPosition > 0 then
				Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "Must remove this from hotbar.", Color3.fromRGB(255, 53, 53))
				return 
			end

			local ItemData = Knight.Services.ItemsManager.GetDataFromItemId(Data.ItemId)

			if not ItemData then
				return
			end

			if ItemData.UseFunction == nil then
				return
			end

			ItemData.UseFunction(Player, ItemData, Data, ItemIndex)

			if ItemData.DeleteOnUse then
				Knight.SaveToInventoryByIndex(Player, nil, ItemIndex)
				Knight.RefreshInventory(Player)
			end
		elseif args[1] == "RefreshHolsters" then
			Knight.RefreshHolsters(Player)
		elseif args[1] == "Drop" then
			local Inventory = _G.PlayerData[Player.Name].Backpack;
			local Found, Data = false, {}
			local ItemIndex = 1;
			local HoverItem = args[2];

			if HoverItem == nil then return print("No item found to move to hotbar.") end

			for key, value in pairs(Inventory) do
				if value.ItemId == HoverItem.ItemId and value.Serial == HoverItem.Serial then
					ItemIndex = key;
					Found, Data = true, value;
					break
				end
			end

			if not Found then return end

			if Data.HotbarPosition > 0 then
				Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "Must remove this from hotbar.", Color3.fromRGB(255, 53, 53))
				return 
			end

			local ItemData = Knight.Services.ItemsManager.GetDataFromItemId(Data.ItemId)

			if not ItemData then
				return
			end

			if not ItemData.CanDrop then return end

			local success = Knight.Services.ItemsManager.DropItem(Player, Data, function(Picker, InventoryIndex, TradeReferenceId)
				Knight.Shared.Services.SoundService:PlaySound(Picker.PlayerGui:WaitForChild("Sounds").Grab, Picker.PlayerGui.Core.TempSound)
				Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "Dropped item was picked up, Moderation REFID #" .. TradeReferenceId ..".", Color3.fromRGB(255, 53, 53))
				Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Picker, "Notify", "You picked up a item from ".. Player.Name ..", Moderation REFID #" .. TradeReferenceId ..".", Color3.fromRGB(85, 170, 127))
			end)

			Knight.Shared.Services.SoundService:PlaySound(Player.PlayerGui:WaitForChild("Sounds").Drop, Player.PlayerGui.Core.TempSound)

			--if success then
				Knight.SaveToInventoryByIndex(Player, nil, ItemIndex)
				task.wait()
				Knight.RefreshInventory(Player)
				Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "Item dropped!", Color3.fromRGB(85, 170, 127))
			--else
			--	Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "Failed to drop item.", Color3.fromRGB(255, 38, 0))
			--end
		elseif args[1] == "Discard" then
		elseif args[1] == "MoveToHotbar" or args[1] == "MoveToInventory" then
			local Inventory = _G.PlayerData[Player.Name].Backpack;
			local Found, Data = false, {}
			local ItemIndex = 1;
			local HoverItem = args[2];

			if HoverItem == nil then 
				return Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "ERROR_INVALID_SOCKET_ARGS", Color3.fromRGB(255, 53, 53)) 
			end

			for key, value in pairs(Inventory) do
				if value.ItemId == HoverItem.ItemId and value.Serial == HoverItem.Serial then
					ItemIndex = key;
					Found, Data = true, value;
					break
				end
			end

			if not Found then return end
			if args[1] == "MoveToHotbar" and Data.HotbarPosition > 0 then return end
			if args[1] == "MoveToInventory" and Data.HotbarPosition == 0 then return end

			if args[1] == "MoveToHotbar" then
				local HighHotbarInventoryKey, HighestHotbarPosition = 0, 0;
				local MovePreviousToZero = false

				local OpenSlots = {
					true, true, true, true, true, true
				}

				-- pull all inventory items, and count the highest slot equipped
				for i,v in pairs(Inventory) do
					if v.HotbarPosition > 0 then
						OpenSlots[v.HotbarPosition] = false
					end

					if v.HotbarPosition > HighestHotbarPosition then
						HighHotbarInventoryKey, HighestHotbarPosition = i, v.HotbarPosition;
					end
				end

				local function all_slots_taken()
					local count = 0

					for _, bool in pairs(OpenSlots) do
						if bool == false then 
							count += 1
						end
					end

					return count == 6 and true or false
				end

				local function get_slot_open()
					local slot = 1

					for slot_id, bool in pairs(OpenSlots) do
						if bool == true then 
							slot = slot_id 
							break 
						end
					end

					return slot
				end

				-- if highest is 6 then, move 6 out of hotbar and give 6 to new equipped item.
				local Positon = get_slot_open();
				local slots_taken = all_slots_taken()

				if slots_taken == true then --if HighestHotbarPosition >= 6 then
					Positon = 6;

					HighestHotbarPosition = 6
					MovePreviousToZero = true

					local RestLastIndex = Inventory[HighHotbarInventoryKey]
					RestLastIndex.HotbarPosition = 0
					RestLastIndex.ItemInHotbar = false

					Knight.SaveToInventoryByIndex(Player, RestLastIndex, HighHotbarInventoryKey)
				end

				-- If previous item hotbar id was 6, then move new item to it.
				-- If not, give next position below 6, if its above or is 6 then results in 6.
				--Data.HotbarPosition = HighestHotbarPosition >= 6 and 6 or (HighestHotbarPosition + 1) > 6 and 6 or HighestHotbarPosition + 1
				Data.HotbarPosition = Positon
				Data.ItemInHotbar = true
			end

			if args[1] == "MoveToInventory" then
				-- Move previous items forward.
				--[[
				--TODO: FIX, CRASHES INVENTORY DATA.
				for i,v in pairs(Inventory) do
					if v.HotbarPosition > Data.HotbarPosition then
						
						local RestLastIndex = Inventory[i]
						RestLastIndex.HotbarPosition = (RestLastIndex.HotbarPosition - 1) > 0 and  (RestLastIndex.HotbarPosition - 1) or 1
						RestLastIndex.ItemInHotbar = false

						Knight.SaveToInventoryByIndex(Player, RestLastIndex, i)
					end
				end]]

				Data.HotbarPosition = 0
				Data.ItemInHotbar = false
			end

			Knight.SaveToInventoryByIndex(Player, Data, ItemIndex)
			Knight.RefreshInventory(Player)
			Knight.RefreshHolsters(Player)

			return;
		elseif args[1] == "Key" then
			local KeyId = args[2];

			local InventoryData, ItemData, InventoryIndex = Knight.GetItemInHotbarPosition(Player, KeyId)

			if not InventoryData then return  Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "ERROR_INVALID_SOCKET_ARGS", Color3.fromRGB(255, 53, 53))  end

			if _G.ServerCache[Player.Name .. "_equipped"] == nil then
				_G.ServerCache[Player.Name .. "_equipped"] = {}
			end

			if _G.PlayerData[Player.Name].JailTime > 0 and InventoryData.ItemId ~= 31 then
				return
			end

			if _G.ServerCache[Player.Name .. "_equipped"][InventoryData.ItemId .. "_" .. InventoryData.Serial] == nil then
				-- Equip it
				local equip_data = {
					ItemId = InventoryData.ItemId,
					Serial = InventoryData.Serial,
					RobloxTool = false,
				}

				if ItemData.RobloxTool ~= nil and ItemData.RobloxTool and ItemData.Type ~= "AMS" then
					local Tool = false

					if ItemData.OverrideToolModelWithModel ~= nil and ItemData.OverrideToolModelWithModel then
						Tool = Knight.Shared.Roblox.ReplicatedStorage.Assets.Items:FindFirstChild(ItemData.OverrideToolModelWithModel):Clone()
					else
						Tool = Knight.Shared.Roblox.ReplicatedStorage.Assets.Items:FindFirstChild(ItemData.Name):Clone()
					end

					Tool.Parent = Player.Backpack
					equip_data.RobloxTool = Tool
					task.wait()
					Player.Character.Humanoid:EquipTool(Tool)

					for _, part in pairs(Tool:GetChildren()) do
						if part:IsA("Part") or part:IsA("BasePart") or part:IsA("MeshPart") then
							part.CanCollide = false
							part.Massless = true
						end
					end
				end

				if ItemData.EquipFunction ~= nil and ItemData.EquipFunction then
					ItemData.EquipFunction(Player, InventoryData, ItemData, InventoryIndex)
				end

				Knight.Services.ToolsManager.Listen(Player, equip_data, ItemData, InventoryData)

				_G.ServerCache[Player.Name .. "_equipped"][InventoryData.ItemId .. "_" .. InventoryData.Serial] = equip_data

				if Player.Character:FindFirstChild("ItemWelds") then
					for _, model in pairs(Player.Character:FindFirstChild("ItemWelds"):GetChildren()) do
						if tonumber(model.Name) == tonumber(ItemData.ItemId) then
							for _, part in pairs(model:GetDescendants()) do
								if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
									if part.Transparency == 1 then
										CollectionService:AddTag(part, "KeepInvisible")
									else
										part.Transparency = 1
									end
								end
							end
						end
					end
				end
			else
				-- Unequip it
				local equip_data = _G.ServerCache[Player.Name .. "_equipped"][InventoryData.ItemId .. "_" .. InventoryData.Serial];

				Player.Character.Humanoid:UnequipTools()

				if equip_data.RobloxTool ~= nil and equip_data.RobloxTool and ItemData.Type ~= "AMS" then
					equip_data.RobloxTool:Destroy()
				end

				equip_data = nil;
				Knight.Services.ToolsManager.KillListen(Player)
				_G.ServerCache[Player.Name .. "_equipped"][InventoryData.ItemId .. "_" .. InventoryData.Serial] = nil;

				if Player.Character:FindFirstChild("ItemWelds") then
					for _, model in pairs(Player.Character:FindFirstChild("ItemWelds"):GetChildren()) do
						if tonumber(model.Name) == tonumber(ItemData.ItemId) then
							for _, part in pairs(model:GetDescendants()) do
								if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
									if not CollectionService:HasTag(part, "KeepInvisible") then
										part.Transparency = 0
									end
								end
							end
						end
					end
				end
			end

			debug.traceback()

			return true
		end
	end)
end

function Knight.SaveToInventoryByIndex(Player, Data, Index)
	_G.PlayerData[Player.Name].Backpack[Index] = Data;
end

function Knight.GetPlayerInventory(player)
	local Return = {}
	
	if _G.PlayerData[player.Name] == nil then
		return {}
	end

	if _G.PlayerData[player.Name].Backpack == nil then
		return {}
	end
	
	for key, value in pairs(_G.PlayerData[player.Name].Backpack) do
		local Data = Knight.Services.ItemsManager.GetDataFromItemId(value.ItemId)

		table.insert(Return, {
			value, 
			Data,
		})
	end

	return Return
end

function Knight.GetItemInHotbarPosition(player, slot)
	local inventory = Knight.GetPlayerInventory(player)
	local d1, d2, d3 = false, false, 1

	for index, item in pairs(inventory) do
		if item[1].HotbarPosition == slot and item[1].ItemInHotbar then
			d1, d2, d3  = item[1], item[2], index;
			break
		end
	end

	return d1, d2, d3;
end

function Knight.RefreshInventory(Player)
	if not Player then return end

	Knight.Shared.Services.Remotes:Fire("InventorySocket", Player, "RefreshInventory", {
		Backpack = Knight.GetPlayerInventory(Player),
		Bank = _G.PlayerData[Player.Name].Bank,
	});

	return true;
end

return Knight
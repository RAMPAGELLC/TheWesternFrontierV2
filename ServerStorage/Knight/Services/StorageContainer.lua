-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		ContainerSession = {},
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

-- Script
local DefaultConfig = {
	ContainerName = "MY BANK",
	SaveName = "Bank",
	SaveStorage = true,
	SaveInStorageContainersArray = false,
	AllowTransfersToStorage = true,
	AllowTransferToInventory = true,
	Slots = 60,
	Items = {}
}

function Knight.new(Player, Settings)
	if Knight.Cache.ContainerSession[Player] then
		return;
	end
	
	Knight.Cache.ContainerSession[Player] = {
		InSession = true,
		Event = false, -- Knight.Shared.Objects.Event.new(),
		Connections = {},
		Config = Settings,
		Load = function(Player)
			local Payload = {
				ContainerName = Knight.Cache.ContainerSession[Player].Config.ContainerName,
				Backpack = {},
				MaxSlots = Knight.Cache.ContainerSession[Player].Config.Slots,
			}
			for key, value in pairs(Knight.Cache.ContainerSession[Player].Config.Items) do
				local Data = Knight.Services.ItemsManager.GetDataFromItemId(value.ItemId)

				table.insert(Payload.Backpack, {
					value, 
					Data,
				})
			end
			Knight.Services.CharacterManager.ReloadPlayerCosmetics(Player)
			Knight.Shared.Services.Remotes:Fire("StorageContainerEvents", Player, "LoadStorage", Payload)
			task.wait()
			Knight.Services.InventoryManager.RefreshInventory(Player)
		end,
		Quit = function(Player)
			local _Config = Knight.Cache.ContainerSession[Player].Config;
			
			if _Config.SaveStorage then
				if _Config.SaveInStorageContainersArray then
					_G.PlayerData[Player.Name].StorageContainers[_Config.SaveName] = _Config.Items
				else
					_G.PlayerData[Player.Name][_Config.SaveName] = _Config.Items
				end
			end

			Knight.Shared.Services.Remotes:Fire("StorageContainerEvents", Player, "Quit")
			
			for _, connection in pairs(Knight.Cache.ContainerSession[Player].Connections) do
				connection:Disconnect()
			end
			
			Knight.Cache.ContainerSession[Player] = nil
		end,
	};

	table.insert(Knight.Cache.ContainerSession[Player].Connections, Knight.Shared.Roblox.Players.PlayerRemoving:Connect(function(p)
		if p == Player then
			Knight.Cache.ContainerSession[Player].Quit(Player)
		end
	end))

	Knight.Cache.ContainerSession[Player].Event = function(...)
		local args = {...};
		local Action =  args[1];
		local _Config = Knight.Cache.ContainerSession[Player].Config;
		
		if Action == "Quit" then
			Knight.Cache.ContainerSession[Player].Quit(Player)
			return true, "Done"
		end

		if Action == "Move" then
			local Inventory = _G.PlayerData[Player.Name].Backpack;
			local Found, Data = false, {}
			local ItemIndex = 1;
			local HoverItem = args[3];

			if HoverItem == nil then
				return false, "No item specified" 
			end

			if args[2] == "Storage" then
				for key, value in pairs(Inventory) do
					if value.ItemId == HoverItem.ItemId and value.Serial == HoverItem.Serial then
						ItemIndex = key;
						Found, Data = true, value;
						break
					end
				end
			elseif args[2] == "Inventory" then
				for key, value in pairs(Knight.Cache.ContainerSession[Player].Config.Items) do
					if value.ItemId == HoverItem.ItemId and value.Serial == HoverItem.Serial then
						ItemIndex = key;
						Found, Data = true, value;
						break
					end
				end
			end

			if not Found then 
				return false, "Player does not have the item."
			end

			if Data.HotbarPosition > 0 then
				return false, "Must remove this from hotbar."
			end

			local ItemData = Knight.Services.ItemsManager.GetDataFromItemId(Data.ItemId)

			if not ItemData then
				warn("Item Data not found.")
				return false, "Item data failed to be found."
			end

			if args[2] == "Inventory" then
				if not _Config.AllowTransferToInventory then
					warn("Transfer disabled.")
					return false, "Transfering items to inventory is disabled."
				end

				if #_G.PlayerData[Player.Name].Backpack >= _G.PlayerData[Player.Name].MaxInventory then
					warn("New container parent is full.")
					return false, "Inventory is full."
				end

				local InsertIndex = #_G.PlayerData[Player.Name].Backpack+1;
				_G.PlayerData[Player.Name].Backpack[InsertIndex] = Knight.Cache.ContainerSession[Player].Config.Items[ItemIndex]
				Knight.Cache.ContainerSession[Player].Config.Items[ItemIndex] = nil
			end

			if args[2] == "Storage" then
				if not _Config.AllowTransfersToStorage then
					warn("Transfer disabled.")
					return false, "Transfering items to storage is disabled."
				end
				
				if #Knight.Cache.ContainerSession[Player].Config.Items >= Knight.Cache.ContainerSession[Player].Config.Slots then
					warn("New container parent is full.")
					return false, "Storage is full."
				end

				if Data.JobItem ~= nil and Data.JobItem then
					return false, "You cannot transfer job items."
				end
				
				local InsertIndex = #Knight.Cache.ContainerSession[Player].Config.Items+1;
				Knight.Cache.ContainerSession[Player].Config.Items[InsertIndex] = _G.PlayerData[Player.Name].Backpack[ItemIndex]
				_G.PlayerData[Player.Name].Backpack[ItemIndex] = nil
			end
			
			Knight.Cache.ContainerSession[Player].Load(Player)
			return true, "Done"
		end
	end
	
	Knight.Cache.ContainerSession[Player].Load(Player)
end

function Knight.Init()
	Knight.Shared.Services.Remotes:Register("StorageContainerEvents", "RemoteFunction", function(Player, ...)
		if Knight.Cache.ContainerSession[Player] == nil then return false, "No active storage container" end
		return Knight.Cache.ContainerSession[Player].Event(...);
	end)
end

return Knight
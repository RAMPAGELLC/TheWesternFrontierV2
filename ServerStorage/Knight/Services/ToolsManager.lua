-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		Listens = {}
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

function Knight.Init()
	Knight.Cache.Listens = {}

	Knight.Shared.Services.Remotes:Register("ToolsManager", "RemoteEvent", function(Player, ...)
		local args = {...};

		if Knight.Cache.Listens[Player.UserId] == nil then return false end

		if args[1] == "InputBegan" then
			Knight.Cache.Listens[Player.UserId].InputBegan(Player, args[2])
			
			return;
		elseif args[2] == "InputEnded" then
			Knight.Cache.Listens[Player.UserId].InputEnded(Player, args[2])
			
			return;
		end
	end)
end

function Knight.KillListen(Player)
	if Knight.Cache.Listens[Player.UserId] == nil then return true end

	for _, connection in pairs(Knight.Cache.Listens[Player.UserId].Connections) do
		connection:Disconnect()
	end
	
	Knight.Shared.Services.Remotes:Fire("InventorySocket", Player, "AMSToggle", Knight.Cache.Listens[Player.UserId].Name, false);
	
	if Player.Backpack:FindFirstChild(Knight.Cache.Listens[Player.UserId].Name) then
		Player.Backpack:FindFirstChild(Knight.Cache.Listens[Player.UserId].Name):Destroy()
	end
	
	Knight.Cache.Listens[Player.UserId] = nil
end

function Knight.Listen(Player, EquipData, ItemData, InventoryData)
	if not EquipData.RobloxTool and ItemData.Type ~= "AMS" then return false end
	if ItemData.KnightToolsManager == nil or ItemData.KnightToolsManager ~= nil and not ItemData.KnightToolsManager then return false end
	
	if ItemData.Type == "AMS" then
		Knight.Cache.Listens[Player.UserId] = {
			Name = ItemData.Name,
			Debounce = false,
			Listens = {
				function(new_value)
					table.insert(Knight.Cache.Listens[Player.UserId].Connections, new_value)
				end,
			},
			InputBegan = function(Player, Key)
			end,
			InputEnded = function(Player, Key)
			end,
			Connections = {}
		}
		
		local FakeTool = game.ReplicatedStorage["AMS-assets"].Tools:FindFirstChild(ItemData.Name):Clone()
		FakeTool:ClearAllChildren()
		FakeTool.Parent = Player.Backpack
		task.wait(.1)
		Knight.Shared.Services.Remotes:Fire("InventorySocket", Player, "AMSToggle", ItemData.Name, true);
		
		return false;
	end
	
	Knight.Cache.Listens[Player.UserId] = {
		Name = ItemData.Name,
		Debounce = false,
		Listens = {
			function(new_value)
				table.insert(Knight.Cache.Listens[Player.UserId].Connections, new_value)
			end,
		},
		InputBegan = function(Player, Key)
			if ItemData.InputBegan == nil then return end
			
			ItemData.InputBegan(Player, Key, EquipData, ItemData, InventoryData, Knight.Cache.Listens[Player.UserId].Listens)
		end,
		InputEnded = function(Player, Key)
			if ItemData.InputEnded == nil then return end
			
			ItemData.InputEnded(Player, Key, EquipData, ItemData, InventoryData, Knight.Cache.Listens[Player.UserId].Listens)
		end,
		Connections = {
			EquipData.RobloxTool.Equipped:Connect(function()
				if ItemData.Equipped == nil then return end
				
				ItemData.Equipped(Player, EquipData, ItemData, InventoryData, Knight.Cache.Listens[Player.UserId].Listens)
			end),
			EquipData.RobloxTool.Unequipped:Connect(function()
				if ItemData.Unequipped == nil then return end
				
				ItemData.Unequipped(Player, EquipData, ItemData, InventoryData, Knight.Cache.Listens[Player.UserId].Listens)
			end),
			EquipData.RobloxTool.Activated:Connect(function()
				if ItemData.Activated == nil then return end
				
				if Knight.Cache.Listens[Player.UserId].Debounce then return end
				Knight.Cache.Listens[Player.UserId].Debounce = true
				ItemData.Activated(Player, EquipData, ItemData, InventoryData, Knight.Cache.Listens[Player.UserId].Listens)
				task.delay(ItemData.Debounce ~= nil and ItemData.Debounce or math.random(.2,.4), function()
					if Knight.Cache.Listens[Player.UserId] == nil then return end
					Knight.Cache.Listens[Player.UserId].Debounce = false
				end)
			end)
		}
	}

	return true
end

return Knight
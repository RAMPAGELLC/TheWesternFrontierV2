-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		RefillEvery = 900,
		Stock = {
			[1] = {
				Name = "Joe's Gun Store",
				StockLastRefill = os.time(),
				SellableLoot = {},
				Stock = {
					{ItemId = 4, Stock = 12, Default = 12},
					{ItemId = 20, Stock = 12, Default = 12},
					{ItemId = 21, Stock = 12, Default = 12},
					{ItemId = 40, Stock = 2, Default = 2},
					{ItemId = 28, Stock = 2, Default = 2},
					{ItemId = 118, Stock = 6, Default = 6},
					{ItemId = 119, Stock = 6, Default = 6},
					{ItemId = 120, Stock = 6, Default = 6},
					{ItemId = 121, Stock = 6, Default = 6},
					{ItemId = 122, Stock = 6, Default = 6},
					{ItemId = 123, Stock = 6, Default = 6},
					{ItemId = 124, Stock = 6, Default = 6},
					{ItemId = 125, Stock = 6, Default = 6},
					{ItemId = 126, Stock = 6, Default = 6},
					{ItemId = 127, Stock = 6, Default = 6},
					{ItemId = 128, Stock = 6, Default = 6},
					{ItemId = 142, Stock = 6, Default = 6},
				}
			},
			[2] = {
				Name = "Callahans General Store",
				StockLastRefill = os.time(),
				SellableLoot = {24,25,26,27,37,6,57},
				Stock = {
					[1] = {ItemId = 38, Stock = 12, Default = 12},
					[2] = {ItemId = 39, Stock = 99, Default = 99},
					[3] = {ItemId = 5, Stock = 12, Default = 12},
					[4] = {ItemId = 7, Stock = 2, Default = 2},
					[5] = {ItemId = 23, Stock = 12, Default = 12},
					[6] = {ItemId = 29, Stock = 12, Default = 12},
					[7] = {ItemId = 6, Stock = 2000, Default = 2000},
					[8] = {ItemId = 57, Stock = 3, Default = 3},
				}
			},
			[3] = {
				Name = "Blackwater Mining Supplies",
				StockLastRefill = os.time(),
				SellableLoot = {
					8, 9, 10, 11, 12, 13, 14, 42, 47, 48, 49, 50, 144
				},
				Stock = {
					[1] = {ItemId = 15, Stock = 12, Default = 12},
					[2] = {ItemId = 16, Stock = 3, Default = 3},
					[3] = {ItemId = 17, Stock = 6, Default = 6},
					[4] = {ItemId = 18, Stock = 2, Default = 2},
					[5] = {ItemId = 68, Stock = 12, Default = 12},
				}
			},
			[4] = {
				Name = "Fishing Supplies",
				StockLastRefill = os.time(),
				SellableLoot = {
				},
				Stock = {
					[1] = {ItemId = 41, Stock = 12, Default = 12},
				}
			},
			[5] = {
				Name = "Bob's Farming Supplies",
				StockLastRefill = os.time(),
				SellableLoot = {
					55, 56
				},
				Stock = {
					[1] = {ItemId = 54, Stock = 12, Default = 12},
					[2] = {ItemId = 52, Stock = 12, Default = 12},
					[3] = {ItemId = 51, Stock = 12, Default = 12},
					[4] = {ItemId = 53, Stock = 12, Default = 12},
				}
			},
			[6] = {
				Name = "Witchcraft",
				StockLastRefill = os.time(),
				RequireItems = 65,
				SellableLoot = {
					55, 56
				},
				Stock = {
					[1] = {ItemId = 58, Stock = 2, Default = 2},
					[2] = {ItemId = 59, Stock = 2, Default = 2},
					[3] = {ItemId = 60, Stock = 2, Default = 2},
					[4] = {ItemId = 61, Stock = 1, Default = 1},
					[5] = {ItemId = 66, Stock = 1, Default = 1},
				}
			},
			[7] = {
				Name = "Treasures Clues",
				StockLastRefill = os.time(),
				SellableLoot = {
					149, 146, 
				},
				Stock = {
					[1] = {ItemId = 69, Stock = 6, Default = 6},
					[2] = {ItemId = 65, Stock = 1, Default = 1},
					[3] = {ItemId = 67, Stock = 6, Default = 6},
				}
			},
			[8] = {
				Name = "Wagon Rental",
				StockLastRefill = os.time(),
				SellableLoot = {
				},
				Stock = {
					[1] = {ItemId = 71, Stock = 6, Default = 6},
				}
			},
			[9] = {
				Name = "Jason Brother Clothing",
				StockLastRefill = os.time(),
				SellableLoot = {
				},
				Stock = {
					{
						["Default"] = 6,
						["ItemId"] = 75,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 76,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 77,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 78,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 79,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 80,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 81,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 82,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 83,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 84,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 85,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 86,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 87,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 88,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 89,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 90,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 91,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 92,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 93,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 94,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 95,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 96,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 97,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 98,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 99,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 100,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 101,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 102,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 103,
						["Stock"] = 6
					}
					,{
						["Default"] = 6,
						["ItemId"] = 104,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 105,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 106,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 107,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 108,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 109,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 110,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 111,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 112,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 113,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 114,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 115,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 116,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 117,
						["Stock"] = 6
					},{
						["Default"] = 6,
						["ItemId"] = 153,
						["Stock"] = 6
					},
				}
			},
			[10] = {
				Name = "Stolen Loot Dealer",
				StockLastRefill = os.time(),
				SellableLoot = {35},
				Stock = {
				}
			},
			[11] = {
				Name = "Sammy's Food Market",
				StockLastRefill = os.time(),
				SellableLoot = {},
				Stock = {
					{ItemId = 19, Stock = 12, Default = 12, CanStack = true},
					{ItemId = 38, Stock = 12, Default = 12, CanStack = true},
					{ItemId = 39, Stock = 12, Default = 12, CanStack = true},
				}
			},
			[12] = {
				Name = "Sky's Barber Shop",
				StockLastRefill = os.time(),
				SellableLoot = {},
				Stock = {
					{ItemId = 155, Stock = 12, Default = 12, CanStack = true},
					{ItemId = 156, Stock = 12, Default = 12, CanStack = true},
				}
			},
		}
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

-- Script
function Knight.SellLoot(Player, StockId)
	local sold_count = 0

	for index, inventory_data in pairs(_G.PlayerData[Player.Name].Backpack) do
		local ItemData = Knight.Services.ItemsManager.GetDataFromItemId(inventory_data.ItemId)

		if ItemData.IsOre ~= nil and ItemData.IsOre or ItemData.Type == "StackResource" then
			local s,a = Knight.SellItem(Player, StockId, ItemData.ItemId, inventory_data.Serial, false)
			sold_count += a;
		end

		task.wait()
	end

	task.wait(.4)

	if sold_count > 0 then
		Knight.Services.InventoryManager.RefreshInventory(Player)
		return true, sold_count
	else
		return false, 0
	end
end

function Knight.SellItem(Player, StockId, ItemId, Serial, RefreshInventory)
	if RefreshInventory == nil then RefreshInventory = true end
	if Knight.Cache.Stock[StockId] == nil then
		return false, 0
	end

	local can_sell, amount = false, 0

	for Index, Value in pairs(Knight.Cache.Stock[StockId].Stock) do
		if Value["ItemId"] == ItemId then --and Value["Stock"] > 0 then
			can_sell = true;
			break;
		end
	end

	if not can_sell then
		for Index, Value in pairs(Knight.Cache.Stock[StockId].SellableLoot) do
			if Value == ItemId then
				can_sell = true;
				break;
			end
		end
	end

	if can_sell then
		local ItemData = Knight.Services.ItemsManager.GetDataFromItemId(ItemId)

		if not ItemData then return false, amount end
		local has, index, inventory_data, data = Knight.Services.ItemsManager.HasItem(Player, ItemId, Serial)
		
		if not has then return false, amount end
		if inventory_data == nil then return false, amount end
		
		local Sell = 0

		if ItemData.Sell ~= nil then
			Sell = ItemData.Sell
		else
			Sell = ItemData.Price/4
		end
		
		if inventory_data[1] ~= nil and inventory_data[1].Stack ~= nil and inventory_data[1].Stack > 1 then
			Sell *= inventory_data.Stack
		end

		Knight.Services.ItemsManager.RemoveItem(Player, ItemId, Serial, RefreshInventory, "Item sold to store id " .. tostring(StockId), true)
		Knight.Services.CharacterManager.AddCash(Player, Sell)

		return true, Sell
	end

	return can_sell, amount
end

function Knight.PurchaseItem(Player, StockId, ItemId)
	if Knight.Cache.Stock[StockId] == nil then
		return false
	end

	if Knight.Cache.Stock[StockId].RequireItems ~= nil then
		if not Knight.Services.ItemsManager.HasItem(Player, Knight.Cache.Stock[StockId].RequireItems, false, true) then
			Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "Alert", "Market", "We don't sell to your kind around here.", 5)
			return false
		end
	end

	local success, insert_id = false, 0
	local can_buy, stock_index = false, 0

	for Index, Value in pairs(Knight.Cache.Stock[StockId].Stock) do
		if Value["ItemId"] == ItemId and Value["Stock"] > 0 then
			can_buy, stock_index = true, Index;
			break;
		end
	end

	if can_buy then
		local ItemData = Knight.Services.ItemsManager.GetDataFromItemId(ItemId)

		if not ItemData then return false end
		if not ItemData.ForSale then return false end
		
		local Cash = _G.PlayerData[Player.Name].Cash
		
		-- makes loans pointless lol.
	--	if _G.PlayerData[Player.Name].BadCash > 0 then
	--		Cash -= _G.PlayerData[Player.Name].BadCash
	--	end

		if Cash >= ItemData.Price then
			--success, insert_id = Knight.Services.ItemsManager.GiveItem(Player, ItemId, true, false, false, "Purchase item from shop.", false)
			success = Knight.Services.ItemsManager.AddToStackOrCreate(Player, ItemId, 1, false)
			
			if success then
				Knight.Cache.Stock[StockId].Stock[stock_index].Stock -= 1;
				Knight.Services.CharacterManager.RemoveCash(Player, ItemData.Price)
			end

			return success
		end
	end

	return success
end

function Knight.OpenShop(Player, StockId)
	local Payload = {
		["StockId"] = StockId,
		["Stock"] = Knight.Cache.Stock[StockId]
	}

	if Payload.Stock.RequireItems ~= nil then
		if not Knight.Services.ItemsManager.HasItem(Player, Payload.Stock.RequireItems, false, true) then
			return Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "Alert", "Market", "We don't sell to your kind around here.", 5)
		end
	end

	for index, data in pairs(Payload.Stock.Stock) do
		local ItemData = Knight.Services.ItemsManager.GetDataFromItemId(data.ItemId)

		if ItemData ~= nil then
			Payload.Stock.Stock[index] = ItemData;
			Payload.Stock.Stock[index].Stock = data.Stock;
			Payload.Stock.Stock[index].Default = data.Default;
			Payload.Stock.Stock[index].CanStack = data.CanStack ~= nil and data.CanStack or false;

			if Payload.Stock.Stock[index].Listener ~= nil then
				Payload.Stock.Stock[index].Listener = nil
			end

			if Payload.Stock.Stock[index].Equipped ~= nil then
				Payload.Stock.Stock[index].Equipped = nil
			end

			if Payload.Stock.Stock[index].Unequipped ~= nil then
				Payload.Stock.Stock[index].Unequipped = nil
			end

			if Payload.Stock.Stock[index].Activated ~= nil then
				Payload.Stock.Stock[index].Activated = nil
			end
		end
	end

	Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "LaunchShop", Payload)
end

function Knight.Init()
	Knight.Shared.Services.Remotes:Register("ShopSocket", "RemoteFunction", function(Player, ...)
		local args = {...};
		local StockId = tonumber(args[2]);
		if StockId <= 0 then return false end
		
		Knight.OpenShop(Player, StockId)

		if args[1] == "PurchaseItem" then
			local ItemId = tonumber(args[3]);

			if ItemId <= 0 then return false end
			
			return Knight.PurchaseItem(Player, StockId, ItemId)
		elseif args[1] == "SellItem" then
			local ItemId = tonumber(args[3]);
			local SerialId = tonumber(args[4]);

			if ItemId <= 0 or SerialId <= 0 then return false end

			return Knight.SellItem(Player, StockId, ItemId, SerialId)
		elseif args[1] == "SellLoot" then

			return Knight.SellLoot(Player, StockId)
		end
	end)

	task.spawn(function()
		while true and task.wait(Knight.Cache.RefillEvery) do
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Alert", "Shop Restocking", "All shops are being re-stocked!")
			task.wait(15)
			for ShopId, ShopData in pairs(Knight.Cache.Stock) do
				ShopData.StockLastRefill = os.time()

				for _, StockData in pairs(ShopData.Stock) do
					StockData.Stock = StockData.Default
					--if StockData.Stock <= 0 then
					--	StockData.Stock = StockData.Default
					--end
				end

				Knight.Cache.Stock[ShopId] = ShopData
			end
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Alert", "Shop Restocking", "All shops have been re-stocked!")
		end
	end)
end

return Knight
-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		DatastoreVersion = "alpha_ssid_" .. "test_3",
		Databases = {},
		Modules = {},
		DevMode = false,
		AWS = {
			Client = false,
			Cluster = false,
			Database = false,

			Master = false,
			Player = false,
			Admin = false,
		},
		Settings = {
			PoloarstarBans = {"steelersnj","DJ_Templar","Animosity","NorwegianWarfighter","IoNeptune","m50s","TemplarKnight123","jammuni","gothicserpent","5vmg","WorldLeader","t_repel","JaegerOmega","CerealKiller","PapaBlizzard","InfantryJackal","EnderBlocProduct","Rezzi","TemplarJackal","tomooose","AxeOmega","MP5_A1","WubbersOfArabia","m_agdump","PurelyInfantry","PurelyNeptune","ImmortalTrident","cryegoons","R0KA_0P3RAT0R","Stone_Tactical","Officergdi","tetriskat","XxFearfulxx13","SrZeldas","OperatorSoul","shivercakes","OperativCharlie","Bohors","Daagon","childsupporxt","beardedbmt","REAPERHAVOC","Nuke_Alfa","LynxOmega","Enforcer_Pug"},
			BlacklistedPlayers = {
				{
					Username = "SiIentGhosty",
					UserId = 103989440,
					Reason = "Blacklisted",
					Admin = "vq9o"
				}, 
				{
					Username = "quyphanlong",
					UserId = 1499614781,
					Reason = "Blacklisted",
					Admin = "vq9o"
				},
				{
					Username = "Nestorkie",
					UserId = 382425721,
					Reason = "Blacklisted",
					Admin = "vq9o"
				},
			},
			BlacklistedGroups = {
				{Id = 9768102, Reason = "Blacklisted", Admin = "vq9o"},
			},
		},
		DataTemplate = {
			BadCash = 0,
			Cash = 2500,
			Bounty = 0,
			
			LastLoan = os.time(),
			LoanDownPayment = 0,
			LoanAmount = 0,
			LoanPaid = true,
			
			Wanted = false,
			Hostile = false,
			InMenu = true,
			TutorialCompleted = false,
			Online = false,
			ServerId =  false,

			Hunger = 100,
			Thirst = 100,

			Backpack = {},

			Bank = {},
			Horses = {},

			Building = {
				Saves = {},
				Current = {},
			},

			Clothing = {
				Face = 154,
				Hair = 0,
				Hat = 0,
				Mask = 0,
				Glasses = 0,
				Shirt = 73,
				Pants = 74,
				BodyHeightScale = 1.02,
				BodyWidthScale = 0.9,
				SkinColor = {
					R = 0.800000011920929,
					G = 0.5568627715110779, 
					B = 0.4117647111415863
				},
				FaceColor = {
					R = 1,
					G = 1,
					B = 1
				},
				HairColor = {
					R = 1,
					G = 1,
					B = 1
				},
				ShirtColor = {
					R = 1,
					G = 1,
					B = 1
				},
				PantsColor = {
					R = 1,
					G = 1,
					B = 1
				},
			},

			StorageContainers = {},

			ExpBooster = false,
			ExpBoosterExpire = os.time(),

			ProgressionClaims = {
				["Citizen"] = {},
				["Bounty Hunter"] = {},
				["Doctor"] = {},
				["Governor"] = {},
				["Hitman"] = {},
				["Mayor"] = {},
				["Outlaw"] = {},
				["Pirate"] = {},
				["Sheriff"] = {},
				["RAMPAGE Rangers"] = {},
				["Marshal"] = {},
				["Neutral"] = {},
			},

			Progression = {
				LockpickSpeed = 0,
				MiningDamage = 0,
				TreeDamage = 0,
				RobberyCashMultiplier = 0,
			},

			TeamProgression = {
				["Barkeep"] = {["XP"] = 0, ["Level"] = 1},
				["Citizen"] = {["XP"] = 0, ["Level"] = 1},
				["Bounty Hunter"] = {["XP"] = 0, ["Level"] = 1},
				["Doctor"] = {["XP"] = 0, ["Level"] = 1},
				["Governor"] = {["XP"] = 0, ["Level"] = 1},
				["Hitman"] = {["XP"] = 0, ["Level"] = 1},
				["Mayor"] = {["XP"] = 0, ["Level"] = 1},
				["Outlaw"] = {["XP"] = 0, ["Level"] = 1},
				["Pirate"] = {["XP"] = 0, ["Level"] = 1},
				["Sheriff"] = {["XP"] = 0, ["Level"] = 1},
				["Marshal"] = {["XP"] = 0, ["Level"] = 1},
				["RAMPAGE Rangers"] = {["XP"] = 0, ["Level"] = 1},
				["Neutral"] = {["XP"] = 0, ["Level"] = 1},
			},

			MaxInventory = 30,
			MaxBank = 15,

			InFaction = false,
			FactionUID = "",

			InJail = false,
			JailTime = 0,
			MoneyBagValue = 0,
			MoneyBagIsCivil = false,

			SelectedRankTitle = "",
			Tags = {"Veteran"},

			Surveys = {
				WouldYouInviteAFriend = false,
			},

			Events = {
				Christmas_2021 = false,
				Christmas_2021_Reward = false,
			},

			PlayerStats = {
				-- Game Stats
				PaidAccess = true,
				AlphaPlayer = true,
				BetaPlayer = true,
				ReadRules = false,

				-- Game Records
				TotalRobberys = 0,
				TotalArrests = 0, -- Times you arrested players
				TotalPersonalArrests = 0, -- Times you we're arrested
				TotalDonations = 0,
				TotalBounty = 0,
				TotalClaimedBountys = 0,
				TotalPlayTime = 0,
				TotalBulletsUsed = 0,
				TotalPurchasedCash = 0,
				TotalSpentIncome = 0,
				TotalIncome = 1000,

				-- Total Kills
				TotalKilledPlayers = 0,
				TotalKilledAnimals = 0,
				TotalKilledBears = 0,
				TotalKilledDears = 0,
				TotalKilledHorses = 0,
				TotalKilledBisons = 0,
				TotalKilledGators = 0,
			},

			Moderation = {
				History = {},
				DiscardedItems = {}, -- History of items they lost on drop or deleted from bank/inventory with 
				-- Unique Item ID to track to player of the Item & Item Name & Item ID
				TradeHistory = {}, -- Same as discardeditems, but it tracks items users traded items too.

				Rank = "Player", -- Player, Moderator, Admin, Developer
			}
		}
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

local AWSDatabase = require(game:GetService("ServerScriptService").AWSDatabase)
local GameCodes = require(game:GetService("ServerScriptService").GameCodes)
local HttpService = game:GetService("HttpService")
local DeveloperProducts = {}

_G.IsVIPServer = false
_G.VIPData = {
	DataSave = true,
	OwnerId = game.CreatorId,
	Started = os.time()
}

DeveloperProducts[1387383441] = function(receipt, player)
	local amount = 1000

	Knight.Services.NotifyService.Notify(player, "Robux Purchase", "+"..tostring(amount).." cash has been added to your bank, thank you for your contribution.", false, 15)
	Knight.Services.CharacterManager.AddCash(player, amount)
end

DeveloperProducts[1387383577] = function(receipt, player)
	local amount = 5000

	Knight.Services.NotifyService.Notify(player, "Robux Purchase", "+"..tostring(amount).." cash has been added to your bank, thank you for your contribution.", false, 15)
	Knight.Services.CharacterManager.AddCash(player, amount)
end

DeveloperProducts[1387383862] = function(receipt, player)
	local amount = 10000

	Knight.Services.NotifyService.Notify(player, "Robux Purchase", "+"..tostring(amount).." cash has been added to your bank, thank you for your contribution.", false, 15)
	Knight.Services.CharacterManager.AddCash(player, amount)
end

DeveloperProducts[1387383035] = function(receipt, player)
	local amount = 1800 -- in seconds

	Knight.Services.NotifyService.Notify(player, "Robux Purchase", "30 minute xp boost has been activated. Please note xp boosts are not stackable, thank you for your contribution.", false, 15)

	local timeFormatted = amount + os.time()

	_G.PlayerData[player.Name].ExpBooster = true
	_G.PlayerData[player.Name].ExpBoosterExpire = timeFormatted
	Knight.Services.CharacterManager.UpdateExpBoosterStatus(player)
end

DeveloperProducts[1387382879] = function(receipt, player)
	local amount = 3600 -- in seconds

	Knight.Services.NotifyService.Notify(player, "Robux Purchase", "1 hour xp boost has been activated. Please note xp boosts are not stackable, thank you for your contribution.", false, 15)

	local timeFormatted = amount + os.time()

	_G.PlayerData[player.Name].ExpBooster = true
	_G.PlayerData[player.Name].ExpBoosterExpire = timeFormatted
	Knight.Services.CharacterManager.UpdateExpBoosterStatus(player)
end

DeveloperProducts[1387383164] = function(receipt, player)
	local amount = 86400 -- in seconds

	Knight.Services.NotifyService.Notify(player, "Robux Purchase", "24 hour xp boost has been activated. Please note xp boosts are not stackable, thank you for your contribution.", false, 15)

	local timeFormatted = amount + os.time()

	_G.PlayerData[player.Name].ExpBooster = true
	_G.PlayerData[player.Name].ExpBoosterExpire = timeFormatted
	Knight.Services.CharacterManager.UpdateExpBoosterStatus(player)
end


local function processReceipt(receiptInfo)
	local PurchaseHistory = game:GetService("DataStoreService"):GetDataStore("PurchaseHistory")
	local playerProductKey = receiptInfo.PlayerId .. "_" .. receiptInfo.PurchaseId
	local purchased = false
	local success, errorMessage = pcall(function()
		purchased = PurchaseHistory:GetAsync(playerProductKey)
	end)
	-- If purchase was recorded, the product was already granted
	if success and purchased then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif not success then
		error("Data store error:" .. errorMessage)
	end

	-- Find the player who made the purchase in the server
	local player = game:GetService("Players"):GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		-- The player probably left the game
		-- If they come back, the callback will be called again
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local function Alert(Message)
		Knight.Services.NotifyService.Notify(player, "Robux Purchase", Message, false, 7)
	end

	local function AlertError(Message)
		Knight.Services.NotifyService.Notify(player, "Robux Purchase", Message, false, 7)
	end

	-- Look up handler function from 'productFunctions' table above
	local handler = DeveloperProducts[receiptInfo.ProductId]

	-- Call the handler function and catch any errors
	local success, result = pcall(handler, receiptInfo, player)
	--[[if not success or not result then
		warn("Error occurred while processing a product purchase")
		print("\nProductId:", receiptInfo.ProductId)
		print("\nPlayer:", player)
		AlertError("We we're unable to process your purchase for product ".. receiptInfo.ProductId .." player ".. player.Name)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	]]
	-- Record transaction in data store so it isn't granted again
	local success, errorMessage = pcall(function()
		PurchaseHistory:SetAsync(playerProductKey, true)
	end)


	return Enum.ProductPurchaseDecision.PurchaseGranted

	--if not success then
	--		AlertError("We we're unable to log your purchase for support. ".. errorMessage)
	--	error("Cannot save purchase data: " .. errorMessage)
	--end

	--return Enum.ProductPurchaseDecision.PurchaseGranted
end

game:GetService("MarketplaceService").ProcessReceipt = processReceipt

-- Script
local BannerNotificationModule = require(game:GetService("ReplicatedStorage").BannerNotificationModule)
local BannerIcons = {
	Info = "rbxassetid://12782171134",
	Alert = "rbxassetid://7634887649",
	AlertError = "rbxassetid://12782171182",
	AlertWarning = "rbxassetid://12782171085",
	ClockWarning = "rbxassetid://11430238660",
	RobuxGold = "rbxassetid://11560341824",
	RobuxWHite = "rbxassetid://12782174542",
	RobloxError = "rbxassetid://12782176667",
	Announcement = "rbxassetid://12782185702",
	Checkmark = "rbxassetid://12782186460",
	Xmark = "rbxassetid://12782186126",
	Notification = "rbxassetid://12782186027",
	RAMPAGEBear = "rbxassetid://12403559773",
	User = "rbxassetid://12782170980",
	StarFilled = "rbxassetid://12782180134",
	LawStar = "rbxassetid://12403614612",
	Pirate = "rbxassetid://12403638757",
	Trash = "rbxassetid://12782170915",
	GreenCheck = "rbxassetid://12782170839",
	OrangeWarning = "rbxassetid://12782170759",
	GreenSafety = "rbxassetid://12782183048",
	RedSafety = "rbxassetid://12782183122"
}

function _G.BannerAlert(Player, Title, Message, Duration, Icon)
	if Duration == nil then Duration = 5 end
	if Icon == nil then Icon = "Info" end
	if BannerIcons[Icon] ~= nil then Icon = BannerIcons[Icon] end

	if Player then
		BannerNotificationModule:Notify(Title, Message, Icon, Duration, Player)
	else
		for _, v in pairs(game:GetService("Players"):GetPlayers()) do
			BannerNotificationModule:Notify(Title, Message, Icon, Duration, v)
		end
	end
end

function Knight.DropPlayer(Player, Message)
	if Message == nil then
		Message = "No message specified for disconnection."
	end

	Player:Kick("[KNIGHT FRAMEWORK] \n THE WESTERN FRONTIER \n You were removed from the server by server for: " .. Message)
end

_G.Kick = Knight.DropPlayer

function Knight.Error(...)
	local boardId = Knight.Services.Trello.getBoard("The Western Frontier", true)
	local ListId = Knight.Services.Trello.getList(boardId, "Error Reports", true)
	local args = {...};
	local Status = Knight.Services.Trello.createCard(ListId, "Timestamp:"..os.time(), "Error: ".._G.tableToString(args))

	warn("[WESTERN:Error] ", ...)
end

function Knight.FilterInput(Player, Message)
	return Knight.Shared.Roblox.Chat:FilterStringForBroadcast(Player, Message)
end

function Knight.PlayerAdded(player)
	_G.players_in_cache[player.Name] = true
	print("[KNIGHT] " .. player.Name .. " has connected to the session at " .. os.time())

	if player.UserId > 1 and Knight.Cache.DevMode == true and not player:IsInGroup(9640975) then
		return player:Kick("Developer Mode Enabled \n \n You must be a member of RAMPAGE Interactive LLC in-order to play, Come back later!")
	end

	if player.AccountAge < 30 and player.Name ~= "Player1" and player.Name ~= "Player2" and not player:IsInGroup(15012374)then
		return player:Kick('Your account age is too young. Come back in ' ..(30 - player.AccountAge) ..' day(s), this is to prevent exploiters and laundering of items');
	end
	
	if player.UserId > 1 and not game:GetService("MarketplaceService"):PlayerOwnsAsset(player, 102611803) then
		return player:Kick("A verified roblox account linked to a email is required to play, this is to prvent raids/exploiters.")
	end
	
	for _, GroupBan in pairs(Knight.Cache.Settings.BlacklistedGroups) do
		if player:IsInGroup(GroupBan.Id) then
			local Group = Knight.Shared.Roblox.GroupService:GetGroupInfoAsync(GroupBan.Id)
			return player:Kick("You are in a blacklisted group " .. GroupBan.Id ..", known as " .. Group.Name ..". We see your in the group as " ..player:GetRoleInGroup(GroupBan.Id) ..". In-order to play this game you must leave the group, this group is blacklisted for " ..	GroupBan.Reason .. " by admin " .. GroupBan.Admin)
		end
	end

	for i, Ban in pairs(Knight.Cache.Settings.BlacklistedPlayers) do
		if player.Name == Ban.Username or player.UserId == Ban.UserId then
			return player:Kick("You are a blacklisted player, you are blacklisted for the following reason: " ..Ban.Reason .. ". You were blacklisted by " .. Ban.Admin)
		end
	end

	for _, Ban in pairs(Knight.Cache.Settings.PoloarstarBans) do
		if player.Name == Ban or player.UserId == Ban then
			return player:Kick("You are a known banned user from ACS and/or Polarstar Studios, open an appeal ticket to appeal this.")
		end
	end
	
	Knight.Services.NotifyService.Notify(nil, "Player Connected", string.format("%s has connected to the session.", player.Name), false, 3)
	--[[
	local success, data = pcall(function()
		return Knight.Cache.Databases.Player:GetAsync(player.UserId)
	end)
	]]
	
	local success, data = false, Knight.Cache.Databases.Player:GetAsync(player.UserId)
	if data ~= nil then success = true end

	local FirstLaunch = false

	if not success or data == nil then
		warn(string.format("[KNIGHT] Failed to locate player data, Creating player data for %s (%s).", player.Name, player.UserId))

		data = Knight.Cache.DataTemplate

		local save_success, result = pcall(function()
			return Knight.Cache.Databases.Player:SetAsync(player.UserId, data)
		end)

		if save_success then
			FirstLaunch = true
		else
			local message = "Error Occured while creating new player data, this error has been uploaded to our internal bugs database for review. \n \n Error: ".. result.. " \n Status: ".. tostring(success);
			Knight.Error(message)
			return Knight.DropPlayer(player, message)
		end
	else
		print(string.format("[KNIGHT] Player data loaded for %s (%s) successfully.", player.Name, player.UserId))
		data = Knight.UpdatedTable(data, Knight.Cache.DataTemplate)
	end
	
	Knight.ProccessData(player, data, FirstLaunch)

	task.wait(.1)

	Knight.Services.CharacterManager.PlayerAdded(player)

	if _G.PlayerData[player.Name].Bounty > 0 then
		_G.PlayerData[player.Name].Wanted = true
		Knight.Services.RolesManager.Assign(player, Knight.Shared.Roblox.Teams.Outlaw)
	else
		_G.PlayerData[player.Name].Wanted = false
		Knight.Services.RolesManager.Assign(player, Knight.Shared.Roblox.Teams.Citizen)
	end

	Knight.Services.LawManager.AddBounty(player, 0)
	Knight.Services.CharacterManager.AddCash(player, 0)
	Knight.Services.ProgressionManager.AddXP(player, 0)

	task.spawn(function()
		for _, Item in pairs(Knight.Database.Items.get()) do
			if Item.GamepassItem then
				if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId, Item.GamepassId) then
					if not Knight.Services.ItemsManager.HasItem(player, Item.ItemId, false, true) then
						_G.GiveItem(player, Item.ItemId)
					end
				end
			end
		end
	end)
end

function Knight.PlayerRemoved(Player)
	Knight.Services.NotifyService.Notify(nil, "Player Disconnected", string.format("%s has left the session.", Player.Name), false, 3)

	if _G.PlayerData[Player.Name] == nil then
		return
	end
	
	task.delay(.5, function()
		_G.players_in_cache[Player.Name] = nil
		_G.PlayerData[Player.Name].Online = false
		_G.PlayerData[Player.Name].ServerId = game.GameId

		if Knight.Services.StorageContainer.Cache.ContainerSession[Player] ~= nil then
			Knight.Services.StorageContainer.Cache.ContainerSession[Player].Quit(Player)
		end

		if _G.PVPList[Player.Name] ~= nil then
			_G.PVPList[Player.Name] = nil
		end

		if _G.SafeZoneProtection[Player.Name] ~= nil then
			_G.SafeZoneProtection[Player.Name] = nil
		end

		if Knight.Cache.SpawnsCooldown[Player.Name] ~= nil then
			Knight.Cache.SpawnsCooldown[Player.Name] = nil
		end

		if Knight.Services.LockpickMaster.Cache.LockpickSessions[Player] ~= nil then
			Knight.Services.LockpickMaster.Cache.LockpickSessions[Player].Track:Destroy()
			Knight.Services.LockpickMaster.Cache.LockpickSessions[Player] = nil
		end

		if Knight.Services.ResourcesManager.Cache.CraftSessions[Player.UserId] ~= nil then
			Knight.Services.ResourcesManager.Cache.CraftSessions[Player.UserId] = nil
		end

		if Knight.Services.HorseManager.Cache.IsLeadingHorse[Player] ~= nil then
			Knight.Services.HorseManager.Cache.IsLeadingHorse[Player] = nil
		end

		if Knight.Services.HorseManager.Cache.HasHorseHitched[Player] ~= nil then
			Knight.Services.HorseManager.Cache.HasHorseHitched[Player] = nil
		end
		
		local success, result = pcall(function()
			return Knight.Cache.Databases.Player:SetAsync(Player.UserId, _G.PlayerData[Player.Name])
		end)
		
		task.wait()
		
		_G.PlayerData[Player.Name] = nil;
	end)

	local s,e = pcall(function()
		Knight.Services.WagonManager.DespawnWagon(Player)

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

		if _G.ServerCache[Player.Name .. "_equipped"] ~= nil then
			for _, item in pairs(_G.ServerCache[Player.Name .. "_equipped"]) do
				if item.RobloxTool ~= nil and item.RobloxTool then
					item.RobloxTool:Destroy()
				end
			end

			Knight.Services.ToolsManager.KillListen(Player)
			_G.ServerCache[Player.Name .. "_equipped"] = nil
		end
	end)

	if not s then warn(e) end
end

function Knight:GetDataStore(DatastoreName, ...)
	return AWSDatabase:GetDataStore(DatastoreName, ...)
end

function Knight:Init()
	Knight.Cache.Databases = {
		Master = Knight:GetDataStore("Master"),
		Player = Knight:GetDataStore("Player"),
		Admin = Knight:GetDataStore("Admin"),
		ItemLogging = Knight:GetDataStore("ItemLogging"),
	}

	Knight.Cache.SpawnsCooldown = {}

	game:GetService("Players").PlayerRemoving:Connect(Knight.PlayerRemoved)

	Knight.Shared.Roblox.ReplicatedStorage.Events.ServerSocket.Event:Connect(function(...)
		local args = {...};

		if args[1] == "RolesManager" then
			return Knight.Services.RolesManager.Assign(args[2], args[3])
		elseif args[1] == "Forward" then
			task.spawn(function()
				Knight.Shared.Services.Remotes:Fire(args[3], args[2], table.unpack(args[4]))
			end)
		elseif args[1] == "OpenBank" then
			return Knight.Services.StorageContainer.new(args[2], {
				ContainerName = "MY BANK",
				SaveName = "Bank",
				SaveStorage = true,
				SaveInStorageContainersArray = false,
				AllowTransfersToStorage = true,
				AllowTransferToInventory = true,
				Slots = _G.PlayerData[args[2].Name].MaxBank,
				Items = _G.PlayerData[args[2].Name].Bank
			})
		elseif args[1] == "CraftManager" then
			return Knight.Services.ResourcesManager.OpenBench(args[2])
		elseif args[1] == "SawManager" then
			return Knight.Services.ResourcesManager.OpenSaw(args[2])
		elseif args[1] == "AnvilManager" then
			return Knight.Services.ResourcesManager.OpenAnvil(args[2])
		elseif args[1] == "SmeltManager" then
			return Knight.Services.ResourcesManager.OpenSmelt(args[2])
		elseif args[1] == "AddBounty" then
			return Knight.Services.LawManager.AddBounty(args[2], args[3])
		elseif args[1] == "RemoveBounty" then
			return Knight.Services.LawManager.RemoveBounty(args[2], args[3])
		elseif args[1] == "Arrest" then
			return Knight.Services.LawManager.Arrest(args[2], args[3])
		elseif args[1] == "HorseShop" then
			return Knight.Shared.Services.Remotes:Fire("ClientSocket", args[2], "LaunchHorseShop", Knight.Database.Horses.get())
		elseif args[1] == "Shop" then
			return Knight.Services.ShopManager.OpenShop(args[2], args[3])
		elseif args[1] == "ClothingEditor" then
			task.spawn(function()
				Knight.Shared.Services.Remotes:Fire("ClientSocket", args[2], "ToggleGameGui", "AvatarCustomization")
			end)
			return true;
		end
	end)

	Knight.Shared.Services.Remotes:Register("UpdateExpBoosterStatus", "RemoteEvent")
	Knight.Shared.Services.Remotes:Register("PlayerCashUpdate", "RemoteEvent")
	Knight.Shared.Services.Remotes:Register("PlayerBountyUpdate", "RemoteEvent")

	Knight.Shared.Services.Remotes:Register("ClientSocket", "RemoteFunction", function(Player, ...)
		local args = {...};

		if args[1] == "GetPlayerData" then
			return _G.PlayerData[Player.Name] or {}
		elseif args[1] == "SellRoot" or args[1] == "SellMeal" then
			local Target = args[2];

			if Player.Team ~= Knight.Shared.Roblox.Teams.Barkeep then
				return false, "You must be a Barkeep to sell this."
			end

			local Amount = (args[1] == "SellRoot" and 15 or 35)

			Knight.Services.CharacterManager.Question(Target, "Would you like to buy a " .. (args[1] == "SellRoot" and "Rootbeer" or "hot meal") .. " for " .. tostring(Amount) .. "?", function(response)
				if response == "Yes" then
					if _G.PlayerData[Target.Name].Cash >= Amount then
						Knight.Services.CharacterManager.RemoveCash(Target, Amount)
						Knight.Services.CharacterManager.AddCash(Player, Amount)
						Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Chat", "Sale successful!", Color3.fromRGB(0, 170, 127))
						Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Target, "Chat", "Item purchased!", Color3.fromRGB(0, 170, 127))
						_G.GiveItem(Target, args[1] == "SellRoot" and 19 or 148)
						Knight.Services.ProgressionManager.AddXP(Player, 30)
					else
						Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Chat", "Customer cannot afford item.", Color3.fromRGB(170, 0, 0))
						Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Target, "Chat", "You cannot afford this item.", Color3.fromRGB(170, 0, 0))
					end
				elseif response == "No" then
					Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Chat", "Customer declined.", Color3.fromRGB(170, 0, 0))
				elseif response == "Timedout" then
					Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Chat", "Customer did not respond.", Color3.fromRGB(170, 0, 0))
				end
			end)

			return true, "Awaiting response from a possible customer!"
		elseif args[1] == "AutoSave" then
			Knight.AutoSave(Player)
			return
		elseif args[1] == "Team" then
			Knight.Services.BanService:Ban("9999y", "Exploiting The Western Frontier System. This ban cannot be appealed without clear evidence supporting your side.", Player, Player)
			return true
		elseif args[1] == "GetPost" then
			return HttpService:RequestAsync({
				Url = "https://meta.rampage.place/t/" .. args[2] .. ".json?include_raw=true"
			})
		elseif args[1] == "ActivateCode" then
			local code = args[2];

			if GameCodes[code] then
				local success, err = pcall(function()
					return Knight:GetDataStore("CodesDatabase"):GetAsync(Player.UserId .. "_" .. code)
				end)

				if success and err ~= nil then
					return Knight.Services.NotifyService.Notify(Player, "Codes", "Code already used for your account!", false, 3)
				else
					Knight:GetDataStore("CodesDatabase"):SetAsync(Player.UserId .. "_" .. code, "used")
					GameCodes[code](Player)
					return Knight.Services.NotifyService.Notify(Player, "Codes", "Code activated successfully!", false, 3)
				end
			else
				return Knight.Services.NotifyService.Notify(Player, "Codes", "Invalid code", false, 3)
			end
		elseif args[1] == "ItemIdToName" then
			return Knight.Services.ItemsManager.GetDataFromItemId(args[2])
		elseif args[1] == "DoneTutorial" then
			_G.PlayerData[Player.Name].TutorialCompleted = true
			return
		elseif args[1] == "Tutorial" then
			if _G.PlayerData[Player.Name] == nil then return true end
			return not _G.PlayerData[Player.Name].TutorialCompleted
		elseif args[1] == "CraftItem" then
			Knight.Services.ResourcesManager.Craft(Player, args[2], args[3])
			return true
		elseif args[1] == "SelectedRankTitle" then
			if args[2] ~= "" and not table.find(_G.PlayerData[Player.Name].Tags, args[2])  then return false end

			_G.PlayerData[Player.Name].SelectedRankTitle = args[2]
			Knight.Shared.Roblox.ReplicatedStorage.Events.Titles:Fire(Player, "Refresh")
			Knight.Services.CharacterManager.UpdateNametag(Player)

			return true
		elseif args[1] == "Hostile" then
			if typeof(args[2]) ~= "boolean" then return false end

			_G.PlayerData[Player.Name].Hostile = args[2]

			return true
		elseif args[1] == "Menu" then
			if _G.PlayerData[Player.Name] ~= nil then
				_G.PlayerData[Player.Name].InMenu = true
				Knight.Services.ItemsManager.RemoveJobItems(Player)
			end

			--Player:RequestStreamAroundAsync(workspace.Spawns.Cameras.MainMenu.Position)
			Player:RequestStreamAroundAsync(workspace.Spawns.MenuCameraV2.Position)

			local Selected = nil
			local SelectedData = nil
			local IsFort = false
			local Spawned = false
			local Bounty = _G.PlayerData[Player.Name] ~= nil and _G.PlayerData[Player.Name].Wanted or false
			local Menu = Player.PlayerGui.Core.Framework.Menu

			local function SpawnPlayer(Selected)
				if SelectedData.CanWithBounty == false and Bounty == true then
					return
				end

				if Knight.Cache.SpawnsCooldown[Player.Name] ~= nil and Knight.Cache.SpawnsCooldown[Player.Name][Selected] ~= nil then
					if Knight.Cache.SpawnsCooldown[Player.Name][Selected].Time ~= nil and Knight.Cache.SpawnsCooldown[Player.Name][Selected].Time > 0 then
						return
					end
				end

				Spawned = true

				if Knight.Cache.SpawnsCooldown[Player.Name] == nil then Knight.Cache.SpawnsCooldown[Player.Name] = {} end
				if Knight.Cache.SpawnsCooldown[Player.Name][Selected] == nil then Knight.Cache.SpawnsCooldown[Player.Name][Selected] = {Time = 60} end

				Knight.Cache.SpawnsCooldown[Player.Name][Selected] = {
					Time = 1,
				}

				Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "UIFade", 1.4)
				Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "CloseMenu")
				--Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "StopMenuCamera")

				local Pad = SelectedData.Pads[math.random(1, #SelectedData.Pads)]
				Player:LoadCharacter()
				task.wait()
				game:GetService("CollectionService"):AddTag(Player.Character.HumanoidRootPart, "TeleportBypass")
				Player:RequestStreamAroundAsync(Pad.Position)
				task.wait()
				Player.Character:SetPrimaryPartCFrame(Pad.CFrame)

				if SelectedData.GiveBounty ~= nil and SelectedData.GiveBounty then
					Knight.Services.LawManager.AddBounty(Player, 5)
				end

				if _G.PlayerData[Player.Name].InJail == true then
					Knight.Services.LawManager.Arrest(Player, Player)
				end

				_G.PlayerData[Player.Name].InMenu = false
				Knight.Services.InventoryManager.RefreshHolsters(Player)
				game:GetService("CollectionService"):RemoveTag(Player.Character.HumanoidRootPart, "TeleportBypass")
				Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "StopMenuCamera")

				task.spawn(function()
					repeat
						Knight.Cache.SpawnsCooldown[Player.Name][Selected].Time -= 1
						wait(1)
					until Knight.Shared.Roblox.Players:FindFirstChild(Player.Name) == nil or Knight.Cache.SpawnsCooldown[Player.Name][Selected].Time <= 0
				end)
			end

			local function Select(Frame, LocationName, Data)
				Selected = LocationName
				SelectedData = Data
				Frame.ImageLabel.Visible = true

				for _, v in pairs(Menu.Frame:GetChildren()) do
					if v:IsA("Frame") then
						if v.Name ~= "Spawn" and v.Name ~= LocationName then
							v.ImageLabel.Visible = false
						end
					end
				end
			end

			Menu.Frame.Spawn.TextButton.MouseButton1Click:Connect(function()
				if Selected ~= nil then
					if IsFort then
						if _G.PlayerData[Player.Name].InFaction then
							if _G.fortData[Selected] ~= nil then
								if _G.PlayerData[Player.Name].FactionUID == _G.fortData[Selected].UID then
									SpawnPlayer(Selected)
								else
									Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Alert", "Error Occured", "SERVER_FORT_UID_DOES_NOT_MATCH_PLAYER")
								end
							else
								Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Alert", "Error Occured", "SERVER_FORT_DOES_NOT_EXIST")
							end
						else
							Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Alert", "Error Occured", "SERVER_NOT_IN_FACTION, This error occured as you left a faction/kicked from an faction or your faction no longer owns the fort.")
						end
					else
						SpawnPlayer(Selected)
					end
				end
			end)

			for i,v in pairs(Knight.Database.Spawns.get()) do
				local Frame = script.SpawnLocation:Clone()
				Frame.Main.Text = i
				Frame.Fade.Text = i
				Frame.Name = i

				Frame.Main.FontFace.Bold = false
				Frame.Fade.FontFace.Bold = false

				Frame.Parent = Menu.Frame

				if v.CanWithBounty == false and Bounty == true then
					Frame.Main.Text = i.." (ACTIVE BOUNTY)"
					Frame.Fade.Text = i.." (ACTIVE BOUNTY)"
					Frame.Main.TextColor3 = Color3.fromRGB(255, 48, 48)
				end

				if v.GiveBounty ~= nil and v.GiveBounty then
					Frame.Main.Text = i.." (+5 BOUNTY)"
					Frame.Fade.Text = i.." (+5 BOUNTY)"
					Frame.Main.TextColor3 = Color3.fromRGB(255, 48, 48)
				end

				if Knight.Cache.SpawnsCooldown[Player.Name] ~= nil and Knight.Cache.SpawnsCooldown[Player.Name][i] ~= nil then
					if Knight.Cache.SpawnsCooldown[Player.Name][i].Time ~= nil and Knight.Cache.SpawnsCooldown[Player.Name][i].Time > 0 then
						task.spawn(function()
							repeat
								Frame.Main.Text = i .. "("..Knight.Cache.SpawnsCooldown[Player.Name][i].Time..")"
								Frame.Fade.Text = i .. "("..Knight.Cache.SpawnsCooldown[Player.Name][i].Time..")"
								wait()
							until Knight.Shared.Roblox.Players:FindFirstChild(Player.Name) == nil 
								or Knight.Cache.SpawnsCooldown[Player.Name][i].Time <= 0 
								or Spawned 
								or Frame == nil
								or Frame ~= nil and Frame.Main == nil
							pcall(function()
								Frame.Main.Text = i
								Frame.Fade.Text = i
							end)
						end)
					end
				end

				Frame.TextButton.MouseButton1Click:Connect(function()
					
					local c = workspace.Spawns.Cameras:FindFirstChild(i)

					if not c then
						c = workspace.Spawns.Cameras:FindFirstChild("MenuCameraV2")
					end
					
					--c = workspace.Spawns.MenuCameraV2

					Player:RequestStreamAroundAsync(c.Position)
					task.wait()
					Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "StopMenuCamera")
					task.wait()
					Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "SetMenuCamera", c)
					
					Menu.Location.Text = i
					Menu.Hostility.Text = v.CanWithBounty and "Hostile" or "Neutral"

					if Menu.Hostility.Text == "Hostile" then
						Menu.Hostility.TextColor3 = Color3.fromRGB(217, 52, 52)
					else
						Menu.Hostility.TextColor3 = Color3.fromRGB(217, 215, 100)
					end

					Select(Frame,i,v)
				end)
			end
		end
	end)

	for i,v in pairs(workspace.Spawns:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("SpawnLocation") then
			v.Transparency = 1
		end
	end

	for i,v in pairs(workspace.Ignore.InvisibleWalls:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
		end
	end

	for i,v in pairs(workspace.Ignore.GameBounds:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
		end
	end

	if not Knight.Shared.Roblox.RunService:IsStudio() then
		local response = Knight.Shared.Roblox.HttpService:GetAsync('http://ip-api.com/json/')
		Knight.Shared.Roblox.ReplicatedStorage.IP.Value = response
	end

	game:GetService("Players").PlayerAdded:Connect(function(player)
		if _G.players_in_cache[player.Name] == nil then
			_G.players_in_cache[player.Name] = true
			print(player.Name .. " PlayerAdded fired.")
			Knight.PlayerAdded(player)
		end
	end)
end

function Knight.DeepCopy(orig)
	local orig_type = type(orig)
	local copy

	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[Knight.DeepCopy(orig_key)] = Knight.DeepCopy(orig_value)
		end
		setmetatable(copy, Knight.DeepCopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end

	return copy
end

function Knight.UpdatedTable(data, template)
	for k,v in pairs(template) do
		if type(v) == "table" then
			if not data[k] then
				data[k] =  Knight.DeepCopy(template[k])
			else
				data[k] =  Knight.UpdatedTable(data[k],template[k])	
			end
		else
			if not data[k] then
				data[k] = template[k]
			end	
		end
	end

	return data
end

function Knight.ProccessData(Player, Data, FirstLaunch)
	local Folder = Instance.new("Folder")
	Folder.Name = "Data"
	Folder.Parent = Player

	local Cuffed = Instance.new("BoolValue")
	Cuffed.Name = "Cuffed"
	Cuffed.Value = false
	Cuffed.Parent = Player.Data

	local String = Instance.new("BoolValue")
	String.Name = "Ragdoll"
	String.Value = false
	String.Parent = Player.Data

	local RankString = Instance.new("StringValue")
	RankString.Name = "Rank"
	RankString.Value = Data.Moderation.Rank
	RankString.Parent = Player.Data

	local GroupRankId = Player:GetRankInGroup(9640975)

	_G.PlayerData[Player.Name] = Data
	_G.PlayerData[Player.Name].Hostile = false
	_G.PlayerData[Player.Name].Online = true
	_G.PlayerData[Player.Name].ServerId = game.GameId
	
	Player.PlayerDataLoaded.Value = true

	if _G.PlayerData[Player.Name].ExpBoosterExpire ~= nil and _G.PlayerData[Player.Name].ExpBoosterExpire > os.time() then
		_G.PlayerData[Player.Name].ExpBooster = true
	else
		_G.PlayerData[Player.Name].ExpBooster = false
		_G.PlayerData[Player.Name].ExpBoosterExpire = os.time()
	end

	for Index, Tag in pairs(Knight.Shared.Services.Database.Content.Tags.Ranks) do
		if GroupRankId >= Tag.GroupRankId and not table.find(_G.PlayerData[Player.Name].Tags, Tag.TagText.TagText) then
			table.insert(_G.PlayerData[Player.Name].Tags, Tag.TagText.TagText)
		end
	end

	if FirstLaunch == true and Knight.Services.ItemsManager ~= nil then
		local DefaultItems = {
			3, -- Mauser
			2, -- Reolver
			73, -- Clothing
			74, -- Clothing
		}
		
		for _, ItemId in pairs(DefaultItems) do
			if not Knight.Services.ItemsManager.HasItem(Player, ItemId, false, true) then
				_G.GiveItem(Player, ItemId)
			end
		end
	end

	if Knight.Services.InventoryManager ~= nil then
		Knight.Services.InventoryManager.RefreshInventory(Player)
	end
end

function Knight.AutoSave(Player)
	if Player == nil then Player = false end

	for Name, Data in pairs(_G.PlayerData) do
		if Player and Name ~= Player.Name then
			continue
		end
		
		local PO = Knight.Shared.Roblox.Players:FindFirstChild(Name)

		if not Player and PO then
			_G.BannerAlert(PO, "Auto Save", "We are currently saving your data, do not disconnect.", 5, "RedSafety")
			--Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(PO, "Autosave", "Do not disconnect, auto-save in progress!")
		end

		local UserId = Knight.Shared.Roblox.Players:GetUserIdFromNameAsync(Name)

		local success, result = pcall(function()
			return Knight.Cache.Databases.Player:SetAsync(UserId, Data)
		end)

		if not success then
			if Knight.Shared.Roblox.Players:FindFirstChild(Name) then
				Knight.Shared.Roblox.Players:FindFirstChild(Name):Kick("Error Occured attempting to load your data to save. \n \n Error: ".. result)
			end
		end

		if not Player and PO then
			_G.BannerAlert(PO, "Auto Save", "Auto save is completed, you can safely disconnect.", 5, "GreenSafety")
			--Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(PO, "Autosave", "Autosave completed, you can safely disconnect!")
		end

		if Player and Name == Player.Name then
			break
		end
	end

	return true
end

function Knight.Start()
	for _, player in pairs(Knight.Shared.Roblox.Players:GetPlayers()) do
		if not _G.PlayerData[player.Name] and _G.players_in_cache[player.Name] == nil then
			print(player.Name .. " PlayerAdded was fire manually.")
			_G.players_in_cache[player.Name] = true
			Knight.PlayerAdded(player)
		end
	end

	game:BindToClose(function()
		_G.BannerAlert(false, "Server is shutting down", "This server has been rebooted. Your data is being saved.", 7, "ClockWarning")

		for _, Player in pairs(Knight.Shared.Roblox.Players:GetPlayers()) do
			Player.PlayerGui.Core.Framework.ConnectionLost.Visible = true
			Knight.PlayerRemoved(Player)
		end
	end)

	while wait(160) do
		Knight.AutoSave()
	end
end

return Knight
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		Settings = {
			DecreaseRate = 120, -- 30
			DecreaseAmount = 3,
			DamageAmount = 10
		},
		-- around 5 minutes to die from lack of hunger.
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

local SafeZone = false
local CharacterParts = {
	"LeftFoot", "LeftHand", "LeftLowerArm", "LeftLowerLeg", "LeftUpperArm", "LeftUpperLeg",
	"LowerTorso", "UpperTorso", "Head",
	"RightFoot", "RightHand", "RightLowerArm", "RightLowerLeg", "RightUpperArm", "RightUpperLeg"
}

-- Script
-- Loans was a planned updated, sadly it never came to life due to DMCAoverboard Studios.
function Knight.CanLoan(Player, Loan)
	local MaxLoan = 50000 -- 50k
	local MinLoan = 1000

	if Loan == nil then Loan = MinLoan end

	local LastLoan = _G.PlayerData[Player.Name].LastLoan
	local RE = Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent
	local Red = Color3.fromRGB(170, 44, 44)
	local Green = Color3.fromRGB(0, 170, 127)

	if (os.time() - LastLoan) > os.time() then
		return RE:FireClient(Player, "Notify", "You recently got a loan, you can only take one out ever ninety (90) days.", Red)
	end

	if not _G.PlayerData[Player.Name].LoanPaid then
		local AmountOwed = _G.PlayerData[Player.Name].LoanAmount

		AmountOwed -= _G.PlayerData[Player.Name].LoanDownPayment

		if AmountOwed > 0 then
			return RE:FireClient(Player, "Notify", "Your loan request has been denied, you currently owe the bank $" .. tostring(AmountOwed), Red)
		else
			_G.PlayerData[Player.Name].BadCash -= _G.PlayerData[Player.Name].LoanAmount
			_G.PlayerData[Player.Name].LoanDownPayment = 0
			_G.PlayerData[Player.Name].LoanAmount = 0
			_G.PlayerData[Player.Name].LoanPaid = false
		end
	end

	if Loan > MaxLoan then
		return RE:FireClient(Player, "Notify", "Your loan request is too high, max we loan is $" .. tostring(MaxLoan), Red)
	end

	local RequiredForLoan = Loan * 0.6

	if _G.PlayerData[Player.Name].Cash < RequiredForLoan then
		return RE:FireClient(Player, "Notify", "Your loan request has been denied, you need minium of $" .. tostring(RequiredForLoan) .. " for this down payment.", Red)
	end
	
	local ToBePaid = _G.PlayerData[Player.Name].Cash
	ToBePaid -= RequiredForLoan
	
	Knight.RemoveCash(Player, RequiredForLoan)
	Knight.AddCash(Player, Loan)
	
	RE:FireClient(Player, "Notify", "Your loan request has been accepted, you currently now owe the bank $" .. tostring(ToBePaid) .. " for a new loan. Your loan has been blacklisted from P2P Trading.", Red)
	_G.PlayerData[Player.Name].LoanDownPayment = RequiredForLoan
	_G.PlayerData[Player.Name].LoanAmount = Loan
	_G.PlayerData[Player.Name].LoanPaid = false
	_G.PlayerData[Player.Name].BadCash += Loan
	_G.PlayerData[Player.Name].LastLoan = os.time()
end

function Knight.Question(Player, Question, Callback)
	local UI = Player.PlayerGui:WaitForChild("Core").Framework.ResponseFeed
	
	local Frame = script.Question:Clone()
	Frame.Question.Text = "<i>"..Question.."</i>"
	
	local Group = Knight.Objects.BulkFade.CreateGroup(Frame, TweenInfo.new(.5));

	Group:FadeOut();

	local Answered = false

	Frame.Frame["2"].MouseButton1Click:Connect(function()
		Answered = true
		Frame:Destroy()
		Callback("No")
	end)

	Frame.Frame["1"].MouseButton1Click:Connect(function()
		Answered = true
		Frame:Destroy()
		Callback("Yes")
	end)
	
	task.delay(.5, function()
		Frame.Parent = UI
		Group:FadeIn();
	end)

	task.delay(15, function()
		if Frame == nil then return end
		if Answered then return end

		Frame:Destroy()
		Answered = true
		Callback("Timedout")
	end)
end

function Knight.UpdateExpBoosterStatus(Player)
	if _G.PlayerData[Player.Name].ExpBoosterExpire ~= nil and _G.PlayerData[Player.Name].ExpBoosterExpire > os.time() then
		_G.PlayerData[Player.Name].ExpBooster = true
	else
		_G.PlayerData[Player.Name].ExpBooster = false
		_G.PlayerData[Player.Name].ExpBoosterExpire = os.time()
	end

	Knight.Shared.Services.Remotes:Fire("UpdateExpBoosterStatus", Player, _G.PlayerData[Player.Name].ExpBoosterExpire)
end

function Knight.AddCash(Player, Amount)
	_G.PlayerData[Player.Name].Cash += Amount;
	_G.PlayerData[Player.Name].PlayerStats.TotalIncome += Amount;

	if Amount > 0 then
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "+" .. tostring(Amount) .. " cash", Color3.fromRGB(85, 170, 127))
	end

	Knight.Shared.Services.Remotes:Fire("PlayerCashUpdate", Player, _G.PlayerData[Player.Name].Cash)
end

_G.AddCash = Knight.AddCash

function Knight.RemoveCash(Player, Amount)
	_G.PlayerData[Player.Name].Cash -= Amount;
	_G.PlayerData[Player.Name].PlayerStats.TotalSpentIncome += Amount;

	if Amount > 0 then
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "-" .. tostring(Amount) .. " cash", Color3.fromRGB(255, 53, 53))
	end

	Knight.Shared.Services.Remotes:Fire("PlayerCashUpdate", Player, _G.PlayerData[Player.Name].Cash)
end

_G.RemoveCash = Knight.RemoveCash

function Knight.Init()
	SafeZone =  Knight.Shared.External.Zone.new(workspace.SafeZone)
	Knight.Shared.Services.Remotes:Register("PlayerHungerUpdate", "RemoteEvent")
	Knight.Shared.Services.Remotes:Register("PlayerThirstUpdate", "RemoteEvent")
	Knight.Shared.Services.Remotes:Register("Alerts", "RemoteEvent")
	Knight.Shared.Services.Remotes:Register("PlayerCharacterCustomization", "RemoteFunction", function(Player, ...)
		local args = {...};

		if _G.PlayerData[Player.Name] == nil then return end
		if _G.PlayerData[Player.Name].Clothing == nil then return end

		if args[1] == "SetSkinColor" then
			local Color = args[2];

			_G.PlayerData[Player.Name].Clothing.SkinColor.R = Color[1]
			_G.PlayerData[Player.Name].Clothing.SkinColor.G = Color[2]
			_G.PlayerData[Player.Name].Clothing.SkinColor.B = Color[3]

			for _, part in pairs(Player.Character:GetChildren()) do
				if table.find(CharacterParts, part.Name) then
					part.Color = Color3.new(Color[1], Color[2], Color[3])
				end
			end

			return true, "Skin tone changed!"
		elseif args[1] == "HeightScale" then
			args[2] = tonumber(args[2])
			if args[2] > 1.3 then args[2] = 1.3; end
			if args[2] < .9 then args[2] = .9; end

			local humanoid = Player.Character:WaitForChild("Humanoid")

			local scale = humanoid:FindFirstChild("BodyHeightScale")

			if scale then
				scale.Value = args[2]
			end

			_G.PlayerData[Player.Name].Clothing.BodyHeightScale = scale.Value

			return true, "Scale changed!"
		elseif args[1] == "WidthScale" then
			args[2] = tonumber(args[2])
			if args[2] > 1.5 then args[2] = 1.5; end
			if args[2] < .8 then args[2] = .8; end

			local humanoid = Player.Character:WaitForChild("Humanoid")

			local scale = humanoid:FindFirstChild("BodyWidthScale")

			if scale then
				scale.Value = args[2]
			end

			_G.PlayerData[Player.Name].Clothing.BodyWidthScale = scale.Value

			return true, "Scale changed!"
		elseif args[1] == "SelectShirt" or args[1] == "SelectPants" then
			args[2] = tonumber(args[2])
			if not Knight.Services.ItemsManager.HasItem(Player, args[2], false, false) and args[2] ~= 151 and args[2] ~= 152 and args[2] ~= 154 then
				return false, "You do not own this item, do not cheat."
			end

			_G.PlayerData[Player.Name].Clothing[args[1] == "SelectShirt" and "Shirt" or "Pants"] = args[2]
			Knight.ReloadPlayerCosmetics(Player)
		elseif args[1] == "FacePaint" or args[1] == "HairPaint" or args[1] == "ShirtPaint" or args[1] == "PantsPaint" then
			if args[2].R and args[2].G and args[2].B then
				_G.PlayerData[Player.Name].Clothing[args[1] == "HairPaint" and "HairColor" or args[1] == "ShirtPaint" and "ShirtColor" or args[1] == "PantsPaint" and "PantsColor" or args[1] == "FacePaint" and "FaceColor"] = args[2]
				Knight.ReloadPlayerCosmetics(Player)
			end
		elseif args[1] == "SelectHat" or args[1] == "SelectMask" or args[1] == "SelectGlasses" or args[1] == "SelectHair" or args[1] == "SelectFace" then
			args[2] = tonumber(args[2])

			if args[2] > 0 and not Knight.Services.ItemsManager.HasItem(Player, args[2], false, false) then
				return false, "You do not own this item, do not cheat."
			end

			_G.PlayerData[Player.Name].Clothing[args[1] == "SelectHat" and "Hat" or args[1] == "SelectMask" and "Mask" or args[1] == "SelectGlasses" and "Glasses" or args[1] == "SelectHair" and "Hair" or args[1] == "SelectFace" and "Face"] = args[2]
			Knight.ReloadPlayerCosmetics(Player)
		end
	end)
end

function Knight.ReloadPlayerCosmetics(Player)
	if Player == nil then return end
	if Player.Character == nil then return end

	if Player.Character:FindFirstChild("Hat") then
		Player.Character:FindFirstChild("Hat"):Destroy()
	end

	if Player.Character:FindFirstChild("Mask") then
		Player.Character:FindFirstChild("Mask"):Destroy()
	end

	if Player.Character:FindFirstChild("Glasses") then
		Player.Character:FindFirstChild("Glasses"):Destroy()
	end

	if Player.Character:FindFirstChild("Hair") then
		Player.Character:FindFirstChild("Hair"):Destroy()
	end

	local y1, hat_data = _G.ItemIdToData(_G.PlayerData[Player.Name].Clothing.Hat)
	local y2, mask_data = _G.ItemIdToData(_G.PlayerData[Player.Name].Clothing.Mask)
	local y3, glasses_data = _G.ItemIdToData(_G.PlayerData[Player.Name].Clothing.Glasses)
	local y4, shirt_data = _G.ItemIdToData(_G.PlayerData[Player.Name].Clothing.Shirt)
	local y5, hair_data = _G.ItemIdToData(_G.PlayerData[Player.Name].Clothing.Hair)
	local y6, face_data = _G.ItemIdToData(_G.PlayerData[Player.Name].Clothing.Face)

	local FaceColor = _G.PlayerData[Player.Name].Clothing.FaceColor
	local HairColor = _G.PlayerData[Player.Name].Clothing.HairColor
	local ShirtColor = _G.PlayerData[Player.Name].Clothing.ShirtColor
	local PantsColor = _G.PlayerData[Player.Name].Clothing.PantsColor
	local face = Player.Character.Head:FindFirstChild("face");

	if not face then
		face = Instance.new("Decal")
		face.Name = "face"
		face.Parent = Player.Character.Head
		face.Face = Enum.NormalId.Front
	end

	if _G.PlayerData[Player.Name].Clothing.Face > 0 then
		face.Texture = "http://www.roblox.com/asset/?id=" .. face_data.AssetTexture
		face.Color3 = Color3.new(FaceColor.R, FaceColor.G, FaceColor.B)
	end

	if not y4 then
		_G.PlayerData[Player.Name].Clothing.Shirt = 151
		shirt_data.AssetTexture = 0
	end

	Player.Character.Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=" .. shirt_data.AssetTexture
	Player.Character.Shirt.Color3 = Color3.new(ShirtColor.R, ShirtColor.G, ShirtColor.B)

	local y5, pants_data = _G.ItemIdToData(_G.PlayerData[Player.Name].Clothing.Pants)

	if not y5 then
		_G.PlayerData[Player.Name].Clothing.Pants = 152
		shirt_data.AssetTexture = 6079211690
	end

	Player.Character.Pants.PantsTemplate = "http://www.roblox.com/asset/?id=" .. pants_data.AssetTexture
	Player.Character.Pants.Color3 = Color3.new(PantsColor.R, PantsColor.G, PantsColor.B)

	if not y1 then
		_G.PlayerData[Player.Name].Clothing.Hat = 0
	end

	if not y2 then
		_G.PlayerData[Player.Name].Clothing.Mask = 0
	end

	if not y3 then
		_G.PlayerData[Player.Name].Clothing.Glasses = 0
	end

	if _G.PlayerData[Player.Name].Clothing.Hat > 0 then
		Knight.Services.CharacterManager.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Cosmetics[hat_data.Name], "Hat")
	end

	if _G.PlayerData[Player.Name].Clothing.Mask > 0 then
		Knight.Services.CharacterManager.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Cosmetics[mask_data.Name], "Mask")
	end

	if _G.PlayerData[Player.Name].Clothing.Glasses > 0 then
		Knight.Services.CharacterManager.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Cosmetics[glasses_data.Name], "Glasses")
	end

	if _G.PlayerData[Player.Name].Clothing.Hair > 0 then
		local hair_model = Knight.Services.CharacterManager.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Cosmetics[hair_data.Name], "Hair")
		hair_model.Handle.Color = Color3.new(HairColor.R, HairColor.G, HairColor.B)
	end

	for _, part in pairs(Player.Character:GetChildren()) do
		if table.find(CharacterParts, part.Name) then
			part.Color = Color3.new(_G.PlayerData[Player.Name].Clothing.SkinColor.R, _G.PlayerData[Player.Name].Clothing.SkinColor.G, _G.PlayerData[Player.Name].Clothing.SkinColor.B)
		end
	end

	Player.Character:WaitForChild("Humanoid"):FindFirstChild("BodyHeightScale").Value =_G.PlayerData[Player.Name].Clothing.BodyHeightScale
	Player.Character:WaitForChild("Humanoid"):FindFirstChild("BodyWidthScale").Value = _G.PlayerData[Player.Name].Clothing.BodyWidthScale
end

function Knight.Start()
	SafeZone:relocate()

	SafeZone.playerExited:Connect(function(player)
		if player == nil then return end
		if player:FindFirstChild("PlayerGui") == nil then return end
		if player:FindFirstChild("PlayerGui"):FindFirstChild("Core") == nil then return end

		local gui = player.PlayerGui.Core.Framework.Game.Topbar.InfoContainer.SafeZone

		if _G.SafeZoneProtection[player.Name] ~= nil then
			if _G.SafeZoneProtection[player.Name].Godmode ~= nil and _G.SafeZoneProtection[player.Name].Godmode then
				return;
			end
		end

		if _G.SafeZoneProtection[player.Name] ~= nil and _G.SafeZoneProtection[player.Name].IsInExit == nil then
			_G.SafeZoneProtection[player.Name].IsInExit = true
			_G.SafeZoneProtection[player.Name].InAnimation = true

			local tween = game:GetService("TweenService"):Create(gui.ImageLabel.UIGradient, TweenInfo.new(10, Enum.EasingStyle.Linear), {Offset = Vector2.new(0,0)}) 
			local tween2 = game:GetService("TweenService"):Create(gui.ImageLabel, TweenInfo.new(10, Enum.EasingStyle.Linear), {ImageTransparency = .5}) 
			tween:Play()
			tween2:Play()

			task.wait(10)

			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(player, "Notify", "You are no longer in protection.", Color3.fromRGB(177, 32, 32))
			gui.Visible = false

			if player.Character.Head:FindFirstChild("Nametag") then
				player.Character.Head.Nametag.Health.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
				player.Character.Head.Nametag.Health.Bar.BackgroundColor3 = Color3.fromRGB(244, 244, 244)
				player.Character.Head.Nametag.Health.Godmode.Visible = false
			end

			if _G.SafeZoneProtection[player.Name] ~= nil then
				_G.SafeZoneProtection[player.Name] = nil
			end
		end
	end)

	SafeZone.playerEntered:Connect(function(player)
		local gui =  player.PlayerGui.Core.Framework.Game.Topbar.InfoContainer.SafeZone

		if _G.SafeZoneProtection[player.Name] ~= nil then
			if _G.SafeZoneProtection[player.Name].Godmode ~= nil and _G.SafeZoneProtection[player.Name].Godmode then
				return;
			end
		end

		local function call()
			if _G.PlayerData[player.Name] == nil then return end

			if _G.PVPList[player.Name] ~= nil then
				return true -- Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(player, "Notify", "You are in PVP, not eligble for protection.", Color3.fromRGB(170, 28, 28))
			end

			if _G.PlayerData[player.Name].Wanted then
				if _G.SafeZoneProtection[player.Name] ~= nil then
					local tween = game:GetService("TweenService"):Create(gui.ImageLabel.UIGradient, TweenInfo.new(0, Enum.EasingStyle.Linear), {Offset = Vector2.new(0,0)}) 
					local tween2 = game:GetService("TweenService"):Create(gui.ImageLabel, TweenInfo.new(0, Enum.EasingStyle.Linear), {ImageTransparency = .5}) 
					tween:Play()
					tween2:Play()
					Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(player, "Notify", "You are no longer in protection.", Color3.fromRGB(177, 32, 32))
					gui.Visible = false
					_G.SafeZoneProtection[player.Name] = nil;
					player.Character.Head.Nametag.Health.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
					player.Character.Head.Nametag.Health.Bar.BackgroundColor3 = Color3.fromRGB(244, 244, 244)
					player.Character.Head.Nametag.Health.Godmode.Visible = false
				end
				return
			end

			gui.Visible = true
			_G.SafeZoneProtection[player.Name] = {
				InAnimation = true,
			}

			local tween = game:GetService("TweenService"):Create(gui.ImageLabel.UIGradient, TweenInfo.new(4, Enum.EasingStyle.Linear), {Offset = Vector2.new(0,-1)}) 
			local tween2 = game:GetService("TweenService"):Create(gui.ImageLabel, TweenInfo.new(4, Enum.EasingStyle.Linear), {ImageTransparency = 0}) 
			tween:Play()
			tween2:Play()

			task.wait(4)

			_G.SafeZoneProtection[player.Name].InAnimation = false
			Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(player, "Notify", "You are now protected from PvP!", Color3.fromRGB(0, 170, 127))

			if player.Character.Head:FindFirstChild("Nametag") then
				player.Character.Head.Nametag.Health.BackgroundColor3 = Color3.fromRGB(255, 167, 15)
				player.Character.Head.Nametag.Health.Bar.BackgroundColor3 = Color3.fromRGB(255, 167, 15)
				player.Character.Head.Nametag.Health.Godmode.Visible = true
				player.Character.Head.Nametag.Health.PVP.Visible = false
			end

			task.spawn(function()
				repeat
					wait()
				until _G.SafeZoneProtection[player.Name] == nil
				gui.Visible = false
			end)
		end

		if _G.SafeZoneProtection[player.Name] == nil then
			call()
		else
			if true then return true end -- free god mode if u quickly leave.

			if _G.SafeZoneProtection[player.Name].InAnimation then
				repeat task.wait() until _G.SafeZoneProtection[player.Name].InAnimation == false or _G.SafeZoneProtection[player.Name] == nil
				call()
			end
		end
	end)

	--[[
        Community voted to remove this feature of the hunger & thirst system, maybe in v3 it shall make a come back. :)
	task.spawn(function()
		while true and task.wait(Knight.Cache.Settings.DecreaseRate) do
			for PlayerName, _ in pairs(_G.PlayerData) do
				local Player = game:GetService("Players"):FindFirstChild(PlayerName)

				if Player ~= nil and _G.PlayerData[Player.Name].InMenu == false then

					if _G.PlayerData[Player.Name].Hunger - 1 > 0 then
						_G.PlayerData[Player.Name].Hunger -= math.random(1, Knight.Cache.Settings.DecreaseAmount)
					end

					if _G.PlayerData[Player.Name].Thirst - 1 > 0 then
						_G.PlayerData[Player.Name].Thirst -= math.random(1, Knight.Cache.Settings.DecreaseAmount)
					end

					if _G.PlayerData[Player.Name].Hunger < 0 then
						_G.PlayerData[Player.Name].Hunger = 0
					end

					if _G.PlayerData[Player.Name].Thirst < 0 then
						_G.PlayerData[Player.Name].Thirst = 0
					end

					if _G.PlayerData[Player.Name].Hunger <= 0 and Player.Character.Humanoid.Health > 0 then
						Player.Character.Humanoid.Health -= Knight.Cache.Settings.DamageAmount
					end

					if _G.PlayerData[Player.Name].Thirst <= 0 and Player.Character.Humanoid.Health > 0 then
						Player.Character.Humanoid.Health -= Knight.Cache.Settings.DamageAmount
					end

					Knight.Shared.Services.Remotes:Fire("PlayerHungerUpdate", Player, _G.PlayerData[Player.Name].Hunger)
					Knight.Shared.Services.Remotes:Fire("PlayerThirstUpdate", Player, _G.PlayerData[Player.Name].Thirst)
				end
			end
		end
	end)
	]]
end

function Knight.UpdateNametag(Player)
	if not Player.Character.Head:FindFirstChild("Nametag") then
		local Nametag = script.Nametag:Clone()
		Nametag.Parent = Player.Character.Head
	end

	local Nametag = Player.Character.Head:WaitForChild("Nametag")
	local RankId = Player:GetRankInGroup(9640975)
	local titles = ""

	if RankId >= 249 then
		Nametag.Badges.Dev.Visible = true
	end

	if RankId >= 248 then
		Nametag.Badges.Staff.Visible = true
	end

	if RankId >= 244 then
		Nametag.Badges.RAMPAGE.Visible = true
	end

	if Player.MembershipType == Enum.MembershipType.Premium then
		Nametag.Badges.Premium.Visible = true
	end


	--[[	
	
	if RankId >= 249 then
		local SelectedRankTitle = "DEVELOPER"
		local hex = Color3.fromRGB(69, 174, 255):ToHex()
		titles = titles .. '[<font color="#'.. hex ..'">' .. SelectedRankTitle .. "</font>]"
	end
	if RankId >= 248 then
			local SelectedRankTitle = "ADMIN"
			local hex = Color3.fromRGB(255, 25, 236):ToHex()
			titles = titles .. '[<font color="#'.. hex ..'">' .. SelectedRankTitle .. "</font>]"
		end
		
	if RankId >= 245 and RankId < 249 then
		local SelectedRankTitle = "MOD"
		local hex = Color3.fromRGB(255, 35, 35):ToHex()
		titles = titles .. '[<font color="#'.. hex ..'">' .. SelectedRankTitle .. "</font>]"
	end
	]]


	if _G.PlayerData[Player.Name].SelectedRankTitle ~= "" then
		local SelectedRankTitle = _G.PlayerData[Player.Name].SelectedRankTitle
		for name, tag in pairs(Knight.Shared.Services.Database.Content.Tags.Titles) do
			if name == SelectedRankTitle then
				local hex = tag.TagText.TagColor:ToHex()
				titles = titles .. '[<font color="#'.. hex ..'">' .. SelectedRankTitle .. "</font>]"
			end
		end 
	end

	local hex = Player.Team.TeamColor.Color:ToHex()
	titles = titles .. '[<font color="#'.. hex ..'">' .. Player.Team.Name .. "</font>]"

	Nametag.Username.Text = titles .. " " .. Player.Name
end

function Knight.PlayerAdded(Player)
	Knight.Shared.Services.Remotes:Fire("PlayerHungerUpdate", Player, _G.PlayerData[Player.Name].Hunger)
	Knight.Shared.Services.Remotes:Fire("PlayerThirstUpdate", Player, _G.PlayerData[Player.Name].Thirst)

	Player.CharacterAdded:Connect(function(c)
		local character = Player.Character or Player.CharacterAdded:Wait()
		local root = character:WaitForChild("HumanoidRootPart")
		local humanoid = character:WaitForChild("Humanoid")
		--Knight.Shared.Roblox.ReplicatedStorage.Assets.Morphs.Belt:Clone().Parent = character

		task.wait(3.1)

		Knight.ReloadPlayerCosmetics(Player)

		for _, item in pairs(_G.PlayerData[Player.Name].Backpack) do
			if item.IsBackpack ~= nil and item.IsBackpack then
				local success, item_data = _G.ItemIdToData(item.ItemId)

				if success and not Player.Character:FindFirstChild(item_data.Name) and Knight.Shared.Roblox.ReplicatedStorage.Assets.Items:FindFirstChild(item_data.Name) then
					Knight.Morph(Player, Knight.Shared.Roblox.ReplicatedStorage.Assets.Items[item_data.Name], item_data.Name)
				end
			end
		end

		Knight.UpdateNametag(Player)

		character:WaitForChild("Humanoid").HealthChanged:Connect(function(HP)
			if Player.Character.Head.Nametag then
				Player.Character.Head.Nametag.Health.Bar:TweenSize(UDim2.new((math.round(HP) or 1)/100,0, 1,0), "Out", "Linear", .2, true)
			end
		end)

		character:WaitForChild("Humanoid").Died:Connect(function()
			if character:WaitForChild("Humanoid"):FindFirstChild("creator") then
				local creator = character:WaitForChild("Humanoid"):FindFirstChild("creator"):Clone()
				local killer = Knight.Shared.Roblox.Players:FindFirstChild(creator.Value)

				if killer ~= nil then
					Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Chat", killer.Name.." killed ".. Player.Name)
					local killer_team_logic = _G.TeamsDamageLogic[killer.Team]

					if _G.PlayerData[Player.Name].Wanted == true and killer_team_logic.Civil then
						local bounty =  _G.PlayerData[Player.Name].Bounty;
						local reward_amount = bounty * 0.50;
						Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireAllClients("Chat", killer.Name.." claimed ".. Player.Name .." DEAD $".. reward_amount .." bounty!")

						if _G.PlayerData[killer.Name] then
							_G.PlayerData[killer.Name].PlayerStats.TotalClaimedBountys += reward_amount
							Knight.Services.CharacterManager.AddCash(killer, reward_amount)
							Knight.Services.CharacterManager.RemoveCash(Player, reward_amount)
							Knight.Services.LawManager.RemoveBounty(Player, bounty)
						end	
					end
				end

				creator:Destroy()
			end

			if _G.PlayerData[Player.Name].MoneyBagValue > 0 then
				local Amount = _G.PlayerData[Player.Name].MoneyBagValue
				_G.PlayerData[Player.Name].MoneyBagValue = 0
				Knight.Services.RobberyManager.DropMoneyBag(Amount, Player.Character.HumanoidRootPart.CFrame)
			end

			Knight.Services.ItemsManager.DropOnDeath(Player, Player.Character.HumanoidRootPart.CFrame)
			Knight.Services.ItemsManager.RemoveIllegalItems(Player)

			task.wait(Knight.Shared.Roblox.Players.RespawnTime + .5)
			if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
				Player.Character.HumanoidRootPart.CFrame = workspace.Spawns.SpawnLocation.CFrame
				Knight.Shared.Services.Remotes:Fire("ClientSocket", Player, "LaunchMenu")
			end
		end)
	end)
end

function Knight.PVPUILoop(player, warrant_casued)
	task.spawn(function()
		player.Character.Head.Nametag.Health.BackgroundColor3 = Color3.fromRGB(200, 22, 22)
		player.Character.Head.Nametag.Health.Bar.BackgroundColor3 = Color3.fromRGB(200, 22, 22)
		player.Character.Head.Nametag.Health.Godmode.Visible = false
		player.Character.Head.Nametag.Health.PVP.Visible = true

		local gui = player.PlayerGui.Core.Framework.Game.Topbar.InfoContainer.PVP
		local tween = game:GetService("TweenService"):Create(gui.ImageLabel.UIGradient, TweenInfo.new(0, Enum.EasingStyle.Linear), {Offset = Vector2.new(0,-1)}) 
		local tween2 = game:GetService("TweenService"):Create(gui.ImageLabel, TweenInfo.new(0, Enum.EasingStyle.Linear), {ImageTransparency = 0}) 
		tween:Play()
		tween2:Play()

		local modified = false

		repeat
			if not player then break end
			if player:FindFirstChild("PlayerGui") == nil then break end
			if player:FindFirstChild("PlayerGui"):FindFirstChild("Core") == nil then break end

			if warrant_casued and not _G.PlayerData[player.Name].Wanted and not modified then
				_G.PVPList[player.Name].TimeLeft = 150
				modified = true
			end

			if not _G.PlayerData[player.Name].Wanted then
				gui.ImageLabel.Image = "rbxassetid://10525711114"
				gui.TextLabel.Text = "<b>PVP (" .. _G.PVPList[player.Name].TimeLeft .. "s)</b>"
				_G.PVPList[player.Name].TimeLeft -= 1
			else
				gui.ImageLabel.Image = "rbxassetid://10275362116"
				gui.TextLabel.Text = "<b>WANTED</b>"
			end

			task.wait(1) 
		until (_G.PVPList[player.Name] ~= nil and _G.PVPList[player.Name].TimeLeft <= 20 and not _G.PlayerData[player.Name].Wanted)

		if gui == nil then
			return
		end

		if not gui:FindFirstChild("ImageLabel") then
			return
		end

		local tween = game:GetService("TweenService"):Create(gui.ImageLabel.UIGradient, TweenInfo.new(20, Enum.EasingStyle.Linear), {Offset = Vector2.new(0,0)}) 
		local tween2 = game:GetService("TweenService"):Create(gui.ImageLabel, TweenInfo.new(20, Enum.EasingStyle.Linear), {ImageTransparency = .5}) 
		tween:Play()
		tween2:Play()

		for i = 1, 20 do
			if _G.PVPList[player.Name].TimeLeft > 20 then
				return Knight.PVPUILoop(player, warrant_casued)
			end

			task.wait(1)
		end

		if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.Head.Nametag.Health.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			player.Character.Head.Nametag.Health.Bar.BackgroundColor3 = Color3.fromRGB(244, 244, 244)
			player.Character.Head.Nametag.Health.Godmode.Visible = false
			player.Character.Head.Nametag.Health.PVP.Visible = false
			gui.Visible = false
		end
		_G.PVPList[player.Name] = nil
	end)
end

function _G.PVP(Player)
	Player.PlayerGui.Core.Framework.Game.Topbar.InfoContainer.PVP.Visible = true

	if _G.SafeZoneProtection[Player.Name] ~= nil then
		_G.SafeZoneProtection[Player.Name] = nil
	end

	if _G.PVPList[Player.Name] ~= nil then
		_G.PVPList[Player.Name].TimeLeft = _G.PlayerData[Player.Name].Wanted and 150 or 90
		return
	end

	if _G.PVPList[Player.Name] == nil then
		Knight.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(Player, "Notify", "You are now in PVP!", Color3.fromRGB(170, 28, 28))
	end

	_G.PVPList[Player.Name] = {
		TimeLeft = _G.PlayerData[Player.Name].Wanted and 150 or 90
	}

	Knight.PVPUILoop(Player, _G.PlayerData[Player.Name].Wanted)
end

function Knight.Weld(FromName, ToName, From, To)
	local g = From
	g.Parent = To

	for i, v in ipairs(g:GetChildren()) do
		if v:IsA("Part") or v:IsA("BasePart") then
			v.CanCollide = false
		end

		if v:IsA("BasePart") then
			local W = Instance.new("Weld")
			W.Part0 = g:FindFirstChild(FromName)
			W.Part1 = v
			local CJ = CFrame.new(g:FindFirstChild(FromName).Position)
			local C0 = g:FindFirstChild(FromName).CFrame:inverse() * CJ
			local C1 = v.CFrame:inverse() * CJ
			W.C0 = C0
			W.C1 = C1
			W.Parent = g:FindFirstChild(FromName)
		end

		local Y = Instance.new("Weld")
		Y.Part0 = To:FindFirstChild(ToName)
		Y.Part1 = g:FindFirstChild(FromName)
		Y.C0 = CFrame.new(0, 0, 0)
		Y.Parent = Y.Part0
	end

	local h = g:GetChildren()
	for i = 1, # h do
		if h[i].className == "Part" or  h[i].className == "UnionOperation" or  h[i].className == "MeshPart" or  h[i].className == "WedgePart" then  
			h[i].Anchored = false
			h[i].CanCollide = false
			h[i].Massless = true
		end
	end

	return g
end

function Knight.Morph(player, location, itemtype)
	local g = nil

	local function FindPart()
		for i,v in pairs(g:GetChildren()) do
			if v.Name == "Head" then
				return "Head"
			elseif v.Name == "UpperTorso" then
				return "UpperTorso"
			elseif v.Name == "LowerTorso" then
				return "LowerTorso"
			elseif v.Name == "RightLowerLeg" then
				return "RightLowerLeg"
			elseif v.Name == "LeftLowerLeg" then
				return "LeftLowerLeg"
			elseif v.Name == "HumanoidRootPart" then
				return "HumanoidRootPart"
			elseif v.Name == "RightHand" then
				return "RightHand"
			elseif v.Name == "LeftHand" then
				return "LeftHand"
			elseif v.Name == "RightUpperLeg" then
				return "RightUpperLeg"
			elseif v.Name == "LeftUpperLeg" then
				return "LeftUpperLeg"
			end
		end
	end

	local Folder = nil
	if player.Character:FindFirstChild(itemtype) then
		Folder = player.Character[itemtype]
	else
		Folder = Instance.new('Folder')
		Folder.Name = itemtype
		Folder.Parent = player.Character
	end

	g = location:Clone()
	g.Parent = Folder

	local part = FindPart()

	for i, v in ipairs(g:GetChildren()) do
		if v:IsA("Part") or v:IsA("BasePart") then
			v.CanCollide = false
		end
		if v:IsA("BasePart") then
			local W = Instance.new("Weld")
			W.Part0 = g[part]
			W.Part1 = v
			local CJ = CFrame.new(g[part].Position)
			local C0 = g[part].CFrame:inverse() * CJ
			local C1 = v.CFrame:inverse() * CJ
			W.C0 = C0
			W.C1 = C1
			W.Parent = g[part]
		end
		local Y = Instance.new("Weld")
		Y.Part0 = player.Character:FindFirstChild(part)
		Y.Part1 = g[part]
		Y.C0 = CFrame.new(0, 0, 0)
		Y.Parent = Y.Part0
	end

	local h = g:GetChildren()
	for i = 1, # h do
		if h[i].className == "Part" or  h[i].className == "UnionOperation" or  h[i].className == "MeshPart" or  h[i].className == "WedgePart" then  
			h[i].Anchored = false
			h[i].CanCollide = false
			h[i].Massless = true
		end
	end

	return g
end

return Knight
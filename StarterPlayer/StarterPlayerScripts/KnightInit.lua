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

function _G.BannerAlert(Title, Message, Duration, Icon)
	if Duration == nil then Duration = 5 end
	if Icon == nil then Icon = "Info" end
	if BannerIcons[Icon] ~= nil then Icon = BannerIcons[Icon] end
	BannerNotificationModule:Notify(Title, Message, Icon, Duration)
end

shared.SessionID = game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("GetSessionID") or "UNKNOWN-RAMPAGE-SSID"

local KnightInternal, Knight = require(game:GetService("ReplicatedStorage").Packages.Knight).Core.Init()
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()

Mouse.KeyDown:Connect(function(key)
	if key == "e" then
		if Character.Humanoid.Sit then
			Character.Humanoid.Sit = false
			wait(0.02)
			Character:SetPrimaryPartCFrame(Character.PrimaryPart.CFrame * CFrame.new(0,-4,0))
			Character.Humanoid.JumpPower = 50
			Player.CameraMaxZoomDistance = 40
		end
	end
end)

game:GetService("ReplicatedStorage").RemoteFunction.OnClientInvoke = function(Action, ...)
	local args = {...};

	if Action == "CalculateCameraLook" then
		return workspace.CurrentCamera.CFrame.LookVector
	elseif Action == "MouseTarget" then
		return Mouse.Target or nil
	end
end

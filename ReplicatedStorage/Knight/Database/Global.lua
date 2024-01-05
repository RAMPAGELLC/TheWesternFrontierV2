-- Western Frontier Core

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");

local Global = {
	["Client"] = {
		SessionStarted = os.time(),
		LocalPlayer = RunService:IsClient() and Players.LocalPlayer or false;
		LocalUserId = RunService:IsClient() and Players.LocalPlayer.UserId or false;
	},
	
	["Server"] = {
		IsServer = RunService:IsServer(), 
		IsClient = RunService:IsClient(), 
		IsStudio = RunService:IsStudio(), 
		IsTestingPlace = game.PlaceId == 12336113063 or RunService:IsStudio(),
		IsVIPServer = RunService:IsServer() and game.PrivateServerOwnerId ~= 0 and game.PrivateServerId ~= "" or false;
		BuildingEnabled = true,
		KickOnModuleLoadError = true,
		DebugMode = true
	},
}

Global.IsServer = function()
	return Global.Server.IsServer
end

Global.IsClient = function()
	return Global.Server.IsClient
end

_G.Global = Global;

return _G.Global;
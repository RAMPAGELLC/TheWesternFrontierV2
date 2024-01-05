_G.PlayerData = {}
_G.fortData = {}
_G.ServerCache = {}
_G.players_in_cache = {}
_G.PVPList = {}
_G.SafeZoneProtection = {}

game:GetService("ServerStorage").Knight.Database.Items:Clone().Parent = game:GetService("ReplicatedStorage")

local KnightInternal, Knight = require(game:GetService("ReplicatedStorage").Packages.Knight).Core.Init()

repeat task.wait(.1) until Knight.Priority ~= nil;
repeat task.wait(.1) until Knight.Priority.Master ~= nil;
print("[WESTERN] Server Loaded")

game:GetService("Players").PlayerRemoving:Connect(function(player)
	_G.players_in_cache[player.Name] = nil
end)
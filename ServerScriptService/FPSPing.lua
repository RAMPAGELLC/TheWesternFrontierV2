game.Players.PlayerAdded:Connect(function(player)
	local ping = Instance.new("StringValue")
	ping.Name = "Ping"
	ping.Value = "0"
	ping.Parent = player

	local fps = Instance.new("StringValue")
	fps.Name = "FPS"
	fps.Value = "0"
	fps.Parent = player
end)

game:GetService("ReplicatedStorage").PingFPS.OnServerEvent:Connect(function(plr,fps,ping)
	local player = game.Players[plr.Name]
	player:WaitForChild("FPS").Value = fps
	player:WaitForChild("Ping").Value = ping
end)

game:GetService("ReplicatedStorage").Ping.OnServerInvoke = function(player)
	return "received"
end
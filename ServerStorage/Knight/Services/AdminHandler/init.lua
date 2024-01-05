local m = {}
_G.ServerBans = {}

function m.Start()
	local cmdr = m.Services.Cmdr

	cmdr:RegisterDefaultCommands()

	for i,v in pairs(script.Commands:GetChildren()) do
		cmdr:RegisterCommandsIn(v)
	end

	cmdr:RegisterHooksIn(script.Hooks)

	game:GetService("Players").PlayerAdded:Connect(function(player)
		if _G.ServerBans[player.UserId] ~= nil then
			_G.Kick(player, _G.ServerBans[player.UserId] or "Unknown reason")
		end
	end)
end

return m
-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		CoreGui = false,
		Camera = false,
		Modules = {},
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

function Knight.Init()
	Knight.Shared.Services.Remotes:Register("ClientEffects", "RemoteEvent", function(Player, ...)
		local args = {...};

		if args[1] == "Eeeee" then
		end
	end)
end

function Knight.Shake(Player, Magnitude)
	local times = math.random(1,5)
	local number = 2
	number = number/Magnitude*2
	number = number/45

	Knight.Shared.Services.Remotes:Fire("ClientEffects", Player, "CameraShake", times, number)
end

function Knight.Start()
	workspace.DescendantAdded:connect(function(explosion)
		if explosion.ClassName ~= "Explosion" then return end

		explosion.Hit:connect(function(hit)
			if not hit.Parent:FindFirstChild("Humanoid") then end
			local hitplayer = Knight.Shared.Roblox.Players:FindFirstChild(hit.Parent.Name)

			if hitplayer then
				local magnitude = (explosion.Position - hit.Parent.UpperTorso.Position).Magnitude
				Knight.Shake(hitplayer, magnitude)
			end
		end)
	end)
end

return Knight
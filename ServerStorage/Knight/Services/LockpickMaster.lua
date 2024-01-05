local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		LockpickSessions = {}
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

local Animation = Instance.new("Animation")
Animation.AnimationId = "rbxassetid://12710751082"

function Format(Int)
	return string.format("%02i", Int)
end

function convertToHMS(Seconds)
	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	--- Format(Hours)..":"..
	return Format(Minutes)..":"..Format(Seconds)
end

function Knight.Init()
	Knight.Shared.Services.Remotes:Register("LockpickSocket", "RemoteEvent", function(Player, ...)
		local args = {...};
		
		if Knight.Cache.LockpickSessions[Player] == nil then 
			return 
		end
		
		local success = args[1] or false
		
		if success then 
			Knight.Services.LawManager.AddBounty(Player, 15) 
		end
		
		Knight.Cache.LockpickSessions[Player].Track:Stop()
		task.spawn(function()
			Knight.Cache.LockpickSessions[Player].Callback(success)
		end)
		Knight.Cache.LockpickSessions[Player] = nil
	end)
end

function Knight.StartSession(Player, BasePart, MinTime, Callback)
	if Knight.Cache.LockpickSessions[Player] ~= nil then return Callback(false) end
	
	Knight.Services.LawManager.AddBounty(Player, 5)
	Knight.Cache.LockpickSessions[Player] = {
		Track = Player.Character.Humanoid.Animator:LoadAnimation(Animation),
		Callback = Callback
	}
	Knight.Cache.LockpickSessions[Player].Track:Play()
	
	Knight.StartTimer(Player, MinTime, function()
		Knight.Shared.Services.Remotes:Fire("LockpickSocket", Player, BasePart)
	end)
end

function Knight.StartTimer(Player, MinTime, Callback)
	local TimerUI = Player.PlayerGui.Core.Framework.Game.LockpickTimer
	TimerUI.Visible = true

	local LockTime = MinTime

	if _G.PlayerData[Player.Name].Progression.LockpickSpeed > 0 then
		LockTime -= _G.PlayerData[Player.Name].Progression.LockpickSpeed
	end

	for i = LockTime, 0, -1 do
		TimerUI.TextLabel.Text = convertToHMS(i)
		task.wait(1)
	end

	TimerUI.Visible = false

	return Callback()
end

return Knight
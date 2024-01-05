local plrs = game:GetService("Players")

local m = {}

function m.Notify(target, title, text, icon, duration, sound)
	if m.Shared == nil then return end
	
	sound = sound or m.Shared.Assets.SharedSounds.NotifSound
	
	if target then
		if typeof(target) == "Instance" then
			m.Shared.Services.Remotes:Fire("Notifyv2", target, title, text, icon, duration, sound)
		end
	else
		m.Shared.Services.Remotes:FireAll("Notifyv2", title, text, icon, duration, sound)
	end
end

return m
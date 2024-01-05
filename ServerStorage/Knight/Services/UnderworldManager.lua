-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		Settings = false,
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

function Knight.Start()
	local TopInProgress = false
	local BottomInProgress = false
	local CooldownBell = false
	
	Knight.Services.InteractionService.RegisterInteraction(workspace.Ignore.MayorBell, "Ring Town Bell", 0, function(Player)
		if Player.Team ~= game.Teams.Mayor then
			return Knight.Services.NotifyService.Notify(Player, "Town Bell", "You must be the town mayor to ring this", false, 7.5, false)
		end
		
		if CooldownBell then 
			return Knight.Services.NotifyService.Notify(Player, "Town Bell", "This bell is on a cooldown.", false, 7.5, false)
		end
		
		CooldownBell = true
		
		workspace.Ignore.MayorBell.Bell.Model.Bell.Value.Value = not workspace.Ignore.MayorBell.Bell.Model.Bell.Value.Value
		
		task.delay(3, function()
			CooldownBell = false
		end)
	end)
	
	Knight.Services.InteractionService.RegisterInteraction(workspace.Ignore.Underworld_Down, "Exit Underworld", 0, function(Player)
		local Part = workspace.Ignore.Underworld_Down
		if not Knight.Services.ItemsManager.HasItem(Player, 66, false, true) then
			return Knight.Services.NotifyService.Notify(Player, "Underworld Teleportation Spell", "You do not have the magical key to enter this place.", false, 7.5, false)
		end

		if TopInProgress then
			return Knight.Services.NotifyService.Notify(Player, "Underworld Teleportation Spell", "Someone else is currently teleporting.", false, 7.5, false)
		end

		BottomInProgress = true
		for _, effect in pairs(Part.VFX.Open:GetChildren()) do
			effect.Enabled = true
		end
		task.wait(1.4)
		for _, effect in pairs(Part.VFX.PrepareTP:GetChildren()) do
			effect.Enabled = true
		end
		task.wait(1.5)
		Part.Spin.Disabled = false
		Part.Decal.Transparency = 0
		task.wait(1.6)
		for _, effect in pairs(Part.VFX.OnTP:GetChildren()) do
			effect.Enabled = true
		end
		task.wait(4.5)
		Player:RequestStreamAroundAsync(workspace.Ignore.Underworld_Top.VFX.Position)
		task.wait(.3)
		Player.Character:PivotTo(workspace.Ignore.Underworld_Top.VFX.CFrame)
		for _, effect in pairs(Part.VFX.Open:GetChildren()) do
			effect.Enabled = false
		end
		for _, effect in pairs(Part.VFX.PrepareTP:GetChildren()) do
			effect.Enabled = false
		end
		for _, effect in pairs(Part.VFX.OnTP:GetChildren()) do
			effect.Enabled = false
		end
		BottomInProgress = false
		Part.Spin.Disabled = true
		Part.Decal.Transparency = 1
	end)
	
	Knight.Services.InteractionService.RegisterInteraction(workspace.Ignore.Underworld_Top, "Enter Underworld", 0, function(Player)
		local Part = workspace.Ignore.Underworld_Top
		if not Knight.Services.ItemsManager.HasItem(Player, 66, false, true) then
			return Knight.Services.NotifyService.Notify(Player, "Underworld Teleportation Spell", "You do not have the magical key to enter this place.", false, 7.5, false)
		end
		
		if TopInProgress then
			return Knight.Services.NotifyService.Notify(Player, "Underworld Teleportation Spell", "Someone else is currently teleporting.", false, 7.5, false)
		end
		
		TopInProgress = true
		for _, effect in pairs(Part.VFX.Open:GetChildren()) do
			effect.Enabled = true
		end
		task.wait(1.4)
		for _, effect in pairs(Part.VFX.PrepareTP:GetChildren()) do
			effect.Enabled = true
		end
		task.wait(1.5)
		Part.Spin.Disabled = false
		Part.Decal.Transparency = 0
		task.wait(1.6)
		for _, effect in pairs(Part.VFX.OnTP:GetChildren()) do
			effect.Enabled = true
		end
		task.wait(4.5)
		Player:RequestStreamAroundAsync(workspace.Ignore.Underworld_Down.VFX.Position)
		task.wait(.3)
		Player.Character:PivotTo(workspace.Ignore.Underworld_Down.VFX.CFrame)
		for _, effect in pairs(Part.VFX.Open:GetChildren()) do
			effect.Enabled = false
		end
		for _, effect in pairs(Part.VFX.PrepareTP:GetChildren()) do
			effect.Enabled = false
		end
		for _, effect in pairs(Part.VFX.OnTP:GetChildren()) do
			effect.Enabled = false
		end
		TopInProgress = false
		Part.Spin.Disabled = true
		Part.Decal.Transparency = 1
	end)
end

return Knight